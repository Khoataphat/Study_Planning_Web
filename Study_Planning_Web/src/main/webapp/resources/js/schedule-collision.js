/**
 * Kiểm tra xem sự kiện mới có va chạm với các sự kiện đã lưu khác.
 * @param {string} newDayOfWeek - Ngày (vd: 'Mon', 'Tue').
 * @param {string} newStartTimeStr - Giờ bắt đầu mới (HH:MM:SS).
 * @param {string} newEndTimeStr - Giờ kết thúc mới (HH:MM:SS).
 * @param {string} currentScheduleId - ID của sự kiện hiện tại (để loại trừ chính nó).
 * @returns {boolean} True nếu có va chạm, False nếu không.
 */
function checkCollision(newDayOfWeek, newStartTimeStr, newEndTimeStr, currentScheduleId) {
    console.log("--- Bắt đầu checkCollision ---");
    console.log(`Kiểm tra sự kiện mới: ID=${currentScheduleId}, Ngày=${newDayOfWeek}, Bắt đầu=${newStartTimeStr}, Kết thúc=${newEndTimeStr}`);

    if (!window.weeklySchedule) {
        console.warn("Lỗi: window.weeklySchedule chưa được tải.");
        return false;
    }

    const dayTasks = window.weeklySchedule[newDayOfWeek];
    if (!dayTasks || dayTasks.length === 0) {
        console.log(`Không có sự kiện đã lưu nào cho ngày ${newDayOfWeek}.`);
        return false;
    }

    const timeToMinutes = (timeStr) => {
        const parts = timeStr.split(' ');
        const timePart = parts[0]; 
        const ampm = parts.length > 1 ? parts[1].toUpperCase() : ''; 
        const [h, m] = timePart.split(':').map(Number);
        let hour = h;

        // Chuyển đổi sang 24h
        if (ampm === 'CH') { // PM (Chiều)
            if (hour < 12) {
                hour += 12;
            }
        } else if (ampm === 'SA') { // AM (Sáng)
            if (hour === 12) {
                hour = 0;
            }
        }
        return hour * 60 + m; 
    };

    const newStart = timeToMinutes(newStartTimeStr);
    const newEnd = timeToMinutes(newEndTimeStr);

    console.log(`Thời gian sự kiện mới (phút): [${newStart} - ${newEnd}]`);

    for (const task of dayTasks) {
        // Bỏ qua chính sự kiện đang được di chuyển/resize (chỉ áp dụng nếu là sự kiện đã lưu)
        if (task.scheduleId == currentScheduleId) {
            console.log(`Bỏ qua: Chính sự kiện đang được thao tác (ID: ${task.scheduleId})`);
            continue;
        }

        const existingStart = timeToMinutes(task.startTime);
        const existingEnd = timeToMinutes(task.endTime);

        const isCollision = (newStart < existingEnd && newEnd > existingStart);
        
        console.log(`\nKiểm tra Va chạm với Saved Task ID ${task.scheduleId}:`);
        console.log(`  Saved Task: [${task.startTime} - ${task.endTime}] -> [${existingStart} - ${existingEnd}] phút`);
        console.log(`  So sánh: (${newStart} < ${existingEnd} && ${newEnd} > ${existingStart})`);

        if (isCollision) {
            console.error("!!! ❌ VA CHẠM ĐƯỢC PHÁT HIỆN. Hủy thao tác.");
            console.log("--- Kết thúc checkCollision (VA CHẠM) ---");
            return true; // Có va chạm
        }
    }
    
    console.log("--- ✅ Kết thúc checkCollision (KHÔNG VA CHẠM) ---");
    return false; // Không có va chạm
}

window.checkCollision = checkCollision;  // Gán ra window để có thể truy cập

function formatMinutesToHHMMSS(totalMinutes) {
    const hour = Math.floor(totalMinutes / 60);
    const minute = totalMinutes % 60;
    const second = 0;
    
    // Format với AM/PM nếu cần
    let ampm = 'SA'; // Sáng
    let displayHour = hour;
    
    if (hour >= 12) {
        ampm = 'CH'; // Chiều
        if (hour > 12) displayHour = hour - 12;
    }
    if (hour === 0) displayHour = 12;
    
    // Trả về format "HH:MM:SS SA/CH"
    return `${String(hour).padStart(2, '0')}:${String(minute).padStart(2, '0')}:${String(second).padStart(2, '0')} ${ampm}`;
}
window.formatMinutesToHHMMSS = formatMinutesToHHMMSS;

/**
 * Tính toán vị trí và chiều rộng cho các sự kiện bị chồng chéo trong một ngày.
 * @param {Array} dayEvents - Mảng các sự kiện trong ngày (cần có startMinutes và endMinutes).
 * @returns {Array} Mảng sự kiện đã được bổ sung thuộc tính width và left.
 */
function calculateEventPositions(dayEvents) {
    if (!dayEvents || dayEvents.length === 0) return [];

    // 1. Chuyển đổi thời gian: Nếu chưa có startMinutes/endMinutes, cần tính toán ở đây.
    // Giả sử dữ liệu đầu vào đã được tiền xử lý để có startMinutes/endMinutes.
    
    // Sắp xếp theo thời gian bắt đầu
    dayEvents.sort((a, b) => a.startMinutes - b.startMinutes);

    const positionedEvents = [];

    dayEvents.forEach(event => {
        const eventStart = event.startMinutes; 
        const eventEnd = event.endMinutes;     

        // 2. Tìm các sự kiện đã định vị va chạm với sự kiện hiện tại
        const overlappingEvents = positionedEvents.filter(pEvent => {
            return eventStart < pEvent.endMinutes && eventEnd > pEvent.startMinutes;
        });

        // 3. Tính toán Depth và Index
        const depth = overlappingEvents.length + 1; // Bao gồm cả sự kiện hiện tại

        // Cập nhật lại chiều rộng của tất cả sự kiện va chạm để chúng phù hợp với depth mới
        // (Đây là phần phức tạp nhất, nhưng quan trọng)
        overlappingEvents.forEach(pEvent => {
            pEvent.width = 100 / depth;
        });

        // 4. Tìm vị trí ngang (Horizontal Index) còn trống cho sự kiện hiện tại
        let availableIndex = 0;
        let occupiedIndices = overlappingEvents.map(pEvent => pEvent.horizontalIndex);
        
        while (occupiedIndices.includes(availableIndex)) {
            availableIndex++;
        }
        
        // Gán vị trí cho sự kiện hiện tại
        event.horizontalIndex = availableIndex;
        event.width = 100 / depth;
        event.left = availableIndex * event.width;

        positionedEvents.push(event);
    });

    return positionedEvents;
}

// Gán hàm ra ngoài để có thể sử dụng nếu cần
window.calculateEventPositions = calculateEventPositions;

// ⭐️ DEBUG CHUẨN ĐOÁN HỆ THỐNG
// Hàm này sẽ chạy khi tải trang để xác nhận checkCollision đã sẵn sàng.
(function () {
    if (typeof window.checkCollision === 'function') {
        console.info("✅ HỆ THỐNG: window.checkCollision đã được nạp thành công.");
        
        // Gọi thử nghiệm với dữ liệu giả định (Thứ Ba, 7:30-8:30)
        const testResult = window.checkCollision('Tue', '07:30:00 SA', '08:30:00 SA', null);
        console.info(`TEST VA CHẠM THỬ NGHIỆM (Tue 7:30-8:30): Kết quả = ${testResult}`);
        if (testResult === true) {
            console.warn("TEST THÀNH CÔNG: Logic va chạm hoạt động với dữ liệu đã lưu.");
        } else {
            console.warn("TEST KHÔNG VA CHẠM: Dữ liệu đã lưu có thể không có va chạm trong khoảng này.");
        }
    } else {
        console.error("❌ LỖI HỆ THỐNG: window.checkCollision KHÔNG được định nghĩa hoặc nạp sai.");
    }
})();