package service;

import dao.UserDAO;
import dao.UserProfilesDAO;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.UserProfiles;

public class UserProfilesService {

    private final UserProfilesDAO profilesDAO;
    private final UserDAO userDAO;

    // Constructor không tham số
    public UserProfilesService() {
        this.profilesDAO = new UserProfilesDAO();
        this.userDAO = new UserDAO();
    }

    // Constructor nhận DAO (dùng cho DI hoặc test)
    public UserProfilesService(UserProfilesDAO profilesDAO, UserDAO userDAO) {
        this.profilesDAO = profilesDAO;
        this.userDAO = userDAO;
    }

    /**
     * Lấy profile (nếu chưa có → tạo default)
     * @param userId
     */
    public UserProfiles getProfile(int userId) throws Exception {
        UserProfiles profile = profilesDAO.getLatestUserProfile(userId);

        if (profile == null) {
            profile = createDefault(userId);
            profilesDAO.insert(profile);
            userDAO.markSetupDone(userId);
        }

        return profile;
    }

    /**
     * Lưu mới profile
     * @param profile
     */
    public boolean save(UserProfiles profile) throws Exception {
        validate(profile);
        boolean ok = profilesDAO.insert(profile);

        if (ok) userDAO.markSetupDone(profile.getUserId());

        return ok;
    }

    /**
     * Cập nhật profile
     */
    public boolean update(UserProfiles profile) {
        validate(profile);
        return profilesDAO.update(profile);
    }

    /**
     * Validation logic
     */
    private void validate(UserProfiles p) {
        if (p.getFullName() == null || p.getFullName().isBlank()) {
            throw new IllegalArgumentException("Full name is required");
        }
    }

    /**
     * Default profile
     */
    private UserProfiles createDefault(int userId) {
        UserProfiles p = new UserProfiles();
        p.setUserId(userId);
        p.setFullName("Người dùng mới");
        p.setDescription("Chưa có mô tả");
        p.setLearningStyle("visual");
        p.setWorkStyle("individual");
        p.setPreferredStudyTime("morning");
        p.setYearOfStudy(1);
        p.setFocusDuration(45);
        p.setHobbies("Đọc sách");
        p.setGoal("Hoàn thành khóa học");

        return p;
    }

    public void saveSetup(UserProfiles profile) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    /**
     * Tạo hồ sơ mới từ form hoàn thiện hồ sơ
     */
    public boolean createUserProfile(int userId, String fullName, String description,
                                    String learningStyle, String workStyle, 
                                    String interests, String productiveTime) throws Exception {
        try {
            UserProfiles profile = new UserProfiles();
            profile.setUserId(userId);
            profile.setFullName(fullName);
            profile.setDescription(description);
            profile.setLearningStyle(learningStyle);
            profile.setWorkStyle(workStyle);
            profile.setInterests(interests);
            profile.setProductiveTime(productiveTime);
            profile.setCreatedAt(LocalDateTime.now());
            
            boolean success = profilesDAO.createUserProfile(profile);
            if (success) {
                userDAO.markSetupDone(userId);
            }
            return success;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Cập nhật thông tin profile từ form hoàn thiện hồ sơ
     */
    public boolean updateUserProfile(int userId, String fullName, String description,
                                    String learningStyle, String workStyle, 
                                    String interests, String productiveTime) {
        try {
            // Lấy profile hiện tại
            UserProfiles existingProfile = profilesDAO.getProfileByUserId(userId);
            
            if (existingProfile == null) {
                return createUserProfile(userId, fullName, description, 
                                        learningStyle, workStyle, interests, productiveTime);
            }
            
            // Cập nhật thông tin
            existingProfile.setFullName(fullName);
            existingProfile.setDescription(description);
            existingProfile.setLearningStyle(learningStyle);
            existingProfile.setWorkStyle(workStyle);
            existingProfile.setInterests(interests);
            existingProfile.setProductiveTime(productiveTime);
            existingProfile.setUpdatedAt(LocalDateTime.now());
            
            return profilesDAO.update(existingProfile);
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra user đã có profile chưa
     */
    public boolean hasUserProfile(int userId) {
        UserProfiles profile = profilesDAO.getProfileByUserId(userId);
        return profile != null;
    }
    
    /**
     * Cập nhật kết quả trắc nghiệm từ form khám phá phương pháp học
     */
    public boolean updateLearningStyleQuiz(int userId, String studyMethodVisual,
                                         String studyMethodAuditory, String studyMethodReading,
                                         String studyMethodPractice, String productiveTime,
                                         int groupStudyPreference) {
        try {
            return profilesDAO.updateLearningQuizNew(
                userId, 
                studyMethodVisual != null ? "selected" : "",
                studyMethodAuditory != null ? "selected" : "",
                studyMethodReading != null ? "selected" : "",
                studyMethodPractice != null ? "selected" : "",
                productiveTime,
                groupStudyPreference
            );
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra đã hoàn thành trắc nghiệm chưa
     */
    public boolean hasCompletedLearningStyleQuiz(int userId) {
        return profilesDAO.hasCompletedLearningStyleSetup(userId);
    }
    
    /**
     * Lấy toàn bộ profile của user (phiên bản mới)
     */
    public UserProfiles getUserProfile(int userId) {
        return profilesDAO.getProfileByUserId(userId);
    }
    
    /**
     * Phân tích và đưa ra gợi ý học tập
     * @param userId
     * @param userId
     * @param userId
     * @param userId
     * @return 
     * @return  
     */
    public String analyzeProfileAndSuggest(int userId) {
        UserProfiles profile = getUserProfile(userId);
        if (profile == null) {
            return "Bạn chưa hoàn thành hồ sơ. Vui lòng điền đầy đủ thông tin.";
        }
        
        StringBuilder suggestions = new StringBuilder();
        suggestions.append("<h3 class='text-xl font-bold mb-4'>📊 Gợi ý học tập dành cho bạn:</h3>");
        
        // Phân tích phong cách học
        String learningStyle = profile.getLearningStyle();
        if ("visual".equals(learningStyle)) {
            suggestions.append("<div class='p-4 bg-blue-50 rounded-lg mb-4'>");
            suggestions.append("<h4 class='font-bold text-blue-700 mb-2'>🎨 Bạn là người học qua hình ảnh:</h4>");
            suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
            suggestions.append("<li>Sử dụng mindmap, sơ đồ tư duy</li>");
            suggestions.append("<li>Xem video bài giảng, infographic</li>");
            suggestions.append("<li>Dùng highlight để đánh dấu thông tin quan trọng</li>");
            suggestions.append("</ul></div>");
        } else if ("auditory".equals(learningStyle)) {
            suggestions.append("<div class='p-4 bg-green-50 rounded-lg mb-4'>");
            suggestions.append("<h4 class='font-bold text-green-700 mb-2'>🎧 Bạn học tốt qua âm thanh:</h4>");
            suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
            suggestions.append("<li>Ghi âm bài giảng và nghe lại</li>");
            suggestions.append("<li>Tham gia thảo luận nhóm</li>");
            suggestions.append("<li>Sử dụng podcast, audiobook</li>");
            suggestions.append("</ul></div>");
        } else if ("kinesthetic".equals(learningStyle)) {
            suggestions.append("<div class='p-4 bg-purple-50 rounded-lg mb-4'>");
            suggestions.append("<h4 class='font-bold text-purple-700 mb-2'>🖐️ Bạn học qua thực hành:</h4>");
            suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
            suggestions.append("<li>Làm bài tập, project thực tế</li>");
            suggestions.append("<li>Thí nghiệm, mô phỏng</li>");
            suggestions.append("<li>Kết hợp học với vận động</li>");
            suggestions.append("</ul></div>");
        }
        
        // Phân tích phong cách làm việc
        String workStyle = profile.getWorkStyle();
        if ("alone".equals(workStyle)) {
            suggestions.append("<div class='p-4 bg-yellow-50 rounded-lg mb-4'>");
            suggestions.append("<h4 class='font-bold text-yellow-700 mb-2'>🧘 Ưu điểm làm việc độc lập:</h4>");
            suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
            suggestions.append("<li>Tập trung cao độ</li>");
            suggestions.append("<li>Tự chủ thời gian</li>");
            suggestions.append("<li>Phát triển tư duy cá nhân</li>");
            suggestions.append("</ul></div>");
        } else if ("group".equals(workStyle)) {
            suggestions.append("<div class='p-4 bg-pink-50 rounded-lg mb-4'>");
            suggestions.append("<h4 class='font-bold text-pink-700 mb-2'>👥 Ưu điểm làm việc nhóm:</h4>");
            suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
            suggestions.append("<li>Học hỏi từ người khác</li>");
            suggestions.append("<li>Phát triển kỹ năng giao tiếp</li>");
            suggestions.append("<li>Giải quyết vấn đề đa chiều</li>");
            suggestions.append("</ul></div>");
        }
        
        // Phân tích thời gian năng suất
        String productiveTime = profile.getProductiveTime();
        if (productiveTime != null) {
            suggestions.append("<div class='p-4 bg-teal-50 rounded-lg'>");
            suggestions.append("<h4 class='font-bold text-teal-700 mb-2'>⏰ Thời gian học hiệu quả:</h4>");
            
            switch (productiveTime) {
                case "morning":
                    suggestions.append("<p class='font-medium mb-2'>☀️ <strong>Buổi sáng (6h-12h)</strong></p>");
                    suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
                    suggestions.append("<li>Sắp xếp môn khó vào buổi sáng</li>");
                    suggestions.append("<li>Dậy sớm ôn bài</li>");
                    suggestions.append("<li>Tận dụng năng lượng đầu ngày</li>");
                    suggestions.append("</ul>");
                    break;
                case "afternoon":
                    suggestions.append("<p class='font-medium mb-2'>🏙️ <strong>Buổi chiều (12h-18h)</strong></p>");
                    suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
                    suggestions.append("<li>Học các môn cần sự tỉnh táo</li>");
                    suggestions.append("<li>Làm bài tập vào buổi chiều</li>");
                    suggestions.append("<li>Kết hợp học và thực hành</li>");
                    suggestions.append("</ul>");
                    break;
                case "evening":
                    suggestions.append("<p class='font-medium mb-2'>🌙 <strong>Buổi tối (18h-24h)</strong></p>");
                    suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
                    suggestions.append("<li>Ôn tập lại kiến thức trong ngày</li>");
                    suggestions.append("<li>Làm bài tập về nhà</li>");
                    suggestions.append("<li>Chuẩn bị cho ngày hôm sau</li>");
                    suggestions.append("</ul>");
                    break;
                case "night":
                    suggestions.append("<p class='font-medium mb-2'>🌃 <strong>Đêm khuya (0h-6h)</strong></p>");
                    suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
                    suggestions.append("<li>Học trong không gian yên tĩnh</li>");
                    suggestions.append("<li>Tập trung cao độ không bị phân tán</li>");
                    suggestions.append("<li>Dành cho các công việc đòi hỏi sáng tạo</li>");
                    suggestions.append("</ul>");
                    break;
                default:
                    suggestions.append("<p>Thời gian học tập chưa được xác định</p>");
                    break;
            }
            suggestions.append("</div>");
        }
        
        return suggestions.toString();
    }
    
    public boolean createUserProfileNew(int userId, String fullName, String description,
                                    String learningStyle, String workStyle, 
                                    String interests, String productiveTime) {
        try {
            UserProfiles profile = new UserProfiles();
            profile.setUserId(userId);
            profile.setFullName(fullName);
            profile.setDescription(description);
            profile.setLearningStyle(learningStyle);
            profile.setWorkStyle(workStyle);
            profile.setInterests(interests);
            profile.setProductiveTime(productiveTime);
            profile.setCreatedAt(LocalDateTime.now());
            
            boolean success = profilesDAO.createUserProfile(profile);
            if (success) {
                userDAO.markSetupDone(userId);
            }
            return success;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } catch (Exception ex) {
            Logger.getLogger(UserProfilesService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    /**
     * Cập nhật thông tin profile từ form hoàn thiện hồ sơ
     */
    public boolean updateUserProfileNew(int userId, String fullName, String description,
                                    String learningStyle, String workStyle, 
                                    String interests, String productiveTime) {
        try {
            // Lấy profile hiện tại
            UserProfiles existingProfile = profilesDAO.getProfileByUserId(userId);
            
            if (existingProfile == null) {
                return createUserProfile(userId, fullName, description, 
                                        learningStyle, workStyle, interests, productiveTime);
            }
            
            // Cập nhật thông tin
            existingProfile.setFullName(fullName);
            existingProfile.setDescription(description);
            existingProfile.setLearningStyle(learningStyle);
            existingProfile.setWorkStyle(workStyle);
            existingProfile.setInterests(interests);
            existingProfile.setProductiveTime(productiveTime);
            existingProfile.setUpdatedAt(LocalDateTime.now());
            
            return profilesDAO.update(existingProfile);
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra user đã có profile chưa
     */
    public boolean hasUserProfileNew(int userId) {
        UserProfiles profile = profilesDAO.getProfileByUserId(userId);
        return profile != null;
    }
    
    /**
     * Cập nhật kết quả trắc nghiệm từ form khám phá phương pháp học
     */
    public boolean updateLearningStyleQuizNew(int userId, String studyMethodVisual,
                                         String studyMethodAuditory, String studyMethodReading,
                                         String studyMethodPractice, String productiveTime,
                                         int groupStudyPreference) {
        try {
            return profilesDAO.updateLearningQuizNew(
                userId, 
                studyMethodVisual != null ? "selected" : "",
                studyMethodAuditory != null ? "selected" : "",
                studyMethodReading != null ? "selected" : "",
                studyMethodPractice != null ? "selected" : "",
                productiveTime,
                groupStudyPreference
            );
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra đã hoàn thành trắc nghiệm chưa
     */
    public boolean hasCompletedLearningStyleQuizNew(int userId) {
        return profilesDAO.hasCompletedLearningStyleSetup(userId);
    }
    
    /**
     * Lấy toàn bộ profile của user (phiên bản mới)
     */
    public UserProfiles getUserProfileNew(int userId) {
        return profilesDAO.getProfileByUserId(userId);
    }
    
    /**
     * Phân tích và đưa ra gợi ý học tập
     */
    public String analyzeProfileAndSuggestNew(int userId) {
        UserProfiles profile = getUserProfile(userId);
        if (profile == null) {
            return "Bạn chưa hoàn thành hồ sơ. Vui lòng điền đầy đủ thông tin.";
        }
        
        StringBuilder suggestions = new StringBuilder();
        suggestions.append("<h3 class='text-xl font-bold mb-4'>📊 Gợi ý học tập dành cho bạn:</h3>");
        
        // Phân tích phong cách học
        String learningStyle = profile.getLearningStyle();
        if ("visual".equals(learningStyle)) {
            suggestions.append("<div class='p-4 bg-blue-50 rounded-lg mb-4'>");
            suggestions.append("<h4 class='font-bold text-blue-700 mb-2'>🎨 Bạn là người học qua hình ảnh:</h4>");
            suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
            suggestions.append("<li>Sử dụng mindmap, sơ đồ tư duy</li>");
            suggestions.append("<li>Xem video bài giảng, infographic</li>");
            suggestions.append("<li>Dùng highlight để đánh dấu thông tin quan trọng</li>");
            suggestions.append("</ul></div>");
        } else if ("auditory".equals(learningStyle)) {
            suggestions.append("<div class='p-4 bg-green-50 rounded-lg mb-4'>");
            suggestions.append("<h4 class='font-bold text-green-700 mb-2'>🎧 Bạn học tốt qua âm thanh:</h4>");
            suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
            suggestions.append("<li>Ghi âm bài giảng và nghe lại</li>");
            suggestions.append("<li>Tham gia thảo luận nhóm</li>");
            suggestions.append("<li>Sử dụng podcast, audiobook</li>");
            suggestions.append("</ul></div>");
        } else if ("kinesthetic".equals(learningStyle)) {
            suggestions.append("<div class='p-4 bg-purple-50 rounded-lg mb-4'>");
            suggestions.append("<h4 class='font-bold text-purple-700 mb-2'>🖐️ Bạn học qua thực hành:</h4>");
            suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
            suggestions.append("<li>Làm bài tập, project thực tế</li>");
            suggestions.append("<li>Thí nghiệm, mô phỏng</li>");
            suggestions.append("<li>Kết hợp học với vận động</li>");
            suggestions.append("</ul></div>");
        }
        
        // Phân tích phong cách làm việc
        String workStyle = profile.getWorkStyle();
        if ("alone".equals(workStyle)) {
            suggestions.append("<div class='p-4 bg-yellow-50 rounded-lg mb-4'>");
            suggestions.append("<h4 class='font-bold text-yellow-700 mb-2'>🧘 Ưu điểm làm việc độc lập:</h4>");
            suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
            suggestions.append("<li>Tập trung cao độ</li>");
            suggestions.append("<li>Tự chủ thời gian</li>");
            suggestions.append("<li>Phát triển tư duy cá nhân</li>");
            suggestions.append("</ul></div>");
        } else if ("group".equals(workStyle)) {
            suggestions.append("<div class='p-4 bg-pink-50 rounded-lg mb-4'>");
            suggestions.append("<h4 class='font-bold text-pink-700 mb-2'>👥 Ưu điểm làm việc nhóm:</h4>");
            suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
            suggestions.append("<li>Học hỏi từ người khác</li>");
            suggestions.append("<li>Phát triển kỹ năng giao tiếp</li>");
            suggestions.append("<li>Giải quyết vấn đề đa chiều</li>");
            suggestions.append("</ul></div>");
        }
        
        // Phân tích thời gian năng suất
        String productiveTime = profile.getProductiveTime();
        if (productiveTime != null) {
            suggestions.append("<div class='p-4 bg-teal-50 rounded-lg'>");
            suggestions.append("<h4 class='font-bold text-teal-700 mb-2'>⏰ Thời gian học hiệu quả:</h4>");
            
            switch (productiveTime) {
                case "morning":
                    suggestions.append("<p class='font-medium mb-2'>☀️ <strong>Buổi sáng (6h-12h)</strong></p>");
                    suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
                    suggestions.append("<li>Sắp xếp môn khó vào buổi sáng</li>");
                    suggestions.append("<li>Dậy sớm ôn bài</li>");
                    suggestions.append("<li>Tận dụng năng lượng đầu ngày</li>");
                    suggestions.append("</ul>");
                    break;
                case "afternoon":
                    suggestions.append("<p class='font-medium mb-2'>🏙️ <strong>Buổi chiều (12h-18h)</strong></p>");
                    suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
                    suggestions.append("<li>Học các môn cần sự tỉnh táo</li>");
                    suggestions.append("<li>Làm bài tập vào buổi chiều</li>");
                    suggestions.append("<li>Kết hợp học và thực hành</li>");
                    suggestions.append("</ul>");
                    break;
                case "evening":
                    suggestions.append("<p class='font-medium mb-2'>🌙 <strong>Buổi tối (18h-24h)</strong></p>");
                    suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
                    suggestions.append("<li>Ôn tập lại kiến thức trong ngày</li>");
                    suggestions.append("<li>Làm bài tập về nhà</li>");
                    suggestions.append("<li>Chuẩn bị cho ngày hôm sau</li>");
                    suggestions.append("</ul>");
                    break;
                case "night":
                    suggestions.append("<p class='font-medium mb-2'>🌃 <strong>Đêm khuya (0h-6h)</strong></p>");
                    suggestions.append("<ul class='list-disc ml-5 space-y-1'>");
                    suggestions.append("<li>Học trong không gian yên tĩnh</li>");
                    suggestions.append("<li>Tập trung cao độ không bị phân tán</li>");
                    suggestions.append("<li>Dành cho các công việc đòi hỏi sáng tạo</li>");
                    suggestions.append("</ul>");
                    break;
                default:
                    suggestions.append("<p>Thời gian học tập chưa được xác định</p>");
                    break;
            }
            suggestions.append("</div>");
        }
        
        return suggestions.toString();
    }
    
    /**
     * Kiểm tra đã hoàn thành profile cơ bản chưa
     */
    public boolean hasBasicProfileCompleted(int userId) {
        return hasUserProfile(userId);
    }
}
