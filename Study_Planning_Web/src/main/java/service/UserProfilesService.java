/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.UserDAO;
import dao.UserProfilesDAO;
import java.time.LocalDateTime;
import model.UserProfiles;

/**
 *
 * @author Admin
 */
public class UserProfilesService {
    private UserProfilesDAO setupDAO;
    private UserDAO userDAO;

    // Constructor dùng khi inject hoặc kiểm thử (Khuyên dùng)
    public UserProfilesService(UserProfilesDAO setupDAO, UserDAO userDAO) {
        this.setupDAO = setupDAO;
        this.userDAO = userDAO;
        System.out.println("UserProfilesService: Initialized with provided DAOs");
    }

    // Constructor mặc định cho Controller (Tự khởi tạo DAO)
    public UserProfilesService() {
        try {
            this.setupDAO = new UserProfilesDAO();
            this.userDAO = new UserDAO();
            System.out.println("UserProfilesService: Success - DAOs created internally");
        } catch (Exception e) {
            System.err.println("UserProfilesService: Critical Error - Failed to initialize DAOs");
            e.printStackTrace();
            throw new RuntimeException("Could not initialize Service layer", e);
        }
    }

    /**
     * Kiểm tra nhanh xem User đã có bản ghi setup hay chưa
     */
    public boolean hasSetup(int userId) throws Exception {
        UserProfiles profile = setupDAO.getSetup(userId);
        // Kiểm tra profile tồn tại và các trường quan trọng không được rỗng
        return profile != null && 
               profile.getLearningStyle() != null && 
               profile.getPreferredStudyTime() != null;
    }

    /**
     * Kiểm tra chi tiết trạng thái hoàn thành Setup (Dùng cho logic chặn trang)
     */
    public boolean isSetupComplete(int userId) throws Exception {
        UserProfiles profile = getProfile(userId);
        if (profile == null) return false;

        boolean hasLearningStyle = profile.getLearningStyle() != null && !profile.getLearningStyle().trim().isEmpty();
        boolean hasStudyTime = profile.getPreferredStudyTime() != null && !profile.getPreferredStudyTime().trim().isEmpty();
        boolean hasFocusDuration = profile.getFocusDuration() != null && profile.getFocusDuration() > 0;
        boolean hasGoal = profile.getGoal() != null && !profile.getGoal().trim().isEmpty();

        return hasLearningStyle && hasStudyTime && hasFocusDuration && hasGoal;
    }

    /**
     * Lấy Profile theo ID. Nếu không có trả về null (có log hỗ trợ debug)
     */
    public UserProfiles getProfile(int userId) throws Exception {
        UserProfiles profile = setupDAO.getSetup(userId);
        if (profile == null) {
            System.out.println(">>> UserProfilesService: No profile found for user " + userId);
        }
        return profile;
    }

    /**
     * Lấy Profile hiện tại hoặc tạo mới một Object trống (Tránh NullPointerException ở View)
     */
    public UserProfiles getOrCreateDefaultProfile(int userId) throws Exception {
        UserProfiles profile = getProfile(userId);
        if (profile == null) {
            profile = new UserProfiles();
            profile.setUserId(userId);
            System.out.println(">>> UserProfilesService: Created default profile object for user " + userId);
        }
        return profile;
    }

    /**
     * Lưu hoặc Cập nhật Profile và đồng bộ trạng thái User
     */
    public boolean saveOrUpdateProfile(UserProfiles profile) throws Exception {
        if (profile == null || profile.getUserId() <= 0) {
            throw new IllegalArgumentException("Invalid Profile Data");
        }

        System.out.println(">>> UserProfilesService: Saving/Updating profile for UID: " + profile.getUserId());

        // 1. Kiểm tra tồn tại để quyết định Insert hay Update
        UserProfiles existing = setupDAO.getSetup(profile.getUserId());
        if (existing == null) {
            setupDAO.saveSetup(profile);
            System.out.println(">>> Action: Insert new profile");
        } else {
            setupDAO.updateSetup(profile);
            System.out.println(">>> Action: Update existing profile");
        }

        // 2. Đánh dấu User đã hoàn thành setup (Đồng bộ giữa 2 bảng)
        try {
            userDAO.markSetupDone(profile.getUserId());
        } catch (Exception e) {
            // Log lỗi nhưng không làm chết chương trình vì data profile đã lưu xong
            System.err.println(">>> Warning: Profile saved but could not update User status: " + e.getMessage());
        }

        return true;
    }

    public void saveSetup(UserProfiles info) throws Exception {
        saveOrUpdateProfile(info);
    }
    
    //vy
    public UserProfiles createDefaultProfile(int userId) {
        UserProfiles profile = new UserProfiles();
        profile.setUserId(userId);
        profile.setYearOfStudy(1); 
        profile.setFocusDuration(45);
        profile.setCreatedAt(LocalDateTime.now());
        return profile;
    }
}
