package service;

import dao.TaskDAO;
import dao.UserScheduleDAO;
import model.Task;
import model.UserSchedule;

import java.sql.Time;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;

/**
 * Service to generate smart schedules based on user tasks and preferences.
 */
public class SmartScheduleService {

    private final TaskDAO taskDAO;
    private final UserScheduleDAO scheduleDAO;

    public SmartScheduleService() {
        this.taskDAO = new TaskDAO();
        this.scheduleDAO = new UserScheduleDAO();
    }

    /**
     * Calculates the smart schedule without saving it to the database.
     * Useful for previewing the schedule.
     */
    public List<UserSchedule> calculateSchedule(int userId, int collectionId, String startTimeStr, String endTimeStr,
            boolean includeWeekends) {
        try {
            // 1. Fetch existing schedules (from Designer/Manual)
            List<UserSchedule> existingSchedules = scheduleDAO.getAllByCollectionId(collectionId);

            // Start with existing items (we preserve them)
            List<UserSchedule> finalSchedule = new ArrayList<>(existingSchedules);

            // 2. Fetch pending tasks
            List<Task> pendingTasks = taskDAO.getByUserIdAndStatus(userId, "pending");
            if (pendingTasks.isEmpty()) {
                return finalSchedule;
            }

            // Sort logic..
            pendingTasks.sort((t1, t2) -> {
                int p1 = getPriorityScore(t1.getPriority());
                int p2 = getPriorityScore(t2.getPriority());
                return p2 - p1;
            });

            // 3. Constraints
            if (startTimeStr.length() == 5)
                startTimeStr += ":00";
            if (endTimeStr.length() == 5)
                endTimeStr += ":00";

            Time dayStart = Time.valueOf(startTimeStr);
            Time dayEnd = Time.valueOf(endTimeStr);

            // Simulation
            String[] days;
            if (includeWeekends) {
                days = new String[] { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" };
            } else {
                days = new String[] { "Mon", "Tue", "Wed", "Thu", "Fri" };
            }
            int currentDayIndex = 0;
            Time currentSlotStart = dayStart;

            for (Task task : pendingTasks) {
                boolean placed = false;

                // Try to find a slot
                while (currentDayIndex < days.length && !placed) {
                    int durationMins = task.getDuration();

                    // Possible End Time
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(currentSlotStart);
                    cal.add(Calendar.MINUTE, durationMins);
                    Time currentSlotEnd = new Time(cal.getTimeInMillis());

                    // Check Day Boundary
                    if (currentSlotEnd.after(dayEnd)) {
                        currentDayIndex++;
                        if (currentDayIndex >= days.length)
                            break;
                        currentSlotStart = dayStart;
                        continue;
                    }

                    // Check Collision
                    String dayName = days[currentDayIndex];
                    boolean conflict = false;
                    long nextAvailable = -1;

                    for (UserSchedule existing : finalSchedule) {
                        if (!existing.getDayOfWeek().equalsIgnoreCase(dayName))
                            continue;

                        // Overlap Check (Time A overlaps Time B)
                        Time exStart = existing.getStartTime();
                        Time exEnd = existing.getEndTime();

                        if (currentSlotStart.before(exEnd) && currentSlotEnd.after(exStart)) {
                            conflict = true;
                            // Jump to end of existing task
                            if (exEnd.getTime() > nextAvailable) {
                                nextAvailable = exEnd.getTime();
                            }
                        }
                    }

                    if (conflict) {
                        if (nextAvailable != -1) {
                            currentSlotStart = new Time(nextAvailable);
                        } else {
                            // Should not happen if logic matches, but fallback
                            cal.setTime(currentSlotStart);
                            cal.add(Calendar.MINUTE, 5);
                            currentSlotStart = new Time(cal.getTimeInMillis());
                        }
                    } else {
                        // Found a slot
                        UserSchedule s = new UserSchedule();
                        s.setUserId(userId);
                        s.setCollectionId(collectionId);
                        s.setDayOfWeek(dayName);
                        s.setStartTime(currentSlotStart);
                        s.setEndTime(currentSlotEnd);
                        s.setSubject(task.getTitle());
                        s.setType("self-study");
                        s.setDescription(task.getTitle());

                        finalSchedule.add(s);
                        placed = true;

                        currentSlotStart = currentSlotEnd;
                    }
                }
            }
            return finalSchedule;

        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * Saves a list of schedules to the database, replacing existing ones in the
     * collection.
     */
    public boolean saveSchedules(int userId, int collectionId, List<UserSchedule> schedules) {
        try {
            // Delete existing schedules in this collection
            scheduleDAO.deleteByCollectionId(collectionId);

            // Insert new schedules
            for (UserSchedule schedule : schedules) {
                // Sanitize Type to avoid Truncation/Enum errors
                String fixedType = sanitizeType(schedule.getType());
                schedule.setType(fixedType);

                // Ensure IDs are set correctly
                schedule.setUserId(userId);
                schedule.setCollectionId(collectionId);
                scheduleDAO.insert(schedule);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String sanitizeType(String type) {
        if (type == null)
            return "self-study";

        switch (type.toLowerCase()) {
            case "học_tập":
            case "học":
            case "tự học":
            case "study":
                return "self-study";
            case "lớp học":
            case "lên lớp":
            case "class":
                return "class";
            case "giải_trí":
            case "giải trí":
            case "hobby":
                return "activity";
            case "công_việc":
            case "làm việc":
            case "work":
                return "self-study";
            case "nghỉ_ngơi":
            case "nghỉ":
            case "break":
                return "break";
            default:
                // If it's one of the valid keys, return it, else default
                if (type.equals("self-study") || type.equals("class") || type.equals("activity")
                        || type.equals("break")) {
                    return type;
                }
                return "self-study"; // Fallback
        }
    }

    // Deprecated wrapper to maintain backward compatibility if needed, or just
    // remove
    public boolean generateSmartSchedule(int userId, int collectionId, String startTimeStr, String endTimeStr) {
        List<UserSchedule> schedules = calculateSchedule(userId, collectionId, startTimeStr, endTimeStr, false);
        if (schedules.isEmpty())
            return false;
        return saveSchedules(userId, collectionId, schedules);
    }

    private int getPriorityScore(String priority) {
        if (priority == null)
            return 1;
        if ("high".equalsIgnoreCase(priority))
            return 3;
        if ("medium".equalsIgnoreCase(priority))
            return 2;
        return 1;
    }
}
