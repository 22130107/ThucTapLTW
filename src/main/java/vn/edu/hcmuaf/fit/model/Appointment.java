package vn.edu.hcmuaf.fit.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Appointment implements Serializable {
    private int appointmentID;
    private int customerID;
    private Integer productID; // nullable
    private LocalDateTime appointmentDateTime;
    private AppointmentType appointmentType;
    private String address;
    private AppointmentStatus status;
    private String adminNote;

    // Enums
    public enum AppointmentType {
        AT_CLINIC("AtClinic"),
        AT_HOME("AtHome");

        private final String value;

        AppointmentType(String value) {
            this.value = value;
        }

        public String getValue() {
            return value;
        }

        public static AppointmentType fromString(String value) {
            for (AppointmentType type : AppointmentType.values()) {
                if (type.value.equalsIgnoreCase(value)) {
                    return type;
                }
            }
            return null;
        }
    }

    public enum AppointmentStatus {
        NEW("New"),
        CONFIRMED("Confirmed"),
        COMPLETED("Completed"),
        CANCELLED("Cancelled");

        private final String value;

        AppointmentStatus(String value) {
            this.value = value;
        }

        public String getValue() {
            return value;
        }

        public static AppointmentStatus fromString(String value) {
            for (AppointmentStatus status : AppointmentStatus.values()) {
                if (status.value.equalsIgnoreCase(value)) {
                    return status;
                }
            }
            return null;
        }
    }

    // Constructors
    public Appointment() {
        this.status = AppointmentStatus.NEW;
    }

    public Appointment(int customerID, LocalDateTime appointmentDateTime, AppointmentType appointmentType,
                       String address, String adminNote) {
        this.customerID = customerID;
        this.appointmentDateTime = appointmentDateTime;
        this.appointmentType = appointmentType;
        this.address = address;
        this.adminNote = adminNote;
        this.status = AppointmentStatus.NEW;
    }

    // Getters and Setters
    public int getAppointmentID() {
        return appointmentID;
    }

    public void setAppointmentID(int appointmentID) {
        this.appointmentID = appointmentID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public Integer getProductID() {
        return productID;
    }

    public void setProductID(Integer productID) {
        this.productID = productID;
    }

    public LocalDateTime getAppointmentDateTime() {
        return appointmentDateTime;
    }

    public void setAppointmentDateTime(LocalDateTime appointmentDateTime) {
        this.appointmentDateTime = appointmentDateTime;
    }

    public AppointmentType getAppointmentType() {
        return appointmentType;
    }

    public void setAppointmentType(AppointmentType appointmentType) {
        this.appointmentType = appointmentType;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public AppointmentStatus getStatus() {
        return status;
    }

    public void setStatus(AppointmentStatus status) {
        this.status = status;
    }

    public String getAdminNote() {
        return adminNote;
    }

    public void setAdminNote(String adminNote) {
        this.adminNote = adminNote;
    }

    // Transient fields for display
    private String customerName;
    private String customerPhone;
    private String productName;

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    @Override
    public String toString() {
        return "Appointment{" +
                "appointmentID=" + appointmentID +
                ", customerID=" + customerID +
                ", productID=" + productID +
                ", appointmentDateTime=" + appointmentDateTime +
                ", appointmentType=" + appointmentType +
                ", address='" + address + '\'' +
                ", status=" + status +
                ", adminNote='" + adminNote + '\'' +
                ", customerName='" + customerName + '\'' +
                '}';
    }


    public String getFormattedDateTime() {
        if (appointmentDateTime == null) return "";
        return appointmentDateTime.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }


    public String getTypeVietnamese() {
        if (appointmentType == null) return "Không xác định";
        // Enum value: AtClinic, AtHome
        if (appointmentType == AppointmentType.AT_CLINIC) return "Tại phòng khám";
        if (appointmentType == AppointmentType.AT_HOME) return "Tại nhà";
        return appointmentType.getValue();
    }


    public String getStatusVietnamese() {
        if (status == null) return "Mới";
        switch (status) {
            case NEW: return "Chờ xác nhận";
            case CONFIRMED: return "Đã xác nhận";
            case COMPLETED: return "Đã khám xong";
            case CANCELLED: return "Đã hủy";
            default: return status.getValue();
        }
    }


    public String getStatusCssClass() {
        if (status == null) return "secondary";
        switch (status) {
            case NEW: return "warning";    // Vàng
            case CONFIRMED: return "primary"; // Xanh dương
            case COMPLETED: return "success"; // Xanh lá
            case CANCELLED: return "danger";  // Đỏ
            default: return "secondary";
        }
    }
}