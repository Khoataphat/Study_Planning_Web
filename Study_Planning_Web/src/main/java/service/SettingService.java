/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

/**
 *
 * @author Admin
 */
import dao.SettingDAO;
import model.UserSetting;

public class SettingService {
    private SettingDAO dao;

    public SettingService(SettingDAO dao){
        this.dao = dao;
    }

    public UserSetting load(int userId) throws Exception {
        return dao.getByUserId(userId);
    }

    public void save(UserSetting setting) throws Exception {
        dao.update(setting);
    }
}