package vn.edu.hcmuaf.fit.service;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.dao.PaymentTransactionDAO;
import vn.edu.hcmuaf.fit.model.Order;
import vn.edu.hcmuaf.fit.model.PaymentTransaction;
import vn.edu.hcmuaf.fit.util.SepayConfig;
import vn.edu.hcmuaf.fit.util.SepayUtil;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.logging.Logger;

public class SepayService {
    private static final Logger LOGGER = Logger.getLogger(SepayService.class.getName());
    private static final SepayService INSTANCE = new SepayService();
    private final OrderDAO orderDAO = OrderDAO.getInstance();
    private final PaymentTransactionDAO txnDAO = PaymentTransactionDAO.getInstance();

    private SepayService() {}

    public static SepayService getInstance() { return INSTANCE; }
