/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class WorkStyleQuestion {

    private int id;
    private String category;
    private String questionText;
    private String optionAText;
    private String optionAScore; // JSON String: {"leadership": 2}
    private String optionBText;
    private String optionBScore;
    private String optionCText;
    private String optionCScore;
    private int displayOrder;

    public WorkStyleQuestion() {
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getOptionAText() {
        return optionAText;
    }

    public void setOptionAText(String optionAText) {
        this.optionAText = optionAText;
    }

    public String getOptionAScore() {
        return optionAScore;
    }

    public void setOptionAScore(String optionAScore) {
        this.optionAScore = optionAScore;
    }

    public String getOptionBText() {
        return optionBText;
    }

    public void setOptionBText(String optionBText) {
        this.optionBText = optionBText;
    }

    public String getOptionBScore() {
        return optionBScore;
    }

    public void setOptionBScore(String optionBScore) {
        this.optionBScore = optionBScore;
    }

    public String getOptionCText() {
        return optionCText;
    }

    public void setOptionCText(String optionCText) {
        this.optionCText = optionCText;
    }

    public String getOptionCScore() {
        return optionCScore;
    }

    public void setOptionCScore(String optionCScore) {
        this.optionCScore = optionCScore;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }
}
