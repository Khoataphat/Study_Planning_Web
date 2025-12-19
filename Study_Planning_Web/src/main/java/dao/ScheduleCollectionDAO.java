package dao;

import model.ScheduleCollection;
import utils.DBUtil;

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
    public int insert(ScheduleCollection collection) throws SQLException {
        System.out.println("DEBUG: Inserting collection: " + collection);
        System.out.println("DEBUG: Collection user_id = " + collection.getUserId());
        System.out.println("DEBUG: Collection name = " + collection.getCollectionName());

        // VERIFICATION: Check if user_id exists RIGHT BEFORE insert
        String checkSql = "SELECT user_id, username, email FROM users WHERE user_id = ?";
        try (Connection checkConn = DBUtil.getConnection();
                PreparedStatement checkStmt = checkConn.prepareStatement(checkSql)) {
            checkStmt.setInt(1, collection.getUserId());
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                System.out.println("DEBUG: ✅ User EXISTS in database:");
                System.out.println("  - user_id: " + rs.getInt("user_id"));
                System.out.println("  - username: " + rs.getString("username"));
                System.out.println("  - email: " + rs.getString("email"));
            } else {
                System.out.println("DEBUG: ❌ User DOES NOT EXIST in database for user_id = " + collection.getUserId());
            }
        } catch (SQLException e) {
            System.out.println("DEBUG: Error checking user existence: " + e.getMessage());
        }

        String sql = "INSERT INTO schedule_collection (user_id, collection_name, created_at) VALUES (?, ?, NOW())";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, collection.getUserId());
            stmt.setString(2, collection.getCollectionName());

            System.out.println("DEBUG: About to execute INSERT with user_id = " + collection.getUserId());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    int generatedId = rs.getInt(1);
                    System.out.println("DEBUG: ✅ INSERT SUCCESSFUL! Generated collection_id = " + generatedId);
                    return generatedId;
                }
            }
        } catch (SQLException e) {
            System.out.println("DEBUG: ❌ INSERT FAILED!");
            System.out.println("DEBUG: SQLException: " + e.getMessage());
            System.out.println("DEBUG: SQLState: " + e.getSQLState());
            System.out.println("DEBUG: ErrorCode: " + e.getErrorCode());
            throw e; // Re-throw to be caught by controller
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
        String deleteSchedulesSql = "DELETE FROM user_schedule WHERE collection_id = ?";
        String deleteCollectionSql = "DELETE FROM schedule_collection WHERE collection_id = ?";

        try (Connection conn = DBUtil.getConnection()) {
            // Start transaction
            conn.setAutoCommit(false);

            try (PreparedStatement stmt1 = conn.prepareStatement(deleteSchedulesSql);
                    PreparedStatement stmt2 = conn.prepareStatement(deleteCollectionSql)) {

                // 1. Delete associated schedules
                stmt1.setInt(1, collectionId);
                stmt1.executeUpdate();

                // 2. Delete the collection itself
                stmt2.setInt(1, collectionId);
                int rowsAffected = stmt2.executeUpdate();

                conn.commit();
                return rowsAffected > 0;

            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }

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
                rs.getTimestamp("updated_at"));
    }
}