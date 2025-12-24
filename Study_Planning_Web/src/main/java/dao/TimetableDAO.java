/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.TimetableSlot;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.time.DayOfWeek;
import java.time.LocalTime;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.sql.*;

public class TimetableDAO {

    private Connection conn;

    public TimetableDAO(Connection conn) {
        this.conn = conn;
    }

    private DayOfWeek mapDayOfWeek(String dbDay) {
        if (dbDay == null) {
            return null;
        }

        // Đảm bảo chữ HOA hoàn toàn để khớp với Enum Java
        String normalizedDay = dbDay.toUpperCase();

        // Chuyển đổi các giá trị viết tắt hoặc giá trị sai khác (nếu cần)
        switch (normalizedDay) {
            case "MON":
                return DayOfWeek.MONDAY;
            case "TUE":
                return DayOfWeek.TUESDAY;
            case "WED":
                return DayOfWeek.WEDNESDAY;
            case "THU":
                return DayOfWeek.THURSDAY;
            case "FRI":
                return DayOfWeek.FRIDAY;
            case "SAT":
                return DayOfWeek.SATURDAY;
            case "SUN":
                return DayOfWeek.SUNDAY;
            default:
                // Nếu giá trị đã là định dạng đầy đủ (ví dụ: MONDAY), vẫn hoạt động
                return DayOfWeek.valueOf(normalizedDay);
        }
    }

    public List<TimetableSlot> getUserTimetable(int userId) throws Exception {

        // String sql = "SELECT * FROM user_schedule /* Đã sửa tên bảng */"
        // + " WHERE user_id = ?"
        // + " ORDER BY FIELD(day_of_week, "
        // + " 'MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY'),"
        // + " start_time";
        // LOẠI BỎ CÚ PHÁP ORDER BY FIELD()
        String sql = "SELECT us.*, sc.user_id "
                + "FROM user_schedule us "
                + "JOIN schedule_collection sc ON us.collection_id = sc.collection_id "
                + "WHERE sc.user_id = ? "
                + "ORDER BY us.day_of_week, us.start_time";

        List<TimetableSlot> list = new ArrayList<>();

        // Sử dụng try-with-resources để tự động đóng PreparedStatement và ResultSet
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            // ********** SỬA Ở ĐÂY **********
            // Thay vì ps.setInt(1, userId);
            ps.setInt(1, userId); // Ép kiểu số thành chuỗi "25"
            // ********************************

            int rowCount = 0; // Thêm biến đếm

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    rowCount++;

                    // **********************************************
                    // THÊM DÒNG DEBUG QUAN TRỌNG NÀY VÀO ĐẦU VÒNG LẶP
                    System.out.println("DEBUG: Đã tìm thấy dữ liệu dòng " + rowCount);
                    // **********************************************

                    // Lấy giá trị theo đúng thứ tự cột trong DB (hoặc thứ tự mong muốn trong
                    // constructor)
                    // 1. schedule_id
                    int scheduleId = rs.getInt("schedule_id");
                    // 2. user_id
                    int slotUserId = rs.getInt("user_id");
                    // 3. day_of_week
                    String dayString = rs.getString("day_of_week");
                    DayOfWeek dayOfWeek = mapDayOfWeek(dayString);
                    // 4. schedule_date
                    LocalDate scheduleDate = null;// rs.getDate("schedule_date") != null ?
                                                  // rs.getDate("schedule_date").toLocalDate() : null;
                    // 5. start_time
                    LocalTime startTime = rs.getTime("start_time").toLocalTime();
                    // 6. end_time
                    LocalTime endTime = rs.getTime("end_time").toLocalTime();
                    // 7. subject
                    String subject = rs.getString("subject");

                    // KIỂM TRA LỖI: IN RA MỘT GIÁ TRỊ TỪ DÒNG NÀY
                    System.out.println("DEBUG: Subject = " + subject);
                    // 8. type
                    String type = rs.getString("type");
                    // 9. created_at
                    LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();

                    // Tạo đối tượng TimetableSlot. Đảm bảo constructor của bạn có thứ tự khớp với
                    // thứ tự này
                    TimetableSlot s = new TimetableSlot(
                            scheduleId,
                            slotUserId, // user_id
                            subject,
                            type,
                            dayOfWeek,
                            scheduleDate,
                            startTime,
                            endTime,
                            createdAt // Cuối cùng
                    );

                    list.add(s);
                    System.out.println("DEBUG: Đã thêm slot vào danh sách. Kích thước hiện tại: " + list.size());
                }
                // **********************************************
                // THÊM DÒNG DEBUG CUỐI CÙNG
                System.out.println("DEBUG: Vòng lặp kết thúc. Tổng số dòng được xử lý: " + rowCount);
                // **********************************************
            }
        } // Không cần khối catch e.printStackTrace() ở đây, ném Exception ra ngoài để
          // Controller xử lý.

        return list;
    }

    // Bạn có thể thêm các hàm khác như addTimetableSlot(), deleteTimetableSlot(),
    // updateTimetableSlot()
}
