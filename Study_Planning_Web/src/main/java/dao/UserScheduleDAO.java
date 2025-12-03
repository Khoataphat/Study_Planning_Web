package dao;

import model.UserSchedule;
import utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for user_schedule table
 * Handles all database operations for schedules
 */
public class UserScheduleDAO {

    /**
     * Get all schedules for a specific user
     */
    public List<UserSchedule> getAllByUserId(int userId) {
        List<UserSchedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM user_schedule WHERE user_id = ? ORDER BY day_of_week, start_time";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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
        String sql = "SELECT * FROM user_schedule WHERE user_id = ? AND day_of_week = ? ORDER BY start_time";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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
        String sql = "SELECT * FROM user_schedule WHERE collection_id = ? ORDER BY day_of_week, start_time";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, collectionId);
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
     * Insert new schedule
     * Returns the generated schedule_id
     */
    public int insert(UserSchedule schedule) {
        String sql = "INSERT INTO user_schedule (user_id, collection_id, day_of_week, start_time, end_time, subject, type) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, schedule.getUserId());
            stmt.setInt(2, schedule.getCollectionId());
            stmt.setString(3, schedule.getDayOfWeek());
            stmt.setTime(4, schedule.getStartTime());
            stmt.setTime(5, schedule.getEndTime());
            stmt.setString(6, schedule.getSubject());
            stmt.setString(7, schedule.getType());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    /**
     * Update existing schedule
     */
    public boolean update(UserSchedule schedule) {
        String sql = "UPDATE user_schedule SET day_of_week = ?, start_time = ?, end_time = ?, subject = ?, type = ? WHERE schedule_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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
        String sql = "SELECT COUNT(*) FROM user_schedule WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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
        return new UserSchedule(
                rs.getInt("schedule_id"),
                rs.getInt("user_id"),
                rs.getInt("collection_id"),
                rs.getString("day_of_week"),
                rs.getTime("start_time"),
                rs.getTime("end_time"),
                rs.getString("subject"),
                rs.getString("type"),
                rs.getTimestamp("created_at")
        );
    }
}
