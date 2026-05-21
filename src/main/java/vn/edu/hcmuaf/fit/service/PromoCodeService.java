package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.PromoCodeDAO;
import vn.edu.hcmuaf.fit.model.PromoCode;

import java.util.Date;
import java.util.List;

public class PromoCodeService {
    private static final PromoCodeService instance = new PromoCodeService();
    private final PromoCodeDAO dao = new PromoCodeDAO();

    private PromoCodeService() {}

    public static PromoCodeService getInstance() { return instance; }

    public boolean addPromo(PromoCode p) { return dao.create(p); }
    public boolean updatePromo(PromoCode p) { return dao.update(p); }
    public boolean deletePromo(int id) { return dao.delete(id); }
    public PromoCode getById(int id) { return dao.getById(id); }
    public PromoCode findByCode(String code) { return dao.findByCode(code); }
    public List<PromoCode> list(int offset, int limit) { return dao.list(offset, limit); }
    public int countAll() { return dao.countAll(); }

    public void incrementUsedCount(int promoId) {
        dao.incrementUsedCount(promoId);
    }

    /**
     * Apply a promo code for an order: returns discount amount or negative on error
     * Basic checks: active, date range, usage limit, min order value
     */
    public double applyCode(String code, double orderTotal, int productId, int categoryId) {
        PromoCode p = dao.findByCode(code);
        if (p == null) return -1; // not found
        if (!p.isActive()) return -2; // inactive
        Date now = new Date();
        if (p.getStartAt() != null && now.before(p.getStartAt())) return -3; // not started
        if (p.getEndAt() != null && now.after(p.getEndAt())) return -4; // expired
        if (p.getUsageLimit() > 0 && p.getUsedCount() >= p.getUsageLimit()) return -5; // exhausted
        if (orderTotal < p.getMinOrderValue()) return -6; // min order not met

        // applicability (basic)
        if ("category".equals(p.getAppliesTo()) && p.getAppliesToId() != null) {
            if (p.getAppliesToId() != categoryId) return -7;
        }
        if ("product".equals(p.getAppliesTo()) && p.getAppliesToId() != null) {
            if (p.getAppliesToId() != productId) return -8;
        }

        double discount;
        if ("percent".equals(p.getType())) {
            discount = orderTotal * (p.getAmount() / 100.0);
        } else {
            discount = p.getAmount();
        }

        // increment used count
        dao.incrementUsedCount(p.getId());

        return Math.min(discount, orderTotal);
    }
}
