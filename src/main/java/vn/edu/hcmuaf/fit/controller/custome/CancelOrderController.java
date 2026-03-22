package vn.edu.hcmuaf.fit.controller.custome;

import vn.edu.hcmuaf.fit.dao.OrderDAO;
import vn.edu.hcmuaf.fit.model.Customer;
import vn.edu.hcmuaf.fit.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "CancelOrderController", value = "/cancel-order")
public class CancelOrderController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        Customer customer = (Customer) session.getAttribute("customer");
        String contextPath = request.getContextPath();
        String targetUrl = contextPath + "/purchase-history";

        if (user == null || customer == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(targetUrl);
            return;
        }

        try {
            int orderId = Integer.parseInt(idParam);
            int customerID = customer.getCustomerID();

            OrderDAO orderDAO = OrderDAO.getInstance();

            if (!orderDAO.isOrderOwnedByCustomer(orderId, customerID)) {
                session.setAttribute("toastError", "KhÃ´ng tÃ¬m tháº¥y Ä‘Æ¡n hÃ ng hoáº·c báº¡n khÃ´ng cÃ³ quyá»�n há»§y.");
            } else {

                boolean success = orderDAO.cancelOrder(orderId);

                if (success) {
                    session.setAttribute("toastSuccess", "Ä�Æ¡n hÃ ng #" + orderId + " Ä‘Ã£ Ä‘Æ°á»£c há»§y thÃ nh cÃ´ng.");

                    targetUrl += "?tab=Cancelled";
                } else {
                    session.setAttribute("toastError", "KhÃ´ng thá»ƒ há»§y Ä‘Æ¡n hÃ ng #" + orderId + " (CÃ³ thá»ƒ Ä‘Æ¡n Ä‘Ã£ Ä‘Æ°á»£c xá»­ lÃ½).");
                }
            }

        } catch (NumberFormatException e) {
            session.setAttribute("toastError", "MÃ£ Ä‘Æ¡n hÃ ng khÃ´ng há»£p lá»‡.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("toastError", "Ä�Ã£ xáº£y ra lá»—i há»‡ thá»‘ng.");
        }

        response.sendRedirect(targetUrl);
    }
}