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
        String sql = "UPDATE users SET is_first_login = 0 WHERE user_id = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
