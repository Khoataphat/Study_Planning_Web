CREATE TABLE user_settings (
    user_id INT PRIMARY KEY,
    theme VARCHAR(20) DEFAULT 'light',
    language VARCHAR(10) DEFAULT 'vi',
    notification_level VARCHAR(10) DEFAULT 'medium',
    preferred_study_time VARCHAR(20),
    focus_level VARCHAR(10),
    ai_enabled BOOLEAN DEFAULT TRUE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);