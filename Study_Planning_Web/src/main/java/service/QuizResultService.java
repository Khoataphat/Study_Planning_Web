/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

/**
 *
 * @author Admin
 */
import dao.*;
import model.*;
import java.util.*;

public class QuizResultService {
    
    private MBTIResultDAO mbtiDAO;
    private WorkStyleResultDAO workStyleDAO;
    private LearningStyleResultDAO learningStyleDAO;
    private CareerResultDAO careerDAO;
    private QuizProgressDAO progressDAO;
    
    public QuizResultService() {
        this.mbtiDAO = new MBTIResultDAO();
        this.workStyleDAO = new WorkStyleResultDAO();
        this.learningStyleDAO = new LearningStyleResultDAO();
        this.careerDAO = new CareerResultDAO();
        this.progressDAO = new QuizProgressDAO();
    }
    
    public Map<String, Object> getUserDashboardData(int userId) {
        Map<String, Object> dashboardData = new HashMap<>();
        
        // Get all quiz results
        dashboardData.put("mbtiResult", mbtiDAO.getResultByUserId(userId));
        dashboardData.put("workStyleResult", workStyleDAO.getResultByUserId(userId));
        dashboardData.put("learningStyleResult", learningStyleDAO.getResultByUserId(userId));
        dashboardData.put("careerResult", careerDAO.getResultByUserId(userId));
        
        // Get quiz progress
        List<QuizProgress> progress = progressDAO.getUserProgress(userId);
        dashboardData.put("quizProgress", progress);
        
        // Calculate completion percentage
        int completed = 0;
        int total = 4; // MBTI, Work Style, Learning Style, Career
        
        if (dashboardData.get("mbtiResult") != null) completed++;
        if (dashboardData.get("workStyleResult") != null) completed++;
        if (dashboardData.get("learningStyleResult") != null) completed++;
        if (dashboardData.get("careerResult") != null) completed++;
        
        dashboardData.put("completedQuizzes", completed);
        dashboardData.put("totalQuizzes", total);
        dashboardData.put("completionPercentage", (completed * 100) / total);
        
        // Generate personalized insights
        dashboardData.put("insights", generateInsights(dashboardData));
        
        return dashboardData;
    }
    
    private List<String> generateInsights(Map<String, Object> data) {
        List<String> insights = new ArrayList<>();
        
        MBTIResult mbti = (MBTIResult) data.get("mbtiResult");
        WorkStyleResult workStyle = (WorkStyleResult) data.get("workStyleResult");
        LearningStyleResult learning = (LearningStyleResult) data.get("learningStyleResult");
        
        if (mbti != null) {
            insights.add("Tính cách MBTI: " + mbti.getMbtiType() + " - " + mbti.getDescription());
        }
        
        if (workStyle != null) {
            insights.add("Phong cách làm việc: " + workStyle.getPrimaryStyle());
        }
        
        if (learning != null) {
            insights.add("Phong cách học tập: " + learning.getPrimaryStyle() + 
                        " (Thị giác: " + learning.getVisualPercentage() + 
                        "%, Thính giác: " + learning.getAuditoryPercentage() + 
                        "%, Vận động: " + learning.getKinestheticPercentage() + "%)");
        }
        
        // Add more insights based on combinations
        if (mbti != null && workStyle != null) {
            if (mbti.getMbtiType().startsWith("E") && "LEADER".equals(workStyle.getPrimaryStyle())) {
                insights.add("Bạn có tố chất lãnh đạo và giao tiếp tốt với mọi người");
            }
        }
        
        return insights;
    }
}
