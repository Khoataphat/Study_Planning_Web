package com.studyplanning.dao;

import com.studyplanning.model.ScheduleCollection;
import com.studyplanning.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for schedule_collection table
 * Handles all database operations for schedule collections
 */
public class ScheduleCollectionDAO {

    /**
     * Get all collections for a specific user
     */
    public List<ScheduleCollection> getAllByUserId(int userId) {
        List<ScheduleCollection> collections = new ArrayList<>();
        String sql = "SELECT * FROM schedule_collection WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                collections.add(extractCollectionFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return collections;
    }

    /**
     * Get collection by ID
     */
    public ScheduleCollection getById(int collectionId) {
        String sql = "SELECT * FROM schedule_collection WHERE collection_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, collectionId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractCollectionFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Insert new collection
     * Returns the generated collection_id
     */
    public int insert(ScheduleCollection collection) {
        String sql = "INSERT INTO schedule_collection (user_id, collection_name) VALUES (?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, collection.getUserId());
            stmt.setString(2, collection.getCollectionName());

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
     * Update collection (rename)
     */
    public boolean update(ScheduleCollection collection) {
        String sql = "UPDATE schedule_collection SET collection_name = ? WHERE collection_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, collection.getCollectionName());
            stmt.setInt(2, collection.getCollectionId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Delete collection by ID
     * This will cascade delete all schedules in the collection
     */
    public boolean delete(int collectionId) {
        String sql = "DELETE FROM schedule_collection WHERE collection_id = ?";

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
     * Count total collections for a user
     */
    public int countByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM schedule_collection WHERE user_id = ?";

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
     * Helper method to extract ScheduleCollection from ResultSet
     */
    private ScheduleCollection extractCollectionFromResultSet(ResultSet rs) throws SQLException {
        return new ScheduleCollection(
                rs.getInt("collection_id"),
                rs.getInt("user_id"),
                rs.getString("collection_name"),
                rs.getTimestamp("created_at"),
                rs.getTimestamp("updated_at")
        );
    }
}
