/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author Admin
 */
import model.MBTIResult;
import java.util.Map;
import java.util.HashMap;
import java.util.List;

public class MBTICalculator {
    
    public static MBTIResult calculateMBTI(Map<Integer, String> answers) {
        Map<String, Integer> scores = new HashMap<>();
        scores.put("E", 0); scores.put("I", 0);
        scores.put("S", 0); scores.put("N", 0);
        scores.put("T", 0); scores.put("F", 0);
        scores.put("J", 0); scores.put("P", 0);
        
        // Calculate scores from answers
        // Note: In real implementation, you would need question data
        // to know which dimension each answer belongs to
        
        // For now, simulate calculation
        scores.put("E", 3); scores.put("I", 2);
        scores.put("S", 4); scores.put("N", 1);
        scores.put("T", 2); scores.put("F", 3);
        scores.put("J", 3); scores.put("P", 2);
        
        // Determine MBTI type
        StringBuilder mbtiType = new StringBuilder();
        mbtiType.append(scores.get("E") >= scores.get("I") ? "E" : "I");
        mbtiType.append(scores.get("S") >= scores.get("N") ? "S" : "N");
        mbtiType.append(scores.get("T") >= scores.get("F") ? "T" : "F");
        mbtiType.append(scores.get("J") >= scores.get("P") ? "J" : "P");
        
        MBTIResult result = new MBTIResult();
        result.setMbtiType(mbtiType.toString());
        result.setDimensionEI(mbtiType.charAt(0) == 'E' ? "EXTROVERT" : "INTROVERT");
        result.setDimensionSN(mbtiType.charAt(1) == 'S' ? "SENSING" : "INTUITION");
        result.setDimensionTF(mbtiType.charAt(2) == 'T' ? "THINKING" : "FEELING");
        result.setDimensionJP(mbtiType.charAt(3) == 'J' ? "JUDGING" : "PERCEIVING");
        result.setDescription(getMBTIDescription(mbtiType.toString()));
        
        return result;
    }
    
    private static String getMBTIDescription(String mbtiType) {
        Map<String, String> descriptions = new HashMap<>();
        descriptions.put("INTJ", "Nhà chiến lược - Độc lập, sáng tạo, có tầm nhìn xa");
        descriptions.put("INTP", "Nhà tư duy - Phân tích, sáng tạo, độc lập");
        descriptions.put("ENTJ", "Nhà lãnh đạo - Quyết đoán, chiến lược, có tầm nhìn");
        descriptions.put("ENTP", "Nhà đổi mới - Sáng tạo, nhanh trí, thích tranh luận");
        descriptions.put("INFJ", "Người cố vấn - Lý tưởng, sáng tạo, nhân văn");
        descriptions.put("INFP", "Người lý tưởng - Sáng tạo, lý tưởng, trung thành");
        descriptions.put("ENFJ", "Người chỉ dẫn - Nhiệt tình, thuyết phục, có trách nhiệm");
        descriptions.put("ENFP", "Người truyền cảm hứng - Nhiệt tình, sáng tạo, lạc quan");
        descriptions.put("ISTJ", "Người kiểm tra - Thực tế, có trách nhiệm, đáng tin cậy");
        descriptions.put("ISFJ", "Người bảo vệ - Tận tâm, ấm áp, đáng tin cậy");
        descriptions.put("ESTJ", "Người giám sát - Thực tế, quyết đoán, có tổ chức");
        descriptions.put("ESFJ", "Người cung cấp - Thân thiện, có trách nhiệm, hòa đồng");
        descriptions.put("ISTP", "Thợ thủ công - Thực tế, linh hoạt, độc lập");
        descriptions.put("ISFP", "Nghệ sĩ - Dịu dàng, linh hoạt, sáng tạo");
        descriptions.put("ESTP", "Người khởi xướng - Năng động, thực tế, thích mạo hiểm");
        descriptions.put("ESFP", "Người trình diễn - Vui vẻ, năng động, thân thiện");
        
        return descriptions.getOrDefault(mbtiType, "Phân tích tính cách dựa trên MBTI");
    }
}
