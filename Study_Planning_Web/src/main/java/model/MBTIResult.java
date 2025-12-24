/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
import java.util.Date;
import java.util.List;
import java.util.Arrays;
import java.util.ArrayList;

public class MBTIResult {
    private int id;
    private int userId;
    private String mbtiType; // INTJ, ENFP, etc.
    private String dimensionEI;
    private String dimensionSN;
    private String dimensionTF;
    private String dimensionJP;
    private String description;
    private Date completedAt;
    
    // Thêm các thuộc tính mới
    private List<String> strengths;
    private List<String> weaknesses;
    private List<String> recommendedCareers;
    private List<String> compatibleTypes;
    
    // Constructors
    public MBTIResult() {
        this.strengths = new ArrayList<>();
        this.weaknesses = new ArrayList<>();
        this.recommendedCareers = new ArrayList<>();
        this.compatibleTypes = new ArrayList<>();
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getMbtiType() { return mbtiType; }
    public void setMbtiType(String mbtiType) { 
        this.mbtiType = mbtiType; 
        // Tự động set thông tin dựa trên MBTI type
        setMbtiDetails(mbtiType);
    }
    
    public String getDimensionEI() { return dimensionEI; }
    public void setDimensionEI(String dimensionEI) { this.dimensionEI = dimensionEI; }
    
    public String getDimensionSN() { return dimensionSN; }
    public void setDimensionSN(String dimensionSN) { this.dimensionSN = dimensionSN; }
    
    public String getDimensionTF() { return dimensionTF; }
    public void setDimensionTF(String dimensionTF) { this.dimensionTF = dimensionTF; }
    
    public String getDimensionJP() { return dimensionJP; }
    public void setDimensionJP(String dimensionJP) { this.dimensionJP = dimensionJP; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Date getCompletedAt() { return completedAt; }
    public void setCompletedAt(Date completedAt) { this.completedAt = completedAt; }
    
    // Getters and Setters mới
    public List<String> getStrengths() { return strengths; }
    public void setStrengths(List<String> strengths) { this.strengths = strengths; }
    public void addStrength(String strength) { this.strengths.add(strength); }
    
    public List<String> getWeaknesses() { return weaknesses; }
    public void setWeaknesses(List<String> weaknesses) { this.weaknesses = weaknesses; }
    public void addWeakness(String weakness) { this.weaknesses.add(weakness); }
    
    public List<String> getRecommendedCareers() { return recommendedCareers; }
    public void setRecommendedCareers(List<String> recommendedCareers) { 
        this.recommendedCareers = recommendedCareers; 
    }
    public void addRecommendedCareer(String career) { this.recommendedCareers.add(career); }
    
    public List<String> getCompatibleTypes() { return compatibleTypes; }
    public void setCompatibleTypes(List<String> compatibleTypes) { 
        this.compatibleTypes = compatibleTypes; 
    }
    public void addCompatibleType(String type) { this.compatibleTypes.add(type); }
    
    // Helper method để set thông tin chi tiết dựa trên MBTI type
    private void setMbtiDetails(String mbtiType) {
        switch (mbtiType) {
            case "INTJ":
                setDescription("Nhà chiến lược - Độc lập, sáng tạo, có tầm nhìn xa");
                setStrengths(Arrays.asList(
                    "Tư duy chiến lược và logic",
                    "Khả năng phân tích sâu sắc", 
                    "Độc lập và tự chủ cao",
                    "Tập trung vào mục tiêu dài hạn",
                    "Quyết tâm và kiên trì"
                ));
                setWeaknesses(Arrays.asList(
                    "Đôi khi quá cầu toàn",
                    "Khó thể hiện cảm xúc",
                    "Có thể thiếu kiên nhẫn",
                    "Khó chấp nhận ý kiến trái chiều",
                    "Dễ bị căng thẳng khi mất kiểm soát"
                ));
                setRecommendedCareers(Arrays.asList(
                    "Kỹ sư phần mềm", "Data Scientist", "Quản lý dự án",
                    "Kiến trúc sư", "Nhà nghiên cứu", "Tư vấn chiến lược",
                    "Giảng viên đại học", "Chuyên gia phân tích"
                ));
                setCompatibleTypes(Arrays.asList("ENFP", "ENTP", "INFJ", "INTP"));
                break;
                
            case "INFP":
                setDescription("Người lý tưởng - Sáng tạo, đồng cảm, trung thành");
                setStrengths(Arrays.asList(
                    "Sáng tạo và giàu trí tưởng tượng",
                    "Đồng cảm và quan tâm đến người khác",
                    "Trung thành và đáng tin cậy",
                    "Cởi mở và linh hoạt",
                    "Có giá trị và nguyên tắc riêng"
                ));
                setWeaknesses(Arrays.asList(
                    "Quá nhạy cảm",
                    "Khó đưa ra quyết định",
                    "Dễ bị choáng ngợp bởi căng thẳng",
                    "Thiếu tính thực tế",
                    "Khó nói không"
                ));
                setRecommendedCareers(Arrays.asList(
                    "Nhà văn", "Nhà tâm lý học", "Giáo viên",
                    "Nghệ sĩ", "Công tác xã hội", "Nhà thiết kế",
                    "Biên tập viên", "Chuyên viên tư vấn"
                ));
                setCompatibleTypes(Arrays.asList("ENFJ", "ENTJ", "INFJ", "ENFP"));
                break;
                
            case "ENFP":
                setDescription("Người truyền cảm hứng - Nhiệt tình, sáng tạo, lạc quan");
                setStrengths(Arrays.asList(
                    "Nhiệt tình và đầy năng lượng",
                    "Sáng tạo và giàu ý tưởng",
                    "Giao tiếp tốt và hòa đồng",
                    "Linh hoạt và thích nghi nhanh",
                    "Truyền cảm hứng cho người khác"
                ));
                setWeaknesses(Arrays.asList(
                    "Thiếu tập trung",
                    "Dễ bị phân tâm",
                    "Quá cảm xúc",
                    "Khó hoàn thành dự án",
                    "Khó tuân theo quy tắc"
                ));
                setRecommendedCareers(Arrays.asList(
                    "Marketing", "Sales", "Nhà báo",
                    "Diễn giả", "Nhà tổ chức sự kiện", "Giáo viên",
                    "Nhà tư vấn", "Doanh nhân"
                ));
                setCompatibleTypes(Arrays.asList("INTJ", "INFJ", "ENFJ", "ENTJ"));
                break;
                
            case "ISTJ":
                setDescription("Người kiểm tra - Thực tế, có trách nhiệm, đáng tin cậy");
                setStrengths(Arrays.asList(
                    "Thực tế và logic",
                    "Có trách nhiệm và đáng tin cậy",
                    "Tổ chức và chi tiết",
                    "Trung thành và ổn định",
                    "Kiên trì và chăm chỉ"
                ));
                setWeaknesses(Arrays.asList(
                    "Cứng nhắc và bảo thủ",
                    "Khó thích nghi với thay đổi",
                    "Thiếu sáng tạo",
                    "Khó thể hiện cảm xúc",
                    "Quá tập trung vào chi tiết"
                ));
                setRecommendedCareers(Arrays.asList(
                    "Kế toán", "Quản lý văn phòng", "Kỹ sư",
                    "Cảnh sát", "Quân nhân", "Thủ thư",
                    "Nhân viên hành chính", "Chuyên gia phân tích"
                ));
                setCompatibleTypes(Arrays.asList("ESFP", "ISFP", "ESTJ", "ENTJ"));
                break;
                
            default:
                setDescription("Phân tích tính cách dựa trên MBTI");
                setStrengths(Arrays.asList(
                    "Tư duy logic và phân tích",
                    "Khả năng lập kế hoạch chiến lược",
                    "Độc lập và tự chủ cao",
                    "Quyết tâm và kiên trì",
                    "Khả năng học hỏi nhanh"
                ));
                setWeaknesses(Arrays.asList(
                    "Đôi khi quá cầu toàn",
                    "Khó thể hiện cảm xúc",
                    "Có thể thiếu kiên nhẫn",
                    "Khó chấp nhận ý kiến trái chiều",
                    "Dễ bị căng thẳng khi mất kiểm soát"
                ));
                setRecommendedCareers(Arrays.asList(
                    "Kỹ sư phần mềm", "Data Scientist", "Quản lý dự án",
                    "Kiến trúc sư", "Nhà nghiên cứu", "Tư vấn chiến lược"
                ));
                setCompatibleTypes(Arrays.asList("ENFP", "ENTP", "INFJ", "INTP"));
                break;
        }
    }
    
    // Helper methods
    public String getDimensionDescription(String dimension) {
        switch (dimension) {
            case "EXTROVERT": return "Hướng ngoại - Năng lượng từ tương tác xã hội";
            case "INTROVERT": return "Hướng nội - Năng lượng từ thời gian một mình";
            case "SENSING": return "Giác quan - Tập trung vào thực tế hiện tại";
            case "INTUITION": return "Trực giác - Tập trung vào khả năng tương lai";
            case "THINKING": return "Lý trí - Ra quyết định dựa trên logic";
            case "FEELING": return "Cảm xúc - Ra quyết định dựa trên giá trị";
            case "JUDGING": return "Nguyên tắc - Thích kế hoạch và tổ chức";
            case "PERCEIVING": return "Linh hoạt - Thích tự phát và linh hoạt";
            default: return dimension;
        }
    }
}