package dao;

import utils.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class StudySessionDAO {

    public static void saveSession(int minutes, boolean finished) {

        String sql = "INSERT INTO study_sessions (minutes, finished) VALUES (?, ?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, minutes);
            ps.setBoolean(2, finished);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
