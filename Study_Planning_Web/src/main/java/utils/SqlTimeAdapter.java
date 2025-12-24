package utils;

import com.google.gson.*;
import java.lang.reflect.Type;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;

/**
 * Custom Gson deserializer for SQL Time
 * Handles time formats with or without seconds (HH:mm:ss or HH:mm or H:mm)
 */
public class SqlTimeAdapter implements JsonSerializer<Time>, JsonDeserializer<Time> {

    @Override
    public JsonElement serialize(Time src, Type typeOfSrc, JsonSerializationContext context) {
        // Always serialize as HH:mm:ss to be clear and consistent
        return new JsonPrimitive(src.toString());
    }

    @Override
    public Time deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context)
            throws JsonParseException {

        String timeString = json.getAsString();

        // Add seconds if not present (e.g., "5:00" -> "05:00:00")
        if (timeString != null && !timeString.isEmpty()) {
            // Trim whitespace
            timeString = timeString.trim();

            // Handle Vietnamese/English AM/PM markers
            boolean isPM = false;
            boolean isAM = false;
            String upperTime = timeString.toUpperCase();

            if (upperTime.contains("PM") || upperTime.contains("CH")) {
                isPM = true;
                timeString = timeString.replaceAll("(?i)(PM|CH)", "").trim();
            } else if (upperTime.contains("AM") || upperTime.contains("SA")) {
                isAM = true;
                timeString = timeString.replaceAll("(?i)(AM|SA)", "").trim();
            }

            try {
                // Determine format
                String[] parts = timeString.split(":");
                String hourStr, minuteStr, secondStr = "00";

                if (parts.length >= 2) {
                    hourStr = parts[0].trim();
                    minuteStr = parts[1].trim();
                    if (parts.length >= 3) {
                        secondStr = parts[2].trim();
                        // Remove potential decimals
                        if (secondStr.contains(".")) {
                            secondStr = secondStr.split("\\.")[0];
                        }
                    }

                    // Convert to integer for 12h -> 24h logic
                    int hour = Integer.parseInt(hourStr);

                    if (isPM && hour < 12) {
                        hour += 12;
                    } else if (isAM && hour == 12) {
                        hour = 0;
                    }

                    // Format back to HH:mm:ss
                    String finalTime = String.format("%02d:%02d:%02d", hour, Integer.parseInt(minuteStr),
                            Integer.parseInt(secondStr));

                    // Use standard SQL Time parsing (HH:mm:ss)
                    return Time.valueOf(finalTime);
                } else {
                    throw new JsonParseException("Invalid time format (expected HH:mm or HH:mm:ss): " + timeString);
                }
            } catch (Exception e) {
                System.err.println("SqlTimeAdapter: Failed to parse time: " + timeString);
                e.printStackTrace();
                throw new JsonParseException("Failed to parse time: " + timeString, e);
            }
        }

        return null;
    }
}
