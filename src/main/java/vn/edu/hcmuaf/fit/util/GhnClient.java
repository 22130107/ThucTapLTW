package vn.edu.hcmuaf.fit.util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.http.client.fluent.Request;
import org.apache.http.entity.ContentType;

import java.io.IOException;

public class GhnClient {
    private static final Gson gson = new Gson();

    public static GhnCreateResult createOrder(JsonObject payload) throws IOException {
        String url = GhnConfig.BASE_URL() + "/v2/shipping-order/create";
        String response = Request.Post(url)
                .addHeader("token", GhnConfig.TOKEN())
                .addHeader("shop_id", GhnConfig.SHOP_ID())
                .bodyString(gson.toJson(payload), ContentType.APPLICATION_JSON)
                .execute().returnContent().asString(java.nio.charset.StandardCharsets.UTF_8);

        JsonObject obj = gson.fromJson(response, JsonObject.class);
        int code = obj.has("code") ? obj.get("code").getAsInt() : -1;
        String message = obj.has("message") ? obj.get("message").getAsString() : null;
        String orderCode = null;

        if (code == 200 && obj.has("data") && obj.get("data").getAsJsonObject().has("order_code")) {
            orderCode = obj.get("data").getAsJsonObject().get("order_code").getAsString();
        }
        return new GhnCreateResult(code, message, orderCode, response);
    }

    public static GhnStatusResult getOrderDetail(String orderCode) throws IOException {
        String url = GhnConfig.BASE_URL() + "/v2/shipping-order/detail";
        JsonObject payload = new JsonObject();
        payload.addProperty("order_code", orderCode);

        String response = Request.Post(url)
                .addHeader("token", GhnConfig.TOKEN())
                .addHeader("shop_id", GhnConfig.SHOP_ID())
                .bodyString(gson.toJson(payload), ContentType.APPLICATION_JSON)
                .execute().returnContent().asString(java.nio.charset.StandardCharsets.UTF_8);

        JsonObject obj = gson.fromJson(response, JsonObject.class);
        int code = obj.has("code") ? obj.get("code").getAsInt() : -1;
        String message = obj.has("message") ? obj.get("message").getAsString() : null;
        String status = null;
        if (code == 200 && obj.has("data") && obj.get("data").getAsJsonObject().has("status")) {
            status = obj.get("data").getAsJsonObject().get("status").getAsString();
        }
        return new GhnStatusResult(code, message, status, response);
    }

    public static class GhnCreateResult {
        private final int code;
        private final String message;
        private final String orderCode;
        private final String rawResponse;

        public GhnCreateResult(int code, String message, String orderCode, String rawResponse) {
            this.code = code;
            this.message = message;
            this.orderCode = orderCode;
            this.rawResponse = rawResponse;
        }

        public int getCode() { return code; }
        public String getMessage() { return message; }
        public String getOrderCode() { return orderCode; }
        public String getRawResponse() { return rawResponse; }
    }

    public static class GhnStatusResult {
        private final int code;
        private final String message;
        private final String status;
        private final String rawResponse;

        public GhnStatusResult(int code, String message, String status, String rawResponse) {
            this.code = code;
            this.message = message;
            this.status = status;
            this.rawResponse = rawResponse;
        }

        public int getCode() { return code; }
        public String getMessage() { return message; }
        public String getStatus() { return status; }
        public String getRawResponse() { return rawResponse; }
    }
}
