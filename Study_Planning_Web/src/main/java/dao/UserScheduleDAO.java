package dao;

import model.UserSchedule;
import utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for user_schedule table Handles all database operations for
 * schedules
 */
public class UserScheduleDAO {

    /**
     * Get all schedules for a specific user
     */
    /**
     * Get all schedules for a specific user
     */
    public List<UserSchedule> getAllByUserId(int userId) {
        List<UserSchedule> schedules = new ArrayList<>();
        // Modified to JOIN with schedule_collection to filter by user_id
        String sql = "SELECT us.* FROM user_schedule us "
                + "JOIN schedule_collection sc ON us.collection_id = sc.collection_id "
                + "WHERE sc.user_id = ? ORDER BY us.day_of_week, us.start_time";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                schedules.add(extractScheduleFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return schedules;
    }

    /**
     * Get schedule by ID
     */
    public UserSchedule getById(int scheduleId) {
        String sql = "SELECT * FROM user_schedule WHERE schedule_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, scheduleId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractScheduleFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get schedules for a specific user and day
     */
    public List<UserSchedule> getByUserIdAndDay(int userId, String dayOfWeek) {
        List<UserSchedule> schedules = new ArrayList<>();
        // Modified to JOIN with schedule_collection to filter by user_id
        String sql = "SELECT us.* FROM user_schedule us "
                + "JOIN schedule_collection sc ON us.collection_id = sc.collection_id "
                + "WHERE sc.user_id = ? AND us.day_of_week = ? ORDER BY us.start_time";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setString(2, dayOfWeek);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                schedules.add(extractScheduleFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return schedules;
    }

    /**
     * Get all schedules for a specific collection
     */
public List<UserSchedule> getAllByCollectionId(int collectionId) {
    List<UserSchedule> schedules = new ArrayList<>();

    // ⭐️ SỬA QUERY: Lấy tất cả schedule bao gồm cả task_id
    String sql = "SELECT " +
                "us.schedule_id, " +
                "us.collection_id, " +
                "us.task_id, " +  // ⭐️ QUAN TRỌNG: Lấy task_id
                "us.day_of_week, " +
                "us.start_time, " +
                "us.end_time, " +
                "us.subject, " +
                "us.type, " +
                "us.created_at " +
                "FROM user_schedule us " +
                "WHERE us.collection_id = ? " +
                "ORDER BY us.day_of_week, us.start_time";

    try (Connection conn = DBUtil.getConnection(); 
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, collectionId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            UserSchedule schedule = extractScheduleFromResultSet(rs);
            schedules.add(schedule);
            
            // Debug log
            System.out.println("[DAO] Loaded schedule: " + 
                             schedule.getScheduleId() + 
                             ", taskId: " + schedule.getTaskId() + 
                             ", subject: " + schedule.getSubject());
        }
        
        System.out.println("[DAO] Total schedules loaded: " + schedules.size());
        
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return schedules;
}

    /**
     * Insert new schedule Returns the generated schedule_id
     */
public int insert(UserSchedule schedule) {
    System.out.println("[DAO INSERT] Starting insert for schedule:");
    System.out.println("  TaskId: " + schedule.getTaskId());
    System.out.println("  CollectionId: " + schedule.getCollectionId());
    System.out.println("  Subject: " + schedule.getSubject());
    
    // Kiểm tra column task_id trước
    boolean hasTaskIdColumn = hasTaskIdColumn();
    System.out.println("[DAO INSERT] Has task_id column? " + hasTaskIdColumn);
    
    String sql;
    if (hasTaskIdColumn) {
        sql = "INSERT INTO user_schedule (collection_id, task_id, day_of_week, " +
              "start_time, end_time, subject, type) " +
              "VALUES (?, ?, ?, ?, ?, ?, ?)";
    } else {
        sql = "INSERT INTO user_schedule (collection_id, day_of_week, " +
              "start_time, end_time, subject, type) " +
              "VALUES (?, ?, ?, ?, ?, ?)";
    }
    
    System.out.println("[DAO INSERT] SQL: " + sql);
    
    try (Connection conn = DBUtil.getConnection(); 
         PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        
        int paramIndex = 1;
        stmt.setInt(paramIndex++, schedule.getCollectionId());
        
        if (hasTaskIdColumn) {
            // Xử lý taskId có thể là 0 (nghĩa là không có task)
            int taskId = schedule.getTaskId();
            if (taskId > 0) {
                stmt.setInt(paramIndex++, taskId);
                System.out.println("[DAO INSERT] Setting taskId: " + taskId);
            } else {
                stmt.setNull(paramIndex++, Types.INTEGER);
                System.out.println("[DAO INSERT] Setting taskId: NULL");
            }
        }
        
        stmt.setString(paramIndex++, schedule.getDayOfWeek());
        stmt.setTime(paramIndex++, schedule.getStartTime());
        stmt.setTime(paramIndex++, schedule.getEndTime());
        stmt.setString(paramIndex++, schedule.getSubject());
        stmt.setString(paramIndex, schedule.getType());
        
        System.out.println("[DAO INSERT] Executing update...");
        int affectedRows = stmt.executeUpdate();
        System.out.println("[DAO INSERT] Affected rows: " + affectedRows);
        
        if (affectedRows > 0) {
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                int generatedId = rs.getInt(1);
                System.out.println("[DAO INSERT] Generated ID: " + generatedId);
                return generatedId;
            }
        }
        
    } catch (SQLException e) {
        System.err.println("[DAO INSERT ERROR] " + e.getMessage());
        e.printStackTrace();
    }
    
    return -1;
}

// Helper method để kiểm tra xem bảng có cột task_id không
private boolean hasTaskIdColumn() {
    try (Connection conn = DBUtil.getConnection()) {
        DatabaseMetaData metaData = conn.getMetaData();
        ResultSet columns = metaData.getColumns(null, null, "user_schedule", "task_id");
        boolean exists = columns.next();
        System.out.println("[DAO] Column task_id exists in user_schedule? " + exists);
        return exists;
    } catch (SQLException e) {
        System.err.println("[DAO] Error checking column: " + e.getMessage());
        return false;
    }
}

    /**
     * Update existing schedule
     */
    public boolean update(UserSchedule schedule) {
        String sql = "UPDATE user_schedule SET day_of_week = ?, start_time = ?, end_time = ?, subject = ?, type = ? WHERE schedule_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, schedule.getDayOfWeek());
            stmt.setTime(2, schedule.getStartTime());
            stmt.setTime(3, schedule.getEndTime());
            stmt.setString(4, schedule.getSubject());
            stmt.setString(5, schedule.getType());
            stmt.setInt(6, schedule.getScheduleId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Delete schedule by ID
     */
    public boolean delete(int scheduleId) {
        String sql = "DELETE FROM user_schedule WHERE schedule_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, scheduleId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Delete all schedules for a collection
     */
    public boolean deleteByCollectionId(int collectionId) {
        String sql = "DELETE FROM user_schedule WHERE collection_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, collectionId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Count total schedules for a collection
     */
    public int countByCollectionId(int collectionId) {
        String sql = "SELECT COUNT(*) FROM user_schedule WHERE collection_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, collectionId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Count total schedules for a user
     */
    public int countByUserId(int userId) {
        // Modified to JOIN with schedule_collection
        String sql = "SELECT COUNT(*) FROM user_schedule us "
                + "JOIN schedule_collection sc ON us.collection_id = sc.collection_id "
                + "WHERE sc.user_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Helper method to extract UserSchedule from ResultSet
     */
private UserSchedule extractScheduleFromResultSet(ResultSet rs) throws SQLException {
    UserSchedule schedule = new UserSchedule();
    
    // Debug: In ra tất cả columns
    ResultSetMetaData metaData = rs.getMetaData();
    System.out.println("[DAO EXTRACT] Available columns:");
    for (int i = 1; i <= metaData.getColumnCount(); i++) {
        System.out.println("  " + i + ": " + metaData.getColumnName(i));
    }
    
    schedule.setScheduleId(rs.getInt("schedule_id"));
    schedule.setCollectionId(rs.getInt("collection_id"));
    
    // ⭐️ QUAN TRỌNG: Lấy task_id
    int taskId = rs.getInt("task_id");
    if (!rs.wasNull()) {
        schedule.setTaskId(taskId);
        System.out.println("[DAO EXTRACT] TaskId from DB: " + taskId);
    } else {
        schedule.setTaskId(0);
        System.out.println("[DAO EXTRACT] TaskId is NULL in DB");
    }
    
    schedule.setDayOfWeek(rs.getString("day_of_week"));
    schedule.setStartTime(rs.getTime("start_time"));
    schedule.setEndTime(rs.getTime("end_time"));
    schedule.setSubject(rs.getString("subject"));
    schedule.setType(rs.getString("type"));
    
    // Debug: In ra tất cả giá trị
    System.out.println("[DAO EXTRACT] Extracted schedule: " + schedule);
    
    return schedule;
}

    /**
     * Convert day number (1-7) to day name (Mon-Sun)
     */
    private String convertDayNumberToName(int dayNumber) {
        switch (dayNumber) {
            case 1:
                return "Mon";
            case 2:
                return "Tue";
            case 3:
                return "Wed";
            case 4:
                return "Thu";
            case 5:
                return "Fri";
            case 6:
                return "Sat";
            case 7:
                return "Sun";
            default:
                return "Mon";
        }
    }

    //hàm Debug
    public void debugTableStructure() {
        try (Connection conn = DBUtil.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet columns = metaData.getColumns(null, null, "user_schedule", null);

            System.out.println("=== user_schedule Table Structure ===");
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String columnType = columns.getString("TYPE_NAME");
                System.out.println(columnName + " : " + columnType);
            }
            System.out.println("=====================================");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

/**
 * Get schedules by collectionId and day
 */
public List<UserSchedule> getByCollectionIdAndDay(int collectionId, String dayOfWeek) {
    List<UserSchedule> schedules = new ArrayList<>();
    
    // ⭐️ SỬA: Dùng đúng tên bảng "user_schedule"
    String sql = "SELECT * FROM user_schedule " +
                "WHERE collection_id = ? AND day_of_week = ? " +
                "ORDER BY start_time";
    
    try (Connection conn = DBUtil.getConnection(); 
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, collectionId);
        stmt.setString(2, dayOfWeek);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            schedules.add(extractScheduleFromResultSet(rs));
        }
        
        // Debug log
        System.out.println("[DAO] Found " + schedules.size() + 
                          " schedules for collection " + collectionId + 
                          ", day " + dayOfWeek);
        
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return schedules;
}
   
}

