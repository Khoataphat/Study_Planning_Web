// Designer Page JavaScript - Backend Integration Version

let currentCollectionId = null;
let currentCollectionName = '';
let scheduleData = {};
let currentDragData = null;
let selectedDay = null;
let selectedEventElement = null;
let currentEventKey = null; // startTime of the selected event

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
            // Normalize time format to get Hour for grid placement
            // e.g. "01:30:00" -> Hour: 1, Minute: 30
            const parts = schedule.startTime.split(':');
            const hour = parseInt(parts[0]);
            const minute = parseInt(parts[1]);

            // Grid uses "1:00", "2:00" format
            const gridTime = hour + ':00';

            const cell = document.querySelector('[data-day="' + clientDay + '"][data-time="' + gridTime + '"]');

            if (cell) {
                // Ensure format "1:30" or "01:30" depending on requirement, usually we want "1:30" for display?
                // But createEventElement splits it.
                // Let's pass the raw HH:mm string
                const formattedStart = hour + ':' + (minute < 10 ? '0' + minute : minute);

                const endParts = schedule.endTime.split(':');
                const endHour = parseInt(endParts[0]);
                const endMinute = parseInt(endParts[1]);
                const formattedEnd = endHour + ':' + (endMinute < 10 ? '0' + endMinute : endMinute);

                createEventElement(cell, {
                    type: schedule.type,
                    name: schedule.subject,
                    color: getColorForType(schedule.type),
                    startTime: formattedStart,
                    endTime: formattedEnd,
                    description: '',
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
            cellsHtml += '<td class="time-slot p-2 border-b border-l border-slate-100 align-top h-12" ' + // Added h-12 for consistent height base
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

function allowDrop(ev) {
    ev.preventDefault();
}

function dragTask(ev) {
    const target = ev.target.closest('.task-item');
    if (target) {
        currentDragData = {
            isMoving: false,
            type: target.getAttribute('data-task-type'),
            name: target.getAttribute('data-task-name'),
            color: target.getAttribute('data-task-color')
        };
        ev.dataTransfer.effectAllowed = 'copy';
    }
}

function dropTask(ev) {
    ev.preventDefault();
    const cell = ev.currentTarget;
    const day = cell.getAttribute('data-day');
    const time = cell.getAttribute('data-time');

    if (!currentDragData) return;

    // Check if new task or moving existing
    if (currentDragData.isMoving) {
        // Remove old event
        if (currentDragData.element) currentDragData.element.remove();

        // Remove from data structure
        if (scheduleData[currentDragData.originalDay] && scheduleData[currentDragData.originalDay][currentDragData.originalStartTime]) {
            delete scheduleData[currentDragData.originalDay][currentDragData.originalStartTime];
        }

        // Calculate new times (preserve duration)
        let durationMin = 60; // Default 1 hour
        if (currentDragData.startTime && currentDragData.endTime) {
            const s = currentDragData.startTime.split(':');
            const e = currentDragData.endTime.split(':');
            const sm = parseInt(s[0]) * 60 + parseInt(s[1] || 0);
            const em = parseInt(e[0]) * 60 + parseInt(e[1] || 0);
            durationMin = em - sm;
        }

        const startH = parseInt(time.split(':')[0]);
        const startM = 0; // Dropping on grid always starts at :00 (unless we implemented pixel precision drop which we haven't)

        const endTotal = (startH * 60 + startM) + durationMin;
        const endH = Math.floor(endTotal / 60);
        const endM = endTotal % 60;

        const newStart = startH + ':' + (startM < 10 ? '0' + startM : startM);
        const newEnd = endH + ':' + (endM < 10 ? '0' + endM : endM);

        createEventElement(cell, {
            type: currentDragData.type,
            name: currentDragData.name,
            color: currentDragData.color,
            startTime: newStart,
            endTime: newEnd,
            description: currentDragData.description,
            day: day
        });

    } else {
        // New Task from Toolbox
        const startH = parseInt(time.split(':')[0]);
        const endH = startH + 1;

        createEventElement(cell, {
            type: currentDragData.type,
            name: currentDragData.name,
            color: currentDragData.color,
            startTime: startH + ":00",
            endTime: endH + ":00",
            description: '',
            day: day
        });
    }

    currentDragData = null; // Reset
}

function createEventElement(cell, data) {
    // Calculate duration in hours
    const startParts = data.startTime.split(':');
    const endParts = data.endTime.split(':');
    const startHours = parseInt(startParts[0]) + parseInt(startParts[1]) / 60;
    const endHours = parseInt(endParts[0]) + parseInt(endParts[1]) / 60;
    const duration = endHours - startHours;

    // Calculate Top Offset (Minutes)
    const startMinutes = parseInt(startParts[1]);

    // Get cell height
    const cellHeight = cell.offsetHeight || 48; // Fallback to 48 if 0 (hidden)

    const topOffset = (startMinutes / 60) * cellHeight;
    const eventHeight = duration * cellHeight;

    // Create event block
    const eventBlock = document.createElement('div');
    eventBlock.className = 'event-block p-2 rounded-lg text-white text-xs font-semibold cursor-pointer hover:opacity-90 transition-opacity';
    eventBlock.style.backgroundColor = data.color;
    eventBlock.style.position = 'absolute';
    eventBlock.style.top = topOffset + 'px'; // Apply offset
    eventBlock.style.left = '2px';
    eventBlock.style.right = '2px';
    eventBlock.style.height = (eventHeight - 4) + 'px'; // Subtract margin
    eventBlock.style.display = 'flex';
    eventBlock.style.flexDirection = 'column';
    eventBlock.style.justifyContent = 'center';
    eventBlock.style.alignItems = 'flex-start';
    eventBlock.style.zIndex = '10';
    eventBlock.style.overflow = 'hidden';

    // Make event draggable
    eventBlock.setAttribute('draggable', 'true');
    eventBlock.addEventListener('dragstart', function (e) {
        e.stopPropagation();
        dragExistingEvent(e, data, eventBlock);
    });

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
        description: data.description
    };
}

// New function to handle dragging existing events
function dragExistingEvent(ev, data, element) {
    currentDragData = {
        isMoving: true,
        type: data.type,
        name: data.name,
        color: data.color,
        startTime: data.startTime,
        endTime: data.endTime,
        description: data.description,
        originalDay: data.day,
        originalStartTime: data.startTime,
        element: element
    };
    ev.dataTransfer.effectAllowed = 'move';
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
                type: typeMapping[event.type] || 'class'
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
