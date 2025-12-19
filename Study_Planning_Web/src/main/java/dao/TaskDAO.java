package dao;

import model.Task;
import utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * DAO class for tasks table
 */
public class TaskDAO {

    /**
     * Get all tasks for a specific user
     */
public List<Task> getAllByUserId(int userId) {
    List<Task> tasks = new ArrayList<>();
    // Sửa query join qua user_schedule và schedule_collection
    String sql = "SELECT t.* FROM tasks t " +
                "INNER JOIN user_schedule us ON t.task_id = us.task_id " +
                "INNER JOIN schedule_collection sc ON us.collection_id = sc.collection_id " +
                "WHERE sc.user_id = ? " +
                "ORDER BY t.deadline ASC, t.priority DESC";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            tasks.add(extractTaskFromResultSet(rs));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return tasks;
}

    /**
     * Get task by ID
     */
    public Task getById(int taskId) {
        String sql = "SELECT * FROM tasks WHERE task_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, taskId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractTaskFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Insert new task
     */
 public int insert(Task task) {
    System.out.println("[TaskDAO.insert] Inserting task: " + task.getTitle());
    
    // SỬA: Bỏ user_id khỏi câu SQL vì bảng tasks không còn cột này
    String sql = "INSERT INTO tasks (title, description, priority, " +
                "duration, deadline, status, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        
        System.out.println("[TaskDAO.insert] Parameters:");
        System.out.println("  1. title: " + task.getTitle());
        System.out.println("  2. description: " + task.getDescription());
        System.out.println("  3. priority: " + task.getPriority());
        System.out.println("  4. duration: " + task.getDuration());
        System.out.println("  5. deadline: " + task.getDeadline());
        System.out.println("  6. status: " + task.getStatus());
        System.out.println("  7. created_at: " + task.getCreatedAt());
        System.out.println("  8. updated_at: " + task.getUpdatedAt());
        
        // SỬA: Chỉ còn 8 parameters, không có user_id nữa
        stmt.setString(1, task.getTitle());
        stmt.setString(2, task.getDescription());
        stmt.setString(3, task.getPriority());
        stmt.setInt(4, task.getDuration());
        
        if (task.getDeadline() != null) {
            stmt.setTimestamp(5, task.getDeadline());
        } else {
            stmt.setNull(5, Types.TIMESTAMP);
        }
        
        stmt.setString(6, task.getStatus());
        stmt.setTimestamp(7, task.getCreatedAt());
        stmt.setTimestamp(8, task.getUpdatedAt());
        
        int affectedRows = stmt.executeUpdate();
        System.out.println("[TaskDAO.insert] Affected rows: " + affectedRows);
        
        if (affectedRows > 0) {
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                int taskId = rs.getInt(1);
                System.out.println("[TaskDAO.insert] Generated taskId: " + taskId);
                
                // QUAN TRỌNG: Cần tạo record trong user_schedule để liên kết task với user
                linkTaskToUser(taskId, task.getUserId(), task);
                
                return taskId;
            }
        }
        
        System.err.println("[TaskDAO.insert] No keys generated");
        return -1;
        
    } catch (SQLException e) {
        System.err.println("[TaskDAO.insert] SQL Error: " + e.getMessage());
        e.printStackTrace();
        return -1;
    }
}
 
/**
 * Helper method để liên kết task với user thông qua user_schedule
 */
private void linkTaskToUser(int taskId, int userId, Task task) {
    try {
        // 1. Tìm hoặc tạo collection
        int collectionId = findOrCreateCollection(userId);
        
        if (collectionId == -1) {
            System.err.println("[TaskDAO] Failed to find or create collection for user: " + userId);
            return;
        }
        
        // ⭐️ QUAN TRỌNG: Sử dụng deadline từ task làm thời gian
        Timestamp deadline = task.getDeadline();
        
        if (deadline == null) {
            System.err.println("[TaskDAO] Task deadline is null, cannot create schedule");
            return;
        }
        
        // 2. Tính startTime từ deadline và duration
        Timestamp startTime = deadline;
        if (task.getDuration() > 0) {
            // Trừ duration từ deadline để lấy startTime
            long startMillis = deadline.getTime() - (task.getDuration() * 60000L);
            startTime = new Timestamp(startMillis);
        }
        
        // ⭐️ QUAN TRỌNG: Tính day_of_week từ startTime (KHÔNG phải deadline)
        Calendar cal = Calendar.getInstance();
        cal.setTime(startTime);
        
        // Chuyển đổi: Calendar day (1=Sunday, 2=Monday, ..., 7=Saturday)
        // Sang hệ thống của chúng ta: (Mon=1, Tue=2, ..., Sun=7)
        int calendarDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
        String dayOfWeek = convertCalendarDayToDayName(calendarDayOfWeek);
        
        System.out.println("[TaskDAO] Date info - StartTime: " + startTime + 
                         ", Deadline: " + deadline + 
                         ", Calendar Day: " + calendarDayOfWeek + 
                         ", Our Day: " + dayOfWeek);
        
        // 3. Insert vào user_schedule
        String insertSql = "INSERT INTO user_schedule " +
                          "(collection_id, task_id, day_of_week, schedule_date, " +
                          "start_time, end_time, subject, type, created_at) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, 'self-study', NOW())";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, collectionId);
            stmt.setInt(2, taskId);
            stmt.setString(3, dayOfWeek);
            stmt.setTimestamp(4, startTime); // schedule_date
            stmt.setTime(5, new Time(startTime.getTime())); // start_time
            stmt.setTime(6, new Time(deadline.getTime()));  // end_time
            stmt.setString(7, task.getTitle()); // subject
            
            int rows = stmt.executeUpdate();
            System.out.println("[TaskDAO] Linked task " + taskId + 
                             " to schedule in collection " + collectionId + 
                             ", day: " + dayOfWeek + 
                             ", rows affected: " + rows);
            
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                int scheduleId = rs.getInt(1);
                System.out.println("[TaskDAO] Generated scheduleId: " + scheduleId);
            }
        }
        
    } catch (SQLException e) {
        System.err.println("[TaskDAO] Error linking task to user: " + e.getMessage());
        e.printStackTrace();
    }
}

// ⭐️ HÀM MỚI: Chuyển đổi Calendar.DAY_OF_WEEK sang hệ thống của chúng ta
private String convertCalendarDayToDayName(int calendarDay) {
    // Calendar: 1=Sunday, 2=Monday, ..., 7=Saturday
    // Hệ thống: Mon=1, Tue=2, Wed=3, Thu=4, Fri=5, Sat=6, Sun=7
    switch (calendarDay) {
        case Calendar.MONDAY: return "Mon";
        case Calendar.TUESDAY: return "Tue";
        case Calendar.WEDNESDAY: return "Wed";
        case Calendar.THURSDAY: return "Thu";
        case Calendar.FRIDAY: return "Fri";
        case Calendar.SATURDAY: return "Sat";
        case Calendar.SUNDAY: return "Sun";
        default: return "Mon";
    }
}

private int findOrCreateCollection(int userId) throws SQLException {
    // Tìm collection hiện có
    String findSql = "SELECT collection_id FROM schedule_collection WHERE user_id = ? LIMIT 1";
    
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(findSql)) {
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            return rs.getInt("collection_id");
        }
    }
    
    // Tạo collection mới nếu chưa có
    String createSql = "INSERT INTO schedule_collection (user_id, collection_name, created_at, updated_at) " +
                      "VALUES (?, 'Default Schedule', NOW(), NOW())";
    
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(createSql, Statement.RETURN_GENERATED_KEYS)) {
        stmt.setInt(1, userId);
        stmt.executeUpdate();
        
        ResultSet rs = stmt.getGeneratedKeys();
        if (rs.next()) {
            return rs.getInt(1);
        }
    }
    
    return -1;
}

// Helper method: chuyển Timestamp sang day_of_week (1-7)
private int getDayOfWeek(Timestamp timestamp) {
    if (timestamp == null) return 1; // Default Monday
    
    Calendar cal = Calendar.getInstance();
    cal.setTime(timestamp);
    
    // Chuyển từ Calendar day (1=Sunday, 7=Saturday) sang (1=Monday, 7=Sunday)
    int calendarDay = cal.get(Calendar.DAY_OF_WEEK); // 1=Sun, 2=Mon, ..., 7=Sat
    return calendarDay == 1 ? 7 : calendarDay - 1; // 1=Mon, 7=Sun
}

/**
 * Tạo schedule collection mới cho user nếu chưa có
 */
private int createScheduleCollection(int userId) throws SQLException {
    String sql = "INSERT INTO schedule_collection (user_id, collection_name, created_at, updated_at) VALUES (?, 'Default', NOW(), NOW())";
    
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        stmt.setInt(1, userId);
        stmt.executeUpdate();
        
        ResultSet rs = stmt.getGeneratedKeys();
        if (rs.next()) {
            return rs.getInt(1);
        }
    }
    return -1;
}

    /**
     * Update existing task
     */
    public boolean update(Task task) {
        String sql = "UPDATE tasks SET title = ?, description = ?, priority = ?, " +
                    "duration = ?, deadline = ?, status = ? WHERE task_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, task.getTitle());
            stmt.setString(2, task.getDescription());
            stmt.setString(3, task.getPriority());
            stmt.setInt(4, task.getDuration());
            stmt.setTimestamp(5, task.getDeadline());
            stmt.setString(6, task.getStatus());
            stmt.setInt(7, task.getTaskId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Delete task by ID
     */
    public boolean delete(int taskId) {
        String sql = "DELETE FROM tasks WHERE task_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, taskId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get tasks by status
     */
    public List<Task> getByUserIdAndStatus(int userId, String status) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM tasks WHERE user_id = ? AND status = ? ORDER BY deadline ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setString(2, status);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                tasks.add(extractTaskFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }

    /**
     * Helper method to extract Task from ResultSet
     */
private Task extractTaskFromResultSet(ResultSet rs) throws SQLException {
    Task task = new Task();
    task.setTaskId(rs.getInt("task_id"));
    // BỎ: task.setUserId(rs.getInt("user_id")); // Không còn trong bảng tasks
    task.setTitle(rs.getString("title"));
    task.setDescription(rs.getString("description"));
    task.setPriority(rs.getString("priority"));
    task.setDuration(rs.getInt("duration"));
    task.setDeadline(rs.getTimestamp("deadline"));
    task.setStatus(rs.getString("status"));
    task.setCreatedAt(rs.getTimestamp("created_at"));
    task.setUpdatedAt(rs.getTimestamp("updated_at"));
    return task;
}
}
