/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.UserDAO;
import dao.UserProfilesDAO;
import model.UserProfiles;

/**
 *
 * @author Admin
 */
public class UserProfilesService {
    private UserProfilesDAO setupDAO;
    private UserDAO userDAO;

    public UserProfilesService(UserProfilesDAO setupDAO, UserDAO userDAO) {
        this.setupDAO = setupDAO;
        this.userDAO = userDAO;
    }

    public boolean hasSetup(int userId) throws Exception {
        return setupDAO.getSetup(userId) != null;
    }

    public void saveSetup(UserProfiles info) throws Exception {
        setupDAO.saveSetup(info);
        userDAO.markSetupDone(info.getUserId());
    }
}
