<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>SQL Gateway</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f4f9;
        }
        h2 {
            color: #333;
        }
        textarea {
            width: 100%;
            height: 120px;
            font-size: 14px;
            padding: 8px;
            margin-bottom: 10px;
        }
        input[type="submit"] {
            padding: 10px 20px;
            font-size: 14px;
            border: none;
            background-color: #4CAF50;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .error {
            color: red;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <h2>Nhập SQL query</h2>
    <form action="SQLGatewayServlet" method="post">
        <textarea name="sql" placeholder="Ví dụ: SELECT * FROM users;"></textarea><br>
        <input type="submit" value="Chạy SQL">
    </form>

    <c:if test="${not empty error}">
        <div class="error">
            ❌ ${error}
        </div>
    </c:if>
</body>
</html>
