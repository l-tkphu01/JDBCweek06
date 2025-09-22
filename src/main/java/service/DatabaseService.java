package service;

import dao.DatabaseDAO;
import java.util.*;

public class DatabaseService {
    private DatabaseDAO dao = new DatabaseDAO();

    public List<Map<String, Object>> runSQL(String sql) throws Exception {
        if (sql == null || sql.trim().isEmpty()) {
            throw new Exception("SQL không được để trống!");
        }
        return dao.executeQuery(sql);
    }
}
