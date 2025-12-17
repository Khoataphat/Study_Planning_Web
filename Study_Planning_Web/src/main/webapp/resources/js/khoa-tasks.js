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
const START_HOUR = 7;
const END_HOUR = 18; // Kết thúc ở mép dưới của 17:00
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

    const parentCell = container; // container chính là .calendar-day-cell
    const startHourOfCell = parseInt(container.dataset.hour);
    const dayIndex = parseInt(container.dataset.dayIndex); // Sử dụng data-day-index (1=Mon, 7=Sun)
    const dayOfWeek = DAYS_OF_WEEK[dayIndex - 1];

    // Tính toán giờ và phút bắt đầu thực tế
    const totalStartMinutes = (startHourOfCell * 60) + startMinutesRounded;
    const actualStartHour = Math.floor(totalStartMinutes / 60);
    const startMinute = totalStartMinutes % 60;

    // Tính toán giờ và phút kết thúc
    const totalEndMinutes = totalStartMinutes + DEFAULT_DURATION_MINUTES;
    const actualEndHour = Math.floor(totalEndMinutes / 60);
    const endMinute = totalEndMinutes % 60;

    const startTime = `${String(actualStartHour).padStart(2, '0')}:${String(startMinute).padStart(2, '0')}`;
    const endTime = `${String(actualEndHour).padStart(2, '0')}:${String(endMinute).padStart(2, '0')}`;

    // --- 2. Tạo khối sự kiện TẠM THỜI (TEMP EVENT) ---
    const eventElement = document.createElement('div');
    eventElement.className = 'calendar-event temp-event bg-blue-100 border-blue-400'; // Thêm class tạm thời để dễ dàng tìm/xóa
    eventElement.style.top = `${finalTop}px`;
    eventElement.style.height = `${finalHeight}px`;

// ⭐️ THAY ĐỔI LÕI: Thêm các tay cầm Resize vào HTML của sự kiện TẠM THỜI
        eventElement.innerHTML = `
        <div class="resize-handle top-handle" data-handle="top"></div> 
        <span class="p-1 text-blue-800 text-xs font-semibold truncate">${startTime} – ${endTime}</span>
        <div class="resize-handle bottom-handle" data-handle="bottom"></div> 
    `;


    parentCell.appendChild(eventElement);

    // ⭐️ THÊM: Gắn handlers cho sự kiện TẠM THỜI
        window.attachResizeHandlers(eventElement);
        window.attachDragHandlers(eventElement);

    // Lưu thông tin vị trí vào eventElement (hữu ích nếu modal cần biết phải xóa/cập nhật cái gì)
    eventElement.dataset.dayIndex = dayIndex;
    eventElement.dataset.startTime = startTime;
    eventElement.dataset.endTime = endTime;

    // --- 3. GỌI MODAL DỮ LIỆU ---
    // Giao eventElement tạm thời cho modal để modal có thể xóa nó nếu Hủy, 
    // hoặc chuyển đổi nó thành sự kiện chính thức nếu Lưu.
    window.openTaskDetailModalFromSchedule(
            eventElement, // Tham số 1
            dayOfWeek, // Tham số 2
            startTime, // Tham số 3
            endTime, // Tham số 4
            DEFAULT_DURATION_MINUTES // Tham số 5
            );
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
}

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
}

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
}

/**
 * HÀM duringMove ĐÃ CHỈNH SỬA
 */
function duringMove(e) {
    if (!isDragging || !currentEventToMove) return;
    if (isResizing) return;

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
        if (!firstCellOfDayTarget) return;

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
        if (newTop < 0) newTop = 0;
        if (newTop + eventHeight > totalDayHeight) newTop = totalDayHeight - eventHeight;

        // Cập nhật vị trí và hiển thị thời gian
        currentEventToMove.style.top = `${newTop}px`;
        updateEventTimeDisplay(currentEventToMove);
    }
}

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
    if (currentEventToMove.classList.contains('temp-event')) {
        // Logic cập nhật form task (Giữ nguyên logic cũ, chỉ thay startTimeRaw bằng newStartTime)
        const dayOfWeek = DAYS_OF_WEEK[parseInt(newDayIndex) - 1];
        const durationMinutes = Math.round(eventHeight / PIXELS_PER_MINUTE); 

        // TÍNH DATE VÀ CẬP NHẬT FORM
        const [startHour, startMinute] = newStartTime.split(':').map(Number);
        const calculatedDate = window.getDateFromDayAndHour(dayOfWeek, startHour);
        calculatedDate.setMinutes(startMinute);
        const formattedDeadline = window.formatForInput(calculatedDate);

        if (window.updateTaskFormDuration) {
            window.updateTaskFormDuration(durationMinutes, formattedDeadline, dayOfWeek); 
        }
    }

    // ⭐️ Xử lý Sự kiện ĐÃ LƯU (Gọi Backend)
    if (currentEventToMove.dataset.scheduleId) {
        const scheduleId = currentEventToMove.dataset.scheduleId;
        window.updateScheduleTimeBackend(scheduleId, newDayOfWeek, newStartTime, newEndTime);
    }

    currentEventToMove = null;
}

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
    console.log("🔧 createScheduledEventDiv được gọi với:", eventData);
    const eventDiv = document.createElement('div');
    eventDiv.className = 'calendar-event';
    
    console.log("📌 Schedule ID:", eventData.scheduleId, "Task ID:", eventData.taskId);

    // 1. Gắn Data ID Vĩnh Viễn
    eventDiv.dataset.scheduleId = eventData.scheduleId;
    eventDiv.dataset.taskId = eventData.taskId;

    // 2. Tính toán Top và Height dựa trên thời gian
    const start = eventData.startTime.split(':').map(Number);
    const end = eventData.endTime.split(':').map(Number);

    const startMinutes = (start[0] * 60) + start[1];
    const endMinutes = (end[0] * 60) + end[1];

    const minutesOffset = startMinutes - (START_HOUR * 60);
    const finalTop = minutesOffset * PIXELS_PER_MINUTE;

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

    eventDiv.style.top = `${finalTop}px`;
    eventDiv.style.height = `${finalHeight}px`;

    eventDiv.innerHTML = `
        <div class="resize-handle top-handle" data-handle="top"></div>
        <span>${eventData.subject || eventData.title} (${eventData.startTime.substring(0, 5)} – ${eventData.endTime.substring(0, 5)})</span>
        <div class="resize-handle bottom-handle" data-handle="bottom"></div>
    `;

        console.log("🎨 Event sẽ được tạo tại:", {
        top: eventDiv.style.top,
        height: eventDiv.style.height,
        width: eventDiv.style.width,
        left: eventDiv.style.left
    });
    
    
    return eventDiv;
}

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
}


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
