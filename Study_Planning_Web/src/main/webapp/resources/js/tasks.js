// Task Management JavaScript

let allTasks = [];
let currentFilter = 'all';
let currentWeekOffset = 0;
let editingTaskId = null;
let currentCollectionId = null;
let weeklySchedule = {};
let isScheduleLoaded = false;
let isSubmitting = false;

// Thêm ở đầu file tasks.js
const STORAGE_KEY = 'selectedCollectionId';

// Hàm lưu collectionId
function saveSelectedCollectionId(collectionId) {
    if (collectionId) {
        sessionStorage.setItem(STORAGE_KEY, collectionId);
        console.log("💾 Saved collectionId to sessionStorage:", collectionId);
    }
}

// Hàm lấy collectionId
function loadSelectedCollectionId() {
    const savedId = sessionStorage.getItem(STORAGE_KEY);
    if (savedId) {
        currentCollectionId = savedId;
        console.log("📂 Loaded collectionId from sessionStorage:", savedId);
    }
    return savedId;
}

//khoa
// ⭐️ BIẾN MỚI: Theo dõi sự kiện lịch tạm thời (được tạo bằng click)
// ⭐️ ĐẢM BẢO LÀ GLOBAL
window.tempScheduledEvent = null;

//khoa
// ⭐️ THÊM HÀM CHUẨN HÓA THỜI GIAN
function normalizeTimeTo12Hour(timeStr) {
    if (!timeStr) return '';
    
    console.log(`🔄 normalizeTimeTo12Hour: "${timeStr}"`);
    
    // Nếu đã là format 12h với SA/CH, giữ nguyên
    if (timeStr.includes(' SA') || timeStr.includes(' CH')) {
        // Đảm bảo định dạng đúng HH:MM:SS
        const parts = timeStr.split(' ');
        const timePart = parts[0];
        const ampm = parts[1];
        
        // Đảm bảo timePart có đủ HH:MM:SS
        const timeParts = timePart.split(':');
        if (timeParts.length === 2) {
            // Chỉ có HH:MM, thêm :00
            return `${timeParts[0]}:${timeParts[1]}:00 ${ampm}`;
        }
        return timeStr;
    }
    
    // Nếu là 24h format, chuyển sang 12h
    const [h, m, s] = timeStr.split(':').map(Number);
    let hours = h || 0;
    const minutes = m || 0;
    const seconds = s || 0;
    
    let ampm = 'SA';
    let displayHours = hours;
    
    if (hours === 0) {
        displayHours = 12;
        ampm = 'SA';
    } else if (hours < 12) {
        displayHours = hours;
        ampm = 'SA';
    } else if (hours === 12) {
        displayHours = 12;
        ampm = 'CH';
    } else {
        displayHours = hours - 12;
        ampm = 'CH';
    }
    
    const result = `${displayHours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')} ${ampm}`;
    console.log(`   Normalized: ${result}`);
    return result;
}

// ⭐️ SỬA LẠI HÀM formatMinutesToHHMMSS ĐỂ LUÔN TRẢ VỀ ĐÚNG ĐỊNH DẠNG
function formatMinutesToHHMMSS(minutes) {
    if (minutes < 0) minutes = 0;
    if (minutes >= 24 * 60) minutes = 23 * 60 + 59;

    let hours = Math.floor(minutes / 60);
    let mins = minutes % 60;
    let secs = 0;
    
    console.log(`🕐 formatMinutesToHHMMSS: ${minutes} min = ${hours}:${mins}`);
    
    // LUÔN trả về format 24h, để normalizeTimeTo12Hour xử lý sau
    const time24h = `${hours.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
    
    // Chuẩn hóa sang 12h
    const normalized = normalizeTimeTo12Hour(time24h);
    
    console.log(`   Result: ${normalized}`);
    return normalized;
}
window.formatMinutesToHHMMSS = formatMinutesToHHMMSS;



// Khởi tạo cấu trúc rỗng để tránh lỗi 'undefined'
window.weeklySchedule = window.weeklySchedule || {
    'Mon': [], 'Tue': [], 'Wed': [], 'Thu': [], 'Fri': [], 'Sat': [], 'Sun': []
};

/**
 * Load all tasks from server
 */
function loadTasks() {
    console.log("🔍 loadTasks() được gọi");
    
    fetch('/user/tasks?action=list')
        .then(response => response.json())
        .then(tasks => {
            console.log(`📥 Tải được ${tasks.length} tasks từ server:`, tasks);
            
            // Log từng task để debug
            tasks.forEach((task, index) => {
                console.log(`  Task ${index + 1}: ID=${task.taskId}, Title="${task.title}"`);
            });
            
            // ⭐️ Kiểm tra trùng lặp ngay từ đầu
            const uniqueTasks = [];
            const seenIds = new Set();
            const duplicateIds = [];
            
            tasks.forEach(task => {
                if (seenIds.has(task.taskId)) {
                    duplicateIds.push(task.taskId);
                } else {
                    seenIds.add(task.taskId);
                    uniqueTasks.push(task);
                }
            });
            
            if (duplicateIds.length > 0) {
                console.warn(`⚠️ Server trả về task trùng lặp: ${duplicateIds.join(', ')}`);
            }
            
            allTasks = uniqueTasks;
            console.log(`✅ Đã lọc xuống ${allTasks.length} task duy nhất`);
            
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
    console.log("📂 loadScheduleCollections called, currentCollectionId:", currentCollectionId);
    
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

                if (currentCollectionId) {
                    select.value = currentCollectionId;
                    console.log("✅ Set select to existing collectionId:", currentCollectionId);
                } else {
                    console.log("ℹ️ No currentCollectionId, keeping select empty");
                }
                
                // ⭐️ QUAN TRỌNG: Load schedule chỉ khi đã có collectionId
                if (currentCollectionId) {
                    loadSchedule(currentCollectionId);
                }
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
    
    // ⭐️ LƯU collectionId đã chọn
    saveSelectedCollectionId(currentCollectionId);
    
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
function timeToMinutes(timeStr) {
    if (!timeStr) {
        console.warn(`⚠️ timeStr là undefined hoặc null`);
        return 0;
    }

    console.log(`⏱️ timeToMinutes INPUT: "${timeStr}"`);

    // Tách phần thời gian và AM/PM
    const parts = timeStr.trim().split(' ');
    let timePart = parts[0];
    let ampm = parts.length > 1 ? parts[1].toUpperCase() : '';

    // Parse giờ và phút
    const [h, m, s] = timePart.split(':').map(Number);
    let hours = h || 0;
    const minutes = m || 0;

    console.log(`⏱️ Parsed: hours=${hours}, minutes=${minutes}, ampm="${ampm}"`);

    // ⭐️ SỬA QUAN TRỌNG: Xử lý AM/PM đơn giản
    if (ampm === 'CH' || ampm === 'PM') {
        // CH = PM (chiều)
        // 12:xx CH = 12:xx (giữ nguyên)
        // 1:xx CH đến 11:xx CH = +12 giờ
        if (hours < 12) {
            hours += 12;
        }
    } else if (ampm === 'SA' || ampm === 'AM') {
        // SA = AM (sáng)
        // 12:xx SA = 0:xx
        // 1:xx SA đến 11:xx SA = giữ nguyên
        if (hours === 12) {
            hours = 0;
        }
    }

    // ⭐️ LOẠI BỎ: Không điều chỉnh timezone ở client
    // const timezoneOffset = 7; // ⚠️ BỎ DÒNG NÀY
    // hours = (hours - timezoneOffset + 24) % 24; // ⚠️ BỎ DÒNG NÀY

    const totalMinutes = hours * 60 + minutes;
    console.log(`⏱️ OUTPUT: "${timeStr}" -> ${hours}:${minutes} -> ${totalMinutes} phút`);

    return totalMinutes;

}

window.timeToMinutes = timeToMinutes;

// ⭐️ HÀM MỚI: Parse thời gian một cách thống nhất
function parseTime(timeStr) {
    if (!timeStr)
        return {hours: 0, minutes: 0, ampm: ''};

    // Chuẩn hóa input
    timeStr = timeStr.trim().toUpperCase();

    // Tách phần thời gian và AM/PM
    const parts = timeStr.split(' ');
    let timePart = parts[0];
    let ampm = parts.length > 1 ? parts[1] : '';

    // Chuyển đổi viết tắt tiếng Việt
    if (ampm === 'SA')
        ampm = 'AM';
    if (ampm === 'CH')
        ampm = 'PM';

    // Parse giờ và phút
    const [h, m] = timePart.split(':').map(Number);
    let hours = h || 0;
    const minutes = m || 0;

    // Đảm bảo AM/PM hợp lệ
    if (!['AM', 'PM', ''].includes(ampm)) {
        // Nếu không có AM/PM, kiểm tra xem có phải 24h format
        if (hours < 12 && timeStr.includes('SA'))
            ampm = 'AM';
        else if (hours < 12 && timeStr.includes('CH'))
            ampm = 'PM';
        else if (hours >= 12 && hours <= 23)
            ampm = 'PM';
        else
            ampm = 'AM';
    }

    return {hours, minutes, ampm};
}


async function loadSchedule(collectionId) {
    if (!collectionId) {
        isScheduleLoaded = true;
        return Promise.resolve();
    }

    // ⭐️ SỬA: Reset trạng thái loading
    isScheduleLoaded = false;
    console.log("🔄 loadSchedule đang tải collectionId:", collectionId);

    try {
        const response = await fetch(`/user/schedule?action=weekly&collectionId=${collectionId}`);
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }
        
        const data = await response.json();
        console.log("📥 Dữ liệu schedule từ server:", data);
        console.log(JSON.stringify(data, null, 2));

        // Debug chi tiết từng event
        console.log("\n🔍 Chi tiết từng event:");
        Object.keys(data).forEach(day => {
            if (Array.isArray(data[day])) {
                data[day].forEach((event, i) => {
                    console.log(`${day}[${i}]:`, {
                        scheduleId: event.scheduleId,
                        taskId: event.taskId,
                        subject: event.subject,
                        startTime: event.startTime,
                        endTime: event.endTime,
                        type: event.type
                    });
                });
            }
        });

        // Đảm bảo dữ liệu có cấu trúc đúng
        if (data && typeof data === 'object') {
            // KHỞI TẠO LẠI CẤU TRÚC weeklySchedule
            window.weeklySchedule = {
                'Mon': [], 'Tue': [], 'Wed': [], 'Thu': [], 'Fri': [], 'Sat': [], 'Sun': []
            };

            // Cập nhật dữ liệu mới từ server
            Object.keys(data).forEach(day => {
                if (window.weeklySchedule.hasOwnProperty(day)) {
                    // Sao chép mảng events từ server
                    window.weeklySchedule[day] = Array.isArray(data[day])
                            ? [...data[day]]
                            : [];
                }
            });

            console.log("✅ Dữ liệu schedule sau khi xử lý:");
            console.log(window.weeklySchedule);
        }

        debugScheduleData();

        // ⭐️ SỬA QUAN TRỌNG: Đảm bảo renderCalendar() chỉ gọi khi có dữ liệu
        if (window.weeklySchedule && Object.keys(window.weeklySchedule).length > 0) {
            console.log("🔄 Gọi renderCalendar từ loadSchedule với dữ liệu mới");
            renderCalendar();
        } else {
            console.warn("⚠️ Không có dữ liệu schedule để render");
            renderCalendar(); // Vẫn render nhưng sẽ hiển thị lịch trống
        }

    } catch (error) {
        console.error('Error loading schedule:', error);
        // KHỞI TẠO LẠI KHI CÓ LỖI
        window.weeklySchedule = {
            'Mon': [], 'Tue': [], 'Wed': [], 'Thu': [], 'Fri': [], 'Sat': [], 'Sun': []
        };
        renderCalendar(); // Render với schedule rỗng
    } finally {
        isScheduleLoaded = true;
        console.info("✅ Dữ liệu Lịch đã hoàn thành tải. isScheduleLoaded = true.");
    }
}

/**
 * Render task list
 */
function renderTaskList() {
    console.log("🔄 renderTaskList được gọi - Stack trace:");
    console.trace(); // Hiển thị nơi gọi hàm này
    
    const taskList = document.getElementById('taskList');
    console.log(`📊 Số task hiện tại: ${allTasks.length}`);

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
//function setupFormHandler() {
//    const form = document.getElementById('taskForm');
//    form.onsubmit = async (e) => {
//        e.preventDefault();
//
//        const taskData = {
//            title: document.getElementById('taskTitle').value,
//            description: document.getElementById('taskDescription').value,
//            priority: document.getElementById('taskPriority').value,
//            status: document.getElementById('taskStatus').value,
//            deadline: document.getElementById('taskDeadline').value ? formatDateForApi(new Date(document.getElementById('taskDeadline').value)) : null,
//            duration: parseInt(document.getElementById('taskDuration').value)
//        };
//
//        console.log("📝 Form submitted with data:", taskData);
//        console.log("📝 tempScheduledEvent exists?", !!tempScheduledEvent);
//        console.log("📝 editingTaskId:", editingTaskId);
//
//        try {
//            if (tempScheduledEvent) {
//                // ⭐️ TRƯỜNG HỢP 1: LƯU TÁC VỤ MỚI VÀ LÊN LỊCH
//                console.log("🔄 Calling handleScheduleTaskSubmission...");
//                await handleScheduleTaskSubmission(taskData);
//            } else if (editingTaskId) {
//                // TRƯỜNG HỢP 2: CẬP NHẬT TÁC VỤ CÓ SẴN
//                console.log("🔄 Calling updateTask...");
//                await updateTask(editingTaskId, taskData);
//                hideTaskForm();
//                loadTasks();
//            } else {
//                // TRƯỜNG HỢP 3: TẠO TÁC VỤ THÔNG THƯỜNG
//                console.log("🔄 Calling createTask (normal)...");
//                await createTask(taskData);
//                hideTaskForm();
//                loadTasks();
//            }
//        } catch (error) {
//            console.error('Error saving task:', error);
//            alert('Failed to save task. Please try again.');
//        }
//    };
//}
// ⭐️ HÀM MỚI: Kiểm tra task đã tồn tại
function checkTaskExists(title, deadline) {
    return allTasks.some(task => {
        const isSameTitle = task.title.toLowerCase() === title.toLowerCase();
        const isSameDeadline = task.deadline === deadline;
        
        if (isSameTitle && isSameDeadline) {
            console.log(`⚠️ Phát hiện task trùng: ${task.taskId} - "${task.title}" - ${task.deadline}`);
            return true;
        }
        return false;
    });
    }
/**
 * Create new task
 */
async function createTask(taskData) {
    console.log("🚀 [createTask] Bắt đầu gửi task data...");
    console.log("📤 [createTask] Data:", taskData);

    // ⭐️ KIỂM TRA DUPLICATE TRƯỚC KHI GỬI
    const existingTask = allTasks.find(task => 
        task.title === taskData.title && 
        task.deadline === taskData.deadline
    );
    
    if (existingTask) {
        console.warn("⚠️ Task đã tồn tại, trả về task có sẵn");
        return {
            success: true,
            taskId: existingTask.taskId,
            message: "Task already exists"
        };
    }

    try {
        const response = await fetch('/user/tasks', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(taskData)
        });

        console.log("📥 [createTask] Response status:", response.status);

        const result = await response.json();
        console.log("📥 [createTask] Response data:", result);

        if (!result.success) {
            console.error("❌ [createTask] Server error:", result.error || result.message);
            throw new Error(result.error || 'Failed to create task');
        }

        console.log("✅ [createTask] Task created successfully, taskId:", result.taskId);
        return result;

    } catch (error) {
        console.error("❌ [createTask] Network/parsing error:", error);
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
function setupFormHandler() {
    const form = document.getElementById('taskForm');

    if (!form) {
        console.error("❌ Form not found!");
        return;
    }

    form.onsubmit = async (e) => {
        e.preventDefault();
        
        // ⭐️ CHỐNG DOUBLE SUBMIT
        if (isSubmitting) {
            console.log("⏸️ Form đang được xử lý, bỏ qua...");
            return;
        }
        
        isSubmitting = true;
        
        try {
            console.log("📤 FORM SUBMITTED!");
            
            const taskData = {
                title: document.getElementById('taskTitle').value,
                description: document.getElementById('taskDescription').value,
                priority: document.getElementById('taskPriority').value,
                status: document.getElementById('taskStatus').value,
                deadline: document.getElementById('taskDeadline').value ? formatDateForApi(new Date(document.getElementById('taskDeadline').value)) : null,
                duration: parseInt(document.getElementById('taskDuration').value)
            };

            console.log("📊 Form data:", taskData);

            // ⭐️ SỬA: Kiểm tra cả window.tempScheduledEvent
            const scheduleEvent = tempScheduledEvent || window.tempScheduledEvent;

            if (scheduleEvent) {
                console.log("🔄 CASE 1: Schedule creation detected");
                await handleScheduleTaskSubmission(taskData);
            } else if (editingTaskId) {
                console.log("🔄 CASE 2: Editing existing task");
                await updateTask(editingTaskId, taskData);
                hideTaskForm();
                loadTasks();
            } else {
                console.log("🔄 CASE 3: Normal task creation");
                await createTask(taskData);
                hideTaskForm();
                loadTasks();
            }
        } catch (error) {
            console.error('❌ Error saving task:', error);
            alert('Failed to save task: ' + error.message);
        } finally {
            // ⭐️ ĐẢM BẢO MỞ KHÓA
            setTimeout(() => {
                isSubmitting = false;
            }, 1000);
        }
    };
}

/**
 * Hide task form
 */

function hideTaskForm() {
    console.log("-----------------------------------------");
    console.log("1. HÀM hideTaskForm ĐƯỢC GỌI.");

    // ⭐️ THÊM: Biến theo dõi để tránh gọi render nhiều lần
    let shouldRenderTaskList = true;
    let shouldReloadSchedule = false;

    // ⭐️ LOGIC KIỂM TRA VÀ XÓA SỰ KIỆN TẠM THỜI
    if (window.tempScheduledEvent) {
        console.log("2. Biến window.tempScheduledEvent TỒN TẠI.");

        if (window.tempScheduledEvent.element) {
            // Kiểm tra xem element có còn nằm trong DOM không
            const element = window.tempScheduledEvent.element;
            const isElementInDOM = document.body.contains(element);

            console.log("3. Element đã được lưu. Type:", element.tagName);
            console.log("4. Element có còn trong DOM không?", isElementInDOM);

            // Chỉ xóa nếu element còn trong DOM
            if (isElementInDOM) {
                element.remove();
                console.log("5. Đã gọi element.remove().");
            } else {
                console.log("5. Element không còn trong DOM, bỏ qua remove().");
            }

            // Đặt lại biến
            window.tempScheduledEvent = null;
            console.log("6. window.tempScheduledEvent đã được reset thành NULL.");
        } else {
            console.log("3. LỖI: Thuộc tính .element trong tempScheduledEvent là NULL/UNDEFINED.");
        }
    } else {
        console.log("2. window.tempScheduledEvent là NULL. Không có lịch trình tạm thời nào để xóa.");
    }

    // --- Logic Ẩn Form ---
    const formContainer = document.getElementById('taskFormContainer');
    const addBtn = document.getElementById('addTaskBtn');

    if (formContainer) {
        formContainer.classList.add('hidden');
        console.log("7. Form đã bị ẩn.");
    }

    if (addBtn) {
        addBtn.classList.remove('hidden');
    }

    // Reset form
    const taskForm = document.getElementById('taskForm');
    if (taskForm) {
        taskForm.reset();
        editingTaskId = null;
        
        const submitBtnText = document.getElementById('submitBtnText');
        if (submitBtnText) {
            submitBtnText.textContent = 'Save Task';
        }
        
        const taskIdInput = document.getElementById('taskId');
        if (taskIdInput) {
            taskIdInput.value = '';
        }
    }

    // ⭐️ SỬA QUAN TRỌNG: Logic quyết định khi nào gọi renderTaskList
    if (window.isProcessingSchedule) {
        console.log("⏸️  Đang xử lý schedule, bỏ qua renderTaskList trong hideTaskForm");
        window.isProcessingSchedule = false;
        shouldRenderTaskList = false;
    }

    // ⭐️ SỬA: Kiểm tra trạng thái tạo từ lịch
    if (window.isCreatingFromSchedule) {
        console.log("🔄 Đang ở chế độ tạo từ lịch");
        shouldReloadSchedule = true;
        shouldRenderTaskList = false; // ⭐️ QUAN TRỌNG: Không gọi renderTaskList ở đây
        window.isCreatingFromSchedule = false;
    }

    // ⭐️ SỬA: Gọi renderTaskList() TRƯỚC KHI loadSchedule() (nếu cần)
    if (shouldRenderTaskList) {
        console.log("8. Gọi renderTaskList()...");
        renderTaskList();
    } else {
        console.log("8. Bỏ qua renderTaskList() trong hideTaskForm");
    }

    // ⭐️ SỬA: Reload schedule (nếu cần) - sẽ gọi renderCalendar() bên trong
    if (shouldReloadSchedule && currentCollectionId) {
        console.log("🔄 Auto-reloading schedule after task creation...");
        
        // ⭐️ THÊM: Sử dụng Promise để đảm bảo thứ tự thực hiện
        setTimeout(() => {
            loadSchedule(currentCollectionId).then(() => {
                console.log("✅ Schedule reloaded successfully");
            }).catch(error => {
                console.error("❌ Error reloading schedule:", error);
            });
        }, 100); // Delay nhỏ để đảm bảo các xử lý khác hoàn thành
    }

    // ⭐️ THÊM: Reset lại các biến trạng thái
    if (window.tempScheduledEvent) {
        window.tempScheduledEvent = null;
    }
    
    if (tempScheduledEvent) {
        tempScheduledEvent = null;
    }

    console.log("✅ hideTaskForm() hoàn thành");
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
    if (!confirm('Bạn có chắc muốn xóa task này?')) {
        return;
    }

    try {
        console.log(`🗑️ Bắt đầu xóa task ${taskId}...`);
        
        // 1. Kiểm tra task có tồn tại trong danh sách không
        const task = allTasks.find(t => t.taskId == taskId);
        if (!task) {
            alert('Không tìm thấy task để xóa');
            return;
        }
        
        // 2. Kiểm tra task có trong schedule hiện tại không
        let isInCurrentSchedule = false;
        if (window.weeklySchedule && currentCollectionId) {
            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            for (const day of days) {
                const event = window.weeklySchedule[day]?.find(e => e.taskId == taskId);
                if (event) {
                    isInCurrentSchedule = true;
                    console.log(`📅 Task có trong schedule: ${day} ${event.startTime}-${event.endTime}`);
                    break;
                }
            }
        }
        
        // 3. Gọi API xóa task
        const response = await fetch(`/user/tasks?id=${taskId}`, {
            method: 'DELETE'
        });

        const result = await response.json();

        if (result.success) {
            console.log("✅ Task đã được xóa khỏi database");
            
            // 4. Cập nhật UI ngay lập tức (không chờ reload)
            
            // 4a. Xóa task khỏi danh sách local
            const index = allTasks.findIndex(t => t.taskId == taskId);
            if (index > -1) {
                allTasks.splice(index, 1);
            }
            
            // 4b. Render lại danh sách task
            renderTaskList();
            
            // 4c. Nếu task có trong schedule, load lại schedule
            if (isInCurrentSchedule && currentCollectionId) {
                console.log("🔄 Đang load lại schedule...");
                
                // Load lại schedule với độ trễ nhỏ để đảm bảo dữ liệu đồng bộ
                setTimeout(async () => {
                    try {
                        await loadSchedule(currentCollectionId);
                        console.log("✅ Schedule đã được cập nhật sau khi xóa task");
                    } catch (scheduleError) {
                        console.error("Lỗi khi load schedule:", scheduleError);
                    }
                }, 300);
            }
            
            // 4d. Hiển thị thông báo thành công
            showNotification(`Đã xóa task "${task.title}" thành công`, 'success');
            
        } else {
            alert('Không thể xóa task: ' + (result.error || result.message));
        }
    } catch (error) {
        console.error('Lỗi khi xóa task:', error);
        alert('Lỗi khi xóa task. Vui lòng thử lại.');
    }
}

/**
 * ⭐️ HÀM MỚI: Hiển thị thông báo
 */
function showNotification(message, type = 'info') {
    // Tạo và hiển thị thông báo
    const notification = document.createElement('div');
    notification.className = `fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50 ${
        type === 'success' ? 'bg-green-500 text-white' : 
        type === 'error' ? 'bg-red-500 text-white' : 
        'bg-blue-500 text-white'
    }`;
    notification.innerHTML = `
        <div class="flex items-center">
            <i class="fa-solid ${
                type === 'success' ? 'fa-check-circle' : 
                type === 'error' ? 'fa-exclamation-circle' : 
                'fa-info-circle'
            } mr-2"></i>
            <span>${message}</span>
        </div>
    `;
    
    document.body.appendChild(notification);
    
    // Tự động ẩn sau 3 giây
    setTimeout(() => {
        notification.remove();
    }, 3000);
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
function formatHourForDisplay(hour) {
    // ⭐️ SỬA: Logic đơn giản và rõ ràng
    let displayHour = hour;
    let ampm = 'SA'; // Mặc định là sáng
    
    if (hour === 0) {
        // 0 giờ = 12 SA (nửa đêm)
        displayHour = 12;
        ampm = 'SA';
    } else if (hour < 12) {
        // 1-11 giờ = SA
        displayHour = hour;
        ampm = 'SA';
    } else if (hour === 12) {
        // 12 giờ = 12 CH (trưa)
        displayHour = 12;
        ampm = 'CH';
    } else {
        // 13-23 giờ = 1-11 CH
        displayHour = hour - 12;
        ampm = 'CH';
    }
    
    return `${displayHour}:00 ${ampm}`;
}
window.formatHourForDisplay = formatHourForDisplay; // Đảm bảo global

function renderCalendar() {
    console.log("🎨 ===== RENDER CALENDAR DEBUG =====");
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

    // ⭐️ THÊM DEBUG CHI TIẾT VỀ WEEKLY SCHEDULE
    console.log("📅 ===== DEBUG WEEKLY SCHEDULE DATA =====");
    console.log("1. currentCollectionId:", currentCollectionId);
    console.log("2. window.weeklySchedule exists:", !!window.weeklySchedule);
    console.log("3. window.weeklySchedule type:", typeof window.weeklySchedule);
    console.log("4. Raw window.weeklySchedule:", window.weeklySchedule);

    // Debug chi tiết dữ liệu từng ngày
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    let totalEvents = 0;
    console.log("📊 Chi tiết từng ngày:");
    days.forEach(day => {
        const events = window.weeklySchedule && window.weeklySchedule[day];
        if (events && Array.isArray(events)) {
            console.log(`${day}: ${events.length} sự kiện`);
            events.forEach((event, i) => {
                console.log(`  [${i}] ScheduleID: ${event.scheduleId}, TaskID: ${event.taskId}`);
                console.log(`     Subject: "${event.subject}"`);
                console.log(`     Time: ${event.startTime} - ${event.endTime}`);
                console.log(`     Type: ${event.type}, Day: ${event.dayOfWeek}`);
                console.log(`     Has startMinutes: ${'startMinutes' in event}`);
                console.log(`     Has endMinutes: ${'endMinutes' in event}`);
                console.log(`     Full object:`, event);
            });
            totalEvents += events.length;
        } else {
            console.log(`${day}: Không có sự kiện hoặc dữ liệu không hợp lệ`);
        }
    });
    console.log(`Tổng cộng: ${totalEvents} sự kiện trong weeklySchedule`);
    console.log("========================================");

    // ⭐️ BƯỚC MỚI: TÍNH TOÁN VỊ TRÍ VA CHẠM CHO TẤT CẢ CÁC NGÀY TRƯỚC
    const positionedWeeklyEvents = {};
    const timeToMinutes = (timeStr) => {
        if (!timeStr) {
            console.warn(`⚠️ timeStr là undefined hoặc null`);
            return 0;
        }

        console.log(`⏱️ Converting time: "${timeStr}"`);

        // Xử lý cả định dạng "HH:MM:SS" và "HH:MM:SS SA/CH"
        const parts = timeStr.split(' ');
        let timePart = parts[0];
        let ampm = parts.length > 1 ? parts[1] : '';

        const [h, m, s] = timePart.split(':').map(Number);
        let hours = h || 0;
        const minutes = m || 0;

        console.log(`   Raw: hours=${hours}, minutes=${minutes}, ampm="${ampm}"`);

        // ⭐️ SỬA QUAN TRỌNG: Xử lý AM/PM tiếng Việt
        if (ampm === 'CH') {
            // CH = PM (chiều)
            // 12:xx CH = 12:xx (giữ nguyên)
            // 1:xx CH đến 11:xx CH = +12 giờ
            if (hours < 12) {
                hours += 12;
            }
            console.log(`   After PM conversion: ${hours}:${minutes}`);
        } else if (ampm === 'SA') {
            // SA = AM (sáng)
            // 12:xx SA = 0:xx
            // 1:xx SA đến 11:xx SA = giữ nguyên
            if (hours === 12) {
                hours = 0;
            }
            console.log(`   After AM conversion: ${hours}:${minutes}`);
        } else if (!ampm) {
            // Không có AM/PM, giả sử là 24h format
            console.log(`   No AM/PM, using 24h format: ${hours}:${minutes}`);
        }

        const totalMinutes = hours * 60 + minutes;
        console.log(`   "${timeStr}" -> ${hours}:${minutes} -> ${totalMinutes} phút`);
        return totalMinutes;
    };

    console.log("🔍 Bắt đầu xử lý từng ngày để tính toán vị trí...");
    days.forEach(day => {
        console.log(`\n--- Xử lý ngày ${day} ---`);
        if (window.weeklySchedule && window.weeklySchedule[day] && Array.isArray(window.weeklySchedule[day]) && window.weeklySchedule[day].length > 0) {
            console.log(`   Có ${window.weeklySchedule[day].length} sự kiện`);

            // Tiền xử lý để có startMinutes và endMinutes
            const dayEvents = window.weeklySchedule[day].map(e => {
                console.log(`   Processing event: ${e.subject} (${e.startTime} - ${e.endTime})`);

                // Kiểm tra dữ liệu
                if (!e.startTime || !e.endTime) {
                    console.warn(`   ⚠️ Event thiếu startTime hoặc endTime:`, e);
                    return null;
                }

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
                if (!e)
                    return false;
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

                // Debug chi tiết positioned events
                positionedWeeklyEvents[day].forEach((event, index) => {
                    console.log(`     [${index}] "${event.subject}": width=${event.width}%, left=${event.left}%`);
                });
            } else {
                console.log(`   Không có sự kiện hợp lệ cho ${day}`);
            }
        } else {
            console.log(`   Không có sự kiện cho ${day} (hoặc dữ liệu không hợp lệ)`);
        }
    });

    console.log("📊 Kết quả positionedWeeklyEvents:", positionedWeeklyEvents);

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

        // ⭐️ SỬA: Sử dụng hàm formatHourForDisplay
        timeCell.textContent = formatHourForDisplay(hour);
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
                    const eventStartMinute = e.startMinutes % 60;

                    // ⭐️ SỬA: Chỉ render ở ô BẮT ĐẦU của event
                    const shouldRender = (eventStartHour === hour);

                    // Debug
                    // Debug chi tiết
                    if (shouldRender) {
                        console.log(`   📍 Event: "${e.subject}"`);
                        console.log(`     Start: ${eventStartHour}:${eventStartMinute.toString().padStart(2, '0')}`);
                        console.log(`     End: ${Math.floor(e.endMinutes / 60)}:${(e.endMinutes % 60).toString().padStart(2, '0')}`);
                        console.log(`     Render at hour: ${hour}:00 (start hour match)`);
                    }

                    return shouldRender;
                });

                if (eventsToRender.length > 0) {
                    console.log(`   📌 Ô ${day} ${hour}:00 có ${eventsToRender.length} sự kiện cần render`);
                }

                eventsToRender.forEach(event => {
                    totalEventsCreated++;
                    console.log(`\n   👉 Tạo event ${totalEventsCreated}:`);
                    console.log(`     Subject: "${event.subject}"`);
                    console.log(`     ScheduleID: ${event.scheduleId}, TaskID: ${event.taskId}`);
                    console.log(`     Time: ${event.startTime} - ${event.endTime}`);
                    console.log(`     Minutes: ${event.startMinutes} - ${event.endMinutes}`);
                    console.log(`     Position: width=${event.width}%, left=${event.left}%`);

                    console.log(`🕐 EVENT TIME CHECK: ${event.subject}`);
                    console.log(`   Original startTime: ${event.startTime}`);
                    console.log(`   Original endTime: ${event.endTime}`);
                    console.log(`   Calculated minutes: ${event.startMinutes} - ${event.endMinutes}`);

                    // Kiểm tra chuyển đổi ngược
                    const testStart = formatMinutesToHHMMSS(event.startMinutes);
                    const testEnd = formatMinutesToHHMMSS(event.endMinutes);
                    console.log(`   Converted back: ${testStart} - ${testEnd}`);

                    if (event.startTime !== testStart || event.endTime !== testEnd) {
                        console.warn(`   ⚠️ MISMATCH!`);
                        console.warn(`   Original: ${event.startTime} - ${event.endTime}`);
                        console.warn(`   Converted: ${testStart} - ${testEnd}`);
                    }

                    if (window.createScheduledEventDiv) {
                        console.log(`   🔧 Gọi createScheduledEventDiv...`);
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

                        if (!eventDiv) {
                            console.error(`   ❌ createScheduledEventDiv trả về null/undefined`);
                            return;
                        }

                        console.log(`   ✅ DOM created for event: ${event.subject}`);
                        console.log(`   🎨 Event element details:`);
                        console.log(`     - Tag: ${eventDiv.tagName}`);
                        console.log(`     - Classes: ${eventDiv.className}`);
                        console.log(`     - Style top: ${eventDiv.style.top}`);
                        console.log(`     - Style height: ${eventDiv.style.height}`);
                        console.log(`     - Style width: ${eventDiv.style.width}`);
                        console.log(`     - Style left: ${eventDiv.style.left}`);

                        // Kiểm tra element có hợp lệ không
                        if (!(eventDiv instanceof HTMLElement)) {
                            console.error(`   ❌ eventDiv không phải HTMLElement`);
                            return;
                        }

                        // ⭐️ THÊM: Đánh dấu đã render để tránh trùng
                        eventDiv.dataset.rendered = 'true';

                        if (window.attachResizeHandlers && window.attachDragHandlers) {
                            // ⭐️ CHỈ attach handlers cho event chưa có scheduleId (temp event)
                            if (!event.scheduleId || event.scheduleId === "0" || event.scheduleId === 0) {
                                window.attachResizeHandlers(eventDiv);
                                window.attachDragHandlers(eventDiv);
                                console.log(`   🔗 Đã gắn handlers resize/drag`);
                            } else {
                                console.log(`   ⏭️ Event đã có scheduleId (${event.scheduleId}), không gắn handlers resize/drag`);
                            }
                        }

                        cell.appendChild(eventDiv);
                        console.log(`   ✅ Đã append vào cell ${day} ${hour}:00`);
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

    console.log(`\n🎯 Tổng số sự kiện được tạo: ${totalEventsCreated}`);

    if (totalEventsCreated === 0) {
        console.warn("\n⚠️ ⚠️ ⚠️ KHÔNG có sự kiện nào được tạo! ⚠️ ⚠️ ⚠️");
        console.warn("Nguyên nhân có thể là:");
        console.warn("1. Dữ liệu trong window.weeklySchedule rỗng");
        console.warn("2. Hàm timeToMinutes không chuyển đổi đúng thời gian");
        console.warn("3. positionedWeeklyEvents không có dữ liệu");
        console.warn("4. Sự kiện không nằm trong khoảng hiển thị (0-23h)");
        console.warn("5. Điều kiện filter không khớp");

        // Debug chi tiết hơn
        console.log("\n🔍 Debug chi tiết:");
        days.forEach(day => {
            console.log(`\n--- Debug ${day} ---`);
            if (positionedWeeklyEvents[day]) {
                positionedWeeklyEvents[day].forEach((event, i) => {
                    const startHour = Math.floor(event.startMinutes / 60);
                    const endHour = Math.ceil(event.endMinutes / 60);
                    console.log(`  Event ${i}: "${event.subject}"`);
                    console.log(`    Time: ${startHour}:00 - ${endHour}:00 (${event.startMinutes}-${event.endMinutes} phút)`);
                    console.log(`    Display range: ${START_DISPLAY_HOUR}:00 - ${END_DISPLAY_HOUR}:00`);

                    // Kiểm tra xem có nằm trong khoảng hiển thị không
                    const isInDisplayRange = (startHour >= START_DISPLAY_HOUR && startHour <= END_DISPLAY_HOUR) ||
                            (endHour >= START_DISPLAY_HOUR && endHour <= END_DISPLAY_HOUR);
                    console.log(`    In display range? ${isInDisplayRange}`);
                });
            } else {
                console.log(`  Không có positioned events`);
            }
        });

        // Kiểm tra dữ liệu gốc
        console.log("\n🔍 Kiểm tra dữ liệu gốc từ window.weeklySchedule:");
        days.forEach(day => {
            const events = window.weeklySchedule && window.weeklySchedule[day];
            if (events && Array.isArray(events)) {
                console.log(`${day}: ${events.length} events`);
                events.forEach((event, i) => {
                    console.log(`  [${i}] Subject: "${event.subject}", Time: ${event.startTime} - ${event.endTime}`);
                });
            }
        });
    } else {
        console.log("✅ Render thành công!");
    }

    // ⭐️ GỌI SETUP EVENTS
    if (window.setupEvents) {
        console.log("\n🔗 Gọi setupEvents()");
        window.setupEvents();
    }

    console.log("\n✅ renderCalendar() kết thúc");
    console.log("🎨 ===== END RENDER CALENDAR DEBUG =====\n");

    // ⭐️ THÊM: Gửi sự kiện để calendar-highlight.js biết
    setTimeout(() => {
        document.dispatchEvent(new CustomEvent('calendarRendered'));
    }, 50);
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
function addToScheduleBackend(scheduleData) {
    console.log("📤 Sending schedule data to backend:", scheduleData);

    return fetch('/user/schedule?action=add', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(scheduleData)
    })
            .then(response => {
                console.log("📥 Backend response status:", response.status);
                console.log("📥 Backend response headers:", response.headers);

                if (!response.ok) {
                    console.error("❌ Backend returned error status:", response.status);
                    return response.text().then(text => {
                        console.error("❌ Backend error response text:", text);
                        throw new Error(`HTTP ${response.status}: ${text}`);
                    });
                }

                return response.json();
            })
            .then(data => {
                console.log("📊 Full backend response data:", data);

                // ⭐️ THÊM DEBUG CHI TIẾT
                if (data.error || data.message) {
                    console.error("❌ Backend error details:", {
                        error: data.error,
                        message: data.message,
                        fullData: data
                    });
                }

                return {
                    success: data.success || false,
                    scheduleId: data.scheduleId || data.id || null,
                    message: data.message || data.error || '',
                    fullResponse: data // ⭐️ Thêm toàn bộ response để debug
                };
            })
            .catch(error => {
                console.error('❌ Network/parsing error adding to schedule:', error);
                return {
                    success: false,
                    scheduleId: null,
                    message: 'Network error: ' + error.message,
                    fullResponse: null
                };
            });
}
window.addToScheduleBackend = addToScheduleBackend;

/**
 * Get Date object from Day Name and Hour
 */
function getDateFromDayAndHour(dayName, hour, minute = 0) {  // ⭐️ Đã có tham số minute
    console.log("📅 getDateFromDayAndHour DEBUG START:");
    console.log("  Input - dayName:", dayName, "hour:", hour, "type(hour):", typeof hour, "minute:", minute);

    // ⭐️ QUAN TRỌNG: Xử lý hour có thể là string hoặc number
    let hourNum, minuteNum;
    
    if (typeof hour === 'string') {
        // Nếu hour là "09:00:00 SA", phân tích thành phần
        if (hour.includes(':')) {
            const timeParts = hour.split(':');
            hourNum = parseInt(timeParts[0]);
            minuteNum = parseInt(timeParts[1]) || 0;
        } else {
            hourNum = parseInt(hour);
            minuteNum = parseInt(minute) || 0;  // ⭐️ Sử dụng tham số minute
        }
    } else {
        hourNum = parseInt(hour);
        minuteNum = parseInt(minute) || 0;  // ⭐️ Sử dụng tham số minute
    }

    console.log("  Parsed hour:", hourNum, "minute:", minuteNum);

    if (isNaN(hourNum)) {
        console.error("❌ Lỗi: hour không phải số:", hour);
        hourNum = 9; // Mặc định 9:00
    }

    const today = new Date();
    const currentDayIndex = today.getDay(); // 0 (Sun) - 6 (Sat)

    // Map day name to index
    const dayMap = {'Mon': 1, 'Tue': 2, 'Wed': 3, 'Thu': 4, 'Fri': 5, 'Sat': 6, 'Sun': 0};

    let targetDayIndex = dayMap[dayName];
    if (targetDayIndex === undefined) {
        console.error("❌ Lỗi: dayName không hợp lệ:", dayName);
        targetDayIndex = today.getDay();
    }

    // Tính số ngày chênh lệch
    let diff = targetDayIndex - currentDayIndex;

    // Điều chỉnh
    if (diff < 0)
        diff += 7;

    const targetDate = new Date(today);
    targetDate.setDate(today.getDate() + diff);
    
    // ⭐️ SỬA QUAN TRỌNG: Sử dụng minuteNum thay vì minute
    targetDate.setHours(hourNum, minuteNum || 0, 0, 0);  // ⭐️ ĐÃ SỬA

    console.log("📅 getDateFromDayAndHour DEBUG END:");
    console.log("  Today:", today.toDateString());
    console.log("  Target date:", targetDate.toDateString());
    console.log("  Target time:", targetDate.toTimeString());
    console.log("  Hour set:", hourNum, "Minute set:", minuteNum);
    console.log("  Diff days:", diff);

    return targetDate;
}
window.getDateFromDayAndHour = getDateFromDayAndHour;

/**
 * Format date for API (yyyy-MM-dd HH:mm:ss)
 */
function formatDateForApi(date) {
    if (!date || isNaN(date.getTime())) {
        console.error("❌ Invalid date in formatDateForApi:", date);
        return null;
    }

    // ⭐️ THÊM: Validate và fix năm trước khi format
    const validatedDate = validateAndFixDate(date);

    const year = validatedDate.getFullYear();
    const month = String(validatedDate.getMonth() + 1).padStart(2, '0');
    const day = String(validatedDate.getDate()).padStart(2, '0');
    const hours = String(validatedDate.getHours()).padStart(2, '0');
    const minutes = String(validatedDate.getMinutes()).padStart(2, '0');
    const seconds = String(validatedDate.getSeconds()).padStart(2, '0');

    const formatted = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    console.log("📅 Formatted date for API:", formatted, "Year check:", year);
    return formatted;
}

function validateAndFixDate(date) {
    if (!date || isNaN(date.getTime())) {
        console.error("❌ Invalid date");
        return new Date();
    }

    const currentYear = new Date().getFullYear();
    const dateYear = date.getFullYear();

    // ⭐️ KIỂM TRA: Nếu năm sai (không phải năm hiện tại hoặc năm sau)
    if (dateYear > currentYear + 1) {
        console.warn(`⚠️ Năm bị sai: ${dateYear} (hiện tại: ${currentYear}), điều chỉnh...`);

        // Điều chỉnh về năm hiện tại
        date.setFullYear(currentYear);

        // Kiểm tra nếu ngày đã qua trong năm (tháng/ngày đã qua)
        const today = new Date();
        if (date < today) {
            // Nếu đã qua, đặt sang năm sau
            date.setFullYear(currentYear + 1);
        }

        console.log(`✅ Đã điều chỉnh năm thành: ${date.getFullYear()}`);
    }

    return date;
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
    console.log("🔄 navigateWeek called, offset:", offset, "currentWeekOffset before:", currentWeekOffset);

    if (offset === 0) {
        currentWeekOffset = 0;
    } else {
        currentWeekOffset += offset;
    }

    // ⭐️ GIỚI HẠN: Không cho phép currentWeekOffset quá lớn
    if (currentWeekOffset > 52)
        currentWeekOffset = 52;
    if (currentWeekOffset < -52)
        currentWeekOffset = -52;

    console.log("🔄 currentWeekOffset after:", currentWeekOffset);
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

////Sửa hàm này để nó có thể phân biệt giữa việc Lưu Task thường, Cập nhật Task, và Lưu Task từ Lịch
//function setupFormHandler() {
//    const form = document.getElementById('taskForm');
//    form.onsubmit = async (e) => {
//        e.preventDefault();
//
//        const taskData = {
//            title: document.getElementById('taskTitle').value,
//            description: document.getElementById('taskDescription').value,
//            priority: document.getElementById('taskPriority').value,
//            status: document.getElementById('taskStatus').value,
//            // Sử dụng giá trị từ input datetime-local
//            deadline: document.getElementById('taskDeadline').value ? formatDateForApi(new Date(document.getElementById('taskDeadline').value)) : null,
//            duration: parseInt(document.getElementById('taskDuration').value)
//        };
//
//        try {
//            if (tempScheduledEvent) {
//                // ⭐️ TRƯỜNG HỢP 1: LƯU TÁC VỤ MỚI VÀ LÊN LỊCH
//                await handleScheduleTaskSubmission(taskData);
//            } else if (editingTaskId) {
//                // TRƯỜNG HỢP 2: CẬP NHẬT TÁC VỤ CÓ SẴN
//                await updateTask(editingTaskId, taskData);
//                hideTaskForm();
//                loadTasks();
//            } else {
//                // TRƯỜNG HỢP 3: TẠO TÁC VỤ THÔNG THƯỜNG
//                await createTask(taskData);
//                hideTaskForm();
//                loadTasks();
//            }
//        } catch (error) {
//            console.error('Error saving task:', error);
//            alert('Failed to save task. Please try again.');
//        }
//    };
//}


// ⭐️ HÀM MỚI: Xử lý lưu Task và Schedule sau khi submit Form
// ⭐️ HÀM SỬA: Xử lý lưu Task và Schedule sau khi submit Form (FIX DUPLICATE)
async function handleScheduleTaskSubmission(taskData) {
    console.log("🔵 ===========================================");
    console.log("🔵 BẮT ĐẦU: handleScheduleTaskSubmission (NO AUTO-SCHEDULE)");
    console.log("🔵 ===========================================");
    
    const lockedCollectionId = currentCollectionId;
    console.log("🔒 Locked collectionId:", lockedCollectionId);

    if (!currentCollectionId) {
        alert('❌ Vui lòng chọn một lịch trình trước!');
        return;
    }

    if (!tempScheduledEvent || !tempScheduledEvent.element) {
        console.error("❌ Lỗi: tempScheduledEvent không tồn tại!");
        alert('Lỗi: Không tìm thấy thông tin lịch trình.');
        return;
    }
    
    // ⭐️ CHỐNG DOUBLE SUBMIT
    if (window.isProcessingSchedule) {
        console.log("⏸️  Đang xử lý schedule, bỏ qua");
        return;
    }
    
    window.isProcessingSchedule = true;
    
    // ⭐️ DISABLE nút submit
    const submitBtn = document.querySelector('#taskForm button[type="submit"]');
    const originalText = submitBtn?.innerHTML || 'Save';
    if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Saving...';
    }

    try {
        // ⭐️ BƯỚC 1: TẠO TASK (KHÔNG TỰ ĐỘNG LINK SCHEDULE)
        console.log("📦 Bước 1: Tạo task (không tự động link schedule)...");
        
        // 1. Lấy thông tin từ temp event
        const eventEl = tempScheduledEvent.element;
        const dayOfWeek = eventEl.dataset.dayIndex ?
                DAYS_OF_WEEK[parseInt(eventEl.dataset.dayIndex) - 1] :
                tempScheduledEvent.day;

        const startTime = eventEl.dataset.startTime || tempScheduledEvent.start;
        const endTime = eventEl.dataset.endTime || tempScheduledEvent.end;

        console.log("📊 Task information:");
        console.log("  Day:", dayOfWeek);
        console.log("  Time:", startTime, "-", endTime);

        // 2. Parse thời gian
        const startTimeParts = startTime.split(' ');
        const timePart = startTimeParts[0];
        const ampm = startTimeParts.length > 1 ? startTimeParts[1] : '';

        const [startHourStr, startMinuteStr] = timePart.split(':');
        let startHour = parseInt(startHourStr);
        let startMinute = parseInt(startMinuteStr);

        // Chuyển đổi sang 24h format
        if (ampm === 'CH' && startHour < 12) {
            startHour += 12;
        } else if (ampm === 'SA' && startHour === 12) {
            startHour = 0;
        }

        // 3. Tính deadline
        const calculatedDate = getDateFromDayAndHour(dayOfWeek, startHour, startMinute);
        const calculatedDeadline = formatDateForApi(calculatedDate);

        // 4. Tạo taskData với cờ đặc biệt để backend không tự tạo schedule
        const taskDataForAPI = {
            title: taskData.title || "",
            description: taskData.description || "",
            priority: taskData.priority || "medium",
            status: taskData.status || "pending",
            deadline: calculatedDeadline,
            duration: taskData.duration || 60,
            // ⭐️ THÊM: Cờ để backend biết đây là task từ schedule, không tự tạo schedule
            noAutoSchedule: true
        };

        console.log("📦 Creating task (no auto-schedule):", taskDataForAPI);

        const createTaskResult = await createTask(taskDataForAPI);

        if (!createTaskResult.success || !createTaskResult.taskId) {
            throw new Error('Tạo task thất bại: ' + (createTaskResult.message || 'Không rõ lỗi'));
        }

        const newTaskId = createTaskResult.taskId;
        console.log("✅ Task created successfully! ID:", newTaskId);

        // ⭐️ XÓA SCHEDULE TỰ ĐỘNG NẾU CÓ
        console.log("🔄 Checking for auto-schedules to delete...");
        await deleteAutoScheduleIfExists(newTaskId, currentCollectionId);

        // ⭐️ BƯỚC 2: TẠO SCHEDULE THỦ CÔNG
        console.log("📅 Bước 2: Tạo schedule thủ công...");

        // Kiểm tra xung đột
        console.log("🔍 Kiểm tra xung đột schedule...");
        const hasConflict = await checkScheduleConflict(dayOfWeek, startTime, endTime, newTaskId);

        if (hasConflict) {
            console.error("❌ Conflict detected:", hasConflict);
            
            let errorMessage = '⚠️ Xung đột lịch trình:\n\n';
            
            if (hasConflict.sameTask) {
                errorMessage += `Task "${taskData.title}" đã có lịch vào thời gian này.\n`;
                errorMessage += `• Thời gian hiện tại: ${hasConflict.conflictStart} - ${hasConflict.conflictEnd}\n`;
            } else {
                errorMessage += `Thời gian bị trùng với task khác: "${hasConflict.conflictSubject}"\n`;
                errorMessage += `• ${hasConflict.conflictStart} - ${hasConflict.conflictEnd}\n`;
            }
            
            errorMessage += '\nVui lòng chọn thời gian khác.';
            
            throw new Error(errorMessage);
        }

        // Tạo schedule
        const scheduleData = {
            collectionId: parseInt(lockedCollectionId),
            dayOfWeek: dayOfWeek,
            startTime: startTime,
            endTime: endTime,
            subject: taskData.title || "New Task",
            taskId: newTaskId,
            type: 'self-study'
        };

        console.log("📅 Creating schedule manually:", scheduleData);

        const scheduleResult = await addToScheduleBackend(scheduleData);
        console.log("📥 Schedule creation result:", scheduleResult);

        if (!scheduleResult.success) {
            // Kiểm tra nếu lỗi là duplicate trong database
            if (scheduleResult.message && 
                (scheduleResult.message.includes('Duplicate') || 
                 scheduleResult.message.includes('duplicate') ||
                 scheduleResult.message.includes('already exists'))) {
                
                console.error("❌ Database detected duplicate entry");
                
                // Xóa task đã tạo vì schedule thất bại
                console.log("🗑️ Deleting task since schedule failed...");
                try {
                    await fetch(`/user/tasks?id=${newTaskId}`, { method: 'DELETE' });
                    console.log("✅ Task deleted successfully");
                } catch (deleteError) {
                    console.error("⚠️ Could not delete task:", deleteError);
                }
                
                throw new Error('Lịch trình đã tồn tại trong database. Vui lòng chọn thời gian khác.');
            }
            
            throw new Error('Tạo schedule thất bại: ' + scheduleResult.message);
        }

        console.log("✅ Schedule created successfully! ID:", scheduleResult.scheduleId);

        // ⭐️ BƯỚC 3: CẬP NHẬT UI
        if (eventEl && eventEl.parentNode) {
            eventEl.dataset.scheduleId = scheduleResult.scheduleId;
            eventEl.dataset.taskId = newTaskId;
            eventEl.classList.remove('temp-event');
            eventEl.classList.add('saved-event');

            const span = eventEl.querySelector('span');
            if (span) {
                const displayStart = startTime.substring(0, 5);
                const displayEnd = endTime.substring(0, 5);
                span.textContent = `${taskData.title} (${displayStart} – ${displayEnd})`;
            }
        }

        // ⭐️ BƯỚC 4: CLEANUP VÀ RELOAD
        tempScheduledEvent = null;
        window.tempScheduledEvent = null;

        // Ẩn form
        const formContainer = document.getElementById('taskFormContainer');
        const addBtn = document.getElementById('addTaskBtn');
        if (formContainer) formContainer.classList.add('hidden');
        if (addBtn) addBtn.classList.remove('hidden');
        
        // Reset form
        const taskForm = document.getElementById('taskForm');
        if (taskForm) taskForm.reset();

        // Load lại dữ liệu
        await loadTasks();
        await loadSchedule(currentCollectionId);

        console.log("🎉 COMPLETE: Task and schedule created successfully!");
        
        // Hiển thị thông báo thành công
        showNotification(`Đã tạo task "${taskData.title}" và lên lịch thành công`, 'success');

    } catch (error) {
        console.error("💥 ERROR DETAILS:", error);
        
        // Hiển thị thông báo lỗi
        alert(error.message);

        // ⭐️ GIỮ LẠI TEMP EVENT KHI CÓ LỖI XUNG ĐỘT
        if (!error.message.includes('Xung đột') && !error.message.includes('duplicate')) {
            if (tempScheduledEvent && tempScheduledEvent.element) {
                tempScheduledEvent.element.remove();
            }
            tempScheduledEvent = null;
        }
        
        // Vẫn ẩn form để người dùng có thể thử lại
        hideTaskForm();
        
    } finally {
        // ⭐️ RESET TRẠNG THÁI
        window.isProcessingSchedule = false;
        
        // ENABLE lại nút submit
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
        }
    }
}

// ⭐️ HÀM PHỤ: Tạo schedule với taskId đã biết
async function createScheduleWithTaskId(taskId, dayOfWeek, startTime, endTime, subject) {
    console.log("📅 Bước 2: Tạo schedule với taskId:", taskId);
    
    // 1. Load lại schedule để có dữ liệu mới nhất
    console.log("🔄 Loading latest schedule data...");
    await loadSchedule(currentCollectionId);
    console.log("✅ Schedule loaded, checking data...");

    // Debug schedule hiện tại
    console.log("📅 Current schedule data for conflict checking:");

    // 2. Kiểm tra xung đột với dữ liệu MỚI NHẤT
    console.log("🔍 Checking for conflicts with latest data...");
    if (window.checkCollision) {
        const hasConflict = window.checkCollision(dayOfWeek, startTime, endTime, null);
        console.log("  Conflict check result:", hasConflict);

        if (hasConflict) {
            // Hiển thị chi tiết xung đột
            console.log("  Conflict details for", dayOfWeek + ":");
            if (window.weeklySchedule && window.weeklySchedule[dayOfWeek]) {
                window.weeklySchedule[dayOfWeek].forEach(event => {
                    console.log(`    - ${event.subject || 'No subject'}: ${event.startTime} - ${event.endTime}`);
                });
            }

            throw new Error('Xung đột thời gian với sự kiện đã có. Vui lòng chọn thời gian khác.');
        }
    } else {
        console.warn("⚠️ checkCollision function not available");
    }

    // 3. Tạo schedule
    const scheduleData = {
        collectionId: parseInt(currentCollectionId),
        dayOfWeek: dayOfWeek,
        startTime: startTime,
        endTime: endTime,
        subject: subject || "New Task",
        taskId: taskId,
        type: 'self-study'
    };

    console.log("📅 Creating schedule:", scheduleData);

    const scheduleResult = await addToScheduleBackend(scheduleData);
    console.log("📥 Schedule creation result:", scheduleResult);

    if (!scheduleResult.success) {
        // ⭐️ XỬ LÝ LỖI CHI TIẾT
        console.error("❌ Schedule creation failed:", scheduleResult);

        let errorMessage = 'Tạo schedule thất bại: ';

        // Phân tích lỗi từ backend
        if (scheduleResult.message.includes('conflict') ||
            scheduleResult.message.includes('Conflict') ||
            scheduleResult.message.includes('time conflict')) {

            errorMessage = '⚠️ Xung đột thời gian với sự kiện khác trong database.\n\n';
            errorMessage += 'Có thể có sự kiện không hiển thị trên lịch. ';
            errorMessage += 'Vui lòng chọn thời gian khác.';

            // ⭐️ QUAN TRỌNG: Xóa task đã tạo vì schedule thất bại
            console.log("🔄 Deleting task since schedule failed...");
            try {
                await fetch(`/user/tasks?id=${taskId}`, { method: 'DELETE' });
                console.log("✅ Task deleted successfully");
            } catch (deleteError) {
                console.error("⚠️ Could not delete task:", deleteError);
            }

        } else if (scheduleResult.message.includes('DB error') ||
                  scheduleResult.message.includes('database')) {
            errorMessage = 'Lỗi database. Vui lòng thử lại sau.';
        } else {
            errorMessage += scheduleResult.message;
        }

        throw new Error(errorMessage);
    }

    console.log("✅ Schedule created successfully! ID:", scheduleResult.scheduleId);

    // 4. Cập nhật UI
    if (tempScheduledEvent && tempScheduledEvent.element) {
        const eventEl = tempScheduledEvent.element;
        eventEl.dataset.scheduleId = scheduleResult.scheduleId;
        eventEl.dataset.taskId = taskId;
        eventEl.classList.remove('temp-event');
        eventEl.classList.add('saved-event');

        const span = eventEl.querySelector('span');
        if (span) {
            const displayStart = startTime.substring(0, 5);
            const displayEnd = endTime.substring(0, 5);
            span.textContent = `${subject} (${displayStart} – ${displayEnd})`;
        }
    }

    // 5. Reset và reload
    tempScheduledEvent = null;
    window.tempScheduledEvent = null;

    const formContainer = document.getElementById('taskFormContainer');
    const addBtn = document.getElementById('addTaskBtn');
    formContainer.classList.add('hidden');
    addBtn.classList.remove('hidden');
    document.getElementById('taskForm').reset();

    // Load lại toàn bộ dữ liệu
    await loadTasks();
    await loadSchedule(currentCollectionId);

    console.log("🎉 COMPLETE: Task and schedule created successfully!");
}
window.handleScheduleTaskSubmission = handleScheduleTaskSubmission;


// ⭐️ HÀM MỚI: Mở Modal từ sự kiện lịch (Được gọi bởi khoa-tasks.js)
window.openTaskDetailModalFromSchedule = function (eventElement, dayOfWeek, startTime, endTime, duration) {
    console.log("🎯 openTaskDetailModalFromSchedule called!");
    console.log("📅 Day:", dayOfWeek);
    console.log("⏰ Time:", startTime, "-", endTime);
    console.log("⏱️ Duration:", duration);

    // ⭐️ SỬA: Parse thời gian đúng cách
    // startTime có thể là "10:30:00 SA" hoặc "10:30:00"
    const [timePart, ampm] = startTime.split(' ');
    const [hoursStr, minutesStr] = timePart.split(':');
    
    const startHour = parseInt(hoursStr);
    const startMinute = parseInt(minutesStr);
    
    console.log("🔍 Parsed time:", { 
        startHour, 
        startMinute, 
        ampm: ampm || 'SA',
        timePart 
    });

    // ⭐️ KIỂM TRA QUAN TRỌNG: Nếu event đã có scheduleId (đã được lưu), KHÔNG mở form tạo mới
    if (eventElement.dataset.scheduleId) {
        console.log("⚠️ Event đã có scheduleId:", eventElement.dataset.scheduleId, "- KHÔNG mở form tạo mới");
        alert('Sự kiện này đã được lên lịch. Vui lòng sửa task từ danh sách task.');
        return;
    }

    // ⭐️ KIỂM TRA: Nếu event đã có taskId (đã liên kết với task), cũng không mở form
    if (eventElement.dataset.taskId && eventElement.dataset.taskId !== "null" && eventElement.dataset.taskId !== "0") {
        console.log("⚠️ Event đã có taskId:", eventElement.dataset.taskId, "- KHÔNG mở form tạo mới");
        alert('Sự kiện này đã được liên kết với một task. Vui lòng sửa task từ danh sách task.');
        return;
    }

    if (!currentCollectionId) {
        alert('Please select a schedule collection first!');
        eventElement.remove();
        return;
    }

    // ⭐️ CHỈ tạo temp event cho những event thực sự mới (temp-event)
    if (!eventElement.classList.contains('temp-event')) {
        console.log("⚠️ Event không phải temp-event, không tạo mới");
        return;
    }

    // ⭐️ QUAN TRỌNG: Set cả hai biến
    window.tempScheduledEvent = {
        element: eventElement,
        day: dayOfWeek,
        start: startTime,
        end: endTime,
        duration: duration,
        taskId: null
    };

    // Đồng bộ biến local
    tempScheduledEvent = window.tempScheduledEvent;

    console.log("✅ tempScheduledEvent set:", tempScheduledEvent);

    // ⭐️ SỬA QUAN TRỌNG: Truyền cả phút và xử lý AM/PM
    const calculatedDate = getDateFromDayAndHour(dayOfWeek, startHour, startMinute);
    
    // ⭐️ THÊM: Xử lý AM/PM nếu cần
    // (Hàm getDateFromDayAndHour nên tự xử lý AM/PM từ chuỗi đầy đủ)
    
    const formattedDeadline = formatForInput(calculatedDate);

    showTaskForm();
    document.getElementById('formTitle').textContent = 'New Scheduled Task';
    document.getElementById('taskDeadline').value = formattedDeadline;
    document.getElementById('taskDuration').value = duration;

    // Debug thêm
    console.log("📝 Form deadline set to:", formattedDeadline);
    console.log("📝 Calculated date:", calculatedDate.toString());
    console.log("📝 Form duration set to:", duration);
};

function showTaskForm() {
    console.log("📝 showTaskForm called");
    console.log("📝 Current tempScheduledEvent:", tempScheduledEvent);

    const formContainer = document.getElementById('taskFormContainer');
    const formTitle = document.getElementById('formTitle');
    const addBtn = document.getElementById('addTaskBtn');

    formContainer.classList.remove('hidden');

    // ⭐️ XÁC ĐỊNH LOẠI FORM
    if (tempScheduledEvent) {
        formTitle.textContent = 'New Scheduled Task';
        console.log("📝 Setting form as 'Scheduled Task'");
    } else {
        formTitle.textContent = 'Add New Task';
        console.log("📝 Setting form as 'Normal Task'");
    }

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
    console.log("🔄 updateTaskFormDuration called:", {duration, startTime, dayOfWeek});

    // 1. Cập nhật Duration (input number)
    const durationInput = document.getElementById('taskDuration');
    if (durationInput) {
        durationInput.value = duration;
    }

    // 2. Parse startTime để lấy giờ và phút
    // ⭐️ SỬA: Xử lý cả format với AM/PM
    let hourNum, minuteNum;

    // Kiểm tra định dạng thời gian
    if (startTime.includes('SA') || startTime.includes('CH')) {
        // Format có AM/PM: "HH:MM:SS SA/CH"
        let startTimeParts = startTime.split(' ');
        let timePart = startTimeParts[0];
        let ampm = startTimeParts[1] || '';

        let [hourStr, minuteStr] = timePart.split(':');
        hourNum = parseInt(hourStr);
        minuteNum = parseInt(minuteStr);

        // Xử lý AM/PM
        if (ampm === 'CH' && hourNum < 12) {
            hourNum += 12;
        } else if (ampm === 'SA' && hourNum === 12) {
            hourNum = 0;
        }
    } else {
        // Format 24h: "HH:MM:SS" hoặc "HH:MM"
        let [hourStr, minuteStr] = startTime.split(':');
        hourNum = parseInt(hourStr);
        minuteNum = parseInt(minuteStr || '0');
    }

    console.log("⏰ Parsed time:", {
        original: startTime,
        hour: hourNum,
        minute: minuteNum
    });

    // ⭐️ SỬA: Gọi hàm với minuteNum
    const calculatedDate = getDateFromDayAndHour(dayOfWeek, hourNum, minuteNum);
    // ⭐️ ĐÃ XÓA: calculatedDate.setMinutes(startMinute); // Không cần vì hàm đã xử lý

    // ⭐️ KIỂM TRA: Log ra để debug
    console.log("📅 Calculated date:", calculatedDate.toString());
    console.log("📅 Formatted for input:", formatForInput(calculatedDate));

    // Kiểm tra xem ngày có hợp lệ không
    if (isNaN(calculatedDate.getTime())) {
        console.error("❌ Ngày tính toán không hợp lệ!");
        return;
    }

    const deadlineInput = document.getElementById('taskDeadline');
    if (deadlineInput) {
        deadlineInput.value = formatForInput(calculatedDate);
        console.log("✅ Updated deadline input to:", deadlineInput.value);
    }
};

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


// ⭐️ THÊM HÀM MỚI: Tính toán vị trí sự kiện để tránh overlap
function calculateEventPositions(events) {
    if (!events || events.length === 0)
        return [];

    // Sắp xếp sự kiện theo thời gian bắt đầu
    events.sort((a, b) => a.startMinutes - b.startMinutes);

    const groups = [];
    let currentGroup = [];
    let currentEnd = -1;

    // Nhóm các sự kiện chồng lấn
    events.forEach(event => {
        if (event.startMinutes >= currentEnd) {
            if (currentGroup.length > 0) {
                groups.push([...currentGroup]);
            }
            currentGroup = [event];
            currentEnd = event.endMinutes;
        } else {
            currentGroup.push(event);
            if (event.endMinutes > currentEnd) {
                currentEnd = event.endMinutes;
            }
        }
    });

    if (currentGroup.length > 0) {
        groups.push(currentGroup);
    }

    // Tính toán vị trí cho từng nhóm
    const positionedEvents = [];
    groups.forEach(group => {
        group.sort((a, b) => a.startMinutes - b.startMinutes);

        group.forEach((event, index) => {
            // Tính toán chiều rộng và vị trí
            const totalInGroup = group.length;
            const widthPercentage = 100 / totalInGroup;
            const leftPercentage = index * widthPercentage;

            positionedEvents.push({
                ...event,
                width: widthPercentage,
                left: leftPercentage
            });
        });
    });

    return positionedEvents;
}

async function checkScheduleConflict(dayOfWeek, startTime, endTime, taskId) {
    // Load schedule hiện tại để kiểm tra
    if (!window.weeklySchedule) {
        await loadSchedule(currentCollectionId);
    }
    
    if (window.weeklySchedule && window.weeklySchedule[dayOfWeek]) {
        const dayEvents = window.weeklySchedule[dayOfWeek];
        
        // Chuyển đổi thời gian để so sánh
        const newStartMinutes = timeToMinutes(startTime);
        const newEndMinutes = timeToMinutes(endTime);
        
        console.log(`🔍 Checking conflict for ${dayOfWeek} ${startTime}-${endTime} (${newStartMinutes}-${newEndMinutes})`);
        
        for (const event of dayEvents) {
            // Bỏ qua chính nó nếu đang chỉnh sửa
            if (event.taskId == taskId) {
                console.log(`   Skipping same task: ${event.subject}`);
                continue;
            }
            
            const eventStartMinutes = timeToMinutes(event.startTime);
            const eventEndMinutes = timeToMinutes(event.endTime);
            
            console.log(`   Comparing with: ${event.subject} (${event.startTime}-${event.endTime}, ${eventStartMinutes}-${eventEndMinutes})`);
            
            // Kiểm tra overlap
            const isOverlap = (newStartMinutes < eventEndMinutes && newEndMinutes > eventStartMinutes);
            
            if (isOverlap) {
                console.log(`   ⚠️ CONFLICT DETECTED with ${event.subject}`);
                return {
                    conflict: true,
                    sameTask: event.taskId == taskId,
                    conflictSubject: event.subject,
                    conflictStart: event.startTime,
                    conflictEnd: event.endTime,
                    existingEvent: event
                };
            }
        }
    }
    
    console.log(`   ✅ No conflicts detected`);
    return null;
}
async function deleteAutoScheduleIfExists(taskId, collectionId) {
    try {
        const response = await fetch(`/user/schedule?action=list-by-task&taskId=${taskId}&collectionId=${collectionId}`);
        if (response.ok) {
            const schedules = await response.json();
            if (schedules && schedules.length > 0) {
                console.log(`🔍 Found ${schedules.length} auto-schedules for task ${taskId}`);
                
                // Xóa tất cả schedule tự động
                for (const schedule of schedules) {
                    if (schedule.type === 'auto-generated' || schedule.isAuto) {
                        console.log(`🗑️ Deleting auto-schedule ${schedule.scheduleId}`);
                        await fetch(`/user/schedule?action=delete&scheduleId=${schedule.scheduleId}`, {
                            method: 'DELETE'
                        });
                    }
                }
            }
        }
    } catch (error) {
        console.error("Error checking/deleting auto-schedule:", error);
    }
}

function initializeApp() {
    console.log("🚀 Khởi tạo ứng dụng...");
    
    // ⭐️ LOAD collectionId đã lưu TRƯỚC
    loadSelectedCollectionId();
    
    // Load tasks trước
    loadTasks();
    
    // Load schedule collections sau
    setTimeout(() => {
        loadScheduleCollections();
    }, 500);
    
    // Setup form handler
    setupFormHandler();
}

// Gọi khi trang đã load
document.addEventListener('DOMContentLoaded', function() {
    console.log("📄 DOM đã load, bắt đầu khởi tạo...");
    initializeApp();
});

// Hoặc gọi trực tiếp nếu DOM đã sẵn sàng
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeApp);
} else {
    initializeApp();
}


