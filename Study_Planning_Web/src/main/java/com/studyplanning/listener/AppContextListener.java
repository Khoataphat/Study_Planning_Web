package com.studyplanning.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

/**
 * Listener to handle application lifecycle events
 * Cleans up JDBC drivers and threads to prevent memory leaks
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Application startup logic if needed
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Deregister JDBC drivers
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                System.out.println("Deregistering JDBC driver: " + driver);
            } catch (SQLException e) {
                System.err.println("Error deregistering JDBC driver: " + driver);
                e.printStackTrace();
            }
        }

        // Stop MySQL AbandonedConnectionCleanupThread
        try {
            com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
            System.out.println("MySQL AbandonedConnectionCleanupThread stopped.");
        } catch (Exception e) {
            System.err.println("Error stopping MySQL AbandonedConnectionCleanupThread");
            e.printStackTrace();
        }
    }
}
