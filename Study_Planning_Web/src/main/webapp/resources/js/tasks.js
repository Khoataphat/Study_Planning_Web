// Task Management JavaScript

let allTasks = [];
let currentFilter = 'all';
let currentWeekOffset = 0;
let editingTaskId = null;
let currentCollectionId = null;
let weeklySchedule = {};

// Initialize on page load
document.addEventListener('DOMContentLoaded', function () {
    loadTasks();
    loadScheduleCollections();
    setupFormHandler();
});

/**
 * Load all tasks from server
 */
function loadTasks() {
    fetch('/user/tasks?action=list')
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
 * Load schedule collections for dropdown
 */
function loadScheduleCollections() {
    fetch('/user/collections?action=list')
        .then(response => response.json())
        .then(collections => {
            const select = document.getElementById('scheduleSelect');
            select.innerHTML = '<option value="">Select a schedule...</option>';

            if (collections && collections.length > 0) {
                collections.forEach(collection => {
                    const option = document.createElement('option');
                    option.value = collection.collectionId;
                    option.textContent = collection.collectionName;
                    select.appendChild(option);
                });

                // Select first one by default
                select.value = collections[0].collectionId;
                currentCollectionId = collections[0].collectionId;
                loadSchedule(currentCollectionId);
            }
        })
        .catch(error => console.error('Error loading collections:', error));
}

/**
 * Handle schedule change
 */
function changeSchedule() {
    const select = document.getElementById('scheduleSelect');
    currentCollectionId = select.value;
    if (currentCollectionId) {
        loadSchedule(currentCollectionId);
    } else {
        renderCalendar(); // Clear calendar
    }
}

/**
 * Load weekly schedule
 */
function loadSchedule(collectionId) {
    if (!collectionId) return;

    fetch(`/user/schedule?action=weekly&collectionId=${collectionId}`)
        .then(response => response.json())
        .then(data => {
            weeklySchedule = data;
            renderCalendar();
        })
        .catch(error => console.error('Error loading schedule:', error));
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
    card.draggable = true; // Enable dragging
    card.dataset.taskId = task.taskId;
    card.dataset.duration = task.duration;

    // Drag start handler
    card.ondragstart = (e) => {
        e.dataTransfer.setData('taskId', task.taskId);
        e.dataTransfer.setData('duration', task.duration);
        e.dataTransfer.effectAllowed = 'copy';
        card.classList.add('opacity-50');
    };

    card.ondragend = () => {
        card.classList.remove('opacity-50');
    };

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
            deadline: formatDateForApi(new Date(document.getElementById('taskDeadline').value)),
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
    const response = await fetch('/user/tasks', {
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
    const response = await fetch(`/user/tasks?id=${taskId}`, {
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
    const formattedDeadline = formatForInput(deadline);
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
        const response = await fetch(`/user/tasks?id=${taskId}`, {
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
 * Render calendar grid
 */
function renderCalendar() {
    const calendarGrid = document.getElementById('calendarGrid');
    calendarGrid.innerHTML = '';

    // Calculate week range
    const today = new Date();
    const startOfWeek = new Date(today);
    startOfWeek.setDate(today.getDate() - today.getDay() + (currentWeekOffset * 7));

    // Adjust to Monday start if needed, but keeping Sunday start for consistency with backend
    // Backend uses Mon, Tue... so we need to map correctly

    const endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() + 6);
    document.getElementById('weekRangeDisplay').textContent =
        `${formatDate(startOfWeek)} - ${formatDate(endOfWeek)}`;

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

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    // Note: startOfWeek is Sunday. If we want Mon-Sun columns, we need to adjust logic.
    // The table header is Time, Mon, Tue... Sun.
    // So we need to map columns 1-7 to Mon-Sun.

    // Generate time slots (7 AM to 10 PM)
    for (let hour = 7; hour <= 22; hour++) {
        const row = document.createElement('tr');
        row.className = 'border-b border-slate-100 hover:bg-slate-50/50 transition-colors h-20';

        // Time column
        const timeCell = document.createElement('td');
        timeCell.className = 'p-2 text-xs text-slate-400 font-medium border-r border-slate-200 align-top text-center';
        timeCell.textContent = `${hour}:00`;
        row.appendChild(timeCell);

        // Day columns
        days.forEach((day, index) => {
            const cell = document.createElement('td');
            // Add border-r to all except the last column
            const borderClass = index < days.length - 1 ? 'border-r border-slate-100' : '';
            cell.className = `p-1 ${borderClass} relative align-top transition-all`;
            cell.dataset.day = day;
            cell.dataset.hour = hour;

            // Drag over handler
            cell.ondragover = (e) => {
                e.preventDefault();
                cell.classList.add('bg-blue-50');
            };

            cell.ondragleave = () => {
                cell.classList.remove('bg-blue-50');
            };

            // Drop handler
            cell.ondrop = (e) => {
                e.preventDefault();
                cell.classList.remove('bg-blue-50');
                const taskId = e.dataTransfer.getData('taskId');
                const duration = e.dataTransfer.getData('duration');
                if (taskId) {
                    addTaskToSchedule(taskId, day, hour, duration);
                }
            };

            // Render events if any
            if (weeklySchedule[day]) {
                const events = weeklySchedule[day].filter(e => {
                    const startHour = parseInt(e.startTime.split(':')[0]);
                    return startHour === hour;
                });

                events.forEach(event => {
                    const eventDiv = document.createElement('div');
                    eventDiv.className = 'bg-indigo-50 text-indigo-700 border border-indigo-200 p-1.5 rounded-md text-xs mb-1 font-medium cursor-pointer hover:bg-indigo-100 transition-colors truncate shadow-sm';
                    eventDiv.textContent = event.subject;
                    eventDiv.title = `${event.subject} (${event.startTime} - ${event.endTime})`;
                    cell.appendChild(eventDiv);
                });
            }

            row.appendChild(cell);
        });

        calendarGrid.appendChild(row);
    }
}

/**
 * Add task to schedule
 */
function addTaskToSchedule(taskId, day, startHour, duration) {
    if (!currentCollectionId) {
        alert('Please select a schedule first!');
        return;
    }

    const task = allTasks.find(t => t.taskId == taskId);
    if (!task) return;

    // Calculate new deadline based on schedule slot
    const newDeadline = getDateFromDayAndHour(day, startHour);

    // Update task deadline first
    const updatedTask = { ...task };
    // Format for API: yyyy-MM-dd HH:mm:ss
    updatedTask.deadline = formatDateForApi(newDeadline);

    // Call update task API
    fetch(`/user/tasks?id=${taskId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(updatedTask)
    })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                // Update local task list
                task.deadline = updatedTask.deadline;
                renderTaskList(); // Re-sort and render

                // Now add to schedule
                addToScheduleBackend(task, day, startHour, duration);
            } else {
                alert('Failed to update task time: ' + (result.message || result.error));
            }
        })
        .catch(error => {
            console.error('Error updating task:', error);
            alert('Error updating task time');
        });
}

/**
 * Helper to add to schedule backend
 */
function addToScheduleBackend(task, day, startHour, duration) {
    // Calculate times
    const start = `${startHour.toString().padStart(2, '0')}:00:00`;

    // Calculate end time based on duration (default 60 mins if not set)
    const durationMins = parseInt(duration) || 60;
    const endDate = new Date();
    endDate.setHours(startHour);
    endDate.setMinutes(durationMins);
    const endHour = endDate.getHours().toString().padStart(2, '0');
    const endMin = endDate.getMinutes().toString().padStart(2, '0');
    const end = `${endHour}:${endMin}:00`;

    const scheduleData = {
        collectionId: parseInt(currentCollectionId),
        dayOfWeek: day,
        startTime: start,
        endTime: end,
        subject: task.title,
        type: 'self-study' // Default type
    };

    fetch('/user/schedule?action=add', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(scheduleData)
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Reload schedule to show new event
                loadSchedule(currentCollectionId);
            } else {
                alert('Failed to add to schedule: ' + (data.message || 'Time conflict'));
            }
        })
        .catch(error => {
            console.error('Error adding to schedule:', error);
            alert('Error adding to schedule');
        });
}

/**
 * Get Date object from Day Name and Hour
 */
function getDateFromDayAndHour(dayName, hour) {
    const today = new Date();
    const currentDayIndex = today.getDay(); // 0 (Sun) - 6 (Sat)

    // Map day name to index (Mon=1, ... Sun=0/7)
    const dayMap = { 'Mon': 1, 'Tue': 2, 'Wed': 3, 'Thu': 4, 'Fri': 5, 'Sat': 6, 'Sun': 0 };
    let targetDayIndex = dayMap[dayName];

    // Fix logic for Mon-Sun week:
    // Treat Sun as 7.
    let currentDayIso = currentDayIndex === 0 ? 7 : currentDayIndex;
    let targetDayIso = targetDayIndex === 0 ? 7 : targetDayIndex;

    let diff = targetDayIso - currentDayIso;
    diff += (currentWeekOffset * 7);

    const targetDate = new Date(today);
    targetDate.setDate(today.getDate() + diff);
    targetDate.setHours(hour, 0, 0, 0);

    return targetDate;
}

/**
 * Format date for API (yyyy-MM-dd HH:mm:ss)
 */
function formatDateForApi(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

/**
 * Format date for input (yyyy-MM-ddTHH:mm)
 */
function formatForInput(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day}T${hours}:${minutes}`;
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
