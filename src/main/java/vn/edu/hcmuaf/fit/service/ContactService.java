package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.ContactDAO;
import vn.edu.hcmuaf.fit.model.ContactRequest;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.List;
import java.util.Properties;

public class ContactService {

    private static final ContactService INSTANCE = new ContactService();
    public static ContactService getInstance() { return INSTANCE; }

    private final ContactDAO dao = new ContactDAO();

    // ── Cấu hình email nhận thông báo ──────────────────────────────────
    // Thay bằng email + App Password thực của bạn
    private static final String SMTP_HOST     = "smtp.gmail.com";
    private static final String SMTP_PORT     = "587";
    private static final String SENDER_EMAIL  = "thietbiyte24h@gmail.com";
    private static final String SENDER_PASS   = "YOUR_APP_PASSWORD"; // App Password Gmail
    private static final String NOTIFY_EMAIL  = "thietbiyte24h@gmail.com"; // email nhận thông báo

    /**
     * Xử lý yêu cầu liên hệ:
     * 1. Lưu vào DB
     * 2. Gửi email thông báo cho admin (bất đồng bộ)
     */
    public boolean handle(ContactRequest req) {
        boolean saved = dao.save(req);
        if (saved) {
            // Gửi email trong thread riêng để không block response
            new Thread(() -> sendNotificationEmail(req)).start();
        }
        return saved;
    }

    public List<ContactRequest> getAll() { return dao.findAll(); }

    public boolean updateStatus(int id, String status) {
        return dao.updateStatus(id, status);
    }

    // ── Gửi email thông báo ─────────────────────────────────────────────
    private void sendNotificationEmail(ContactRequest req) {
        Properties props = new Properties();
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host",            SMTP_HOST);
        props.put("mail.smtp.port",            SMTP_PORT);
        props.put("mail.smtp.ssl.trust",       SMTP_HOST);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASS);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(SENDER_EMAIL, "THIET BI Y TE 24H"));
            msg.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(NOTIFY_EMAIL));
            msg.setSubject("[YEU CAU TU VAN MOI] " + req.getFullname() + " - " + req.getPhone());

            String body = buildEmailBody(req);
            msg.setContent(body, "text/html; charset=UTF-8");
            Transport.send(msg);
            System.out.println("LOG: Contact notification email sent to " + NOTIFY_EMAIL);
        } catch (Exception e) {
            // Không throw – lỗi email không ảnh hưởng UX
            System.err.println("LOG: Failed to send contact email: " + e.getMessage());
        }
    }

    private String buildEmailBody(ContactRequest req) {
        return "<div style='font-family:Arial,sans-serif;max-width:600px;margin:0 auto'>"
            + "<div style='background:#1f8fe5;padding:20px;border-radius:8px 8px 0 0'>"
            + "<h2 style='color:#fff;margin:0'>Yeu cau tu van moi – THIET BI Y TE 24H</h2></div>"
            + "<div style='background:#f9f9f9;padding:24px;border:1px solid #e0e0e0'>"
            + "<table style='width:100%;border-collapse:collapse'>"
            + row("Ho ten",       req.getFullname())
            + row("So dien thoai", req.getPhone())
            + row("Email",        req.getEmail() != null ? req.getEmail() : "(khong co)")
            + row("Chu de",       req.getSubject() != null ? req.getSubject() : "(khong chon)")
            + row("Noi dung",     req.getMessage())
            + "</table></div>"
            + "<div style='background:#fff3cd;padding:14px;border-radius:0 0 8px 8px;"
            + "font-size:13px;color:#856404'>"
            + "Vui long lien he lai trong vong 30 phut. Xem tat ca yeu cau tai trang Admin.</div></div>";
    }

    private String row(String label, String value) {
        return "<tr><td style='padding:10px;font-weight:bold;width:140px;color:#555'>"
            + label + ":</td>"
            + "<td style='padding:10px;color:#222'>" + value + "</td></tr>";
    }
}
