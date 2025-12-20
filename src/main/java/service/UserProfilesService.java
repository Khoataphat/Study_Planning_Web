package service;

import dao.UserDAO;
import dao.UserProfilesDAO;
import model.UserProfiles;

/**
 *
 * @author Admin
 */
public class UserProfilesService {
    private UserProfilesDAO setupDAO;
    private UserDAO userDAO;

    // Constructor với tham số (dùng khi inject)
    public UserProfilesService(UserProfilesDAO setupDAO, UserDAO userDAO) {
        this.setupDAO = setupDAO;
        this.userDAO = userDAO;
        System.out.println("UserProfilesService initialized with DAOs");
    }

    // Constructor không tham số (dùng trong Controller)
    public UserProfilesService() {
        try {
            this.setupDAO = new UserProfilesDAO();
            this.userDAO = new UserDAO();
            System.out.println("UserProfilesService initialized successfully");
        } catch (Exception e) {
            System.err.println("Failed to initialize UserProfilesService: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize UserProfilesService", e);
        }
    }

    // Kiểm tra xem user đã hoàn thành setup chưa
    public boolean hasSetup(int userId) throws Exception {
        UserProfiles profile = setupDAO.getSetup(userId);
        return profile != null && 
               profile.getLearningStyle() != null && 
               profile.getPreferredStudyTime() != null;
    }

    // Lưu thông tin setup (cho bước 1)
    public void saveSetup(UserProfiles info) throws Exception {
        System.out.println(">>> UserProfilesService.saveSetup() called for user: " + info.getUserId());
        setupDAO.saveSetup(info);
        userDAO.markSetupDone(info.getUserId());
    }

    // Lấy profile hoặc tạo mới nếu chưa có
    public UserProfiles getOrCreateDefaultProfile(int userId) throws Exception {
        UserProfiles profile = setupDAO.getSetup(userId);
        if (profile == null) {
            profile = new UserProfiles();
            profile.setUserId(userId);
            System.out.println(">>> Created default profile for user: " + userId);
        }
        return profile;
    }

    // Lấy profile theo userId
    public UserProfiles getProfile(int userId) throws Exception {
        System.out.println(">>> UserProfilesService.getProfile() called for user: " + userId);
        UserProfiles profile = setupDAO.getSetup(userId);
        if (profile == null) {
            System.out.println(">>> No profile found for user: " + userId);
        } else {
            System.out.println(">>> Profile found: " + profile);
        }
        return profile;
    }

    // Lưu hoặc cập nhật profile
    public boolean saveOrUpdateProfile(UserProfiles profile) throws Exception {
        System.out.println(">>> UserProfilesService.saveOrUpdateProfile() called for user: " + profile.getUserId());
        
        // Kiểm tra dữ liệu
        if (profile == null) {
            throw new IllegalArgumentException("Profile cannot be null");
        }
        
        if (profile.getUserId() <= 0) {
            throw new IllegalArgumentException("Invalid user ID: " + profile.getUserId());
        }
        
        // Debug log
        System.out.println(">>> Profile data to save:");
        System.out.println(">>> - User ID: " + profile.getUserId());
        System.out.println(">>> - Learning Style: " + profile.getLearningStyle());
        System.out.println(">>> - Preferred Study Time: " + profile.getPreferredStudyTime());
        System.out.println(">>> - Year of Study: " + profile.getYearOfStudy());
        System.out.println(">>> - Focus Duration: " + profile.getFocusDuration());
        System.out.println(">>> - Personality Type: " + profile.getPersonalityType());
        System.out.println(">>> - Goal: " + profile.getGoal());
        
        // Kiểm tra xem profile đã tồn tại chưa
        UserProfiles existingProfile = setupDAO.getSetup(profile.getUserId());
        
        if (existingProfile == null) {
            System.out.println(">>> Inserting new profile");
            setupDAO.saveSetup(profile);
        } else {
            System.out.println(">>> Updating existing profile");
            setupDAO.updateSetup(profile);
        }
        
        // Đánh dấu user đã hoàn thành setup
        try {
            userDAO.markSetupDone(profile.getUserId());
            System.out.println(">>> User setup marked as done");
        } catch (Exception e) {
            System.err.println(">>> WARNING: Could not mark setup as done: " + e.getMessage());
            // Không throw exception vì profile đã được lưu
        }
        
        return true;
    }

    // Thêm phương thức update theme nếu cần
    public void updateTheme(int userId, String theme) throws Exception {
        UserProfiles profile = getProfile(userId);
        if (profile == null) {
            profile = new UserProfiles();
            profile.setUserId(userId);
        }
        // Giả sử có phương thức setTheme trong UserProfiles
        // profile.setTheme(theme);
        saveOrUpdateProfile(profile);
    }

    // Thêm phương thức kiểm tra trạng thái setup
    public boolean isSetupComplete(int userId) throws Exception {
        UserProfiles profile = getProfile(userId);
        if (profile == null) {
            return false;
        }
        
        // Kiểm tra các trường bắt buộc
        boolean hasLearningStyle = profile.getLearningStyle() != null && !profile.getLearningStyle().trim().isEmpty();
        boolean hasStudyTime = profile.getPreferredStudyTime() != null && !profile.getPreferredStudyTime().trim().isEmpty();
        boolean hasFocusDuration = profile.getFocusDuration() != null && profile.getFocusDuration() > 0;
        boolean hasGoal = profile.getGoal() != null && !profile.getGoal().trim().isEmpty();
        
        return hasLearningStyle && hasStudyTime && hasFocusDuration && hasGoal;
    }
}