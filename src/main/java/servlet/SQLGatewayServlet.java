    package servlet;

    import service.DatabaseService;
    import jakarta.servlet.*;
    import jakarta.servlet.http.*;
    import jakarta.servlet.annotation.WebServlet;
    import java.io.IOException;
    import java.util.*;

    @WebServlet("/SQLGatewayServlet") // Không cần mapping trong web.xml nữa
    public class SQLGatewayServlet extends HttpServlet {
        private DatabaseService service = new DatabaseService();

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            String sql = request.getParameter("sql");
            try {
                List<Map<String, Object>> result = service.runSQL(sql);
                request.setAttribute("result", result);
                RequestDispatcher rd = request.getRequestDispatcher("result.jsp");
                rd.forward(request, response);
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
                RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
                rd.forward(request, response);
            }
        }
    }
