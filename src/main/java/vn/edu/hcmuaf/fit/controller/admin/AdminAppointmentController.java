package vn.edu.hcmuaf.fit.controller.admin;

import vn.edu.hcmuaf.fit.model.Appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminAppointmentController", value = "/admin/appointments")
public class AdminAppointmentController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("q");
        String type = request.getParameter("type");
        String status = request.getParameter("status");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");

        if ("".equals(type))
            type = null;
        if ("".equals(status))
            status = null;



        request.setAttribute("msgKeyword", keyword);
        request.setAttribute("msgType", type);
        request.setAttribute("msgStatus", status);
        request.setAttribute("msgDateFrom", dateFrom);
        request.setAttribute("msgDateTo", dateTo);

        request.getRequestDispatcher("/Admin/calendar.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {



    }
}
