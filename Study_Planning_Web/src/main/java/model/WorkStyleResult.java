/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
import java.sql.Timestamp;

public class WorkStyleResult {

    private int id;
    private int userId;
    private String primaryStyle;
    private int leadershipScore;
    private int supportScore;
    private int analysisScore;
    private int communicationScore;
    private int teamworkScore;
    private int creativityScore;
    private Timestamp completedAt;

    public WorkStyleResult() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getPrimaryStyle() {
        return primaryStyle;
    }

    public void setPrimaryStyle(String primaryStyle) {
        this.primaryStyle = primaryStyle;
    }

    public int getLeadershipScore() {
        return leadershipScore;
    }

    public void setLeadershipScore(int leadershipScore) {
        this.leadershipScore = leadershipScore;
    }

    public int getSupportScore() {
        return supportScore;
    }

    public void setSupportScore(int supportScore) {
        this.supportScore = supportScore;
    }

    public int getAnalysisScore() {
        return analysisScore;
    }

    public void setAnalysisScore(int analysisScore) {
        this.analysisScore = analysisScore;
    }

    public int getCommunicationScore() {
        return communicationScore;
    }

    public void setCommunicationScore(int communicationScore) {
        this.communicationScore = communicationScore;
    }

    public int getTeamworkScore() {
        return teamworkScore;
    }

    public void setTeamworkScore(int teamworkScore) {
        this.teamworkScore = teamworkScore;
    }

    public int getCreativityScore() {
        return creativityScore;
    }

    public void setCreativityScore(int creativityScore) {
        this.creativityScore = creativityScore;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }
}
