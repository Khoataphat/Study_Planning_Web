package service;

import dao.TaskDAO;
import model.Task;

import java.sql.Timestamp;
import java.util.List;

/**
 * Service layer for Task business logic
 */
public class TaskService {
    private final TaskDAO taskDAO;
    private final dao.UserScheduleDAO scheduleDAO;

    public TaskService() {
        this.taskDAO = new TaskDAO();
        this.scheduleDAO = new dao.UserScheduleDAO();
    }

    /**
     * Get all tasks for a user
     */
    public List<Task> getAllTasksByUserId(int userId) {
        return taskDAO.getAllByUserId(userId);
    }

    /**
     * Get task by ID
     */
    public Task getTaskById(int taskId) {
        return taskDAO.getById(taskId);
    }

    /**
     * Create a new task with validation
     */
    public int createTask(Task task) throws IllegalArgumentException {
        // Validation
        if (task.getTitle() == null || task.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Task title cannot be empty");
        }

        if (task.getDeadline() == null) {
            throw new IllegalArgumentException("Task deadline is required");
        }

        // Set defaults if not provided
        if (task.getPriority() == null || task.getPriority().isEmpty()) {
            task.setPriority("medium");
        }

        if (task.getStatus() == null || task.getStatus().isEmpty()) {
            task.setStatus("pending");
        }

        if (task.getDuration() <= 0) {
            task.setDuration(90); // Default 90 minutes
        }

        return taskDAO.insert(task);
    }

    /**
     * Update existing task with validation
     */
    public boolean updateTask(Task task) throws IllegalArgumentException {
        // Validation
        if (task.getTaskId() <= 0) {
            throw new IllegalArgumentException("Invalid task ID");
        }

        if (task.getTitle() == null || task.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Task title cannot be empty");
        }

        if (task.getDeadline() == null) {
            throw new IllegalArgumentException("Task deadline is required");
        }

        return taskDAO.update(task);
    }

    /**
     * Delete task by ID and remove associated schedule entries
     */
    public boolean deleteTask(int taskId) {
        // Get task details first to know subject and userId
        Task task = taskDAO.getById(taskId);

        boolean deleted = taskDAO.delete(taskId);

        if (deleted && task != null) {
            // Also delete from schedule if it exists
            scheduleDAO.deleteByUserIdAndSubject(task.getUserId(), task.getTitle());
        }

        return deleted;
    }

    /**
     * Get tasks by status
     */
    public List<Task> getTasksByStatus(int userId, String status) {
        return taskDAO.getByUserIdAndStatus(userId, status);
    }

    /**
     * Get pending tasks for a user
     */
    public List<Task> getPendingTasks(int userId) {
        return taskDAO.getByUserIdAndStatus(userId, "pending");
    }

    /**
     * Get in-progress tasks for a user
     */
    public List<Task> getInProgressTasks(int userId) {
        return taskDAO.getByUserIdAndStatus(userId, "in_progress");
    }

    /**
     * Get completed tasks for a user
     */
    public List<Task> getCompletedTasks(int userId) {
        return taskDAO.getByUserIdAndStatus(userId, "done");
    }

    /**
     * Check if task is overdue
     */
    public boolean isOverdue(Task task) {
        if (task.getDeadline() == null) {
            return false;
        }

        Timestamp now = new Timestamp(System.currentTimeMillis());
        return task.getDeadline().before(now) && !"done".equals(task.getStatus());
    }

    /**
     * Get count of tasks by status for a user
     */
    public int getTaskCountByStatus(int userId, String status) {
        return taskDAO.getByUserIdAndStatus(userId, status).size();
    }
}
