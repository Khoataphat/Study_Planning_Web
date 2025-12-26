// Designer Page JavaScript - Backend Integration Version

let currentCollectionId = null;
let currentCollectionName = '';
let scheduleData = {};
let currentDragData = null;
let selectedDay = null;
let selectedEventElement = null;
let currentEventKey = null; // startTime of the selected event
let currentDragElement = null; // Element being dragged from the grid

// Initialize
document.addEventListener('DOMContentLoaded', function () {
    const urlParams = new URLSearchParams(window.location.search);
    currentCollectionId = urlParams.get('collectionId');

    if (currentCollectionId) {
        loadCollectionInfo(currentCollectionId);
        loadScheduleFromServer(currentCollectionId);
    } else {
        alert('Collection ID not specified!');
        window.location.href = '/schedule';
    }

    generateTimeSlots();
});

/**
 * Load collection info from server
 */
function loadCollectionInfo(collectionId) {
    fetch('/user/collections?action=get&id=' + collectionId)
        .then(response => response.json())
        .then(collection => {
            if (collection) {
                currentCollectionName = collection.collectionName;
                updateCollectionNameDisplay();
            }
        })
        .catch(error => {
            console.error('Error loading collection info:', error);
        });
}

/**
 * Update the collection name display in header
 */
function updateCollectionNameDisplay() {
    const headerTitle = document.querySelector('header h2');
    if (headerTitle) {
        headerTitle.innerHTML = '<span contenteditable="true" id="collectionNameEdit" class="outline-none" onblur="saveCollectionName()">' + escapeHtml(currentCollectionName) + '</span>';
        headerTitle.querySelector('#collectionNameEdit').addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                this.blur();
            }
        });
    }
}

/**
 * Save collection name when edited
 */
function saveCollectionName() {
    const editElement = document.getElementById('collectionNameEdit');
    if (!editElement) return;

    const newName = editElement.textContent.trim();
    if (newName && newName !== currentCollectionName) {
        fetch('/user/collections?id=' + currentCollectionId, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ name: newName })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    currentCollectionName = newName;
                } else {
                    // Revert on error
                    editElement.textContent = currentCollectionName;
                    alert('Lỗi khi đổi tên: ' + (data.message || data.error));
                }
            })
            .catch(error => {
                console.error('Error saving collection name:', error);
                editElement.textContent = currentCollectionName;
                alert('Không thể lưu tên. Vui lòng thử lại.');
            });
    }
}

/**
 * Load schedule from server via AJAX
 */
function loadScheduleFromServer(collectionId) {
    fetch('/user/schedule?action=weekly&collectionId=' + collectionId)
        .then(response => response.json())
        .then(data => {
            if (data) {
                renderScheduleFromServer(data);
            }
        })
        .catch(error => {
            console.error('Error loading schedule:', error);
            alert('Không thể tải lịch từ server');
        });
}

/**
 * Render schedule data from server
 */
function renderScheduleFromServer(weeklyData) {
    // Clear existing schedule data
    scheduleData = {};

    // Clear all event blocks from the grid
    document.querySelectorAll('.event-block').forEach(function (el) {
        el.remove();
    });

    const dayMapping = {
        'Mon': 'mon',
        'Tue': 'tue',
        'Wed': 'wed',
        'Thu': 'thu',
        'Fri': 'fri',
        'Sat': 'sat',
        'Sun': 'sun'
    };

    Object.keys(weeklyData).forEach(function (serverDay) {
        const clientDay = dayMapping[serverDay];
        const schedules = weeklyData[serverDay];

        schedules.forEach(function (schedule) {
            // Normalize time format: "09:00:00" -> "9:00"
            let timeStr = schedule.startTime.substring(0, 5); // "09:00"
            timeStr = parseInt(timeStr.split(':')[0]) + ':' + timeStr.split(':')[1]; // "9:00"

            let endTimeStr = schedule.endTime.substring(0, 5); // "09:00"
            endTimeStr = parseInt(endTimeStr.split(':')[0]) + ':' + endTimeStr.split(':')[1]; // "9:00"

            // Find the cell corresponding to the hour
            const hourStr = parseInt(timeStr.split(':')[0]) + ':00';
            const cell = document.querySelector('[data-day="' + clientDay + '"][data-time="' + hourStr + '"]');

            if (cell) {
                createEventElement(cell, {
                    type: schedule.type,
                    name: schedule.subject,
                    color: getColorForType(schedule.type),
                    startTime: timeStr,
                    endTime: endTimeStr,
                    description: '', // Server currently doesn't send description
                    day: clientDay
                });
            }
        });
    });
}

function getColorForType(type) {
    const colorMap = {
        'class': '#A5B4FC',
        'break': '#F9A8D4',
        'self-study': '#FDE047',
        'activity': '#93C5FD'
    };
    return colorMap[type] || '#A5B4FC';
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function generateTimeSlots() {
    const grid = document.getElementById('scheduleGrid');
    const times = ['0:00', '1:00', '2:00', '3:00', '4:00', '5:00', '6:00', '7:00', '8:00', '9:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00'];
    const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

    times.forEach(function (time) {
        const row = document.createElement('tr');

        let cellsHtml = '';
        days.forEach(function (day) {
            cellsHtml += '<td class="time-slot p-2 border-b border-l border-slate-100 align-top" ' +
                'data-time="' + time + '" ' +
                'data-day="' + day + '" ' +
                'ondrop="dropTask(event)" ' +
                'ondragover="allowDrop(event)" ' +
                'onclick="selectSlot(event)">' +
                '</td>';
        });

        row.innerHTML = '<td class="p-3 text-xs font-medium text-slate-500 border-b border-slate-100 bg-slate-50">' +
            time + '</td>' + cellsHtml;
        grid.appendChild(row);
    });
}

function dragTask(ev) {
    const target = ev.target.closest('.task-item');
    currentDragData = {
        type: target.getAttribute('data-task-type'),
        name: target.getAttribute('data-task-name'),
        color: target.getAttribute('data-task-color')
    };
}

function allowDrop(ev) {
    ev.preventDefault();
}

function dropTask(ev) {
    ev.preventDefault();
    if (!currentDragData) return;

    const cell = ev.currentTarget;
    let time = cell.getAttribute('data-time'); // e.g. "8:00"
    const day = cell.getAttribute('data-day');

    // Check if moving to the same slot
    if (currentDragData.isMove &&
        currentDragData.originalDay === day &&
        currentDragData.originalStartTime === time) {
        return;
    }

    // Try to find a valid slot within this hour (every 5 mins)
    const baseHour = parseInt(time.split(':')[0]);
    let foundTime = null;
    let foundEndTime = null;

    // Helper to calculate end time based on duration
    const getEndTime = (startH, startM) => {
        let durationH = 1;
        if (currentDragData.durationHours) {
            durationH = currentDragData.durationHours;
        }

        const totalHours = startH + (startM / 60) + durationH;
        const endH = Math.floor(totalHours);
        const endM = Math.round((totalHours - endH) * 60);
        return endH + ':' + endM.toString().padStart(2, '0');
    };

    // Try offsets: 0, 5, 10, ..., 55
    for (let offset = 0; offset < 60; offset += 5) {
        const checkTime = baseHour + ':' + offset.toString().padStart(2, '0');
        const checkEndTime = getEndTime(baseHour, offset);

        if (!checkConflict(day, checkTime, checkEndTime, currentDragData.isMove ? currentDragData.originalStartTime : null)) {
            foundTime = checkTime;
            foundEndTime = checkEndTime;
            break; // Found a valid slot!
        }
    }

    if (!foundTime) {
        alert('Không tìm thấy khoảng trống nào trong giờ này (' + baseHour + ':00 - ' + (baseHour + 1) + ':00) cho sự kiện này!');
        if (currentDragElement) currentDragElement.classList.remove('opacity-50');
        currentDragData = null;
        currentDragElement = null;
        return;
    }

    createEventElement(cell, {
        type: currentDragData.type,
        name: currentDragData.name,
        color: currentDragData.color,
        startTime: foundTime,
        endTime: foundEndTime,
        description: currentDragData.description || '',
        day: day
    });

    // If this was a move, delete the old event
    if (currentDragData.isMove) {
        if (currentDragElement) currentDragElement.remove();
        if (scheduleData[currentDragData.originalDay] &&
            scheduleData[currentDragData.originalDay][currentDragData.originalStartTime]) {
            delete scheduleData[currentDragData.originalDay][currentDragData.originalStartTime];
        }
    }

    currentDragData = null;
    currentDragElement = null;
}

/**
 * Check if the new time slot overlaps with any existing event
 */
function checkConflict(day, newStartStr, newEndStr, excludeStartTime) {
    if (!scheduleData[day]) return false;

    // Helper to convert "HH:mm" to minutes
    const toMinutes = (str) => {
        const parts = str.split(':');
        return parseInt(parts[0]) * 60 + parseInt(parts[1] || 0);
    };

    const newStart = toMinutes(newStartStr);
    const newEnd = toMinutes(newEndStr);

    for (const key in scheduleData[day]) {
        // Skip the event being moved (self-comparison)
        if (key === excludeStartTime) continue;

        const event = scheduleData[day][key];
        const existingStart = toMinutes(key);
        // Ensure event.endTime exists, if not default to start + 60
        const existingEnd = event.endTime ? toMinutes(event.endTime) : existingStart + 60;

        // Overlap condition: StartA < EndB && EndA > StartB
        if (newStart < existingEnd && newEnd > existingStart) {
            return true;
        }
    }
    return false;
}

function createEventElement(cell, data) {
    // Calculate duration in hours
    const startParts = data.startTime.split(':');
    const endParts = data.endTime.split(':');
    const startHours = parseInt(startParts[0]) + parseInt(startParts[1]) / 60;
    const endHours = parseInt(endParts[0]) + parseInt(endParts[1]) / 60;
    const duration = endHours - startHours;

    // Each hour cell is approximately 48px in height (adjust based on your CSS)
    const cellHeight = cell.offsetHeight; // Get actual cell height
    const eventHeight = duration * cellHeight;

    // Create event block
    const eventBlock = document.createElement('div');
    eventBlock.className = 'event-block p-2 rounded-lg text-white text-xs font-semibold cursor-move hover:opacity-90 transition-opacity';
    eventBlock.setAttribute('draggable', 'true');

    // Drag Handlers
    eventBlock.addEventListener('dragstart', function (e) {
        e.stopPropagation();
        currentDragElement = eventBlock;
        currentDragData = {
            type: data.type,
            name: data.name,
            color: data.color,
            description: data.description,
            isMove: true,
            originalDay: data.day,
            originalStartTime: data.startTime,
            durationHours: duration
        };
        e.dataTransfer.effectAllowed = 'move';
        setTimeout(() => eventBlock.classList.add('opacity-50'), 0);
    });

    eventBlock.addEventListener('dragend', function (e) {
        eventBlock.classList.remove('opacity-50');
        currentDragElement = null;
    });
    // Calculate top offset based on minutes
    const startMinutes = parseInt(startParts[1]);
    const topOffset = (startMinutes / 60) * cellHeight;

    eventBlock.style.backgroundColor = data.color;
    eventBlock.style.position = 'absolute';
    eventBlock.style.top = topOffset + 'px';
    eventBlock.style.left = '2px';
    eventBlock.style.right = '2px';
    eventBlock.style.height = (eventHeight - 4) + 'px'; // Subtract margin
    eventBlock.style.display = 'flex';
    eventBlock.style.flexDirection = 'column';
    eventBlock.style.justifyContent = 'center';
    eventBlock.style.alignItems = 'flex-start';
    eventBlock.style.zIndex = '10';
    eventBlock.style.overflow = 'hidden';

    // Display name and time
    eventBlock.innerHTML = '<div>' + escapeHtml(data.name) + '</div>' +
        '<div style="font-size: 10px; opacity: 0.9;">' +
        data.startTime + ' - ' + data.endTime + '</div>';

    // Click handler for editing
    eventBlock.onclick = function (e) {
        e.stopPropagation();
        selectEvent(eventBlock, data);
    };

    // Make cell position relative to contain absolute event
    cell.style.position = 'relative';
    cell.appendChild(eventBlock);

    // Save to schedule data
    if (!scheduleData[data.day]) scheduleData[data.day] = {};
    scheduleData[data.day][data.startTime] = {
        type: data.type,
        name: data.name,
        color: data.color,
        endTime: data.endTime,
        description: data.description,
        // Preserve task association when present
        taskId: data.taskId || null
    };
}

function selectSlot(ev) {
    const cell = ev.currentTarget;
    const time = cell.getAttribute('data-time');
    const day = cell.getAttribute('data-day');

    // Set global selected day
    selectedDay = day;

    // Clear previous event selection
    selectedEventElement = null;
    currentEventKey = null;

    // Reset form to default for new event
    document.getElementById('eventName').value = '';
    document.getElementById('eventDesc').value = '';
    document.getElementById('startTime').value = time;

    // Calculate end time (1 hour later)
    const hour = parseInt(time.split(':')[0]);
    const endHour = (hour + 1).toString().padStart(2, '0');
    document.getElementById('endTime').value = endHour + ':00';

    document.getElementById('eventRepeat').selectedIndex = 0;

    // Update buttons
    document.getElementById('btnSaveEvent').textContent = 'Thêm vào lịch';
    document.getElementById('btnDeleteEvent').classList.add('hidden');
}

/**
 * Normalize time to HH:mm format for HTML time input
 * Converts "9:00" to "09:00", "14:30" stays "14:30"
 */
function normalizeTimeForInput(timeStr) {
    if (!timeStr) return '09:00';

    const parts = timeStr.split(':');
    const hour = parts[0].padStart(2, '0');
    const minute = parts[1] || '00';

    return hour + ':' + minute;
}

function selectEvent(element, data) {
    selectedEventElement = element;
    selectedDay = data.day;
    currentEventKey = data.startTime; // Store the key

    document.getElementById('eventName').value = data.name;
    // Normalize times for HTML time input (requires HH:mm format)
    document.getElementById('startTime').value = normalizeTimeForInput(data.startTime);
    document.getElementById('endTime').value = normalizeTimeForInput(data.endTime);
    document.getElementById('eventDesc').value = data.description || '';

    document.getElementById('btnSaveEvent').textContent = 'Cập nhật';
    document.getElementById('btnDeleteEvent').classList.remove('hidden');
}

function addEventToCalendar() {
    const name = document.getElementById('eventName').value;
    const startTime = document.getElementById('startTime').value;
    const endTime = document.getElementById('endTime').value;
    const description = document.getElementById('eventDesc').value;

    if (!name) {
        alert('Vui lòng nhập tên sự kiện');
        return;
    }

    if (!selectedDay) {
        alert('Vui lòng chọn một ô trên lịch hoặc kéo thả sự kiện vào lịch trước.');
        return;
    }

    // Validate time
    if (startTime >= endTime) {
        alert('Thời gian kết thúc phải sau thời gian bắt đầu.');
        return;
    }

    // Find the cell - handle non-exact hours
    // Find cell by the hour (grid only has hourly cells)
    const startHour = parseInt(startTime.split(':')[0]);
    const gridTime = startHour + ':00';

    const targetCell = document.querySelector('[data-day="' + selectedDay + '"][data-time="' + gridTime + '"]');

    if (!targetCell) {
        alert('Thời gian bắt đầu không nằm trong khung giờ hiển thị của lịch (0:00 - 23:00).');
        return;
    }

    // Determine type and color
    let type = 'class';
    let color = '#A5B4FC';

    // If editing, preserve type/color from old data
    if (selectedEventElement && currentEventKey) {
        const oldData = scheduleData[selectedDay][currentEventKey];
        if (oldData) {
            type = oldData.type;
            color = oldData.color;
        }

        // Remove old event from DOM and Data
        selectedEventElement.remove();
        delete scheduleData[selectedDay][currentEventKey];
    }

    // Convert "09:00" back to "9:00" format for internal storage
    const normalizedStartTime = parseInt(startTime.split(':')[0]) + ':' + startTime.split(':')[1];
    const normalizedEndTime = parseInt(endTime.split(':')[0]) + ':' + endTime.split(':')[1];

    const newData = {
        type: type,
        name: name,
        color: color,
        startTime: normalizedStartTime,  // Use actual time with minutes
        endTime: normalizedEndTime,      // Use actual time with minutes
        description: description,
        day: selectedDay
    };

    createEventElement(targetCell, newData);
    clearForm();
}

function deleteSelectedEvent() {
    if (selectedEventElement && confirm('Bạn có chắc muốn xóa sự kiện này?')) {
        selectedEventElement.remove();

        if (scheduleData[selectedDay] && scheduleData[selectedDay][currentEventKey]) {
            delete scheduleData[selectedDay][currentEventKey];
        }

        clearForm();
    }
}

function clearForm() {
    document.getElementById('eventName').value = '';
    document.getElementById('eventDesc').value = '';
    document.getElementById('startTime').value = '09:00';
    document.getElementById('endTime').value = '11:00';
    document.getElementById('eventRepeat').selectedIndex = 0;

    selectedEventElement = null;
    currentEventKey = null;
    // selectedDay = null; // Don't reset day so user can keep adding to same day

    document.getElementById('btnSaveEvent').textContent = 'Thêm vào lịch';
    document.getElementById('btnDeleteEvent').classList.add('hidden');
}

/**
 * Save schedule to server via AJAX
 */
function saveSchedule() {
    const dayMapping = {
        'mon': 'Mon',
        'tue': 'Tue',
        'wed': 'Wed',
        'thu': 'Thu',
        'fri': 'Fri',
        'sat': 'Sat',
        'sun': 'Sun'
    };

    const typeMapping = {
        'study': 'class',
        'break': 'break',
        'work': 'self-study',
        'hobby': 'activity',
        'class': 'class',
        'self-study': 'self-study',
        'activity': 'activity'
    };

    const schedules = [];

    Object.keys(scheduleData).forEach(function (day) {
        Object.keys(scheduleData[day]).forEach(function (time) {
            const event = scheduleData[day][time];

            // Use stored endTime or calculate default
            let endTime = event.endTime;
            if (!endTime) {
                const endHour = (parseInt(time.split(':')[0]) + 1).toString().padStart(2, '0');
                endTime = endHour + ':00';
            }

            schedules.push({
                dayOfWeek: dayMapping[day],
                startTime: time,
                endTime: endTime,
                subject: event.name,
                type: typeMapping[event.type] || 'class',
                // include taskId if the event is linked to a task (0 = none)
                taskId: event.taskId || 0
            });
        });
    });

    // Send to server
    fetch('/user/schedule?collectionId=' + currentCollectionId, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(schedules)
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Đã lưu lịch thành công!');
                window.location.href = '/schedule';
            } else {
                // Handle both message and error fields
                const msg = data.message || data.error || 'Lỗi không xác định';
                alert('Lỗi khi lưu lịch: ' + msg);
            }
        })
        .catch(error => {
            console.error('Error saving schedule:', error);
            alert('Không thể lưu lịch. Vui lòng thử lại.');
        });
}
