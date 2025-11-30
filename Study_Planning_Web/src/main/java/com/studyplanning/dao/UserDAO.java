/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.studyplanning.dao;

import com.studyplanning.utils.DBUtil;
import com.studyplanning.model.User;
import java.sql.*;

/**
 *
 * @author Admin
 */
public class UserDAO {

    public User login(String username, String password) {
        System.out.println("=== UserDAO.login() called ===");
        System.out.println("Username received: [" + username + "]");
        System.out.println("Password received: [" + password + "]");
        
        // TEMPORARY: Test user bypass for development
        if ("test".equals(username) && "test".equals(password)) {
            System.out.println("Using test user bypass");
            User testUser = new User();
            testUser.setUserId(1);
            testUser.setUsername("test");
            testUser.setPassword("test");
            testUser.setEmail("test@test.com");
            return testUser;
        }
        
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        System.out.println("SQL Query: " + sql);

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (con == null) {
                System.out.println("ERROR: Database connection is NULL!");
                return null;
            }
            System.out.println("Database connection successful");

            ps.setString(1, username);
            ps.setString(2, password);
            System.out.println("Parameters set, executing query...");

            ResultSet rs = ps.executeQuery();
            System.out.println("Query executed");

            if (rs.next()) {
                System.out.println("User found in database!");
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                
                // Map role from DB (lowercase) to Enum (uppercase)
                String roleStr = rs.getString("role");
                if (roleStr != null) {
                    try {
                        u.setRole(User.Role.valueOf(roleStr.toUpperCase()));
                    } catch (IllegalArgumentException e) {
                        System.out.println("Invalid role in DB: " + roleStr);
                        u.setRole(User.Role.STUDENT); // Default
                    }
                }
                
                System.out.println("User loaded: ID=" + u.getUserId() + ", Username=" + u.getUsername() + ", Role=" + u.getRole());
                return u;
            } else {
                System.out.println("No user found with username: [" + username + "] and password: [" + password + "]");
            }

        } catch (Exception e) {
            System.out.println("Login error: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("=== Login failed, returning null ===");
        return null;
    }
}
