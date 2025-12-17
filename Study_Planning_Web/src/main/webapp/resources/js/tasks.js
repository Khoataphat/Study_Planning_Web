// Task Management JavaScript

let allTasks = [];
let currentFilter = 'all';
let currentWeekOffset = 0;
let editingTaskId = null;
let currentCollectionId = null;
let weeklySchedule = {};
let isScheduleLoaded = false;

//khoa
// ⭐️ BIẾN MỚI: Theo dõi sự kiện lịch tạm thời (được tạo bằng click)
let tempScheduledEvent = null;

// Khởi tạo cấu trúc rỗng để tránh lỗi 'undefined'
window.weeklySchedule = window.weeklySchedule || {
    'Mon': [], 'Tue': [], 'Wed': [], 'Thu': [], 'Fri': [], 'Sat': [], 'Sun': []
};
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
// Trong tasks.js

function loadSchedule(collectionId) {
    if (!collectionId) {
        // Nếu không có ID, coi như tải xong với dữ liệu rỗng
        isScheduleLoaded = true;
        return Promise.resolve();
    }

    // Đặt lại cờ khi bắt đầu tải (để xử lý nếu hàm này được gọi lại)
    isScheduleLoaded = false;
    console.log("🔄 loadSchedule đang tải collectionId:", collectionId);

    fetch(`/user/schedule?action=weekly&collectionId=${collectionId}`)
            .then(response => response.json())
            .then(data => {
                // Thay vì gán weeklySchedule = data;
                // Hãy dùng window. để đảm bảo nó ghi đè vào biến toàn cục
                console.log("📥 Dữ liệu schedule từ server:", data);
                window.weeklySchedule = data;
                console.log("Dữ liệu đã nạp vào window:", window.weeklySchedule);
                // Debug chi tiết
                debugScheduleData();
        
                renderCalendar();
                console.log("✅ renderCalendar() đã được gọi");
            })
            .catch(error => {
                console.error('Error loading schedule:', error);
                // Gán giá trị an toàn nếu lỗi
                weeklySchedule = {};
            })
            .finally(() => {
                // ⭐️ ĐIỂM QUAN TRỌNG: Dù thành công hay thất bại, cờ cũng phải được BẬT
                isScheduleLoaded = true;
                console.info("✅ Dữ liệu Lịch đã hoàn thành tải. isScheduleLoaded = true.");
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
    console.log("📤 Sending task data to server:", taskData);
    
    try {
        const response = await fetch('/user/tasks', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(taskData)
        });

        console.log("📥 Response status:", response.status);
        console.log("📥 Response headers:", response.headers);

        const result = await response.json();
        console.log("📥 Response data:", result);

        if (!result.success) {
            console.error("❌ Server error:", result.error || result.message);
            throw new Error(result.error || 'Failed to create task');
        }

        console.log("✅ Task created successfully, taskId:", result.taskId);
        return result;
    } catch (error) {
        console.error("❌ Network/parsing error:", error);
        throw error;
    }
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
window.tempScheduledEvent = null;

function hideTaskForm() {
    console.log("-----------------------------------------");
    console.log("1. HÀM hideTaskForm ĐƯỢC GỌI.");

    // ⭐️ LOGIC KIỂM TRA VÀ XÓA SỰ KIỆN TẠM THỜI
    if (window.tempScheduledEvent) {
        console.log("2. Biến window.tempScheduledEvent TỒN TẠI.");

        if (window.tempScheduledEvent.element) {
            // Kiểm tra xem element có còn nằm trong DOM không
            const element = window.tempScheduledEvent.element;
            const isElementInDOM = document.body.contains(element);

            console.log("3. Element đã được lưu. Type:", element.tagName);
            console.log("4. Element có còn trong DOM không?", isElementInDOM);

            // Tiến hành xóa
            element.remove();
            console.log("5. Đã gọi element.remove().");

            // Đặt lại biến
            window.tempScheduledEvent = null;
            console.log("6. window.tempScheduledEvent đã được reset thành NULL.");
        } else {
            console.log("3. LỖI: Thuộc tính .element trong tempScheduledEvent là NULL/UNDEFINED.");
            console.log("   (Kiểm tra lại hàm khởi tạo openTaskDetailModalFromSchedule)");
        }
    } else {
        console.log("2. window.tempScheduledEvent là NULL. Không có lịch trình tạm thời nào để xóa.");
    }

    // --- Logic Ẩn Form ---
    const formContainer = document.getElementById('taskFormContainer');
    const addBtn = document.getElementById('addTaskBtn');

    formContainer.classList.add('hidden');
    addBtn.classList.remove('hidden');
    console.log("7. Form đã bị ẩn.");

    // Reset form
    document.getElementById('taskForm').reset();
    editingTaskId = null;
    document.getElementById('submitBtnText').textContent = 'Save Task';
    document.getElementById('taskId').value = '';

    renderTaskList();
    console.log("8. renderTaskList đã được gọi.");
    // ⭐️ THÊM: Reload schedule nếu vừa tạo task từ lịch
    if (wasCreatingFromSchedule && currentCollectionId) {
        console.log("🔄 Detected schedule task creation - reloading calendar");
        setTimeout(() => {
            loadSchedule(currentCollectionId).then(() => {
                console.log("✅ Calendar reloaded with new task");
            });
        }, 500); // Delay 500ms để đảm bảo task đã được lưu trong DB
    }
    console.log("-----------------------------------------");
    
}
window.hideTaskForm = hideTaskForm;

/**
 * Edit task - populate form  
 */
function editTask(taskId) {
    const task = allTasks.find(t => t.taskId === taskId);
    if (!task)
        return;

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
        document.getElementById('taskFormContainer').scrollIntoView({behavior: 'smooth', block: 'nearest'});
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
    // ⭐️ Ưu tiên hủy tạo lịch trình nếu đang tồn tại
    if (tempScheduledEvent) {
        window.cancelScheduleCreation(); // Hàm này sẽ xóa element và gọi hideTaskForm
    } else {
        hideTaskForm(); // Chỉ ẩn form nếu đang ở chế độ chỉnh sửa Task thông thường
    }
}
window.cancelEdit = cancelEdit;
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
//function renderCalendar() {
//    const calendarGrid = document.getElementById('calendarGrid');
//    calendarGrid.innerHTML = '';
//
//    // Calculate week range
//    const today = new Date();
//    const startOfWeek = new Date(today);
//    startOfWeek.setDate(today.getDate() - today.getDay() + (currentWeekOffset * 7));
//
//    // Adjust to Monday start if needed, but keeping Sunday start for consistency with backend
//    // Backend uses Mon, Tue... so we need to map correctly
//
//    const endOfWeek = new Date(startOfWeek);
//    endOfWeek.setDate(startOfWeek.getDate() + 6);
//    document.getElementById('weekRangeDisplay').textContent =
//        `${formatDate(startOfWeek)} - ${formatDate(endOfWeek)}`;
//
//    // Update week label
//    if (currentWeekOffset === 0) {
//        document.getElementById('weekLabel').textContent = 'This Week';
//    } else if (currentWeekOffset === -1) {
//        document.getElementById('weekLabel').textContent = 'Last Week';
//    } else if (currentWeekOffset === 1) {
//        document.getElementById('weekLabel').textContent = 'Next Week';
//    } else {
//        document.getElementById('weekLabel').textContent = `${currentWeekOffset} weeks ${currentWeekOffset > 0 ? 'ahead' : 'ago'}`;
//    }
//
//    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//    // Note: startOfWeek is Sunday. If we want Mon-Sun columns, we need to adjust logic.
//    // The table header is Time, Mon, Tue... Sun.
//    // So we need to map columns 1-7 to Mon-Sun.
//
//    // Generate time slots (7 AM to 10 PM)
//    for (let hour = 7; hour <= 22; hour++) {
//        const row = document.createElement('tr');
//        row.className = 'border-b border-slate-100 hover:bg-slate-50/50 transition-colors h-20';
//
//        // Time column
//        const timeCell = document.createElement('td');
//        timeCell.className = 'p-2 text-xs text-slate-400 font-medium border-r border-slate-200 align-top text-center';
//        timeCell.textContent = `${hour}:00`;
//        row.appendChild(timeCell);
//
//        // Day columns
//        days.forEach((day, index) => {
//            const cell = document.createElement('td');
//            // Add border-r to all except the last column
//            const borderClass = index < days.length - 1 ? 'border-r border-slate-100' : '';
//            cell.className = `p-1 ${borderClass} relative align-top transition-all`;
//            cell.dataset.day = day;
//            cell.dataset.hour = hour;
//
//            // Drag over handler
//            cell.ondragover = (e) => {
//                e.preventDefault();
//                cell.classList.add('bg-blue-50');
//            };
//
//            cell.ondragleave = () => {
//                cell.classList.remove('bg-blue-50');
//            };
//
//            // Drop handler
//            cell.ondrop = (e) => {
//                e.preventDefault();
//                cell.classList.remove('bg-blue-50');
//                const taskId = e.dataTransfer.getData('taskId');
//                const duration = e.dataTransfer.getData('duration');
//                if (taskId) {
//                    addTaskToSchedule(taskId, day, hour, duration);
//                }
//            };
//
//            // Render events if any
//            if (weeklySchedule[day]) {
//                const events = weeklySchedule[day].filter(e => {
//                    const startHour = parseInt(e.startTime.split(':')[0]);
//                    return startHour === hour;
//                });
//
//                events.forEach(event => {
//                    const eventDiv = document.createElement('div');
//                    eventDiv.className = 'bg-indigo-50 text-indigo-700 border border-indigo-200 p-1.5 rounded-md text-xs mb-1 font-medium cursor-pointer hover:bg-indigo-100 transition-colors truncate shadow-sm';
//                    eventDiv.textContent = event.subject;
//                    eventDiv.title = `${event.subject} (${event.startTime} - ${event.endTime})`;
//                    cell.appendChild(eventDiv);
//                });
//            }
//
//            row.appendChild(cell);
//        });
//
//        calendarGrid.appendChild(row);
//    }
//}
function renderCalendar() {
    console.log("🎨 renderCalendar() bắt đầu");
    const calendarGrid = document.getElementById('calendarGrid');
    if (!calendarGrid) {
        console.error("❌ Không tìm thấy calendarGrid");
        return;
    }
    
    calendarGrid.innerHTML = '';
    console.log("🧹 Đã xóa calendarGrid cũ");

    // Cần đảm bảo các hàm từ khoa-tasks.js đã được tải vào window
    if (!window.createScheduledEventDiv || !window.attachResizeHandlers || !window.setupEvents) {
        console.warn("LƯU Ý: Các hàm lịch nâng cao (khoa-tasks.js) chưa được tải. Hiển thị lịch cơ bản.");
    }

    // --- Logic tính toán tuần và hiển thị (Giữ nguyên) ---
    const today = new Date();
    const startOfWeek = new Date(today);
    startOfWeek.setDate(today.getDate() - today.getDay() + (currentWeekOffset * 7));

    const endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() + 6);
    document.getElementById('weekRangeDisplay').textContent =
            `${formatDate(startOfWeek)} - ${formatDate(endOfWeek)}`;

    // Cập nhật nhãn tuần (Giữ nguyên)
    if (currentWeekOffset === 0) {
        document.getElementById('weekLabel').textContent = 'This Week';
    } else if (currentWeekOffset === -1) {
        document.getElementById('weekLabel').textContent = 'Last Week';
    } else if (currentWeekOffset === 1) {
        document.getElementById('weekLabel').textContent = 'Next Week';
    } else {
        document.getElementById('weekLabel').textContent = `${Math.abs(currentWeekOffset)} weeks ${currentWeekOffset > 0 ? 'ahead' : 'ago'}`;
    }

    console.log("📅 Dữ liệu weeklySchedule trong renderCalendar:", window.weeklySchedule);

    // Thứ tự ngày trong lịch: Mon, Tue, Wed, Thu, Fri, Sat, Sun
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // ⭐️ BƯỚC MỚI: TÍNH TOÁN VỊ TRÍ VA CHẠM CHO TẤT CẢ CÁC NGÀY TRƯỚC
    const positionedWeeklyEvents = {};
    const timeToMinutes = (timeStr) => {
        console.log(`⏱️ Converting time: ${timeStr}`);
        // Xử lý cả định dạng "HH:MM:SS" và "HH:MM:SS SA/CH"
        const parts = timeStr.split(' ');
        let timePart = parts[0];
        let ampm = parts.length > 1 ? parts[1] : '';
        
        const [h, m, s] = timePart.split(':').map(Number);
        let hours = h;
        
        // Xử lý AM/PM nếu có
        if (ampm === 'CH' && hours < 12) { // CH = PM
            hours += 12;
        } else if (ampm === 'SA' && hours === 12) { // SA = AM
            hours = 0;
        }
        
        const totalMinutes = hours * 60 + m;
        console.log(`   ${timeStr} -> ${hours}:${m} -> ${totalMinutes} phút`);
        return totalMinutes;
    };
    
    days.forEach(day => {
        console.log(`🔍 Xử lý ngày ${day}:`);
        if (window.weeklySchedule && window.weeklySchedule[day] && window.weeklySchedule[day].length > 0) {
            console.log(`   Có ${window.weeklySchedule[day].length} sự kiện`);

            // Tiền xử lý để có startMinutes và endMinutes
            const dayEvents = window.weeklySchedule[day].map(e => {
                console.log(`   Processing event: ${e.subject} (${e.startTime} - ${e.endTime})`);
                const startMinutes = timeToMinutes(e.startTime);
                const endMinutes = timeToMinutes(e.endTime);
                
                const processedEvent = {
                    ...e,
                    startMinutes: startMinutes,
                    endMinutes: endMinutes
                };
                
                console.log(`     -> startMinutes: ${startMinutes}, endMinutes: ${endMinutes}`);
                return processedEvent;
            }).filter(e => {
                const isValid = e.endMinutes > e.startMinutes;
                if (!isValid) {
                    console.warn(`   ⚠️ Bỏ qua event không hợp lệ: endTime (${e.endMinutes}) <= startTime (${e.startMinutes})`);
                }
                return isValid;
            });

            console.log(`   Sau khi filter: ${dayEvents.length} sự kiện hợp lệ`);
            
            if (dayEvents.length > 0) {
                positionedWeeklyEvents[day] = calculateEventPositions(dayEvents);
                console.log(`   positionedWeeklyEvents[${day}]:`, positionedWeeklyEvents[day]);
            } else {
                console.log(`   Không có sự kiện hợp lệ cho ${day}`);
            }
        } else {
            console.log(`   Không có sự kiện cho ${day}`);
        }
    });

    console.log("📊 positionedWeeklyEvents:", positionedWeeklyEvents);

    // --- ⭐️ THAY ĐỔI QUAN TRỌNG: Mở rộng khoảng thời gian hiển thị ---
    // Thay vì 7-22h, hiển thị từ 0-23h để đảm bảo hiển thị tất cả sự kiện
    const START_DISPLAY_HOUR = 0; // ⬅️ Thay đổi từ 7 thành 0
    const END_DISPLAY_HOUR = 23;  // ⬅️ Có thể giữ 23 hoặc 24
    
    console.log(`⏰ Hiển thị lịch từ ${START_DISPLAY_HOUR}:00 đến ${END_DISPLAY_HOUR}:00`);
    
    let totalEventsCreated = 0;
    for (let hour = START_DISPLAY_HOUR; hour <= END_DISPLAY_HOUR; hour++) {
        const row = document.createElement('tr');
        row.className = 'border-b border-slate-100 hover:bg-slate-50/50 transition-colors h-20';

        // Time column
        const timeCell = document.createElement('td');
        timeCell.className = 'p-2 text-xs text-slate-400 font-medium border-r border-slate-200 align-top text-center';
        
        // Format hiển thị giờ (AM/PM)
        let displayHour = hour;
        let ampm = 'SA';
        if (hour >= 12) {
            ampm = 'CH';
            if (hour > 12) displayHour = hour - 12;
        }
        if (hour === 0) displayHour = 12;
        
        timeCell.textContent = `${displayHour}:00 ${ampm}`;
        row.appendChild(timeCell);

        // Day columns
        days.forEach((day, index) => {
            const dayIndex = index + 1; // 1 (Mon) - 7 (Sun)
            const cell = document.createElement('td');

            const borderClass = index < days.length - 1 ? 'border-r border-slate-100' : '';

            cell.className = `p-1 ${borderClass} relative align-top transition-all calendar-day-cell`;
            cell.dataset.day = day;
            cell.dataset.hour = hour;
            cell.dataset.dayIndex = dayIndex;

            // ⚠️ Gắn Drag and Drop Handlers cho ô LỊCH TRỐNG (từ Task List) (Giữ nguyên)
            cell.ondragover = (e) => {
                e.preventDefault();
                cell.classList.add('bg-blue-50');
            };
            cell.ondragleave = () => {
                cell.classList.remove('bg-blue-50');
            };
            cell.ondrop = (e) => {
                e.preventDefault();
                cell.classList.remove('bg-blue-50');
                const taskId = e.dataTransfer.getData('taskId');
                const duration = e.dataTransfer.getData('duration');
                if (taskId) {
                    addTaskToSchedule(taskId, day, hour, duration);
                }
            };

            // --- ⭐️ THAY ĐỔI QUAN TRỌNG: Sửa điều kiện filter ---
            if (positionedWeeklyEvents[day]) {
                // Lấy các sự kiện DIỄN RA TRONG giờ hiện tại, không chỉ BẮT ĐẦU trong giờ
                const eventsToRender = positionedWeeklyEvents[day].filter(e => {
                    const eventStartHour = Math.floor(e.startMinutes / 60);
                    const eventEndHour = Math.ceil(e.endMinutes / 60);
                    
                    // Sự kiện diễn ra trong giờ hiện tại nếu:
                    // 1. Bắt đầu trong giờ này, HOẶC
                    // 2. Kết thúc trong giờ này, HOẶC
                    // 3. Bắt đầu trước và kết thúc sau giờ này
                    const shouldRender = (
                        (eventStartHour === hour) || // Bắt đầu trong giờ
                        (eventEndHour === hour + 1) || // Kết thúc trong giờ tiếp theo
                        (eventStartHour < hour && eventEndHour > hour + 1) // Kéo dài qua giờ này
                    );
                    
                    if (shouldRender) {
                        console.log(`   📍 Sự kiện "${e.subject}" (${eventStartHour}:00-${eventEndHour}:00) render ở ô ${hour}:00`);
                    }
                    
                    return shouldRender;
                });

                console.log(`   📌 Ô ${day} ${hour}:00 có ${eventsToRender.length} sự kiện cần render`);

                eventsToRender.forEach(event => {
                    totalEventsCreated++;
                    console.log(`   👉 Tạo event ${totalEventsCreated}:`, {
                        subject: event.subject,
                        startTime: event.startTime,
                        endTime: event.endTime,
                        startMinutes: event.startMinutes,
                        endMinutes: event.endMinutes,
                        width: event.width,
                        left: event.left
                    });

                    if (window.createScheduledEventDiv) {
                        console.log(`   🔧 Gọi createScheduledEventDiv cho: ${event.subject}`);
                        const eventDiv = window.createScheduledEventDiv({
                            scheduleId: event.scheduleId,
                            taskId: event.taskId,
                            subject: event.subject,
                            startTime: event.startTime,
                            endTime: event.endTime,
                            dayOfWeek: day,
                            widthPercentage: event.width,
                            leftPercentage: event.left
                        });

                        console.log(`   ✅ DOM created for event: ${event.subject}`);
                        
                        // Kiểm tra element có hợp lệ không
                        if (!eventDiv || !(eventDiv instanceof HTMLElement)) {
                            console.error(`   ❌ eventDiv không hợp lệ cho event: ${event.subject}`);
                            return;
                        }

                        // Kiểm tra style
                        console.log(`   🎨 Event style:`, {
                            top: eventDiv.style.top,
                            height: eventDiv.style.height,
                            width: eventDiv.style.width,
                            left: eventDiv.style.left
                        });

                        if (window.attachResizeHandlers && window.attachDragHandlers) {
                            window.attachResizeHandlers(eventDiv);
                            window.attachDragHandlers(eventDiv);
                            console.log(`   🔗 Đã gắn handlers resize/drag`);
                        }

                        cell.appendChild(eventDiv);
                        console.log(`   ✅ Đã append vào cell`);
                    } else {
                        console.log(`   ⚠️ createScheduledEventDiv không tồn tại, dùng fallback`);
                        // Logic fallback đơn giản nếu hàm nâng cao không tồn tại
                        const eventDiv = document.createElement('div');
                        eventDiv.className = 'bg-indigo-50 text-indigo-700 border border-indigo-200 p-1.5 rounded-md text-xs mb-1 font-medium cursor-pointer hover:bg-indigo-100 transition-colors truncate shadow-sm';
                        eventDiv.textContent = event.subject;
                        eventDiv.title = `${event.subject} (${event.startTime} - ${event.endTime})`;
                        cell.appendChild(eventDiv);
                    }
                });
            }

            row.appendChild(cell);
        });

        calendarGrid.appendChild(row);
    }

    console.log(`🎯 Tổng số sự kiện được tạo: ${totalEventsCreated}`);
    
    if (totalEventsCreated === 0) {
        console.warn("⚠️ KHÔNG có sự kiện nào được tạo! Kiểm tra:");
        console.warn("   1. Dữ liệu trong window.weeklySchedule");
        console.warn("   2. Hàm timeToMinutes có chuyển đổi đúng không");
        console.warn("   3. positionedWeeklyEvents có dữ liệu không");
        console.warn("   4. Sự kiện có nằm trong khoảng hiển thị không");
        
        // Debug chi tiết hơn
        days.forEach(day => {
            if (positionedWeeklyEvents[day]) {
                console.log(`   Debug ${day}:`);
                positionedWeeklyEvents[day].forEach((event, i) => {
                    const startHour = Math.floor(event.startMinutes / 60);
                    const endHour = Math.ceil(event.endMinutes / 60);
                    console.log(`     Event ${i}: ${event.subject} (${startHour}:00 - ${endHour}:00)`);
                });
            }
        });
    }

    // ⭐️ GỌI SETUP EVENTS
    if (window.setupEvents) {
        console.log("🔗 Gọi setupEvents()");
        window.setupEvents();
    }
    
    console.log("✅ renderCalendar() kết thúc");
}
window.renderCalendar = renderCalendar;

/**
 * Add task to schedule
 */
//function addTaskToSchedule(taskId, day, startHour, duration) {
//    if (!currentCollectionId) {
//        alert('Please select a schedule first!');
//        return;
//    }
//
//    const task = allTasks.find(t => t.taskId == taskId);
//    if (!task) return;
//
//    // Calculate new deadline based on schedule slot
//    const newDeadline = getDateFromDayAndHour(day, startHour);
//
//    // Update task deadline first
//    const updatedTask = { ...task };
//    // Format for API: yyyy-MM-dd HH:mm:ss
//    updatedTask.deadline = formatDateForApi(newDeadline);
//
//    // Call update task API
//    fetch(`/user/tasks?id=${taskId}`, {
//        method: 'PUT',
//        headers: {
//            'Content-Type': 'application/json'
//        },
//        body: JSON.stringify(updatedTask)
//    })
//        .then(response => response.json())
//        .then(result => {
//            if (result.success) {
//                // Update local task list
//                task.deadline = updatedTask.deadline;
//                renderTaskList(); // Re-sort and render
//
//                // Now add to schedule
//                addToScheduleBackend(task, day, startHour, duration);
//            } else {
//                alert('Failed to update task time: ' + (result.message || result.error));
//            }
//        })
//        .catch(error => {
//            console.error('Error updating task:', error);
//            alert('Error updating task time');
//        });
//}


/**
 * Helper to add to schedule backend
 */
//function addToScheduleBackend(task, day, startHour, duration) {
//    // Calculate times
//    const start = `${startHour.toString().padStart(2, '0')}:00:00`;
//
//    // Calculate end time based on duration (default 60 mins if not set)
//    const durationMins = parseInt(duration) || 60;
//    const endDate = new Date();
//    endDate.setHours(startHour);
//    endDate.setMinutes(durationMins);
//    const endHour = endDate.getHours().toString().padStart(2, '0');
//    const endMin = endDate.getMinutes().toString().padStart(2, '0');
//    const end = `${endHour}:${endMin}:00`;
//
//    const scheduleData = {
//        collectionId: parseInt(currentCollectionId),
//        dayOfWeek: day,
//        startTime: start,
//        endTime: end,
//        subject: task.title,
//        type: 'self-study' // Default type
//    };
//
//    fetch('/user/schedule?action=add', {
//        method: 'POST',
//        headers: {
//            'Content-Type': 'application/json'
//        },
//        body: JSON.stringify(scheduleData)
//    })
//        .then(response => response.json())
//        .then(data => {
//            if (data.success) {
//                // Reload schedule to show new event
//                loadSchedule(currentCollectionId);
//            } else {
//                alert('Failed to add to schedule: ' + (data.message || 'Time conflict'));
//            }
//        })
//        .catch(error => {
//            console.error('Error adding to schedule:', error);
//            alert('Error adding to schedule');
//        });
//}
function addToScheduleBackend(scheduleData) { // Nhận scheduleData trực tiếp
    // Tính toán thời gian (đã được xử lý ở hàm gọi)

    return fetch('/user/schedule?action=add', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(scheduleData)
    })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Trả về dữ liệu cần thiết cho hàm gọi (scheduleId)
                    return {success: true, scheduleId: data.scheduleId, message: 'Schedule added'};
                } else {
                    return {success: false, message: data.message || 'Time conflict'};
                }
            })
            .catch(error => {
                console.error('Error adding to schedule:', error);
                return {success: false, message: 'Network error'};
            });
}
window.addToScheduleBackend = addToScheduleBackend;

/**
 * Get Date object from Day Name and Hour
 */
function getDateFromDayAndHour(dayName, hour) {
    const today = new Date();
    const currentDayIndex = today.getDay(); // 0 (Sun) - 6 (Sat)

    // Map day name to index (Mon=1, ... Sun=0/7)
    const dayMap = {'Mon': 1, 'Tue': 2, 'Wed': 3, 'Thu': 4, 'Fri': 5, 'Sat': 6, 'Sun': 0};


// ⭐️ BỔ SUNG: ĐẢM BẢO dayName là chuỗi trước khi sử dụng
// ⭐️ SỬA LỖI QUAN TRỌNG: ĐẢM BẢO dayName là chuỗi và hour là số.
    let dayNameStr = String(dayName);
    let hourNum = parseInt(hour); // Chắc chắn là số

    // Kiểm tra đầu vào
    if (!dayNameStr || dayMap[dayNameStr] === undefined || isNaN(hourNum)) {
        console.error("Lỗi đầu vào getDateFromDayAndHour:", {dayName: dayName, hour: hour});
        return new Date('Invalid'); // Trả về Invalid Date
    }

    let targetDayIndex = dayMap[dayNameStr];


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
    if (!date || isNaN(date.getTime())) {
        console.error("❌ Invalid date in formatDateForApi:", date);
        return null;
    }
    
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    
    const formatted = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    console.log("📅 Formatted deadline for API:", formatted);
    return formatted;
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
    return date.toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
}

/**
 * Format date
 */
function formatDate(date) {
    return date.toLocaleDateString('en-US', {month: 'short', day: 'numeric'});
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

//Sửa hàm này để nó có thể phân biệt giữa việc Lưu Task thường, Cập nhật Task, và Lưu Task từ Lịch
function setupFormHandler() {
    const form = document.getElementById('taskForm');
    form.onsubmit = async (e) => {
        e.preventDefault();

        const taskData = {
            title: document.getElementById('taskTitle').value,
            description: document.getElementById('taskDescription').value,
            priority: document.getElementById('taskPriority').value,
            status: document.getElementById('taskStatus').value,
            // Sử dụng giá trị từ input datetime-local
            deadline: document.getElementById('taskDeadline').value ? formatDateForApi(new Date(document.getElementById('taskDeadline').value)) : null,
            duration: parseInt(document.getElementById('taskDuration').value)
        };

        try {
            if (tempScheduledEvent) {
                // ⭐️ TRƯỜNG HỢP 1: LƯU TÁC VỤ MỚI VÀ LÊN LỊCH
                await handleScheduleTaskSubmission(taskData);
            } else if (editingTaskId) {
                // TRƯỜNG HỢP 2: CẬP NHẬT TÁC VỤ CÓ SẴN
                await updateTask(editingTaskId, taskData);
                hideTaskForm();
                loadTasks();
            } else {
                // TRƯỜNG HỢP 3: TẠO TÁC VỤ THÔNG THƯỜNG
                await createTask(taskData);
                hideTaskForm();
                loadTasks();
            }
        } catch (error) {
            console.error('Error saving task:', error);
            alert('Failed to save task. Please try again.');
        }
    };
}


// ⭐️ HÀM MỚI: Xử lý lưu Task và Schedule sau khi submit Form
async function handleScheduleTaskSubmission(taskData) {
    if (!currentCollectionId) {
        alert('Please select a schedule collection first!');
        if (tempScheduledEvent && tempScheduledEvent.element) tempScheduledEvent.element.remove();
        return;
    }

    try {
        // --- BƯỚC 1: LẤY THỜI GIAN THỰC TẾ TỪ VỊ TRÍ ELEMENT TRÊN LỊCH ---
        const eventEl = tempScheduledEvent.element;
        const topPx = parseFloat(eventEl.style.top);
        const heightPx = parseFloat(eventEl.style.height);

        // Chuyển đổi Pixel sang Phút (Ví dụ: 7h sáng + số phút offset)
        const startMinsTotal = (START_HOUR * 60) + Math.round(topPx / PIXELS_PER_MINUTE);
        const durationMins = Math.round(heightPx / PIXELS_PER_MINUTE);
        const endMinsTotal = startMinsTotal + durationMins;

        // Chuyển sang định dạng chuỗi chuẩn để lưu Backend (HH:mm:ss)
        const newStartTime = window.formatMinutesToHHMMSS(startMinsTotal);
        const newEndTime = window.formatMinutesToHHMMSS(endMinsTotal);

        // --- BƯỚC 2: KIỂM TRA VA CHẠM LẦN CUỐI TRƯỚC KHI GỬI SERVER ---
        // Sử dụng hàm checkCollision bạn đã viết
        const day = tempScheduledEvent.day;
        // Lưu ý: Nếu checkCollision yêu cầu định dạng "SA/CH", hãy đảm bảo formatMinutesToHHMMSS trả về đúng
        if (window.checkCollision(day, newStartTime, newEndTime, null)) {
            alert("Không thể lưu: Vị trí này đã bị trùng với lịch khác!");
            return; 
        }
        
        console.log("🎯 Bước 1: Bắt đầu lưu task và schedule");
        console.log("Day:", day, "Start:", newStartTime, "End:", newEndTime);

        // --- BƯỚC 3: TẠO TASK VÀ LƯU SCHEDULE ---
        const createTaskResult = await createTask(taskData);
        const newTaskId = createTaskResult.taskId;
        console.log("✅ Task created, ID:", newTaskId);

        if (newTaskId) {
            const scheduleData = {
                collectionId: parseInt(currentCollectionId),
                dayOfWeek: day,
                startTime: newStartTime,
                endTime: newEndTime,
                subject: taskData.title,
                taskId: newTaskId,
                type: 'self-study'
            };
            
            console.log("📤 Sending schedule data:", scheduleData);
            const addScheduleResult = await window.addToScheduleBackend(scheduleData);

            console.log("📥 Schedule add result:", addScheduleResult);

            if (addScheduleResult.success) {
                // --- BƯỚC 4: CẬP NHẬT BIẾN TOÀN CỤC VÀ VẼ LẠI ---
                if (!window.weeklySchedule) window.weeklySchedule = {};
                if (!window.weeklySchedule[day]) window.weeklySchedule[day] = [];

                const newTaskEntry = {
                    scheduleId: addScheduleResult.scheduleId,
                    taskId: newTaskId,
                    subject: taskData.title,
                    startTime: newStartTime,
                    endTime: newEndTime,
                    dayOfWeek: day,
                    startMinutes: startMinsTotal, // Quan trọng để renderCalendar tính vị trí
                    endMinutes: endMinsTotal
                };

                window.weeklySchedule[day].push(newTaskEntry);

                // Xóa khung tạm màu xanh
                if (tempScheduledEvent.element) {
                    tempScheduledEvent.element.remove();
                    console.log("🗑️ Temp event removed");
                }


                console.log("🔄 Gọi loadSchedule để tải dữ liệu mới từ server...");
                await loadSchedule(currentCollectionId);
                console.log("✅ loadSchedule completed");
                
                                // Kiểm tra dữ liệu sau khi tải
                console.log("📊 window.weeklySchedule sau khi load:", window.weeklySchedule);
                console.log("📊 Dữ liệu cho ngày", day, ":", window.weeklySchedule[day]);
                
                // Reset biến tạm TRƯỚC KHI gọi hideTaskForm
                tempScheduledEvent = null;

                loadTasks();
                
                 // Ẩn form
                hideTaskForm();  // Hàm này sẽ thấy tempScheduledEvent = null nên không xóa gì cả
                console.log("🎉 Quá trình hoàn tất");
            } else {
                console.error("❌ Lỗi khi thêm schedule:", addScheduleResult.message);
                alert('Lỗi: ' + (addScheduleResult.message || 'Trùng lịch trên server'));
                tempScheduledEvent = null;
                hideTaskForm();
            }
        }
    } catch (error) {
        console.error('Error saving:', error);
        alert('Lỗi hệ thống: ' + error.message);
        tempScheduledEvent = null;
        hideTaskForm();
    }
}
window.handleScheduleTaskSubmission = handleScheduleTaskSubmission;


// ⭐️ HÀM MỚI: Mở Modal từ sự kiện lịch (Được gọi bởi khoa-tasks.js)
window.openTaskDetailModalFromSchedule = function (eventElement, dayOfWeek, startTime, endTime, duration) {
    if (!currentCollectionId) {
        alert('Please select a schedule collection first!');
        eventElement.remove();
        return;
    }

    // ⭐️ THÊM: Set flag để biết đang tạo task từ lịch
    window.isCreatingFromSchedule = true;
    
    window.tempScheduledEvent = {
        element: eventElement,
        day: dayOfWeek,
        start: startTime,
        end: endTime,
        duration: duration,
        taskId: null
    };

    const [startHour, startMinute] = startTime.split(':').map(Number);
    const calculatedDate = getDateFromDayAndHour(dayOfWeek, startHour);
    calculatedDate.setMinutes(startMinute);

    const formattedDeadline = formatForInput(calculatedDate);

    showTaskForm();
    document.getElementById('formTitle').textContent = 'New Scheduled Task';
    document.getElementById('taskDeadline').value = formattedDeadline;
    document.getElementById('taskDuration').value = duration;
};


// ⭐️ HÀM MỚI: Xử lý Hủy Tạo Sự kiện từ Lịch (Được gọi bởi khoa-tasks.js hoặc nút Cancel)
window.cancelScheduleCreation = function () {
    if (tempScheduledEvent && tempScheduledEvent.element) {
        tempScheduledEvent.element.remove();
    }
    tempScheduledEvent = null;
    hideTaskForm(); // Sẽ reset tempScheduledEvent = null
};


// ⭐️ HÀM MỚI: Gửi API cập nhật lịch sau khi kéo thả/resize (Được gọi bởi khoa-tasks.js)
window.updateScheduleTimeBackend = async function (scheduleId, dayOfWeek, startTime, endTime) {
    if (!currentCollectionId)
        return;

    const updateData = {
        scheduleId: scheduleId,
        collectionId: parseInt(currentCollectionId),
        dayOfWeek: dayOfWeek,
        startTime: startTime,
        endTime: endTime
    };

    try {
        const response = await fetch('/user/schedule?action=update', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(updateData)
        });

        const result = await response.json();
        if (!result.success) {
            console.error('Failed to update schedule time:', result.error);
            alert('Failed to update schedule time. Please refresh.');
        }
        loadSchedule(currentCollectionId); // Tải lại lịch để đồng bộ
    } catch (error) {
        console.error('Error updating schedule:', error);
    }
}

/**
 * Cập nhật form task với duration và deadline mới
 */
window.updateTaskFormDuration = function (duration, startTime, dayOfWeek) {
    // 1. Cập nhật Duration (input number)
    const durationInput = document.getElementById('taskDuration');
    if (durationInput) {
        durationInput.value = duration;
    }

    // 2. Cập nhật Deadline (input datetime-local)
    // ⚠️ PHẢI ĐẢM BẢO startTimeRaw KHÔNG BỊ UNDEFINED
    const parts = startTime.split(':');
    const startHour = parseInt(parts[0]);
    const startMinute = parseInt(parts[1]);

    if (isNaN(startHour) || isNaN(startMinute)) {
        console.error("Lỗi phân tích cú pháp thời gian trong updateTaskFormDuration:", startTime);
        return;
    }

    const calculatedDate = getDateFromDayAndHour(dayOfWeek, startHour);
    calculatedDate.setMinutes(startMinute); // Đặt phút sau khi tính ngày

    // ⭐️ BỔ SUNG KIỂM TRA: Nếu ngày không hợp lệ, KHÔNG gán giá trị
    if (isNaN(calculatedDate.getTime())) {
        console.error("Ngày tính toán không hợp lệ sau khi resize/move.");
        return;
    }

    const deadlineInput = document.getElementById('taskDeadline');
    if (deadlineInput) {
        // formatForInput phải đảm bảo đầu ra là yyyy-MM-ddThh:mm
        deadlineInput.value = formatForInput(calculatedDate);
    }
}

//hàm dùng để Debug
function debugScheduleData() {
    if (!window.weeklySchedule) {
        console.warn("❌ window.weeklySchedule không tồn tại");
        return;
    }
    
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    days.forEach(day => {
        if (window.weeklySchedule[day] && window.weeklySchedule[day].length > 0) {
            console.log(`📋 ${day}:`, window.weeklySchedule[day]);
            window.weeklySchedule[day].forEach((event, i) => {
                console.log(`   Event ${i}:`, {
                    scheduleId: event.scheduleId,
                    taskId: event.taskId,
                    subject: event.subject,
                    startTime: event.startTime,
                    endTime: event.endTime,
                    hasStartMinutes: 'startMinutes' in event,
                    hasEndMinutes: 'endMinutes' in event
                });
            });
        }
    });
}

