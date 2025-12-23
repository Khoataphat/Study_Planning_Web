/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.TimerSession;
import java.util.List;

public interface TimerSessionDAO {
    
    // Thêm phiên timer mới
    int insert(TimerSession timerSession);
    
    // Cập nhật phiên timer
    boolean update(TimerSession timerSession);
    
    // Xóa phiên timer
    boolean delete(int sessionId);
    
    // Tìm phiên theo ID
    TimerSession findById(int sessionId);
    
    // Lấy tất cả phiên của user
    List<TimerSession> findByUserId(int userId);
    
    // Lấy phiên đang active của user
    TimerSession findActiveByUserId(int userId);
    
    // Lấy phiên hôm nay
    List<TimerSession> findTodaySessions(int userId);
    
    // Lấy phiên theo khoảng thời gian
    List<TimerSession> findByDateRange(int userId, String startDate, String endDate);
    
    // Lấy thống kê theo tuần
    List<TimerSession> findWeeklySessions(int userId);
    
    // Lấy tổng thời gian focus trong ngày
    int getTotalFocusMinutesToday(int userId);
}
