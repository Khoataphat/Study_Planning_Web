/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

/**
 *
 * @author Admin
 */
import com.fasterxml.jackson.databind.JsonNode;
import dao.CareerQuestionDAO;
import dao.CareerResultDAO;
import dao.QuizProgressDAO;
import model.CareerQuestion;
import model.CareerResult;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.util.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CareerService {
    private static final Logger logger = LoggerFactory.getLogger(CareerService.class);
    
    private CareerQuestionDAO questionDAO;
    private CareerResultDAO resultDAO;
    private QuizProgressDAO progressDAO;
    private ObjectMapper objectMapper;
    
    // Career recommendations mapping
    private static final Map<String, List<String>> CAREER_MAPPING = new HashMap<>();
    
    static {
        // Technology careers
        CAREER_MAPPING.put("TECHNOLOGY", Arrays.asList(
            "Lập trình viên Full-stack",
            "Data Scientist",
            "Kỹ sư AI/Machine Learning",
            "Chuyên gia bảo mật mạng",
            "DevOps Engineer",
            "UI/UX Designer",
            "Quản trị hệ thống",
            "Kỹ sư phần mềm nhúng"
        ));
        
        // Business careers
        CAREER_MAPPING.put("BUSINESS", Arrays.asList(
            "Business Analyst",
            "Quản lý dự án",
            "Chuyên viên Marketing Digital",
            "Nhân viên kinh doanh",
            "Kế toán - Kiểm toán",
            "Tư vấn tài chính",
            "Quản lý nhân sự",
            "Startup Founder"
        ));
        
        // Creative careers
        CAREER_MAPPING.put("CREATIVE", Arrays.asList(
            "Graphic Designer",
            "Content Creator",
            "Video Editor & Producer",
            "Kiến trúc sư",
            "Game Designer",
            "Nhà thiết kế nội thất",
            "Nhiếp ảnh gia",
            "Biên tập viên"
        ));
        
        // Science careers
        CAREER_MAPPING.put("SCIENCE", Arrays.asList(
            "Nhà nghiên cứu khoa học",
            "Kỹ sư y sinh",
            "Chuyên gia môi trường",
            "Dược sĩ",
            "Kỹ thuật viên phòng lab",
            "Nhà khoa học dữ liệu",
            "Kỹ sư hóa học",
            "Chuyên gia dinh dưỡng"
        ));
        
        // Education careers
        CAREER_MAPPING.put("EDUCATION", Arrays.asList(
            "Giáo viên",
            "Giảng viên đại học",
            "Chuyên viên đào tạo",
            "Nhà nghiên cứu giáo dục",
            "Tư vấn hướng nghiệp",
            "Quản lý trường học",
            "EdTech Specialist",
            "Instructional Designer"
        ));
        
        // Social careers
        CAREER_MAPPING.put("SOCIAL", Arrays.asList(
            "Công tác xã hội",
            "Nhà tâm lý học",
            "Chuyên viên nhân sự",
            "Quan hệ công chúng",
            "Event Planner",
            "Quản lý tổ chức phi lợi nhuận",
            "Luật sư",
            "Chính trị gia"
        ));
    }
    
    public CareerService() {
        this.questionDAO = new CareerQuestionDAO();
        this.resultDAO = new CareerResultDAO();
        this.progressDAO = new QuizProgressDAO();
        this.objectMapper = new ObjectMapper();
    }
    
    public List<CareerQuestion> getCareerQuestions() {
        return questionDAO.getAllQuestions();
    }
    
    public boolean hasUserCompletedQuiz(int userId) {
        return resultDAO.hasCompletedQuiz(userId);
    }
    
    public CareerResult submitQuiz(int userId, Map<String, String[]> parameters) {
        try {
            logger.info("Processing Career quiz for user: {}", userId);
            
            List<CareerQuestion> questions = getCareerQuestions();
            
            // Initialize scores
            Map<String, Integer> scores = new HashMap<>();
            scores.put("technology", 0);
            scores.put("business", 0);
            scores.put("creative", 0);
            scores.put("science", 0);
            scores.put("education", 0);
            scores.put("social", 0);
            
            // Calculate scores from answers
            for (CareerQuestion question : questions) {
                String paramName = "question_" + question.getId();
                String[] values = parameters.get(paramName);
                
                if (values != null && values.length > 0) {
                    try {
                        int answerValue = Integer.parseInt(values[0]);
                        
                        // Validate answer range (1-5)
                        if (answerValue < 1) answerValue = 1;
                        if (answerValue > 5) answerValue = 5;
                        
                        // Add weighted scores
                        scores.put("technology", scores.get("technology") + 
                                  question.getTechnologyScore() * answerValue);
                        scores.put("business", scores.get("business") + 
                                  question.getBusinessScore() * answerValue);
                        scores.put("creative", scores.get("creative") + 
                                  question.getCreativeScore() * answerValue);
                        scores.put("science", scores.get("science") + 
                                  question.getScienceScore() * answerValue);
                        scores.put("education", scores.get("education") + 
                                  question.getEducationScore() * answerValue);
                        scores.put("social", scores.get("social") + 
                                  question.getSocialScore() * answerValue);
                        
                    } catch (NumberFormatException e) {
                        logger.warn("Invalid answer format for question {}: {}", 
                                   question.getId(), values[0]);
                    }
                }
            }
            
            // Find top 3 categories
            List<Map.Entry<String, Integer>> sortedScores = new ArrayList<>(scores.entrySet());
            sortedScores.sort((a, b) -> b.getValue().compareTo(a.getValue()));
            
            // Generate top career recommendations
            ArrayNode topCareersArray = objectMapper.createArrayNode();
            
            // Add top 3 categories with 2 careers each
            for (int i = 0; i < Math.min(3, sortedScores.size()); i++) {
                String category = sortedScores.get(i).getKey().toUpperCase();
                List<String> careers = CAREER_MAPPING.get(category);
                
                if (careers != null && !careers.isEmpty()) {
                    // Add category header
                    ObjectNode categoryNode = objectMapper.createObjectNode();
                    categoryNode.put("category", category);
                    categoryNode.put("score", sortedScores.get(i).getValue());
                    
                    ArrayNode careerList = objectMapper.createArrayNode();
                    for (String career : careers.subList(0, Math.min(3, careers.size()))) {
                        careerList.add(career);
                    }
                    categoryNode.set("careers", careerList);
                    
                    topCareersArray.add(categoryNode);
                }
            }
            
            String topCareersJson = objectMapper.writeValueAsString(topCareersArray);
            
            // Create result object
            CareerResult result = new CareerResult();
            result.setUserId(userId);
            result.setTechnologyScore(scores.get("technology"));
            result.setBusinessScore(scores.get("business"));
            result.setCreativeScore(scores.get("creative"));
            result.setScienceScore(scores.get("science"));
            result.setEducationScore(scores.get("education"));
            result.setSocialScore(scores.get("social"));
            result.setTopCareers(topCareersJson);
            
            // Save to database
            boolean saved = resultDAO.saveResult(result);
            
            if (saved) {
                progressDAO.updateProgress(userId, "CAREER", "COMPLETED");
                logger.info("Career quiz completed for user {} - Top category: {}", 
                           userId, result.getTopCategory());
                return result;
            } else {
                logger.error("Failed to save Career result for user: {}", userId);
                return null;
            }
            
        } catch (Exception e) {
            logger.error("Error processing Career quiz for user: " + userId, e);
            return null;
        }
    }
    
    public CareerResult getUserResult(int userId) {
        return resultDAO.getResultByUserId(userId);
    }
    
    public Map<String, Integer> getScoreBreakdown(CareerResult result) {
        Map<String, Integer> breakdown = new LinkedHashMap<>();
        breakdown.put("Công nghệ", result.getTechnologyScore());
        breakdown.put("Kinh doanh", result.getBusinessScore());
        breakdown.put("Sáng tạo", result.getCreativeScore());
        breakdown.put("Khoa học", result.getScienceScore());
        breakdown.put("Giáo dục", result.getEducationScore());
        breakdown.put("Xã hội", result.getSocialScore());
        return breakdown;
    }
    
    public boolean resetQuiz(int userId) {
        boolean deleted = resultDAO.deleteResult(userId);
        if (deleted) {
            progressDAO.updateProgress(userId, "CAREER", "NOT_STARTED");
            logger.info("Reset Career quiz for user: {}", userId);
        }
        return deleted;
    }
    
    // Thêm phương thức này vào CareerService.java
public List<Map<String, Object>> getCareerRecommendations(CareerResult result) {
    List<Map<String, Object>> recommendations = new ArrayList<>();
    
    try {
        // Kiểm tra nếu có dữ liệu JSON trong topCareers
        if (result.getTopCareers() != null && !result.getTopCareers().isEmpty()) {
            // Phân tích JSON và chuyển thành List<Map>
            JsonNode rootNode = objectMapper.readTree(result.getTopCareers());
            
            for (JsonNode categoryNode : rootNode) {
                Map<String, Object> categoryMap = new HashMap<>();
                String category = categoryNode.get("category").asText();
                int score = categoryNode.get("score").asInt();
                
                categoryMap.put("categoryName", category);
                categoryMap.put("score", score);
                
                List<String> careers = new ArrayList<>();
                JsonNode careersNode = categoryNode.get("careers");
                if (careersNode.isArray()) {
                    for (JsonNode careerNode : careersNode) {
                        careers.add(careerNode.asText());
                    }
                }
                categoryMap.put("careers", careers);
                
                recommendations.add(categoryMap);
            }
        } else {
            // Nếu không có dữ liệu, tạo recommendations dựa trên điểm số
            recommendations = createFallbackRecommendations(result);
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        // Nếu có lỗi, tạo recommendations dựa trên điểm số
        recommendations = createFallbackRecommendations(result);
    }
    
    return recommendations;
}

private List<Map<String, Object>> createFallbackRecommendations(CareerResult result) {
    List<Map<String, Object>> recommendations = new ArrayList<>();
    
    // Tạo danh sách tất cả categories với điểm số
    List<Map<String, Object>> allCategories = new ArrayList<>();
    
    // Technology
    if (result.getTechnologyScore() > 0) {
        Map<String, Object> techMap = new HashMap<>();
        techMap.put("categoryName", "TECHNOLOGY");
        techMap.put("score", result.getTechnologyScore());
        techMap.put("careers", Arrays.asList(
            "Lập trình viên Full-stack", 
            "Data Scientist", 
            "Chuyên gia bảo mật"
        ));
        allCategories.add(techMap);
    }
    
    // Business
    if (result.getBusinessScore() > 0) {
        Map<String, Object> businessMap = new HashMap<>();
        businessMap.put("categoryName", "BUSINESS");
        businessMap.put("score", result.getBusinessScore());
        businessMap.put("careers", Arrays.asList(
            "Business Analyst", 
            "Digital Marketing", 
            "Quản lý dự án"
        ));
        allCategories.add(businessMap);
    }
    
    // Creative
    if (result.getCreativeScore() > 0) {
        Map<String, Object> creativeMap = new HashMap<>();
        creativeMap.put("categoryName", "CREATIVE");
        creativeMap.put("score", result.getCreativeScore());
        creativeMap.put("careers", Arrays.asList(
            "UI/UX Designer", 
            "Content Creator", 
            "Kiến trúc sư"
        ));
        allCategories.add(creativeMap);
    }
    
    // Science
    if (result.getScienceScore() > 0) {
        Map<String, Object> scienceMap = new HashMap<>();
        scienceMap.put("categoryName", "SCIENCE");
        scienceMap.put("score", result.getScienceScore());
        scienceMap.put("careers", Arrays.asList(
            "Nhà nghiên cứu", 
            "Kỹ sư y sinh", 
            "Chuyên gia môi trường"
        ));
        allCategories.add(scienceMap);
    }
    
    // Education
    if (result.getEducationScore() > 0) {
        Map<String, Object> educationMap = new HashMap<>();
        educationMap.put("categoryName", "EDUCATION");
        educationMap.put("score", result.getEducationScore());
        educationMap.put("careers", Arrays.asList(
            "Giáo viên", 
            "Giảng viên đại học", 
            "Chuyên gia đào tạo"
        ));
        allCategories.add(educationMap);
    }
    
    // Social
    if (result.getSocialScore() > 0) {
        Map<String, Object> socialMap = new HashMap<>();
        socialMap.put("categoryName", "SOCIAL");
        socialMap.put("score", result.getSocialScore());
        socialMap.put("careers", Arrays.asList(
            "Chuyên viên tâm lý", 
            "Công tác xã hội", 
            "Chuyên viên nhân sự"
        ));
        allCategories.add(socialMap);
    }
    
    // Sắp xếp theo điểm số giảm dần
    allCategories.sort((a, b) -> {
        int scoreA = (int) b.get("score");
        int scoreB = (int) a.get("score");
        return Integer.compare(scoreA, scoreB);
    });
    
    // Lấy top 3
    return allCategories.subList(0, Math.min(3, allCategories.size()));
}
}