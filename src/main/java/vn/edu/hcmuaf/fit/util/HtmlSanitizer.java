package vn.edu.hcmuaf.fit.util;

import java.util.regex.Pattern;

public class HtmlSanitizer {

    private static final Pattern SCRIPT_PATTERN = Pattern.compile("(?i)<script.*?>.*?<\\/script>", Pattern.DOTALL);
    private static final Pattern IFRAME_PATTERN = Pattern.compile("(?i)<iframe.*?>.*?<\\/iframe>", Pattern.DOTALL);
    private static final Pattern EVENT_HANDLER_PATTERN = Pattern.compile("(?i)on\\w+\\s*=\\s*(\".*?\"|'.*?'|[^>\\s]+)");
    private static final Pattern JS_URI_PATTERN = Pattern.compile("(?i)(href|src)\\s*=\\s*(\"|')?javascript:[^\"'>\\s]+(\"|')?");

    public static String sanitize(String html) {
        if (html == null) return null;

        // Remove script blocks
        String out = SCRIPT_PATTERN.matcher(html).replaceAll("");

        // Remove iframes
        out = IFRAME_PATTERN.matcher(out).replaceAll("");

        // Remove event handler attributes like onclick="..."
        out = EVENT_HANDLER_PATTERN.matcher(out).replaceAll("");

        // Remove javascript: URIs
        out = JS_URI_PATTERN.matcher(out).replaceAll("");

        return out;
    }
}
