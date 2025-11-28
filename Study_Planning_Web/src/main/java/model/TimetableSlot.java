/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

public class TimetableSlot {
    
    // Thuộc tính chính
    private int scheduleId;       // Tương ứng với schedule_id (PK)
    private int userId;           // Tương ứng với user_id (FK)
    private String subject;       // Tương ứng với subject (tên môn học/hoạt động)
    private String type;          // Tương ứng với type (ví dụ: 'Học tập', 'Giải trí', 'Công việc')
    
    // Thuộc tính Thời gian & Địa điểm
    private DayOfWeek dayOfWeek;  // Tương ứng với day_of_week (Sử dụng Enum DayOfWeek của Java)
    private LocalDate scheduleDate; // Tương ứng với schedule_date (Dùng cho các sự kiện không lặp lại)
    private LocalTime startTime;  // Tương ứng với start_time
    private LocalTime endTime;    // Tương ứng với end_time
    private String location;      // (Bạn không liệt kê, nhưng thường cần cho slot)

    // Thuộc tính hệ thống
    private LocalDateTime createdAt; // Tương ứng với created_at

    // ----------------------------------------------------
    // 1. Constructor (Toàn bộ trường)
    // ----------------------------------------------------
    
    public TimetableSlot(int scheduleId, int userId, String subject, String type, DayOfWeek dayOfWeek, LocalDate scheduleDate, LocalTime startTime, LocalTime endTime, String location, LocalDateTime createdAt) {
        this.scheduleId = scheduleId;
        this.userId = userId;
        this.subject = subject;
        this.type = type;
        this.dayOfWeek = dayOfWeek;
        this.scheduleDate = scheduleDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.location = location;
        this.createdAt = createdAt;
    }

    // ----------------------------------------------------
    // 2. Constructor (Dùng cho việc chèn (INSERT) vào DB, không cần ID và created_at)
    // ----------------------------------------------------

    public TimetableSlot(int userId, String subject, String type, DayOfWeek dayOfWeek, LocalDate scheduleDate, LocalTime startTime, LocalTime endTime, String location) {
        this.userId = userId;
        this.subject = subject;
        this.type = type;
        this.dayOfWeek = dayOfWeek;
        this.scheduleDate = scheduleDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.location = location;
    }

    // ----------------------------------------------------
    // 3. Getters và Setters
    // ----------------------------------------------------

    // Các Getters và Setters chuẩn cho từng thuộc tính...
    // ... (Để giữ cho phản hồi ngắn gọn, tôi không liệt kê tất cả Getters/Setters ở đây, 
    //      nhưng bạn cần tự động tạo chúng trong IDE)
    
    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public DayOfWeek getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(DayOfWeek dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public LocalDate getScheduleDate() {
        return scheduleDate;
    }

    public void setScheduleDate(LocalDate scheduleDate) {
        this.scheduleDate = scheduleDate;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}