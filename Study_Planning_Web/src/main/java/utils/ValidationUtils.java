/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import model.ValidationError;

/**
 *
 * @author Admin
 */
public class ValidationUtils {

    public static ValidationError validateUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return new ValidationError(false, "Username cannot be empty.");
        }
        if (username.length() < 4) {
            return new ValidationError(false, "Username must be at least 4 characters.");
        }
        return new ValidationError(true, null);
    }

    public static ValidationError validateEmail(String email) {
        if (email == null || email.isEmpty()) {
            return new ValidationError(false, "Email cannot be empty.");
        }
        if (!email.matches("^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            return new ValidationError(false, "Invalid email format.");
        }
        return new ValidationError(true, null);
    }

    public static ValidationError validatePassword(String password) {
        if (password == null || password.isEmpty()) {
            return new ValidationError(false, "Password cannot be empty.");
        }
        if (password.length() < 6) {
            return new ValidationError(false, "Password must be at least 6 characters.");
        }
        return new ValidationError(true, null);
    }
}

