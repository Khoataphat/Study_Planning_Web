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

    public List<TimetableSlot> getUserTimetable(int userId) throws Exception {

        String sql = "SELECT * FROM user_schedule /* Đã sửa tên bảng */"
                + " WHERE user_id = ?"
                + " ORDER BY FIELD(day_of_week, "
                + " 'MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY'),"
                + " start_time";

        List<TimetableSlot> list = new ArrayList<>();

        // Sử dụng try-with-resources để tự động đóng PreparedStatement và ResultSet
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    // Lấy giá trị từ ResultSet
                    int scheduleId = rs.getInt("schedule_id");
                    int slotUserId = rs.getInt("user_id");
                    String subject = rs.getString("subject"); // Đã sửa từ 'title' sang 'subject'
                    String type = rs.getString("type");       // Thêm trường 'type'

                    // Chuyển đổi String/SQL sang Java Time API và Enum
                    DayOfWeek dayOfWeek = DayOfWeek.valueOf(rs.getString("day_of_week"));
                    LocalDate scheduleDate = rs.getDate("schedule_date") != null ? rs.getDate("schedule_date").toLocalDate() : null; // Xử lý null
                    LocalTime startTime = rs.getTime("start_time").toLocalTime();
                    LocalTime endTime = rs.getTime("end_time").toLocalTime();

                    // Giả định bảng có thêm cột 'location' (nếu không có, cần bỏ đi)
                    String location = rs.getString("location");

                    LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime(); // Thêm trường created_at

                    // Tạo đối tượng TimetableSlot đầy đủ
                    TimetableSlot s = new TimetableSlot(
                            scheduleId,
                            slotUserId,
                            subject,
                            type,
                            dayOfWeek,
                            scheduleDate,
                            startTime,
                            endTime,
                            location,
                            createdAt
                    );

                    list.add(s);
                }
            }
        } // Không cần khối catch e.printStackTrace() ở đây, ném Exception ra ngoài để Controller xử lý.

        return list;
    }

    // Bạn có thể thêm các hàm khác như addTimetableSlot(), deleteTimetableSlot(), updateTimetableSlot()
}
