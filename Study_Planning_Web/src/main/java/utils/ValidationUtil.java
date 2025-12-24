package utils;

import java.util.regex.Pattern;

/**
 * Validation Utility Class
 * Provides validation methods for schedule data
 */
public class ValidationUtil {
    private static final Pattern TIME_PATTERN = Pattern.compile("^([01]?[0-9]|2[0-3]):[0-5][0-9]$");
    private static final String[] VALID_DAYS = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" };
    private static final String[] VALID_TYPES = { "class", "break", "self-study", "activity" };

    /**
     * Validate time format (HH:mm)
     */
    public static boolean isValidTimeFormat(String time) {
        if (time == null || time.isEmpty()) {
            return false;
        }
        return TIME_PATTERN.matcher(time).matches();
    }

    /**
     * Validate day of week
     */
    public static boolean isValidDayOfWeek(String day) {
        if (day == null || day.isEmpty()) {
            return false;
        }
        for (String validDay : VALID_DAYS) {
            if (validDay.equals(day)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Validate schedule type
     */
    public static boolean isValidType(String type) {
        if (type == null || type.isEmpty()) {
            return false;
        }
        for (String validType : VALID_TYPES) {
            if (validType.equals(type)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Check if start time is before end time
     */
    public static boolean isTimeRangeValid(String startTime, String endTime) {
        if (!isValidTimeFormat(startTime) || !isValidTimeFormat(endTime)) {
            return false;
        }
        return startTime.compareTo(endTime) < 0;
    }

    /**
     * Validate subject name
     */
    public static boolean isValidSubject(String subject) {
        return subject != null && !subject.trim().isEmpty() && subject.length() <= 100;
    }
}
