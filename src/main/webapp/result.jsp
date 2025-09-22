<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Kết quả truy vấn</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f4f9;
        }
        h2 {
            color: #333;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 15px;
            background-color: #fff;
            box-shadow: 0px 2px 8px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        a.button {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 18px;
            font-size: 14px;
            text-decoration: none;
            color: white;
            background-color: #4CAF50;
            border-radius: 5px;
        }
        a.button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <h2>Kết quả truy vấn:</h2>
    <c:if test="${empty result}">
        <p>Không có dữ liệu để hiển thị.</p>
    </c:if>
    <c:if test="${not empty result}">
        <table>
            <thead>
                <tr>
                    <c:forEach var="colName" items="${result[0].keySet()}">
                        <th>${colName}</th>
                    </c:forEach>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="row" items="${result}">
                    <tr>
                        <c:forEach var="col" items="${row.values()}">
                            <td>${col}</td>
                        </c:forEach>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <br>
    <a href="index.jsp" class="button">⬅ Quay lại</a>
</body>
</html>
