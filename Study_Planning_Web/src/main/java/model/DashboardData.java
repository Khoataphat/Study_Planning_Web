/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 *
 * @author Admin
 */
public class DashboardData {
// Đã đổi tên thuộc tính thành timetableList cho rõ ràng hơn
    private List<TimetableSlot> timetableList; 

    // Constructor (Tùy chọn)
    public DashboardData() {
        
    }

    // Setter: Đã sửa lỗi UnsupportedOperationException
    public void setTimetableList(List<TimetableSlot> userTimetable) {
        this.timetableList = userTimetable;
    }

    // **********************************************
    // PHƯƠNG THỨC GETTER CẦN THIẾT CHO JSP/EL
    // **********************************************
    public List<TimetableSlot> getTimetableList() {
        return timetableList;
    }
}
