/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class MBTIQuestion {
    private int id;
    private String dimension; // E_I, S_N, T_F, J_P
    private String questionText;
    private String optionAText;
    private String optionAValue; // E, S, T, J
    private String optionBText;
    private String optionBValue; // I, N, F, P
    private int displayOrder;
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getDimension() { return dimension; }
    public void setDimension(String dimension) { this.dimension = dimension; }
    
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    
    public String getOptionAText() { return optionAText; }
    public void setOptionAText(String optionAText) { this.optionAText = optionAText; }
    
    public String getOptionAValue() { return optionAValue; }
    public void setOptionAValue(String optionAValue) { this.optionAValue = optionAValue; }
    
    public String getOptionBText() { return optionBText; }
    public void setOptionBText(String optionBText) { this.optionBText = optionBText; }
    
    public String getOptionBValue() { return optionBValue; }
    public void setOptionBValue(String optionBValue) { this.optionBValue = optionBValue; }
    
    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }
}
