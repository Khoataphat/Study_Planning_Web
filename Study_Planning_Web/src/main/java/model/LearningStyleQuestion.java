/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class LearningStyleQuestion {

    private int id;
    private String questionText;
    private String visualOption;
    private String auditoryOption;
    private String kinestheticOption;
    private int displayOrder;

    public LearningStyleQuestion() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getVisualOption() {
        return visualOption;
    }

    public void setVisualOption(String visualOption) {
        this.visualOption = visualOption;
    }

    public String getAuditoryOption() {
        return auditoryOption;
    }

    public void setAuditoryOption(String auditoryOption) {
        this.auditoryOption = auditoryOption;
    }

    public String getKinestheticOption() {
        return kinestheticOption;
    }

    public void setKinestheticOption(String kinestheticOption) {
        this.kinestheticOption = kinestheticOption;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }
}
