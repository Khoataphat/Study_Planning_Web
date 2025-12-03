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
public class AuthService {

    private UserDAO userDAO = new UserDAO();

    public User login(String username, String password) {
        return userDAO.login(username, password);
    }

    //Đăng kí
    public String register(String username, String email, String rawPassword) throws Exception {

        // 1. Check trùng username
        if (userDAO.findByUsername(username) != null) {
            return "Username already exists!";
        }

        // 2. Hash password
        //có hàm hash password thì thay sau
        //String hashed = PasswordUtils.hash(rawPassword);
        String hashed = rawPassword;

        // 3. Lưu vào DB
        User u = new User();
        u.setUsername(username);
        u.setPassword(hashed);
        u.setEmail(email);

        userDAO.insert(u);

        return "SUCCESS";
    }

    //google
    //public User loginWithOAuth(String provider, String oauthId, String email, String name, String avatar) throws Exception {
//    public User loginWithOAuth(String provider, String oauthId, String email) throws Exception {
//
//        // Check nếu user đã tồn tại
//        User u = userDAO.findByOAuth(provider, oauthId);
//
//        if (u != null) {
//            return u;
//        }
//
//        // Nếu chưa → tạo mới
//        User newUser = new User();
//        newUser.setEmail(email);
//        //newUser.setDisplayName(name);
//        //newUser.setAvatarUrl(avatar);
//        newUser.setUsername(email);
//        newUser.setOauthProvider(provider);
//        newUser.setOauthId(oauthId);
//
//        userDAO.createOAuthUser(newUser);
//
//        return userDAO.findByOAuth(provider, oauthId);
//    }
    public User loginWithOAuth(String provider, String oauthId, String email) throws Exception {
        UserDAO userDAO = new UserDAO();

        // 1. Kiểm tra: Đã đăng nhập bằng OAuth này trước đây chưa?
        User user = userDAO.findByOAuth(provider, oauthId);
        if (user != null) {
            return user; // Đăng nhập thành công
        }

        // 2. Kiểm tra: Có tài khoản đăng ký thường nào dùng email này không?
        user = userDAO.findByEmail(email);
        if (user != null) {
            // Tài khoản thường tồn tại -> Liên kết OAuth và cập nhật thông tin
            userDAO.updateOAuthInfo(user.getUserId(), provider, oauthId);
            return user; // Đăng nhập thành công, tài khoản đã được liên kết
        }

        // 3. Nếu chưa tồn tại -> Tạo tài khoản mới bằng OAuth
        User newUser = new User();
        newUser.setEmail(email);
        newUser.setOauthProvider(provider);
        newUser.setOauthId(oauthId);

        // Đảm bảo bạn đặt Username (ví dụ: là email) và các trường bắt buộc khác trong đối tượng User 
        // trước khi gọi createOAuthUser, tùy thuộc vào cấu trúc model của bạn.
        // Gọi hàm tạo mới (dòng 66 trong AuthService)
        userDAO.createOAuthUser(newUser);

        // Sau khi tạo, tìm lại User để trả về đối tượng đầy đủ
        return userDAO.findByOAuth(provider, oauthId);
    }
}
