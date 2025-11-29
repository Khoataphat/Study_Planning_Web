package com.studyplanning.utils;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Database Utility Class
 * Provides database connection for the application
 */
public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/spd";
    private static final String USER = "root";
    private static final String PASS = "Anhang@204";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
