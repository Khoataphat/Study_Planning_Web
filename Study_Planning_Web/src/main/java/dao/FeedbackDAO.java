package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import model.Feedback;
import utils.DBUtil;

public class FeedbackDAO {

    public boolean save(Feedback feedback) {
        String sql = "INSERT INTO feedback (user_id, rating, comment, collection_id) VALUES (?, ?, ?, ?)";

        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, feedback.getUserId());
            ps.setInt(2, feedback.getRating());
            ps.setString(3, feedback.getComment());
            ps.setInt(4, feedback.getCollectionId());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
