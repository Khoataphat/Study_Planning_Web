/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

/**
 *
 * @author Admin
 */
import dao.WorkStyleQuestionDAO;
import dao.WorkStyleResultDAO;
import dao.QuizProgressDAO;
import model.WorkStyleQuestion;
import model.WorkStyleResult;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class WorkStyleService {
    private static final Logger logger = LoggerFactory.getLogger(WorkStyleService.class);
    
    private WorkStyleQuestionDAO questionDAO;
    private WorkStyleResultDAO resultDAO;
    private QuizProgressDAO progressDAO;
    private ObjectMapper objectMapper;
    
    public WorkStyleService() {
        this.questionDAO = new WorkStyleQuestionDAO();
        this.resultDAO = new WorkStyleResultDAO();
        this.progressDAO = new QuizProgressDAO();
        this.objectMapper = new ObjectMapper();
    }
    
    public List<WorkStyleQuestion> getWorkStyleQuestions() {
        return questionDAO.getAllQuestions();
    }
    
    public boolean hasUserCompletedQuiz(int userId) {
        return resultDAO.hasCompletedQuiz(userId);
    }
    
    public WorkStyleResult submitQuiz(int userId, Map<String, String[]> parameters) {
        try {
            logger.info("Submitting Work Style quiz for user: {}", userId);
            
            // 1. Get all questions
            List<WorkStyleQuestion> questions = questionDAO.getAllQuestions();
            
            // 2. Calculate scores
            Map<String, Integer> scores = calculateScores(questions, parameters);
            
            // 3. Determine primary style
            String primaryStyle = determinePrimaryStyle(scores);
            
            // 4. Create result
            WorkStyleResult result = new WorkStyleResult();
            result.setUserId(userId);
            result.setPrimaryStyle(primaryStyle);
            result.setLeadershipScore(scores.getOrDefault("leadership", 0));
            result.setSupportScore(scores.getOrDefault("support", 0));
            result.setAnalysisScore(scores.getOrDefault("analysis", 0));
            result.setCommunicationScore(scores.getOrDefault("communication", 0));
            result.setTeamworkScore(scores.getOrDefault("teamwork", 0));
            result.setCreativityScore(scores.getOrDefault("creativity", 0));
            
            // 5. Save result
            boolean saved = resultDAO.saveResult(result);
            
            if (saved) {
                progressDAO.updateProgress(userId, "WORK_STYLE", "COMPLETED");
                logger.info("Work Style quiz completed successfully for user: {}", userId);
                return result;
            } else {
                logger.error("Failed to save Work Style result for user: {}", userId);
                return null;
            }
            
        } catch (Exception e) {
            logger.error("Error submitting Work Style quiz for user: " + userId, e);
            return null;
        }
    }
    
    private Map<String, Integer> calculateScores(List<WorkStyleQuestion> questions, 
                                                Map<String, String[]> parameters) {
        Map<String, Integer> scores = new HashMap<>();
        
        // Initialize all score categories
        String[] categories = {"leadership", "support", "analysis", 
                              "communication", "teamwork", "creativity"};
        for (String category : categories) {
            scores.put(category, 0);
        }
        
        try {
            for (WorkStyleQuestion question : questions) {
                String paramName = "question_" + question.getId();
                String[] values = parameters.get(paramName);
                
                if (values != null && values.length > 0) {
                    String selectedOption = values[0]; // A, B, or C
                    Map<String, Integer> optionScores = null;
                    
                    // Parse JSON scores for selected option
                    switch (selectedOption) {
                        case "A":
                            optionScores = objectMapper.readValue(
                                question.getOptionAScore(), 
                                new com.fasterxml.jackson.core.type.TypeReference<Map<String, Integer>>() {}
                            );
                            break;
                        case "B":
                            optionScores = objectMapper.readValue(
                                question.getOptionBScore(), 
                                new com.fasterxml.jackson.core.type.TypeReference<Map<String, Integer>>() {}
                            );
                            break;
                        case "C":
                            if (question.getOptionCText() != null) {
                                optionScores = objectMapper.readValue(
                                    question.getOptionCScore(), 
                                    new com.fasterxml.jackson.core.type.TypeReference<Map<String, Integer>>() {}
                                );
                            }
                            break;
                    }
                    
                    // Add scores to totals
                    if (optionScores != null) {
                        for (Map.Entry<String, Integer> entry : optionScores.entrySet()) {
                            String category = entry.getKey();
                            int score = entry.getValue();
                            scores.put(category, scores.getOrDefault(category, 0) + score);
                        }
                    }
                }
            }
        } catch (Exception e) {
            logger.error("Error calculating Work Style scores", e);
        }
        
        return scores;
    }
    
    private String determinePrimaryStyle(Map<String, Integer> scores) {
        // Find the category with highest score
        String primaryStyle = "BALANCED";
        int maxScore = 0;
        
        for (Map.Entry<String, Integer> entry : scores.entrySet()) {
            if (entry.getValue() > maxScore) {
                maxScore = entry.getValue();
                primaryStyle = entry.getKey().toUpperCase();
            }
        }
        
        // Map to more user-friendly names
        switch (primaryStyle) {
            case "LEADERSHIP":
                return "LEADER";
            case "SUPPORT":
                return "SUPPORTER";
            case "ANALYSIS":
                return "ANALYZER";
            case "CREATIVITY":
                return "INNOVATOR";
            default:
                return "BALANCED";
        }
    }
    
    public WorkStyleResult getUserResult(int userId) {
        return resultDAO.getResultByUserId(userId);
    }
    
        public Map<String, String> getStyleDescription(String primaryStyle) {
        Map<String, String> descriptions = new HashMap<>();
        
        switch (primaryStyle.toUpperCase()) {
            case "LEADER":
                descriptions.put("title", "Người Lãnh đạo");
                descriptions.put("description", "Bạn có khả năng dẫn dắt và định hướng nhóm làm việc. Phong cách này phù hợp với vai trò quản lý.");
                descriptions.put("strengths", "Quyết đoán, có tầm nhìn, truyền cảm hứng");
                descriptions.put("careers", "Quản lý dự án, Team Lead, Giám đốc điều hành");
                break;
            case "SUPPORTER":
                descriptions.put("title", "Người Hỗ trợ");
                descriptions.put("description", "Bạn giỏi trong việc hỗ trợ người khác và duy trì sự hài hòa trong nhóm.");
                descriptions.put("strengths", "Đồng cảm, kiên nhẫn, hợp tác");
                descriptions.put("careers", "HR, Tư vấn, Hỗ trợ khách hàng");
                break;
            case "ANALYZER":
                descriptions.put("title", "Nhà Phân tích");
                descriptions.put("description", "Bạn có tư duy logic và khả năng phân tích vấn đề sâu sắc.");
                descriptions.put("strengths", "Logic, chi tiết, tập trung");
                descriptions.put("careers", "Data Analyst, Kế toán, Nhà nghiên cứu");
                break;
            case "INNOVATOR":
                descriptions.put("title", "Người Sáng tạo");
                descriptions.put("description", "Bạn có tư duy sáng tạo và thích nghi với những ý tưởng mới.");
                descriptions.put("strengths", "Sáng tạo, linh hoạt, tưởng tượng");
                descriptions.put("careers", "Designer, Marketing, Nghiên cứu phát triển");
                break;
            default:
                descriptions.put("title", "Đa dạng");
                descriptions.put("description", "Bạn có sự cân bằng giữa các phong cách làm việc.");
                descriptions.put("strengths", "Linh hoạt, thích nghi, toàn diện");
                descriptions.put("careers", "Đa dạng lĩnh vực");
        }
        
        return descriptions;
    }
    
    public Map<String, Integer> getScoreBreakdown(WorkStyleResult result) {
        Map<String, Integer> breakdown = new LinkedHashMap<>();
        breakdown.put("Lãnh đạo", result.getLeadershipScore());
        breakdown.put("Hỗ trợ", result.getSupportScore());
        breakdown.put("Phân tích", result.getAnalysisScore());
        breakdown.put("Giao tiếp", result.getCommunicationScore());
        breakdown.put("Làm việc nhóm", result.getTeamworkScore());
        breakdown.put("Sáng tạo", result.getCreativityScore());
        return breakdown;
    }

}
