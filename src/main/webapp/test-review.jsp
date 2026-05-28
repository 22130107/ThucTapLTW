<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Review API</title>
</head>
<body>
    <h1>Test Review API</h1>
    
    <h2>Test 1: Check Servlet Mapping</h2>
    <p>URL: <code>${pageContext.request.contextPath}/review</code></p>
    
    <h2>Test 2: Submit Review</h2>
    <form id="testForm">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="productId" value="1">
        <label>Rating: <input type="number" name="rating" value="5" min="1" max="5"></label><br>
        <label>Content: <textarea name="content">Test review</textarea></label><br>
        <button type="submit">Submit</button>
    </form>
    
    <h2>Response:</h2>
    <pre id="response"></pre>
    
    <script>
        document.getElementById('testForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            const responseDiv = document.getElementById('response');
            
            responseDiv.textContent = 'Sending...';
            
            try {
                const response = await fetch('${pageContext.request.contextPath}/review', {
                    method: 'POST',
                    body: formData
                });
                
                const contentType = response.headers.get('content-type');
                responseDiv.textContent = 'Status: ' + response.status + '\n';
                responseDiv.textContent += 'Content-Type: ' + contentType + '\n\n';
                
                if (contentType && contentType.includes('application/json')) {
                    const json = await response.json();
                    responseDiv.textContent += 'JSON Response:\n' + JSON.stringify(json, null, 2);
                } else {
                    const text = await response.text();
                    responseDiv.textContent += 'Text Response:\n' + text;
                }
            } catch (error) {
                responseDiv.textContent = 'Error: ' + error.message;
            }
        });
    </script>
</body>
</html>
