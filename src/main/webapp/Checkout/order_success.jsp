<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Đặt hàng thành công</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f4f7f6;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }

            .container {
                text-align: center;
                background: #fff;
                padding: 50px;
                border-radius: 8px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                max-width: 500px;
            }

            .icon-success {
                color: #2ecc71;
                font-size: 80px;
                margin-bottom: 20px;
            }

            h1 {
                color: #333;
                margin-bottom: 10px;
            }

            p {
                color: #666;
                font-size: 18px;
                margin-bottom: 30px;
            }

            .btn-home {
                display: inline-block;
                padding: 12px 30px;
                background-color: #3498db;
                color: white;
                text-decoration: none;
                border-radius: 25px;
                font-weight: bold;
                transition: background 0.3s;
            }

            .btn-home:hover {
                background-color: #2980b9;
            }
        </style>
    </head>

    <body>

        <div class="container">
            <i class="fas fa-check-circle icon-success"></i>
            <h1>Đặt hàng thành công!</h1>
            <p>Cảm ơn bạn đã mua hàng. Đơn hàng của bạn đang được xử lý.</p>
            <a href="${pageContext.request.contextPath}/home" class="btn-home">Tiếp tục mua sắm</a>
        </div>

    </body>

    </html>