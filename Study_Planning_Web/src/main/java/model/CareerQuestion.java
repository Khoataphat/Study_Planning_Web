/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class CareerQuestion {
    private int id;
    private String questionText;
    private int technologyScore;
    private int businessScore;
    private int creativeScore;
    private int scienceScore;
    private int educationScore;
    private int socialScore;
    private int displayOrder;
    
    // Constructors
    public CareerQuestion() {}
    
    public CareerQuestion(String questionText, int techScore, int businessScore, 
                         int creativeScore, int scienceScore, int eduScore, int socialScore) {
        this.questionText = questionText;
        this.technologyScore = techScore;
        this.businessScore = businessScore;
        this.creativeScore = creativeScore;
        this.scienceScore = scienceScore;
        this.educationScore = eduScore;
        this.socialScore = socialScore;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    
    public int getTechnologyScore() { return technologyScore; }
    public void setTechnologyScore(int technologyScore) { this.technologyScore = technologyScore; }
    
    public int getBusinessScore() { return businessScore; }
    public void setBusinessScore(int businessScore) { this.businessScore = businessScore; }
    
    public int getCreativeScore() { return creativeScore; }
    public void setCreativeScore(int creativeScore) { this.creativeScore = creativeScore; }
    
    public int getScienceScore() { return scienceScore; }
    public void setScienceScore(int scienceScore) { this.scienceScore = scienceScore; }
    
    public int getEducationScore() { return educationScore; }
    public void setEducationScore(int educationScore) { this.educationScore = educationScore; }
    
    public int getSocialScore() { return socialScore; }
    public void setSocialScore(int socialScore) { this.socialScore = socialScore; }
    
    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }
    
    // Helper method to get all scores as array
    public int[] getAllScores() {
        return new int[]{
            technologyScore, businessScore, creativeScore,
            scienceScore, educationScore, socialScore
        };
    }
}