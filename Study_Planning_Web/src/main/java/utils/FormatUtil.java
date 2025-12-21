/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author Admin
 */
public class FormatUtil {

    public static String getFocusDurationDescription(Integer focusDuration) {
        if (focusDuration == null) {
            return "Chưa thiết lập";
        }
        return focusDuration + " phút";
    }

    /**
     * Giữ nguyên logic từ hàm getYearOfStudyDescription()
     */
    public static String getYearOfStudyDescription(Integer yearOfStudy) {
        if (yearOfStudy == null) {
            return "Chưa thiết lập";
        }
        return "Năm " + yearOfStudy;
    }
}