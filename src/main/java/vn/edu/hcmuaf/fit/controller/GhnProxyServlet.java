package vn.edu.hcmuaf.fit.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.http.client.fluent.Request;
import vn.edu.hcmuaf.fit.util.GhnConfig;

import java.io.IOException;

/**
 * Proxy servlet để frontend gọi GHN Master Data API mà không lộ token.
 *
 * Các endpoint:
 *   GET /ghn-proxy?type=province
 *   GET /ghn-proxy?type=district&province_id=269
 *   GET /ghn-proxy?type=ward&district_id=1442
 */
@WebServlet(name = "GhnProxyServlet", value = "/ghn-proxy")
public class GhnProxyServlet extends HttpServlet {

    private static final Gson GSON = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        String type = request.getParameter("type");
        if (type == null) {
            sendError(response, "Thiếu tham số 'type'");
            return;
        }

        String ghnUrl;
        switch (type) {
            case "province":
                ghnUrl = GhnConfig.BASE_URL() + "/master-data/province";
                break;

            case "district":
                String provinceId = request.getParameter("province_id");
                if (provinceId == null || provinceId.isEmpty()) {
                    sendError(response, "Thiếu tham số 'province_id'");
                    return;
                }
                ghnUrl = GhnConfig.BASE_URL() + "/master-data/district?province_id=" + provinceId;
                break;

            case "ward":
                String districtId = request.getParameter("district_id");
                if (districtId == null || districtId.isEmpty()) {
                    sendError(response, "Thiếu tham số 'district_id'");
                    return;
                }
                ghnUrl = GhnConfig.BASE_URL() + "/master-data/ward?district_id=" + districtId;
                break;

            default:
                sendError(response, "Giá trị 'type' không hợp lệ");
                return;
        }

        String token = GhnConfig.TOKEN();
        System.out.println("[GhnProxy] URL: " + ghnUrl);
        System.out.println("[GhnProxy] TOKEN value: [" + token + "]");
        System.out.println("[GhnProxy] System.getenv(GHN_TOKEN): [" + System.getenv("GHN_TOKEN") + "]");
        System.out.println("[GhnProxy] System.getProperty(GHN_TOKEN): [" + System.getProperty("GHN_TOKEN") + "]");

        try {
            String result = Request.Get(ghnUrl)
                    .addHeader("token", token)
                    .execute()
                    .returnContent()
                    .asString(java.nio.charset.StandardCharsets.UTF_8);
            System.out.println("[GhnProxy] Response (first 300): " + result.substring(0, Math.min(300, result.length())));
            response.getWriter().write(result);
        } catch (org.apache.http.client.HttpResponseException e) {
            System.err.println("[GhnProxy] HTTP error: " + e.getStatusCode() + " " + e.getMessage());
            sendError(response, "GHN trả về lỗi " + e.getStatusCode() + ": " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "Lỗi kết nối GHN: " + e.getMessage());
        }
    }

    private void sendError(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        JsonObject err = new JsonObject();
        err.addProperty("code", -1);
        err.addProperty("message", message);
        response.getWriter().write(GSON.toJson(err));
    }
}
