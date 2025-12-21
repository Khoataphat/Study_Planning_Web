/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.WorkStyleQuestion;
import utils.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class WorkStyleQuestionDAO {
    private static final Logger logger = LoggerFactory.getLogger(WorkStyleQuestionDAO.class);

    public List<WorkStyleQuestion> getAllQuestions() {
        List<WorkStyleQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM work_style_questions ORDER BY display_order";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                WorkStyleQuestion q = new WorkStyleQuestion();
                q.setId(rs.getInt("id"));
                q.setCategory(rs.getString("category"));
                q.setQuestionText(rs.getString("question_text"));
                q.setOptionAText(rs.getString("option_a_text"));
                q.setOptionAScore(rs.getString("option_a_score"));
                q.setOptionBText(rs.getString("option_b_text"));
                q.setOptionBScore(rs.getString("option_b_score"));
                q.setOptionCText(rs.getString("option_c_text"));
                q.setOptionCScore(rs.getString("option_c_score"));
                q.setDisplayOrder(rs.getInt("display_order"));
                questions.add(q);
            }
        } catch (SQLException e) {
            logger.error("Error retrieving Work Style questions", e);
        }
        return questions;
    }
}
