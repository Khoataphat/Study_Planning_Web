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

    public SettingService(SettingDAO dao) {
        this.dao = dao;
    }
    
    public SettingService() {
        this.dao = new SettingDAO(); 
    }

    public UserSetting load(int userId) throws Exception {
        return dao.getByUserId(userId);
    }

    public void save(UserSetting setting) throws Exception {
        // 1. Kiểm tra xem cài đặt đã tồn tại hay chưa
        UserSetting existingSetting = dao.getByUserId(setting.getUserId());

        if (existingSetting != null) {
            // 2. Nếu đã tồn tại, gọi UPDATE
            System.out.println("DEBUG SERVICE: Cài dat dã ton tai. Thuc hien UPDATE.");
            dao.update(setting);
        } else {
            // 3. Nếu chưa tồn tại, gọi INSERT (cần thêm phương thức insert vào DAO)
            System.out.println("DEBUG SERVICE: Cài dat chua ton tai. Thuc hien INSERT.");
            dao.insert(setting);
        }
    }

    public void saveTheme(int userId, String theme) throws Exception {
        UserSetting existingSetting = dao.getSettingByUser(userId);

        if (existingSetting != null) {
            dao.updateTheme(userId, theme);
        } else {
            dao.insert(userId, theme);
        }
    }

    public String getTheme(int userId) throws Exception {
        UserSetting s = dao.getSettingByUser(userId);
        return (s != null) ? s.getTheme() : "light";
    }
}
