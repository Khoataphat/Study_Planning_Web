package service;

import dao.UserDAO;
import dao.UserProfilesDAO;
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
}
