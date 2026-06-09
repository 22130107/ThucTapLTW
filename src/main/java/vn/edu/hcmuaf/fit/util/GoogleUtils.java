package vn.edu.hcmuaf.fit.util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import vn.edu.hcmuaf.fit.model.GooglePojo;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class GoogleUtils {

    public static final String GOOGLE_LINK_GET_TOKEN     = "https://accounts.google.com/o/oauth2/token";
    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";
    public static final String GOOGLE_GRANT_TYPE         = "authorization_code";

    public static String getClientId() {
        return EnvLoader.get("GOOGLE_CLIENT_ID");
    }

    public static String getClientSecret() {
        return EnvLoader.get("GOOGLE_CLIENT_SECRET");
    }

    public static String getRedirectUri() {
        String uri = EnvLoader.get("GOOGLE_REDIRECT_URI");
        return uri.isEmpty() ? "http://localhost:8080/webapp_war/login-google" : uri;
    }

    public static String buildLoginUrl() {
        try {
            return "https://accounts.google.com/o/oauth2/auth"
                    + "?scope=" + URLEncoder.encode("email profile openid", StandardCharsets.UTF_8)
                    + "&redirect_uri=" + URLEncoder.encode(getRedirectUri(), StandardCharsets.UTF_8)
                    + "&response_type=code"
                    + "&client_id=" + URLEncoder.encode(getClientId(), StandardCharsets.UTF_8)
                    + "&approval_prompt=force";
        } catch (Exception e) {
            e.printStackTrace();
            return "#";
        }
    }

    public static String getToken(String code) throws IOException {
        String response = Request.Post(GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form()
                        .add("client_id",     getClientId())
                        .add("client_secret", getClientSecret())
                        .add("redirect_uri",  getRedirectUri())
                        .add("code",          code)
                        .add("grant_type",    GOOGLE_GRANT_TYPE)
                        .build())
                .execute().returnContent().asString();

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);

        if (jobj.has("error")) {
            String error = jobj.get("error").getAsString();
            String desc  = jobj.has("error_description")
                    ? jobj.get("error_description").getAsString() : "";
            throw new IOException("Google token error: " + error + " — " + desc);
        }

        return jobj.get("access_token").getAsString();
    }

    public static GooglePojo getUserInfo(String accessToken) throws IOException {
        String link = GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, GooglePojo.class);
    }
}
