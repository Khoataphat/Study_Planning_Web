/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.UserDAO;
import model.User;

/**
 *
 * @author Admin
 */
public class UserService {
    private UserDAO userDAO;

    public UserService(UserDAO userDAO){
        this.userDAO = userDAO;
    }

    public User authenticate(String email, String rawPassword) throws Exception{
        // có thể hash password ở đây: Utils.hash(rawPassword)
        String hash = rawPassword; // tạm thời để vậy
        return userDAO.login(email, hash);
    }
    
    //Lo nghiệp vụ về User: CRUD, update info, đổi mật khẩu, load profile, validate,…
    
    // Thêm phương thức mới để đánh dấu setup hoàn thành
    public void markSetupDone(int userId) throws Exception {
        userDAO.markSetupDone(userId);
    }
    
    // Thêm phương thức mới để lấy user theo ID
    public User getUserById(int userId) throws Exception {
        return userDAO.getUserById(userId);
    }
    
    // Thêm phương thức mới để kiểm tra user có tồn tại không
    public boolean userExists(int userId) throws Exception {
        return userDAO.userExists(userId);
    }
    
    // Thêm phương thức mới để tìm user bằng username
    public User findByUsername(String username) throws Exception {
        return userDAO.findByUsername(username);
    }
    
    // Thêm phương thức mới để đăng ký user
    public void register(User user) throws Exception {
        userDAO.insert(user);
    }
}