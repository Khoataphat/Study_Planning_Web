/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.studyplanning.service;

import com.studyplanning.dao.UserDAO;
import com.studyplanning.model.User;

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
}
