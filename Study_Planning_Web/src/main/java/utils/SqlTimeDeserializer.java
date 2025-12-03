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
public class SqlTimeDeserializer implements JsonDeserializer<Time> {
    
    @Override
    public Time deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context)
            throws JsonParseException {
        
        String timeString = json.getAsString();
        
        // Add seconds if not present (e.g., "5:00" -> "05:00:00")
        if (timeString != null && !timeString.isEmpty()) {
            String[] parts = timeString.split(":");
            
            // If only hours and minutes, add seconds
            if (parts.length == 2) {
                // Pad hour with zero if needed (5 -> 05)
                String hour = parts[0].length() == 1 ? "0" + parts[0] : parts[0];
                String minute = parts[1].length() == 1 ? "0" + parts[1] : parts[1];
                timeString = hour + ":" + minute + ":00";
            } else if (parts.length == 3) {
                // Ensure proper padding for HH:mm:ss format
                String hour = parts[0].length() == 1 ? "0" + parts[0] : parts[0];
                String minute = parts[1].length() == 1 ? "0" + parts[1] : parts[1];
                String second = parts[2].length() == 1 ? "0" + parts[2] : parts[2];
                timeString = hour + ":" + minute + ":" + second;
            }
            
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
                java.util.Date date = sdf.parse(timeString);
                return new Time(date.getTime());
            } catch (ParseException e) {
                throw new JsonParseException("Failed to parse time: " + timeString, e);
            }
        }
        
        return null;
    }
}
