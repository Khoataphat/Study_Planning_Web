/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.UserDAO;
import java.sql.SQLIntegrityConstraintViolationException;
import model.User;
import model.ValidationError;
import utils.ValidationUtils;

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

        // Tạo đối tượng User để truyền vào hàm xác thực và lưu trữ
        User userToRegister = new User();
        userToRegister.setUsername(username);
        userToRegister.setEmail(email);
        userToRegister.setPassword(rawPassword);

        // 1. GỌI HÀM XÁC THỰC TẬP TRUNG
        ValidationError validationResult = validateSignup(userToRegister);

        // Nếu xác thực thất bại, trả về thông báo lỗi
        if (!validationResult.isValid()) {
            // Trả về thông báo lỗi cụ thể để Controller hiển thị
            return validationResult.getMessage();
        }

        // 2. Hash password (Chỉ chạy khi xác thực thành công)
        // có hàm hash password thì thay sau
        // String hashed = PasswordUtils.hash(rawPassword);
        String hashed = rawPassword;

        // 3. Lưu vào DB (Chỉ chạy khi xác thực thành công)
        userToRegister.setPassword(hashed); // Cập nhật password đã hash
        // ⭐ BỔ SUNG: BẮT LỖI SQL DUPLICATE ENTRY ⭐
        try {
            userDAO.insert(userToRegister);
        } catch (SQLIntegrityConstraintViolationException ex) {
            
            // Xử lý lỗi trùng lặp (duy nhất) nếu xảy ra race condition
            // Kiểm tra xem lỗi có phải do trùng username hoặc email (UNIQUE KEY) không
            String errorMessage = ex.getMessage().toLowerCase();
            
            if (errorMessage.contains("duplicate entry") && errorMessage.contains("username")) {
                return "Username already exists.";
            }
            if (errorMessage.contains("duplicate entry") && errorMessage.contains("email")) {
                return "Email address is already in use.";
            }
            
            // Nếu là lỗi SQL khác, ném lại
            throw ex; 
        }

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

        // Populate other fields to match what UserDAO inserts
        newUser.setUsername(email);
        newUser.setPassword("");
        newUser.setisFirstLogin(1);

        // Gọi hàm tạo mới và lấy ID trả về
        int newId = userDAO.createOAuthUser(newUser);

        if (newId > 0) {
            newUser.setUserId(newId);
            return newUser;
        }

        // Sau khi tạo, tìm lại User để trả về đối tượng đầy đủ (fallback)
        return userDAO.findByOAuth(provider, oauthId);
    }

    // ⭐⭐ 1. THÊM HÀM XÁC THỰC ĐĂNG KÝ (validateSignup) ⭐⭐
    // Chức năng này thực hiện toàn bộ quá trình Validation và Check trùng
    public ValidationError validateSignup(User user) throws Exception {

        // 1. Validation cú pháp (syntax validation)
        ValidationError u = ValidationUtils.validateUsername(user.getUsername());
        if (!u.isValid()) {
            return u;
        }

        ValidationError e = ValidationUtils.validateEmail(user.getEmail());
        if (!e.isValid()) {
            return e;
        }

        // Lưu ý: User.getPassword() phải trả về mật khẩu thô (rawPassword)
        ValidationError p = ValidationUtils.validatePassword(user.getPassword());
        if (!p.isValid()) {
            return p;
        }

        // 2. Validation nghiệp vụ (business validation)
        // Check trùng username trong DB
        if (userDAO.findByUsername(user.getUsername()) != null) {
            return new ValidationError(false, "Username already exists.");
        }
        
        // ⭐ BỔ SUNG: CHECK TRÙNG EMAIL TRONG DB ⭐
        // Cần đảm bảo UserDAO có hàm findByEmail(String email)
        if (userDAO.findByEmail(user.getEmail()) != null) {
            return new ValidationError(false, "Email address is already in use.");
        }
        // ⭐ KẾT THÚC BỔ SUNG ⭐

        return new ValidationError(true, null); // Hợp lệ
    }

}
