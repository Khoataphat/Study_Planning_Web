/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.TimerSettings;

public interface TimerSettingsDAO {
    
    // Lấy cài đặt của user
    TimerSettings findByUserId(int userId);
    
    // Lưu hoặc cập nhật cài đặt
    boolean save(TimerSettings settings);
    
    // Tạo cài đặt mặc định cho user mới
    void createDefaultSettings(int userId);
    
    // Cập nhật 1 vài trường cụ thể
    boolean updateDarkMode(int userId, boolean darkMode);
    boolean updateDailyGoal(int userId, int dailyGoal);
    
    // Lấy cài đặt Pomodoro
    TimerSettings getPomodoroSettings(int userId);
}
