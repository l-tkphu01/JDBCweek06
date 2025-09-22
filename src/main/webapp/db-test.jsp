<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<html>
<head>
    <title>Test PostgreSQL JDBC Driver</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f4f4f9; }
        .status { padding: 10px; border-radius: 5px; margin: 10px 0; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        pre { background: #f8f9fa; padding: 15px; border-radius: 5px; overflow-x: auto; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background: #007bff; color: white; }
        tr:nth-child(even) { background: #f8f9fa; }
    </style>
</head>
<body>
    <h1>🧪 PostgreSQL JDBC Driver Test</h1>

    <h2>1. Kiểm tra Driver Class</h2>
    <div id="driver-test" class="status info">
        <strong>Testing:</strong> Class.forName("org.postgresql.Driver")
    </div>

    <h2>2. Kiểm tra Database Connection</h2>
    <div id="connection-test" class="status info">
        <strong>Testing:</strong> Connection to PostgreSQL
    </div>

    <h2>3. Kiểm tra Query Execution</h2>
    <div id="query-test" class="status info">
        <strong>Testing:</strong> SELECT 1 FROM DUAL
    </div>

    <%
        // Test 1: Load Driver Class
        boolean driverLoaded = false;
        String driverError = "";
        try {
            Class.forName("org.postgresql.Driver");
            driverLoaded = true;
        } catch (ClassNotFoundException e) {
            driverError = "❌ ERROR: " + e.getMessage();
        }

        // Test 2: Database Connection
        String dbUrl = "jdbc:postgresql://localhost:5432/testdb";
        String dbUser = "postgres";
        String dbPassword = "kIMPHU@290105.";

        Connection conn = null;
        String connectionStatus = "";
        String connectionError = "";

        try {
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            connectionStatus = "✅ SUCCESS: Connected to " + dbUrl;
        } catch (SQLException e) {
            connectionError = "❌ ERROR: " + e.getMessage();
        }

        // Test 3: Execute Query
        boolean querySuccess = false;
        List<Map<String, Object>> queryResult = new ArrayList<>();
        String queryError = "";

        if (conn != null) {
            try {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT 1 as test_column, 'Hello PostgreSQL' as message");

                ResultSetMetaData meta = rs.getMetaData();
                int colCount = meta.getColumnCount();

                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= colCount; i++) {
                        row.put(meta.getColumnName(i), rs.getObject(i));
                    }
                    queryResult.add(row);
                }

                querySuccess = true;
                rs.close();
                stmt.close();
            } catch (SQLException e) {
                queryError = "❌ ERROR: " + e.getMessage();
            } finally {
                try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
            }
        }
    %>

    <!-- Results -->
    <div class="status <%= driverLoaded ? "success" : "error" %>">
        <h3>📦 Driver Test Result:</h3>
        <% if (driverLoaded) { %>
            <p><strong>✅ PostgreSQL Driver LOADED SUCCESSFULLY!</strong></p>
            <p><i class="fas fa-check-circle"></i> Class: org.postgresql.Driver</p>
        <% } else { %>
            <p><strong><%= driverError %></strong></p>
            <p>🔍 <a href="check-jar.jsp">Check JAR file location</a></p>
        <% } %>
    </div>

    <div class="status <%= connectionStatus.isEmpty() ? "error" : "success" %>">
        <h3>🔌 Connection Test Result:</h3>
        <% if (!connectionStatus.isEmpty()) { %>
            <p><strong>✅ DATABASE CONNECTION SUCCESS!</strong></p>
            <p><i class="fas fa-database"></i> URL: <%= dbUrl %></p>
            <p><i class="fas fa-user"></i> User: <%= dbUser %></p>
            <p><i class="fas fa-clock"></i> Status: Connected</p>
        <% } else { %>
            <p><strong><%= connectionError %></strong></p>
            <p>⚠️ <strong>Common fixes:</strong></p>
            <ul>
                <li>✅ PostgreSQL server đang chạy: `sudo service postgresql start`</li>
                <li>✅ Database `testdb` tồn tại: `createdb testdb`</li>
                <li>✅ User/password đúng</li>
                <li>✅ Port 5432 mở: `netstat -an | grep 5432`</li>
            </ul>
        <% } %>
    </div>

    <div class="status <%= querySuccess ? "success" : "error" %>">
        <h3>⚡ Query Test Result:</h3>
        <% if (querySuccess) { %>
            <p><strong>✅ QUERY EXECUTION SUCCESS!</strong></p>
            <p><i class="fas fa-play-circle"></i> PostgreSQL JDBC hoạt động hoàn hảo!</p>
            <table>
                <thead>
                    <tr>
                        <th>Column Name</th>
                        <th>Value</th>
                        <th>Type</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="<%= queryResult %>">
                        <c:forEach var="entry" items="${row.entrySet()}">
                            <tr>
                                <td>${entry.key}</td>
                                <td><code>${entry.value}</code></td>
                                <td>${entry.value.getClass().simpleName}</td>
                            </tr>
                        </c:forEach>
                    </c:forEach>
                </tbody>
            </table>
        <% } else { %>
            <p><strong><%= queryError %></strong></p>
            <p>🔍 Nếu connection OK nhưng query lỗi → Vấn đề với database schema</p>
        <% } %>
    </div>

    <hr>
    <h3>🔧 Debug Information</h3>
    <div style="background: #f8f9fa; padding: 15px; border-radius: 5px;">
        <strong>Server Info:</strong> <%= application.getServerInfo() %><br>
        <strong>Context Path:</strong> <%= request.getContextPath() %><br>
        <strong>JDBC Drivers Available:</strong><br>
        <%
            Enumeration<Driver> drivers = DriverManager.getDrivers();
            while (drivers.hasMoreElements()) {
                Driver driver = drivers.nextElement();
                out.println("&nbsp;&nbsp;• " + driver.getClass().getName() + "<br>");
            }
        %>
    </div>

    <p style="margin-top: 30px;">
        <a href="index.jsp" class="btn btn-primary">→ Back to SQL Gateway</a>
    </p>
</body>
</html>