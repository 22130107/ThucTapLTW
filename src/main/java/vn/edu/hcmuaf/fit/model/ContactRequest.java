package vn.edu.hcmuaf.fit.model;

import java.sql.Timestamp;

public class ContactRequest {
    private int id;
    private String fullname;
    private String phone;
    private String email;
    private String subject;
    private String message;
    private String status;   // NEW | READ | REPLIED
    private Timestamp createdAt;

    public ContactRequest() {}

    public ContactRequest(String fullname, String phone, String email,
                          String subject, String message) {
        this.fullname = fullname;
        this.phone    = phone;
        this.email    = email;
        this.subject  = subject;
        this.message  = message;
        this.status   = "NEW";
    }

    public int getId()              { return id; }
    public void setId(int id)       { this.id = id; }
    public String getFullname()     { return fullname; }
    public String getPhone()        { return phone; }
    public String getEmail()        { return email; }
    public String getSubject()      { return subject; }
    public String getMessage()      { return message; }
    public String getStatus()       { return status; }
    public void setStatus(String s) { this.status = s; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp t) { this.createdAt = t; }
}
