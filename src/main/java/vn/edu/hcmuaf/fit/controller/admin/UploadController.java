package vn.edu.hcmuaf.fit.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@WebServlet(urlPatterns = { "/api/upload" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 100
)
public class UploadController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String applicationPath = req.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + "uploads";

        File uploadDir = new File(uploadFilePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try {

            Part filePart = req.getPart("upload");

            if (filePart == null) {

                for (Part part : req.getParts()) {
                    if (part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                        filePart = part;
                        break;
                    }
                }
            }

            if (filePart != null) {
                String originalFileName = filePart.getSubmittedFileName();
                String fileExtension = "";
                int i = originalFileName.lastIndexOf('.');
                if (i > 0) {
                    fileExtension = originalFileName.substring(i);
                }

                String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                Path filePath = Paths.get(uploadFilePath, uniqueFileName);

                Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

                String fileUrl = req.getContextPath() + "/uploads/" + uniqueFileName;

                Map<String, Object> responseData = new HashMap<>();
                responseData.put("uploaded", 1);
                responseData.put("fileName", uniqueFileName);
                responseData.put("url", fileUrl);

                PrintWriter out = resp.getWriter();
                out.print(new Gson().toJson(responseData));
                out.flush();
            } else {
                sendErrorResponse(resp, "No file uploaded.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(resp, "Server Error: " + e.getMessage());
        }
    }

    private void sendErrorResponse(HttpServletResponse resp, String message) throws IOException {
        Map<String, Object> error = new HashMap<>();
        Map<String, Object> errorMsg = new HashMap<>();
        errorMsg.put("message", message);
        error.put("uploaded", 0);
        error.put("error", errorMsg);

        resp.getWriter().print(new Gson().toJson(error));
    }
}
