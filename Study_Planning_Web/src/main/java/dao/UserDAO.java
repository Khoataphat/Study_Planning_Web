/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import utils.DBUtil;
import model.User;
import java.sql.*;

/**
 *
 * @author Admin
 */
public class UserDAO {

    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                u.setisFirstLogin(rs.getInt("is_first_login"));
                return u;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    //Setup = 0 để ko gọi lại file basic-setup nữa
    public void markSetupDone(int userId) throws Exception {
        String sql = "UPDATE users SET is_first_login = 0 WHERE id = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //dùng cho đăng kí
    public User findByUsername(String username) throws Exception {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                u.setisFirstLogin(rs.getInt("is_first_login"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        return null;
    }

    public void insert(User user) throws Exception {
        // 1. LOẠI BỎ created_at khỏi danh sách cột và tham số (?)
        String sql = "INSERT INTO users (username, password, email, role, is_first_login) VALUES (?, ?, ?, ?, ?)";

        final int IS_FIRST_LOGIN_DEFAULT = 1;
        final String DEFAULT_ROLE = "student";

        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            // 1. username
            ps.setString(1, user.getUsername());

            // 2. password (Đã hash)
            ps.setString(2, user.getPassword());

            // 3. email
            ps.setString(3, user.getEmail());

            // 4. role
            ps.setString(4, DEFAULT_ROLE);

            // 5. is_first_login
            ps.setInt(5, IS_FIRST_LOGIN_DEFAULT);

            // BỎ QUA việc gán ps.setTimestamp(5, currentTime);
            // DB sẽ tự động gán CURRENT_TIMESTAMP cho created_at
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            // Luôn ném lại ngoại lệ để lớp Service xử lý
            throw e;
        }
    }

    //google
    public User findByOAuth(String provider, String oauthId) throws Exception {
        String sql = "SELECT * FROM users WHERE oauth_provider=? AND oauth_id=? LIMIT 1";

        // SỬA: Sử dụng try-with-resources để đảm bảo đóng tài nguyên
        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, provider);
            ps.setString(2, oauthId);

            // SỬA: Thêm ResultSet vào try-with-resources nếu bạn dùng JDBC 4.1 trở lên
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        // Không cần đóng con.close() ở đây nữa
        return null;
    }

    public User findByEmail(String email) throws Exception {
        String sql = "SELECT * FROM users WHERE email=? LIMIT 1";

        // SỬA: Sử dụng try-with-resources
        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        // Không cần đóng con.close() ở đây nữa
        return null;
    }

//    public void createOAuthUser(User u) throws Exception {
//        //String sql = "INSERT INTO users(email, display_name, avatar_url, oauth_provider, oauth_id) VALUES (?,?,?,?,?)";
//        String sql = "INSERT INTO users(email, oauth_provider, oauth_id) VALUES (?,?,?)";
//
//        // SỬA: Sử dụng try-with-resources
//        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
//
//            ps.setString(1, u.getEmail());
//            //có thì làm thêm
//            //ps.setString(2, u.getDisplayName());
//            //ps.setString(3, u.getAvatarUrl());
//            ps.setString(2, u.getOauthProvider());
//            ps.setString(3, u.getOauthId());
//
//            ps.executeUpdate();
//        }
//        // Không cần đóng con.close() ở đây nữa
//    }
    public void createOAuthUser(User u) throws Exception {
    // ⚠️ THÊM 'username' vào câu lệnh SQL
    String sql = "INSERT INTO users(username, email, oauth_provider, oauth_id) VALUES (?,?,?,?)"; 
    // Bây giờ có 4 tham số (?)

    try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

        // ⚠️ Gán giá trị cho cột username (Sử dụng email làm username)
        ps.setString(1, u.getEmail()); 
        
        ps.setString(2, u.getEmail()); // Tham số thứ 2 là email
        ps.setString(3, u.getOauthProvider()); // Tham số thứ 3 là provider
        ps.setString(4, u.getOauthId());      // Tham số thứ 4 là oauth_id

        ps.executeUpdate();
    }
}

    private User map(ResultSet rs) throws Exception {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setEmail(rs.getString("email"));
        u.setUsername(rs.getString("username")); // Cần thiết
        u.setPassword(rs.getString("password")); // Cần thiết cho các logic khác
        u.setisFirstLogin(rs.getInt("is_first_login")); // Cần thiết cho logic setup
        //u.setDisplayName(rs.getString("display_name"));
        //u.setAvatarUrl(rs.getString("avatar_url"));
        u.setOauthProvider(rs.getString("oauth_provider"));
        u.setOauthId(rs.getString("oauth_id"));
        return u;
    }
}
