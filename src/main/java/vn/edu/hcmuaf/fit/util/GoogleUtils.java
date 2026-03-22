package vn.edu.hcmuaf.fit.util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import vn.edu.hcmuaf.fit.model.GooglePojo;

import java.io.IOException;

public class GoogleUtils {
    public static final String GOOGLE_CLIENT_ID     = System.getenv("GOOGLE_CLIENT_ID") != null
            ? System.getenv("GOOGLE_CLIENT_ID")
            : "your-google-client-id";
    public static final String GOOGLE_CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET") != null
            ? System.getenv("GOOGLE_CLIENT_SECRET")
            : "your-google-client-secret";
    public static final String GOOGLE_REDIRECT_URI  = "http://localhost:8080/webapp_war/login-google";
    public static final String GOOGLE_GRANT_TYPE    = "authorization_code";
    public static final String GOOGLE_LINK_GET_TOKEN     = "https://accounts.google.com/o/oauth2/token";
    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";


    public static String getToken(String code) throws IOException {
        String response = Request.Post(GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form()
                        .add("client_id", GOOGLE_CLIENT_ID)
                        .add("client_secret", GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", GOOGLE_REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", GOOGLE_GRANT_TYPE)
                        .build())
                .execute().returnContent().asString();

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        return jobj.get("access_token").getAsString();
    }

    public static GooglePojo getUserInfo(String accessToken) throws IOException {
        String link = GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, GooglePojo.class);
    }
}