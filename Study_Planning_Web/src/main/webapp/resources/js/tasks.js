// Task Management JavaScript

let allTasks = [];
let currentFilter = 'all';
let currentWeekOffset = 0;
let editingTaskId = null;

// Initialize on page load
document.addEventListener('DOMContentLoaded', function () {
    loadTasks();
    renderCalendar();
    setupFormHandler();
});

/**
 * Load all tasks from server
 */
function loadTasks() {
    fetch('/Schedule_Student/user/tasks?action=list')
        .then(response => response.json())
        .then(tasks => {
            allTasks = tasks;
            renderTaskList();
            renderCalendar();
        })
        .catch(error => {
            console.error('Error loading tasks:', error);
            showEmptyState('Error loading tasks');
        });
}

/**
 * Render task list
 */
function renderTaskList() {
    const taskList = document.getElementById('taskList');

    // Filter tasks
    let filteredTasks = allTasks;
    if (currentFilter !== 'all') {
        filteredTasks = allTasks.filter(task => task.status === currentFilter);
    }

    // Sort by deadline
    filteredTasks.sort((a, b) => new Date(a.deadline) - new Date(b.deadline));

    // Clear existing tasks
    taskList.innerHTML = '';

    if (filteredTasks.length === 0) {
        taskList.innerHTML = `
            <div class="empty-state">
                <i class="fa-solid fa-tasks"></i>
                <p>No tasks found</p>
            </div>
        `;
        return;
    }

    // Render each task
    filteredTasks.forEach(task => {
        const taskCard = createTaskCard(task);
        taskList.appendChild(taskCard);
    });
}

/**
 * Create task card element
 */
function createTaskCard(task) {
    const card = document.createElement('div');
    card.className = `task-card priority-${task.priority}`;
    if (editingTaskId === task.taskId) {
        card.classList.add('selected');
    }

    const deadline = new Date(task.deadline);
    const now = new Date();
    const isOverdue = deadline < now && task.status !== 'done';
    const deadlineClass = isOverdue ? 'overdue' : '';

    card.innerHTML = `
        <div class="flex items-start justify-between mb-2">
            <div class="flex-1">
                <div class="task-title">${escapeHtml(task.title)}</div>
                <span class="task-status-badge ${task.status}">${formatStatus(task.status)}</span>
            </div>
            <div class="task-actions">
                <button class="task-action-btn edit" onclick="editTask(${task.taskId})" title="Edit">
                    <i class="fa-solid fa-pencil"></i>
                </button>
                <button class="task-action-btn delete" onclick="deleteTask(${task.taskId})" title="Delete">
                    <i class="fa-solid fa-trash"></i>
                </button>
            </div>
        </div>
        <div class="task-deadline ${deadlineClass}">
            <i class="fa-solid fa-clock"></i>
            <span>Due: ${formatDeadline(deadline)}</span>
            ${task.duration ? `<span class="text-xs">• ${task.duration} min</span>` : ''}
        </div>
    `;

    card.onclick = (e) => {
        if (!e.target.closest('.task-actions')) {
            editTask(task.taskId);
        }
    };

    return card;
}

/**
 * Setup form submission handler
 */
function setupFormHandler() {
    const form = document.getElementById('taskForm');
    form.onsubmit = async (e) => {
        e.preventDefault();

        const taskData = {
            title: document.getElementById('taskTitle').value,
            description: document.getElementById('taskDescription').value,
            priority: document.getElementById('taskPriority').value,
            status: document.getElementById('taskStatus').value,
            deadline: new Date(document.getElementById('taskDeadline').value).toISOString(),
            duration: parseInt(document.getElementById('taskDuration').value)
        };

        try {
            if (editingTaskId) {
                // Update existing task
                await updateTask(editingTaskId, taskData);
            } else {
                // Create new task
                await createTask(taskData);
            }

            // Hide form and reload tasks
            hideTaskForm();
            loadTasks();
        } catch (error) {
            console.error('Error saving task:', error);
            alert('Failed to save task. Please try again.');
        }
    };
}

/**
 * Create new task
 */
async function createTask(taskData) {
    const response = await fetch('/Schedule_Student/user/tasks', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(taskData)
    });

    const result = await response.json();

    if (!result.success) {
        throw new Error(result.error || 'Failed to create task');
    }

    return result;
}

/**
 * Update existing task
 */
async function updateTask(taskId, taskData) {
    const response = await fetch(`/Schedule_Student/user/tasks?id=${taskId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(taskData)
    });

    const result = await response.json();

    if (!result.success) {
        throw new Error(result.error || 'Failed to update task');
    }

    return result;
}

/**
 * Show task form for adding new task
 */
function showTaskForm() {
    const formContainer = document.getElementById('taskFormContainer');
    const formTitle = document.getElementById('formTitle');
    const addBtn = document.getElementById('addTaskBtn');

    formContainer.classList.remove('hidden');
    formTitle.textContent = 'Add New Task';
    addBtn.classList.add('hidden');

    // Reset form
    document.getElementById('taskForm').reset();
    editingTaskId = null;
    document.getElementById('submitBtnText').textContent = 'Save Task';
    document.getElementById('taskId').value = '';

    // Focus on title input
    setTimeout(() => {
        document.getElementById('taskTitle').focus();
    }, 100);
}

/**
 * Hide task form
 */
function hideTaskForm() {
    const formContainer = document.getElementById('taskFormContainer');
    const addBtn = document.getElementById('addTaskBtn');

    formContainer.classList.add('hidden');
    addBtn.classList.remove('hidden');

    // Reset form
    document.getElementById('taskForm').reset();
    editingTaskId = null;
    document.getElementById('submitBtnText').textContent = 'Save Task';
    document.getElementById('taskId').value = '';

    // Re-render task list to remove selection
    renderTaskList();
}

/**
 * Edit task - populate form  
 */
function editTask(taskId) {
    const task = allTasks.find(t => t.taskId === taskId);
    if (!task) return;

    editingTaskId = taskId;

    // Show form
    const formContainer = document.getElementById('taskFormContainer');
    const formTitle = document.getElementById('formTitle');
    const addBtn = document.getElementById('addTaskBtn');

    formContainer.classList.remove('hidden');
    formTitle.textContent = 'Edit Task';
    addBtn.classList.add('hidden');

    // Populate form
    document.getElementById('taskId').value = task.taskId;
    document.getElementById('taskTitle').value = task.title;
    document.getElementById('taskDescription').value = task.description || '';
    document.getElementById('taskPriority').value = task.priority;
    document.getElementById('taskStatus').value = task.status;
    document.getElementById('taskDuration').value = task.duration;

    // Format deadline for datetime-local input
    const deadline = new Date(task.deadline);
    const formattedDeadline = deadline.toISOString().slice(0, 16);
    document.getElementById('taskDeadline').value = formattedDeadline;

    // Update button text
    document.getElementById('submitBtnText').textContent = 'Update Task';

    // Scroll to form
    setTimeout(() => {
        document.getElementById('taskFormContainer').scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }, 100);

    // Re-render task list to show selection
    renderTaskList();
}

/**
 * Delete task
 */
async function deleteTask(taskId) {
    if (!confirm('Are you sure you want to delete this task?')) {
        return;
    }

    try {
        const response = await fetch(`/Schedule_Student/user/tasks?id=${taskId}`, {
            method: 'DELETE'
        });

        const result = await response.json();

        if (result.success) {
            loadTasks();
        } else {
            alert('Failed to delete task');
        }
    } catch (error) {
        console.error('Error deleting task:', error);
        alert('Failed to delete task. Please try again.');
    }
}

/**
 * Cancel editing
 */
function cancelEdit() {
    hideTaskForm();
}

/**
 * Filter tasks by status
 */
function filterByStatus(status) {
    currentFilter = status;

    // Update active button
    document.querySelectorAll('.status-filter-btn').forEach(btn => {
        btn.classList.remove('active');
        if (btn.dataset.status === status) {
            btn.classList.add('active');
        }
    });

    renderTaskList();
}

/**
 * Render calendar
 */
function renderCalendar() {
    const calendarGrid = document.getElementById('calendarGrid');
    calendarGrid.innerHTML = '';

    // Calculate week range
    const today = new Date();
    const startOfWeek = new Date(today);
    startOfWeek.setDate(today.getDate() - today.getDay() + (currentWeekOffset * 7));

    const weekDays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    // Update week label
    if (currentWeekOffset === 0) {
        document.getElementById('weekLabel').textContent = 'This Week';
    } else if (currentWeekOffset === -1) {
        document.getElementById('weekLabel').textContent = 'Last Week';
    } else if (currentWeekOffset === 1) {
        document.getElementById('weekLabel').textContent = 'Next Week';
    } else {
        document.getElementById('weekLabel').textContent = `${currentWeekOffset} weeks ${currentWeekOffset > 0 ? 'ahead' : 'ago'}`;
    }

    // Update week range display
    const endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() + 6);
    document.getElementById('weekRangeDisplay').textContent =
        `${formatDate(startOfWeek)} - ${formatDate(endOfWeek)}`;

    // Render each day
    for (let i = 0; i < 7; i++) {
        const currentDay = new Date(startOfWeek);
        currentDay.setDate(startOfWeek.getDate() + i);

        const dayCard = createDayCard(currentDay, weekDays[i]);
        calendarGrid.appendChild(dayCard);
    }
}

/**
 * Create day card for calendar
 */
function createDayCard(date, dayName) {
    const card = document.createElement('div');
    card.className = 'calendar-day';

    // Check if today
    const today = new Date();
    const isToday = date.toDateString() === today.toDateString();
    if (isToday) {
        card.classList.add('today');
    }

    // Get tasks for this day
    const dayTasks = allTasks.filter(task => {
        const taskDate = new Date(task.deadline);
        return taskDate.toDateString() === date.toDateString();
    });

    // Sort by priority (high first) then by time
    dayTasks.sort((a, b) => {
        const priorityOrder = { high: 0, medium: 1, low: 2 };
        const priorityDiff = priorityOrder[a.priority] - priorityOrder[b.priority];
        if (priorityDiff !== 0) return priorityDiff;
        return new Date(a.deadline) - new Date(b.deadline);
    });

    card.innerHTML = `
        <div class="calendar-day-header">${dayName}</div>
        <div class="calendar-day-date">${date.getDate()}</div>
        <div class="calendar-tasks">
            ${dayTasks.length > 0
            ? dayTasks.map(task => createCalendarTaskDot(task)).join('')
            : '<div class="empty-state"><i class="fa-solid fa-calendar-day"></i><p>No tasks</p></div>'}
        </div>
    `;

    return card;
}

/**
 * Create calendar task dot
 */
function createCalendarTaskDot(task) {
    return `
        <div class="calendar-task-dot priority-${task.priority}" onclick="editTask(${task.taskId})" title="${escapeHtml(task.title)}">
            <div class="dot-icon"></div>
            <div class="flex-1 truncate">${escapeHtml(task.title)}</div>
        </div>
    `;
}

/**
 * Navigate to different week
 */
function navigateWeek(offset) {
    if (offset === 0) {
        currentWeekOffset = 0;
    } else {
        currentWeekOffset += offset;
    }
    renderCalendar();
}

/**
 * Format deadline for display
 */
function formatDeadline(date) {
    const today = new Date();
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    if (date.toDateString() === today.toDateString()) {
        return `Today ${formatTime(date)}`;
    } else if (date.toDateString() === tomorrow.toDateString()) {
        return `Tomorrow ${formatTime(date)}`;
    } else {
        const days = Math.ceil((date - today) / (1000 * 60 * 60 * 24));
        if (days < 0) {
            return `${Math.abs(days)} days ago`;
        } else if (days <= 7) {
            return `in ${days} days`;
        } else {
            return date.toLocaleDateString();
        }
    }
}

/**
 * Format time
 */
function formatTime(date) {
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}

/**
 * Format date
 */
function formatDate(date) {
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
}

/**
 * Format status for display
 */
function formatStatus(status) {
    return status.replace('_', ' ');
}

/**
 * Escape HTML to prevent XSS
 */
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

/**
 * Show empty state
 */
function showEmptyState(message) {
    const taskList = document.getElementById('taskList');
    taskList.innerHTML = `
        <div class="empty-state">
            <i class="fa-solid fa-exclamation-triangle"></i>
            <p>${message}</p>
        </div>
    `;
}
