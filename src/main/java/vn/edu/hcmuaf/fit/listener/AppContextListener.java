package vn.edu.hcmuaf.fit.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import vn.edu.hcmuaf.fit.util.EnvLoader;

/**
 * Chạy khi Tomcat khởi động ứng dụng.
 * Nạp biến môi trường từ WEB-INF/.env trước khi bất kỳ servlet nào được khởi tạo.
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        EnvLoader.load(sce.getServletContext());
        System.out.println("[AppContextListener] Application started.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[AppContextListener] Application stopped.");
    }
}
