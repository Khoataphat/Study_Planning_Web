package service;

import dao.UserScheduleDAO;
import model.UserSchedule;

import java.sql.Time;
import java.util.*;

/**
 * Service layer for schedule business logic
 */
public class ScheduleService {
    private final UserScheduleDAO scheduleDAO;

    public ScheduleService() {
        this.scheduleDAO = new UserScheduleDAO();
    }

    /**
     * Get all schedules for a user
     */
    public List<UserSchedule> getUserSchedules(int userId) {
        return scheduleDAO.getAllByUserId(userId);
    }

    /**
     * Get weekly schedule grouped by day for a specific collection
     */
    public Map<String, List<UserSchedule>> getWeeklySchedule(int collectionId) {
        List<UserSchedule> allSchedules = scheduleDAO.getAllByCollectionId(collectionId);
        Map<String, List<UserSchedule>> weeklySchedule = new LinkedHashMap<>();

        // Initialize all days
        String[] days = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" };
        for (String day : days) {
            weeklySchedule.put(day, new ArrayList<>());
        }

        // Group schedules by day
        for (UserSchedule schedule : allSchedules) {
            String day = schedule.getDayOfWeek();
            weeklySchedule.get(day).add(schedule);
        }

        return weeklySchedule;
    }

    /**
     * Save multiple schedules (batch insert)
     * Deletes existing schedules in the collection and inserts new ones
     */
    public boolean saveSchedules(int userId, int collectionId, List<UserSchedule> schedules) {
        try {
            // Delete existing schedules in this collection
            scheduleDAO.deleteByCollectionId(collectionId);

            // Insert new schedules
            for (UserSchedule schedule : schedules) {
                // schedule.setUserId(userId); // Removed
                schedule.setCollectionId(collectionId);
                int id = scheduleDAO.insert(schedule);
                if (id == -1) {
                    return false;
                }
            }

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a specific schedule
     */
    public boolean deleteSchedule(int scheduleId) {
        return scheduleDAO.delete(scheduleId);
    }

    /**
     * Validate time slot for conflicts
     * Checks if the new schedule overlaps with existing ones
     */
    public boolean validateTimeSlot(int userId, UserSchedule newSchedule) {
        List<UserSchedule> existingSchedules = scheduleDAO.getByUserIdAndDay(
                userId,
                newSchedule.getDayOfWeek());

        Time newStart = newSchedule.getStartTime();
        Time newEnd = newSchedule.getEndTime();

        // Check if start time is before end time
        if (newStart.compareTo(newEnd) >= 0) {
            return false;
        }

        // Check for overlaps with existing schedules
        for (UserSchedule existing : existingSchedules) {
            // Skip if it's the same schedule (for updates)
            if (existing.getScheduleId() == newSchedule.getScheduleId()) {
                continue;
            }

            Time existingStart = existing.getStartTime();
            Time existingEnd = existing.getEndTime();

            // Check for overlap
            if (!(newEnd.compareTo(existingStart) <= 0 || newStart.compareTo(existingEnd) >= 0)) {
                return false; // Overlap detected
            }
        }

        return true;
    }

    /**
     * Count total schedules for a collection
     */
    public int countSchedules(int collectionId) {
        return scheduleDAO.countByCollectionId(collectionId);
    }

    /**
     * Get schedule by ID
     */
    public UserSchedule getScheduleById(int scheduleId) {
        return scheduleDAO.getById(scheduleId);
    }

    /**
     * Update a schedule
     */
    public boolean updateSchedule(int userId, UserSchedule schedule) {
        // Validate before updating
        if (!validateTimeSlot(userId, schedule)) {
            return false;
        }
        return scheduleDAO.update(schedule);
    }

    /**
     * Create a new schedule
     */
    public int createSchedule(int userId, UserSchedule schedule) {
        // Validate before creating
        if (!validateTimeSlot(userId, schedule)) {
            return -1;
        }
        return scheduleDAO.insert(schedule);
    }
}
