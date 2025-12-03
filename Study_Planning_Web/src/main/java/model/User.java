/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author Admin
 */
public class User {
    private int userId;
    private String username;
    private String password;
    private String email;
    
    public enum Role {
        STUDENT,
        ADMIN
    }
    
    private Role role = Role.STUDENT; // Ánh xạ cột 'role'
    private LocalDateTime createdAt;
    
    private int isFirstLogin; // 0 or 1
    
    //dùng cho google và facebook
    
    private String oauthProvider; // GOOGLE / FACEBOOK / LOCAL
    private String oauthId;       // ID từ Google/Facebook
    
    // getter setter
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public Role getRole() {
        return role;
    }
    public void setRole(Role role) {
        this.role = role;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public int getisFirstLogin() { return isFirstLogin; }
    public void setisFirstLogin(int isFirstLogin) { this.isFirstLogin = isFirstLogin; }
    
    //google
    public String getOauthProvider() { return oauthProvider; }
    public void setOauthProvider(String oauthProvider) { this.oauthProvider = oauthProvider; }

    public String getOauthId() { return oauthId; }
    public void setOauthId(String oauthId) { this.oauthId = oauthId; }
}
