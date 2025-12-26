// =================================================================
// 1. CÁC BIẾN TRẠNG THÁI VÀ HẰNG SỐ
// (Giữ nguyên)
// =================================================================
let isResizing = false;
let resizeHandle = null;
let currentEvent = null;

let isDragging = false;
let dragStartY = 0;
let dragStartTop = 0;
let currentEventToMove = null;

const PIXELS_PER_HOUR = 80;
const PIXELS_PER_MINUTE = PIXELS_PER_HOUR / 60;
const DEFAULT_DURATION_MINUTES = 60;

// === HẰNG SỐ MỚI ĐƯỢC BỔ SUNG ===
const START_HOUR = 0;
const END_HOUR = 23; // Kết thúc ở mép dưới của 17:00
const DAYS_OF_WEEK = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

// =================================================================
// 2. HÀM THIẾT LẬP (SETUP)
// =================================================================

function setupEvents() {
// Chỉ gắn listeners lên các container đã được tasks.js tạo ra
    document.querySelectorAll('.calendar-day-cell').forEach(container => {
        // Thay vì gắn vào .schedule-container (chỉ là div bên trong td),
        // hãy gắn vào chính td.calendar-day-cell để tối ưu hóa việc click
        // vì td.calendar-day-cell đã có position: relative và data-day-index
        container.addEventListener('click', createDefaultEvent);
    });

    // Gắn sự kiện Resize và Drag lên document
    document.addEventListener('mousemove', duringResize);
    document.addEventListener('mouseup', endResize);

    document.addEventListener('mousemove', duringMove);
    document.addEventListener('mouseup', endMove); // endMove đã được định nghĩa ở ngoài
}

// =================================================================
// 3. LOGIC CLICK-TO-CREATE (Giữ nguyên)
// =================================================================

function createDefaultEvent(e) {

    console.log("🎯 CLICK CREATE DEFAULT EVENT DEBUG:");
    console.log("  Click coordinates:", e.clientX, e.clientY);
    console.log("  Target class:", e.target.className);
    console.log("  Current target dataset:", e.currentTarget.dataset);

    // ⭐️ BỔ SUNG LOGIC CHẶN SỰ KIỆN TẠM THỜI THỨ HAI
    if (window.tempScheduledEvent !== null) {
        console.warn("LƯU Ý: Vui lòng hoàn thành (Save) hoặc hủy (Cancel) tác vụ đang tạo trước.");

        // Bạn có thể thêm logic cuộn đến form đang mở hoặc nháy form để thu hút sự chú ý
        const formContainer = document.getElementById('taskFormContainer');
        if (formContainer && formContainer.classList.contains('hidden') === false) {
            formContainer.classList.add('animate-shake');
            setTimeout(() => formContainer.classList.remove('animate-shake'), 800);
        }

        return; // CHẶN TOÀN BỘ QUÁ TRÌNH TẠO SỰ KIỆN TẠM THỜI MỚI
    }

    // Ngăn chặn việc tạo sự kiện mới khi click vào một sự kiện đã có hoặc handle resize của nó.
    if (e.target.classList.contains('calendar-event') || e.target.classList.contains('resize-handle')) {
        return;
    }

    // Lấy container (ô lịch ngày/giờ) đã được click
    const container = e.currentTarget;

    console.log("🔍 DEBUG 1: CONTAINER INFO");
    console.log("- Container class:", container.className);
    console.log("- Container dataset:", container.dataset);
    console.log("- Container data-hour RAW:", container.dataset.hour);
    console.log("- Container data-hour PARSED:", parseInt(container.dataset.hour));
    console.log("- Container data-day-index:", container.dataset.dayIndex);
    console.log("- Container innerHTML (first 100 chars):", container.innerHTML.substring(0, 100));

// Kiểm tra tất cả các ô cùng giờ
    console.log("- All cells with hour", container.dataset.hour, ":");
    document.querySelectorAll(`.calendar-day-cell[data-hour="${container.dataset.hour}"]`).forEach((cell, i) => {
        console.log(`  [${i}] ${cell.dataset.day} - ${cell.innerHTML.substring(0, 50)}...`);
    });

// Kiểm tra START_HOUR
    console.log("- window.START_HOUR:", window.START_HOUR);
    console.log("- window.PIXELS_PER_MINUTE:", window.PIXELS_PER_MINUTE);

    // Kiểm tra xem container có phải là ô lịch hợp lệ không (chắc chắn hơn)
    if (!container.classList.contains('calendar-day-cell')) {
        return;
    }

    const containerRect = container.getBoundingClientRect();
    const clickY = e.clientY - containerRect.top;

    // --- 1. Tính toán vị trí và thời gian ---
    const minutesOffset = Math.round(clickY / PIXELS_PER_MINUTE);
    // Làm tròn đến 15 phút gần nhất
    const startMinutesRounded = Math.ceil(minutesOffset / 15) * 15;

    const finalTop = startMinutesRounded * PIXELS_PER_MINUTE;
    const finalHeight = DEFAULT_DURATION_MINUTES * PIXELS_PER_MINUTE;

    console.log("🔍 DEBUG 2: POSITION CALCULATION");
    console.log("- clickY:", clickY, "px");
    console.log("- minutesOffset:", minutesOffset, "phút");
    console.log("- startMinutesRounded:", startMinutesRounded, "phút");
    console.log("- PIXELS_PER_MINUTE:", PIXELS_PER_MINUTE);
    console.log("- finalTop:", finalTop, "px (", finalTop / PIXELS_PER_MINUTE, "phút)");
    console.log("- finalHeight:", finalHeight, "px (", finalHeight / PIXELS_PER_MINUTE, "phút)");
    console.log("- finalTop in hours:", finalTop / 80, "giờ từ đỉnh ô");

// Kiểm tra nếu finalTop bị âm hoặc quá lớn
    if (finalTop < 0)
        console.error("❌ finalTop NEGATIVE!");
    if (finalTop > 80)
        console.warn("⚠️ finalTop > 80px - vượt quá chiều cao ô!");

    const parentCell = container; // container chính là .calendar-day-cell
    const startHourOfCell = parseInt(container.dataset.hour);
    const dayIndex = parseInt(container.dataset.dayIndex); // Sử dụng data-day-index (1=Mon, 7=Sun)
    const dayOfWeek = DAYS_OF_WEEK[dayIndex - 1];

    console.log("📅 Cell info:");
    console.log("  Day index:", dayIndex, "-> Day:", dayOfWeek);
    console.log("  Cell hour:", startHourOfCell);
    console.log("  Rounded top:", finalTop, "px");
    console.log("  Final height:", finalHeight, "px");

    // Tính toán giờ và phút bắt đầu thực tế
    const totalStartMinutes = (startHourOfCell * 60) + startMinutesRounded;
    const actualStartHour = Math.floor(totalStartMinutes / 60);
    const startMinute = totalStartMinutes % 60;

    // Tính toán giờ và phút kết thúc
    const totalEndMinutes = totalStartMinutes + DEFAULT_DURATION_MINUTES;
    const actualEndHour = Math.floor(totalEndMinutes / 60);
    const endMinute = totalEndMinutes % 60;

    console.log("🔍 DEBUG 3: TIME CALCULATION");
    console.log("- startHourOfCell:", startHourOfCell, "(từ container.dataset.hour)");
    console.log("- startMinutesRounded:", startMinutesRounded, "phút");
    console.log("- totalStartMinutes:", totalStartMinutes,
            `= ${startHourOfCell}×60 + ${startMinutesRounded}`);
    console.log("- Giờ thực tế:", Math.floor(totalStartMinutes / 60),
            ":", totalStartMinutes % 60);

// ⭐️ QUAN TRỌNG: KIỂM TRA 3-GIỜ LỆCH
    const expectedHour = startHourOfCell + (startMinutesRounded / 60);
    console.log("- Giờ dự kiến trong ô:", expectedHour.toFixed(2));
    console.log("- Chênh lệch với startHourOfCell:", (expectedHour - startHourOfCell).toFixed(2), "giờ");

    if (Math.abs(expectedHour - startHourOfCell - 3) < 0.1) {
        console.error("❌❌❌ PHÁT HIỆN LỖI 3-GIỜ LỆCH!");
        console.error("   startHourOfCell:", startHourOfCell);
        console.error("   expectedHour trong ô:", expectedHour);
        console.error("   Difference:", expectedHour - startHourOfCell);
    }


    console.log("⏰ Time calculations:");
    console.log("  Total start minutes:", totalStartMinutes);
    console.log("  Start hour/minute:", actualStartHour, ":", startMinute);
    console.log("  Total end minutes:", totalEndMinutes);
    console.log("  End hour/minute:", actualEndHour, ":", endMinute);

    // ⭐️ QUAN TRỌNG: Sửa format thời gian
    // Gọi hàm formatMinutesToHHMMSS để có format đúng "HH:MM:SS SA/CH"
    const startTime = window.formatMinutesToHHMMSS ?
            window.formatMinutesToHHMMSS(totalStartMinutes) :
            `${String(actualStartHour).padStart(2, '0')}:${String(startMinute).padStart(2, '0')}:00 ${actualStartHour >= 12 ? 'CH' : 'SA'}`;

    const endTime = window.formatMinutesToHHMMSS ?
            window.formatMinutesToHHMMSS(totalEndMinutes) :
            `${String(actualEndHour).padStart(2, '0')}:${String(endMinute).padStart(2, '0')}:00 ${actualEndHour >= 12 ? 'CH' : 'SA'}`;

    console.log("🕐 Formatted times:");
    console.log("  Start time:", startTime);
    console.log("  End time:", endTime);

    // --- 2. Tạo khối sự kiện TẠM THỜI (TEMP EVENT) ---
    const eventElement = document.createElement('div');
    eventElement.className = 'calendar-event temp-event bg-blue-100 border-blue-400'; // Thêm class tạm thời để dễ dàng tìm/xóa
    eventElement.style.top = `${finalTop}px`;
    eventElement.style.height = `${finalHeight}px`;

// Hiển thị thời gian dạng ngắn cho UI
    const displayStart = `${String(actualStartHour).padStart(2, '0')}:${String(startMinute).padStart(2, '0')}`;
    const displayEnd = `${String(actualEndHour).padStart(2, '0')}:${String(endMinute).padStart(2, '0')}`;

    eventElement.innerHTML = `
        <div class="resize-handle top-handle" data-handle="top"></div> 
        <span class="p-1 text-blue-800 text-xs font-semibold truncate">${displayStart} – ${displayEnd}</span>
        <div class="resize-handle bottom-handle" data-handle="bottom"></div> 
    `;

    parentCell.appendChild(eventElement);
    console.log("✅ Temp event created and appended");

    setTimeout(() => {
        console.log("🔍 DEBUG 4: ACTUAL POSITION CHECK");

        const eventRect = eventElement.getBoundingClientRect();
        const cellRect = parentCell.getBoundingClientRect();

        console.log("- Event actual top (relative to cell):", eventRect.top - cellRect.top, "px");
        console.log("- Event style.top:", eventElement.style.top);
        console.log("- Cell height:", cellRect.height, "px");
        console.log("- Cell top in page:", cellRect.top, "px");
        console.log("- Event top in page:", eventRect.top, "px");

        // Tính toán thời gian từ vị trí thực tế
        const actualTop = eventRect.top - cellRect.top;
        const actualMinutes = actualTop / PIXELS_PER_MINUTE;
        const actualHourInCell = actualMinutes / 60;
        const actualTotalMinutes = (startHourOfCell * 60) + actualMinutes;

        console.log("- Actual minutes in cell:", actualMinutes);
        console.log("- Actual hour in cell:", actualHourInCell.toFixed(2));
        console.log("- Actual total minutes:", actualTotalMinutes);
        console.log("- Actual time:", Math.floor(actualTotalMinutes / 60), ":", Math.round(actualTotalMinutes % 60));

        // So sánh với dự kiến
        console.log("📊 COMPARISON:");
        console.log("  Expected top:", finalTop, "px");
        console.log("  Actual top:", actualTop, "px");
        console.log("  Difference:", actualTop - finalTop, "px");
        console.log("  Difference in hours:", (actualTop - finalTop) / 80, "giờ");

        // Kiểm tra CSS
        const computedStyle = window.getComputedStyle(eventElement);
        console.log("🎨 COMPUTED STYLES:");
        console.log("  top:", computedStyle.top);
        console.log("  position:", computedStyle.position);
        console.log("  transform:", computedStyle.transform);
        console.log("  margin-top:", computedStyle.marginTop);
    }, 100);

    // ⭐️ THÊM: Gắn handlers cho sự kiện TẠM THỜI
    if (window.attachResizeHandlers) {
        window.attachResizeHandlers(eventElement);
        console.log("🔗 Resize handlers attached");
    }

    if (window.attachDragHandlers) {
        window.attachDragHandlers(eventElement);
        console.log("🔗 Drag handlers attached");
    }

    // Lưu thông tin vị trí vào eventElement
    eventElement.dataset.dayIndex = dayIndex;
    eventElement.dataset.startTime = startTime; // Lưu format đầy đủ
    eventElement.dataset.endTime = endTime;     // Lưu format đầy đủ
    eventElement.dataset.startMinutes = totalStartMinutes;
    eventElement.dataset.endMinutes = totalEndMinutes;

    console.log("📊 Event element dataset:", eventElement.dataset);

    // --- 3. GỌI MODAL DỮ LIỆU ---
    console.log("📞 Calling openTaskDetailModalFromSchedule...");
    if (window.openTaskDetailModalFromSchedule) {
        window.openTaskDetailModalFromSchedule(
                eventElement,
                dayOfWeek,
                startTime,
                endTime,
                DEFAULT_DURATION_MINUTES
                );
        console.log("✅ Modal opened");
    } else {
        console.error("❌ openTaskDetailModalFromSchedule not available!");
    }

    console.log("🎯 createDefaultEvent COMPLETED\n");
}

// =================================================================
// 4. LOGIC RESIZE (KÉO TAY CẦM) (Giữ nguyên)
// =================================================================

function attachResizeHandlers(eventElement) {
    eventElement.querySelectorAll('.resize-handle').forEach(handle => {
        handle.addEventListener('mousedown', startResize);
    });
}

function startResize(e) {
    if (e.button !== 0)
        return;
    e.preventDefault();
    e.stopPropagation();

    // 1. Lấy event element
    const eventElement = e.target.closest('.calendar-event');
    if (!eventElement) {
        return;
    }

    // ⭐️ LOGIC CHẶN CHÍNH THỨC: Chặn nếu KHÔNG phải tạm thời VÀ CÓ Schedule ID
    if (!eventElement.classList.contains('temp-event') && eventElement.dataset.scheduleId) {
        console.log("Resize chặn: Sự kiện chính thức.");
        return;
    }

    // 2. Tiếp tục thao tác cho sự kiện tạm thời
    isResizing = true;
    currentEvent = eventElement; // Gán eventElement chính xác
    resizeHandle = e.target; // Gán handle chính xác

    // Lưu trạng thái ban đầu của sự kiện
    currentEvent.dataset.originalTop = currentEvent.style.top;
    currentEvent.dataset.originalHeight = currentEvent.style.height;

    currentEvent.classList.add('resizing');
};

function duringResize(e) {
    if (!isResizing || !currentEvent)
        return;

    const parentCell = currentEvent.closest('.calendar-day-cell');
    const cellRect = parentCell.getBoundingClientRect();
    let currentY = e.clientY - cellRect.top;
    let currentTop = parseFloat(currentEvent.style.top);
    let currentHeight = parseFloat(currentEvent.style.height);

    let deltaY = currentY - (currentTop + (resizeHandle.classList.contains('top-handle') ? 0 : currentHeight));

    if (resizeHandle.classList.contains('top-handle')) {
        currentTop = currentTop + deltaY;
        currentHeight = currentHeight - deltaY;

        if (currentHeight < (15 * PIXELS_PER_MINUTE)) {
            currentHeight = (15 * PIXELS_PER_MINUTE);
            currentTop = parseFloat(currentEvent.style.top);
        }

        currentEvent.style.top = `${currentTop}px`;
        currentEvent.style.height = `${currentHeight}px`;

    } else if (resizeHandle.classList.contains('bottom-handle')) {
        currentHeight = currentHeight + deltaY;

        if (currentHeight < (15 * PIXELS_PER_MINUTE)) {
            currentHeight = (15 * PIXELS_PER_MINUTE);
        }

        currentEvent.style.height = `${currentHeight}px`;
    }
    updateEventTimeDisplay(currentEvent);
}

function endResize(e) {
    if (!isResizing || !currentEvent)
        return;

    isResizing = false;
    currentEvent.classList.remove('resizing');

    let finalTop = parseFloat(currentEvent.style.top);
    let finalHeight = parseFloat(currentEvent.style.height);

    // Tính toán làm tròn (Duy trì logic làm tròn của bạn)
    const intervalPixels = 15 * PIXELS_PER_MINUTE;
    const roundedTop = Math.round(finalTop / intervalPixels) * intervalPixels;
    const roundedHeight = Math.round(finalHeight / intervalPixels) * intervalPixels;

    currentEvent.style.top = `${roundedTop}px`;
    currentEvent.style.height = `${roundedHeight}px`;

    updateEventTimeDisplay(currentEvent); // Cập nhật HH:MM hiển thị dựa trên rounded Top/Height

    // --- CHUẨN BỊ DỮ LIỆU KIỂM TRA VA CHẠM ---

    // Tính toán thời gian mới (HH:MM:SS)
    const startMinutesOffset = Math.round(roundedTop / PIXELS_PER_MINUTE);
    const durationMinutes = Math.round(roundedHeight / PIXELS_PER_MINUTE);
    const actualStartMinutes = (START_HOUR * 60) + startMinutesOffset;
    const actualEndMinutes = actualStartMinutes + durationMinutes;

    const newDayIndex = currentEvent.dataset.dayIndex;
    const newDayOfWeek = DAYS_OF_WEEK[parseInt(newDayIndex) - 1];

    // Sử dụng hàm formatMinutesToHHMMSS đã được định nghĩa ở nơi khác
    const newStartTime = window.formatMinutesToHHMMSS(actualStartMinutes);
    const newEndTime = window.formatMinutesToHHMMSS(actualEndMinutes);
    const currentScheduleId = currentEvent.dataset.scheduleId;

// 1. 🛡️ KIỂM TRA VA CHẠM TRƯỚC KHI LƯU
    const hasCollisionResize = window.checkCollision && window.checkCollision(newDayOfWeek, newStartTime, newEndTime, currentScheduleId);

    if (hasCollisionResize) {

        console.error(">>> KHOA-TASKS: Va chạm khi RESIZE. Bắt đầu hoàn tác!");
        alert("Lỗi: Không thể thay đổi kích thước sự kiện. Thời gian này đã bị chiếm dụng.");

        // --- HOÀN TÁC (REVERT) VỀ TRẠNG THÁI GỐC ---
        currentEvent.style.top = currentEvent.dataset.originalTop;
        currentEvent.style.height = currentEvent.dataset.originalHeight;
        updateEventTimeDisplay(currentEvent); // Cập nhật lại HH:MM gốc

        // Reset trạng thái và kết thúc
        resizeHandle = null;
        currentEvent = null;
        return; // DỪNG LẠI, KHÔNG CHẠY LOGIC CẬP NHẬT
    }

    // 2. ✅ NẾU KHÔNG CÓ VA CHẠM (Tiếp tục Logic cập nhật của bạn)

    // Cập nhật dataset (sử dụng newStartTime/newEndTime đã tính toán)
    currentEvent.dataset.startTime = newStartTime;
    currentEvent.dataset.endTime = newEndTime;

    // ⭐️ Xử lý Sự kiện TẠM THỜI (Cập nhật Form)
    if (currentEvent.classList.contains('temp-event')) {
        // ... (Logic tính toán form và gọi window.updateTaskFormDuration của bạn giữ nguyên, 
        //      chỉ cần thay thế startTimeRaw bằng newStartTime và endTimeRaw bằng newEndTime)

        // Lấy DayOfWeek và Duration (đã tính ở trên)
        // TÍNH DATE VÀ CẬP NHẬT FORM
        const [startHour, startMinute] = newStartTime.split(':').map(Number);
        const calculatedDate = window.getDateFromDayAndHour(newDayOfWeek, startHour);
        calculatedDate.setMinutes(startMinute);
        const formattedDeadline = window.formatForInput(calculatedDate);

        if (window.updateTaskFormDuration) {
            window.updateTaskFormDuration(durationMinutes, formattedDeadline, newDayOfWeek);
        }
    }

    // ⭐️ Xử lý Sự kiện ĐÃ LƯU (Gọi Backend)
    if (currentEvent.dataset.scheduleId) {
        const scheduleId = currentEvent.dataset.scheduleId;
        window.updateScheduleTimeBackend(scheduleId, newDayOfWeek, newStartTime, newEndTime);
    }

    resizeHandle = null;
    currentEvent = null;
};

// =================================================================
// 5. LOGIC DI CHUYỂN (DRAG-AND-DROP) ĐÃ SỬA
// =================================================================

function attachDragHandlers(eventElement) {
    eventElement.addEventListener('mousedown', startMove);
}

function startMove(e) {
    if (e.target.classList.contains('resize-handle')) {
        return;
    }

    const eventElement = e.target.closest('.calendar-event'); // Lấy event element
    if (!eventElement) {
        return;
    }

    // ⭐️ CHỈ CHO PHÉP MOVE NẾU DỮ LIỆU ĐÃ TẢI XONG
    if (!isScheduleLoaded) {
        console.warn("Chặn thao tác: Dữ liệu lịch chưa tải xong.");
        return;
    }

    // ⭐️ LOGIC CHẶN CHÍNH THỨC: Chặn nếu KHÔNG phải tạm thời VÀ CÓ Schedule ID
    if (!eventElement.classList.contains('temp-event') && eventElement.dataset.scheduleId) {
        console.log("Move chặn: Sự kiện chính thức.");
        return;
    }

    if (e.button !== 0)
        return;
    e.preventDefault();
    e.stopPropagation();

    isDragging = true;
    currentEventToMove = eventElement; // Gán eventElement chính xác

    dragStartY = e.clientY;
    dragStartTop = parseFloat(currentEventToMove.style.top);

    // Lưu trạng thái ban đầu của sự kiện
    currentEventToMove.dataset.originalDayIndex = currentEventToMove.dataset.dayIndex;
    currentEventToMove.dataset.originalTop = currentEventToMove.style.top;

    currentEventToMove.classList.add('dragging');
};

/**
 * HÀM duringMove ĐÃ CHỈNH SỬA
 */
function duringMove(e) {
    if (!isDragging || !currentEventToMove)
        return;
    if (isResizing)
        return;

    const deltaY = e.clientY - dragStartY;
    let newTop = dragStartTop + deltaY;

    // 1. TÌM VỊ TRÍ MỚI VÀ XỬ LÝ CHUYỂN NGÀY
    const elementUnderMouse = document.elementFromPoint(e.clientX, e.clientY);
    const targetContainer = elementUnderMouse ? elementUnderMouse.closest('.calendar-day-cell') : null;

    if (targetContainer) {
        const targetDayIndex = parseInt(targetContainer.dataset.dayIndex);
        const newDayOfWeek = DAYS_OF_WEEK[targetDayIndex - 1];

        // Tìm ô gốc của ngày đích
        const firstCellOfDayTarget = document.querySelector(`.calendar-day-cell[data-day-index="${targetDayIndex}"][data-hour="${START_HOUR}"]`);
        if (!firstCellOfDayTarget)
            return;

        // --- ⭐️ LOGIC CHẶN VA CHẠM (BLOCKING) ⭐️ ---

        // A. Giả lập tính toán thời gian tại vị trí chuột mới
        const eventHeight = parseFloat(currentEventToMove.style.height);
        const startMinutesOffset = Math.round(newTop / PIXELS_PER_MINUTE);
        const durationMinutes = Math.round(eventHeight / PIXELS_PER_MINUTE);

        const testStartMinutes = (START_HOUR * 60) + startMinutesOffset;
        const testEndMinutes = testStartMinutes + durationMinutes;

        const testStartTime = window.formatMinutesToHHMMSS(testStartMinutes);
        const testEndTime = window.formatMinutesToHHMMSS(testEndMinutes);
        const scheduleId = currentEventToMove.dataset.scheduleId; // Loại trừ chính nó nếu đang di chuyển task cũ

        // B. Kiểm tra va chạm với các task đã lưu
        const isCollision = window.checkCollision && window.checkCollision(newDayOfWeek, testStartTime, testEndTime, scheduleId);

        if (isCollision) {
            // NẾU VA CHẠM: Dừng hàm tại đây, không cập nhật style.top mới.
            // Điều này làm task "khựng lại" khi chạm vào vật cản.
            return;
        }

        // --- NẾU KHÔNG VA CHẠM: TIẾP TỤC DI CHUYỂN ---

        // XỬ LÝ DI CHUYỂN XUYÊN NGÀY
        const currentParentCell = currentEventToMove.parentElement;
        if (firstCellOfDayTarget !== currentParentCell) {
            const eventRect = currentEventToMove.getBoundingClientRect();
            const currentAbsoluteTop = eventRect.top;

            currentEventToMove.remove();
            firstCellOfDayTarget.appendChild(currentEventToMove);

            const newFirstCellRect = firstCellOfDayTarget.getBoundingClientRect();
            const newRelativeTop = currentAbsoluteTop - newFirstCellRect.top;

            currentEventToMove.dataset.dayIndex = targetDayIndex;
            dragStartY = e.clientY;
            dragStartTop = newRelativeTop;
            newTop = newRelativeTop;
        }

        // 2. GIỚI HẠN KÉO DỌC (Top/Bottom)
        const totalDayHeight = (END_HOUR - START_HOUR) * PIXELS_PER_HOUR;
        if (newTop < 0)
            newTop = 0;
        if (newTop + eventHeight > totalDayHeight)
            newTop = totalDayHeight - eventHeight;

        // Cập nhật vị trí và hiển thị thời gian
        currentEventToMove.style.top = `${newTop}px`;
        updateEventTimeDisplay(currentEventToMove);
    }
};

/**
 * HÀM endMove ĐÃ TÁCH RA NGOÀI VÀ CHỈNH SỬA
 */
function endMove(e) {
    if (!isDragging || !currentEventToMove)
        return;

    // ⭐️ CHỈ CHO PHÉP MOVE NẾU DỮ LIỆU ĐÃ TẢI XONG
    if (!isScheduleLoaded) {
        console.warn("Chặn thao tác: Dữ liệu lịch chưa tải xong.");
        return;
    }

    isDragging = false;
    currentEventToMove.classList.remove('dragging');

    // 1. LÀM TRÒN VỊ TRÍ CUỐI CÙNG (roundedTop)
    let finalTop = parseFloat(currentEventToMove.style.top);
    const intervalPixels = 15 * PIXELS_PER_MINUTE;
    const roundedTop = Math.round(finalTop / intervalPixels) * intervalPixels;
    currentEventToMove.style.top = `${roundedTop}px`;

    // Cập nhật HH:MM hiển thị dựa trên roundedTop (cần để tính toán thời gian mới)
    updateEventTimeDisplay(currentEventToMove);

    // --- CHUẨN BỊ DỮ LIỆU KIỂM TRA VA CHẠM ---

    // Tính toán thời gian mới dựa trên roundedTop
    const eventHeight = parseFloat(currentEventToMove.style.height);
    const startMinutesOffset = Math.round(roundedTop / PIXELS_PER_MINUTE);
    const durationMinutes = Math.round(eventHeight / PIXELS_PER_MINUTE);
    const actualStartMinutes = (START_HOUR * 60) + startMinutesOffset;
    const actualEndMinutes = actualStartMinutes + durationMinutes;

    const newDayIndex = currentEventToMove.dataset.dayIndex;
    const newDayOfWeek = DAYS_OF_WEEK[parseInt(newDayIndex) - 1];

    // Sử dụng hàm formatMinutesToHHMMSS đã được định nghĩa
    const newStartTime = window.formatMinutesToHHMMSS(actualStartMinutes);
    const newEndTime = window.formatMinutesToHHMMSS(actualEndMinutes);
    const currentScheduleId = currentEventToMove.dataset.scheduleId; // Có thể là undefined/null cho temp-event

    // 2. 🛡️ KIỂM TRA VA CHẠM TRƯỚC KHI LƯU
    const hasCollisionMove = window.checkCollision && window.checkCollision(newDayOfWeek, newStartTime, newEndTime, currentScheduleId);

    if (hasCollisionMove) {

        console.error(">>> KHOA-TASKS: Va chạm khi MOVE. Bắt đầu hoàn tác!");
        alert("Lỗi: Không thể di chuyển sự kiện. Vị trí và thời gian này đã bị chiếm dụng bởi sự kiện khác.");

        // --- HOÀN TÁC (REVERT) VỀ TRẠNG THÁI GỐC ---
        const originalDayIndex = currentEventToMove.dataset.originalDayIndex;
        const originalTop = currentEventToMove.dataset.originalTop;

        // A. Xử lý trường hợp chuyển ngày: Chuyển event về ô ngày gốc
        const originalCell = document.querySelector(`.calendar-day-cell[data-day-index="${originalDayIndex}"][data-hour="${START_HOUR}"]`);
        if (originalCell && originalCell !== currentEventToMove.parentElement) {
            currentEventToMove.remove();
            originalCell.appendChild(currentEventToMove);
        }

        // B. Đặt lại vị trí top và day index
        currentEventToMove.style.top = originalTop;
        currentEventToMove.dataset.dayIndex = originalDayIndex;
        updateEventTimeDisplay(currentEventToMove); // Cập nhật HH:MM hiển thị gốc

        // Reset trạng thái
        currentEventToMove = null;
        return; // DỪNG LẠI, KHÔNG LƯU LẠI VỊ TRÍ VA CHẠM
    }

    // 3. ✅ NẾU KHÔNG CÓ VA CHẠM (Logic cập nhật cũ của bạn)

    // Cập nhật Day Index và Thời gian Mới chính thức
    currentEventToMove.dataset.startTime = newStartTime; // Cập nhật dataset với thời gian mới (HH:MM:SS)
    currentEventToMove.dataset.endTime = newEndTime;

    // ⭐️ Xử lý Sự kiện TẠM THỜI (Cập nhật Form)
//    if (currentEventToMove.classList.contains('temp-event')) {
//        // Logic cập nhật form task (Giữ nguyên logic cũ, chỉ thay startTimeRaw bằng newStartTime)
//        const dayOfWeek = DAYS_OF_WEEK[parseInt(newDayIndex) - 1];
//        const durationMinutes = Math.round(eventHeight / PIXELS_PER_MINUTE); 
//
//        // TÍNH DATE VÀ CẬP NHẬT FORM
//        const [startHour, startMinute] = newStartTime.split(':').map(Number);
//        const calculatedDate = window.getDateFromDayAndHour(dayOfWeek, startHour);
//        calculatedDate.setMinutes(startMinute);
//        const formattedDeadline = window.formatForInput(calculatedDate);
//
//        if (window.updateTaskFormDuration) {
//            window.updateTaskFormDuration(durationMinutes, formattedDeadline, dayOfWeek); 
//        }
//    }
    if (currentEventToMove.classList.contains('temp-event')) {
        // Parse thời gian mới
        const [startHour, startMinute, startSecond] = newStartTime.split(':').map(Number);

        // ⭐️ QUAN TRỌNG: Gọi đúng hàm với các tham số
        if (window.updateTaskFormDuration) {
            // Tính toán duration từ roundedHeight
            const eventHeight = parseFloat(currentEventToMove.style.height);
            const durationMinutes = Math.round(eventHeight / PIXELS_PER_MINUTE);

            console.log("📝 Calling updateTaskFormDuration:", {
                duration: durationMinutes,
                startTime: newStartTime,
                dayOfWeek: newDayOfWeek
            });

            window.updateTaskFormDuration(durationMinutes, newStartTime, newDayOfWeek);
        }
    }

    // ⭐️ Xử lý Sự kiện ĐÃ LƯU (Gọi Backend)
    if (currentEventToMove.dataset.scheduleId) {
        const scheduleId = currentEventToMove.dataset.scheduleId;
        window.updateScheduleTimeBackend(scheduleId, newDayOfWeek, newStartTime, newEndTime);
    }

    currentEventToMove = null;
};

// =================================================================
// 6. CÁC HÀM TIỆN ÍCH (Giữ nguyên)
// =================================================================

//function endMove(e) {
//    if (!isDragging || !currentEventToMove)
//        return;
//
//    isDragging = false;
//    currentEventToMove.classList.remove('dragging');
//
//    // --- LÀM TRÒN VỊ TRÍ CUỐI CÙNG ---
//    let finalTop = parseFloat(currentEventToMove.style.top);
//
//    const intervalPixels = 15 * PIXELS_PER_MINUTE;
//    const roundedTop = Math.round(finalTop / intervalPixels) * intervalPixels;
//
//    currentEventToMove.style.top = `${roundedTop}px`;
//
//    // --- Cập nhật Day Index Mới (Lấy từ event.dataset) ---
//    // Vì event đã được chuyển sang ô gốc của ngày mới (nếu có), ta chỉ cần lấy dayIndex
//    const newDayIndex = currentEventToMove.dataset.dayIndex;
//
//    // Tìm giờ bắt đầu thực tế của cột gốc
//    const newCell = currentEventToMove.closest('.calendar-day-cell');
//    const startHourOfCell = parseInt(newCell.querySelector('.schedule-container').dataset.hour); // Sẽ là 7 (START_HOUR)
//
//    // Cập nhật và Xử lý Sau khi Thả
//    updateEventTimeDisplay(currentEventToMove);
//
//    currentEventToMove = null;
//}



// ⭐️ HÀM MỚI: Tạo DOM cho sự kiện ĐÃ LÊN LỊCH (Được gọi bởi tasks.js/renderCalendar)
function createScheduledEventDiv(eventData) {
    console.log("🔧 ===== DEBUG createScheduledEventDiv =====");
    console.log("Input:", eventData);
    console.log("🔍 DEBUG START_HOUR:", START_HOUR);
    console.log("🔍 DEBUG PIXELS_PER_MINUTE:", PIXELS_PER_MINUTE);
    
    const eventDiv = document.createElement('div');
    eventDiv.className = 'calendar-event';

    if (eventData.type) {
        eventDiv.classList.add(`type-${eventData.type.toLowerCase().replace(/\s+/g, '-')}`);
    } else {
        // Mặc định nếu không có type
        eventDiv.classList.add('type-personal');
    }
    
    console.log("📌 Schedule ID:", eventData.scheduleId, "Task ID:", eventData.taskId);

    // ⭐️ THÊM: Đánh dấu event đã được lưu (không phải temp)
    if (eventData.scheduleId && eventData.scheduleId !== "null" && eventData.scheduleId !== "0") {
        eventDiv.classList.add('saved-event');
        eventDiv.title = "Đã lên lịch (Click để xem chi tiết)";
    } else {
        eventDiv.classList.add('temp-event');
        eventDiv.title = "Chưa lưu (Click để tạo task)";
    }

    // 1. Gắn Data ID Vĩnh Viễn
    eventDiv.dataset.scheduleId = eventData.scheduleId;
    eventDiv.dataset.taskId = eventData.taskId;

    // 2. ⭐️ SỬA QUAN TRỌNG: Tính toán Top và Height với xử lý AM/PM
    console.log("🕐 Parsing times:", {
        startTime: eventData.startTime,
        endTime: eventData.endTime
    });
    
    // Sử dụng hàm timeToMinutes từ tasks.js nếu có
    let startMinutes, endMinutes;
    
    if (window.timeToMinutes) {
        // Dùng hàm chuẩn từ tasks.js
        startMinutes = window.timeToMinutes(eventData.startTime);
        endMinutes = window.timeToMinutes(eventData.endTime);
        console.log("✅ Used window.timeToMinutes");
    } else {
        // Fallback: tự parse
        console.warn("⚠️ window.timeToMinutes not found, using fallback");
        startMinutes = parseTimeWithAMPM(eventData.startTime);
        endMinutes = parseTimeWithAMPM(eventData.endTime);
    }
    
    console.log("🔍 DEBUG startMinutes:", startMinutes);
    console.log("🔍 DEBUG minutesOffset tính toán:", startMinutes - (START_HOUR * 60));
    
    console.log("🕐 Calculated minutes:", {
        startMinutes: startMinutes,
        endMinutes: endMinutes,
        startTime: `${Math.floor(startMinutes / 60)}:${startMinutes % 60}`,
        endTime: `${Math.floor(endMinutes / 60)}:${endMinutes % 60}`
    });



//    const minutesOffset = startMinutes - (START_HOUR * 60);
//    const finalTop = minutesOffset * PIXELS_PER_MINUTE;
    const minutesOffset = startMinutes % 60;
    const finalTop =  minutesOffset * PIXELS_PER_MINUTE;

    const durationMinutes = endMinutes - startMinutes;
    const finalHeight = durationMinutes * PIXELS_PER_MINUTE;

    // ⭐️ BỔ SUNG: Áp dụng vị trí và chiều rộng từ logic va chạm
    if (eventData.widthPercentage) {
        eventDiv.style.width = `${eventData.widthPercentage}%`;
    } else {
        eventDiv.style.width = '100%';
    }

    if (eventData.leftPercentage) {
        eventDiv.style.left = `${eventData.leftPercentage}%`;
    } else {
        eventDiv.style.left = '0%';
    }

    console.log("🎨 Top calculation:", {
        startMinutes: startMinutes,
        startHourOfDay: Math.floor(startMinutes / 60),
        startMinute: startMinutes % 60,
        START_HOUR: START_HOUR,
        minutesOffset: minutesOffset,
        finalTop: finalTop,
        PIXELS_PER_MINUTE: PIXELS_PER_MINUTE
    });

    // ⭐️ THÊM: Đảm bảo top không âm
    if (finalTop < 0) {
        console.warn(`⚠️ Top negative (${finalTop}px), setting to 0`);
        eventDiv.style.top = '0px';
    } else {
        eventDiv.style.top = `${finalTop}px`;
    }

    eventDiv.style.height = `${finalHeight}px`;

    // ⭐️ SỬA: Hiển thị thời gian đã format đúng
    const displayStart = formatMinutesToDisplay(startMinutes);
    const displayEnd = formatMinutesToDisplay(endMinutes);
    
    eventDiv.innerHTML = `
        <div class="resize-handle top-handle" data-handle="top"></div>
        <span>${eventData.subject || eventData.title} (${displayStart} – ${displayEnd})</span>
        <div class="resize-handle bottom-handle" data-handle="bottom"></div>
    `;

    console.log("🎨 Event sẽ được tạo tại:", {
        top: eventDiv.style.top,
        height: eventDiv.style.height,
        width: eventDiv.style.width,
        left: eventDiv.style.left,
        displayText: `${displayStart} – ${displayEnd}`
    });
    
    console.log("🔧 ===== END DEBUG =====");

    // Nếu designer script đang dùng `scheduleData`, đồng bộ sự kiện vừa render
    try {
        if (window.scheduleData) {
            const mapToLower = { 'Mon': 'mon', 'Tue': 'tue', 'Wed': 'wed', 'Thu': 'thu', 'Fri': 'fri', 'Sat': 'sat', 'Sun': 'sun' };
            const dayKey = mapToLower[eventData.dayOfWeek] || (eventData.dayOfWeek || '').toLowerCase();
            const startKey = eventData.startTime;

            if (!window.scheduleData[dayKey]) window.scheduleData[dayKey] = {};

            window.scheduleData[dayKey][startKey] = {
                type: eventData.type || 'class',
                name: eventData.subject || eventData.title || 'Untitled',
                color: eventData.color || null,
                endTime: eventData.endTime,
                description: eventData.description || '',
                taskId: eventData.taskId || null
            };
            console.log('🗂️ Synced scheduled event into scheduleData:', dayKey, startKey, window.scheduleData[dayKey][startKey]);
        }
    } catch (err) {
        console.warn('Could not sync scheduled event into scheduleData:', err);
    }

    return eventDiv;
} 

function parseTimeWithAMPM(timeStr) {
    console.log(`⏱️ parseTimeWithAMPM: "${timeStr}"`);
    
    // Tách phần thời gian và AM/PM
    const parts = timeStr.split(' ');
    const timePart = parts[0];
    const ampm = parts.length > 1 ? parts[1].toUpperCase() : '';
    
    const [h, m, s] = timePart.split(':').map(Number);
    let hours = h || 0;
    const minutes = m || 0;
    
    console.log(`  Raw: hours=${hours}, minutes=${minutes}, ampm="${ampm}"`);
    
    // Xử lý AM/PM
    if (ampm === 'CH') {
        // CH = PM
        if (hours === 12) {
            // 12:xx CH = 12:xx
            hours = 12;
        } else if (hours >= 1 && hours <= 11) {
            // 1:xx CH - 11:xx CH = +12
            hours += 12;
        }
    } else if (ampm === 'SA') {
        // SA = AM
        if (hours === 12) {
            // 12:xx SA = 0:xx
            hours = 0;
        }
        // 1:xx SA - 11:xx SA giữ nguyên
    }
    
    const totalMinutes = hours * 60 + minutes;
    console.log(`  Result: ${hours}:${minutes} -> ${totalMinutes} phút`);
    
    return totalMinutes;
}

// ⭐️ THÊM: Hàm format phút thành HH:MM để hiển thị
function formatMinutesToDisplay(minutes) {
    const hours = Math.floor(minutes / 60);
    const mins = minutes % 60;
    
    // Format 24h cho hiển thị
    return `${hours.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}`;
}

// ⭐️ THÊM: Gán hàm parseTimeWithAMPM vào window để dùng chung
window.parseTimeWithAMPM = parseTimeWithAMPM;

function updateEventTimeDisplay(eventElement) {
    const currentTop = parseFloat(eventElement.style.top);
    const currentHeight = parseFloat(eventElement.style.height);

    // BƯỚC 1: Tính toán thời gian bắt đầu (tính từ START_HOUR)
    const startMinutesOffset = Math.round(currentTop / PIXELS_PER_MINUTE);
    const durationMinutes = Math.round(currentHeight / PIXELS_PER_MINUTE);

    const actualStartMinutes = (START_HOUR * 60) + startMinutesOffset;
    const actualEndMinutes = actualStartMinutes + durationMinutes;

    // BƯỚC 2: Chuyển đổi thành HH:MM
    const startHour = Math.floor(actualStartMinutes / 60);
    const startMinute = actualStartMinutes % 60;
    const endHour = Math.floor(actualEndMinutes / 60);
    const endMinute = actualEndMinutes % 60;

    const startTime = `${String(startHour).padStart(2, '0')}:${String(startMinute).padStart(2, '0')}`;
    const endTime = `${String(endHour).padStart(2, '0')}:${String(endMinute).padStart(2, '0')}`;

    // BƯỚC 3: Cập nhật DOM
    const span = eventElement.querySelector('span');
    if (span) {
        // Cập nhật cả nội dung hiển thị và data attributes (nếu cần cho các logic khác)
        span.textContent = `Task (${startTime} – ${endTime})`;
    }
};


// Gán hàm vào window để tasks.js có thể gọi
window.createDefaultEvent = createDefaultEvent;
// ⚠️ BỎ TỪ KHÓA 'function' và gán vào window
window.attachResizeHandlers = function (eventElement) {
    eventElement.querySelectorAll('.resize-handle').forEach(handle => {
        handle.addEventListener('mousedown', startResize);
    });
};

// ⚠️ BỎ TỪ KHÓA 'function' và gán vào window
window.attachDragHandlers = function (eventElement) {
    eventElement.addEventListener('mousedown', startMove);
};

// =================================================================
// 7. THIẾT LẬP BAN ĐẦU
// =================================================================
// Chạy hàm tạo lưới lịch trước
document.addEventListener('DOMContentLoaded', () => {
    //generateCalendarGrid(); 
    setupEvents();
});
