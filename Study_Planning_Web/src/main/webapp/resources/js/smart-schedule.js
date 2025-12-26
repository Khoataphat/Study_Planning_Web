window.currentPreviewData = window.currentPreviewData || null;

window.addEventListener('error', function(e) {
    if (e.filename && e.filename.includes('onboarding.js')) {
        console.warn('Onboarding script error ignored:', e.message);
        e.preventDefault();
    }
});
// ⭐️ HÀM CHUYỂN ĐỔI THỜI GIAN - SỬA LẠI
function timeToMinutes(timeStr) {
    if (!timeStr || timeStr === 'undefined' || timeStr === 'null') {
        console.warn("⚠️ timeStr không hợp lệ:", timeStr);
        return 0;
    }

    console.log(`⏱️ timeToMinutes INPUT: "${timeStr}"`);

    // Chuẩn hóa - luôn chuyển về string
    const str = timeStr.toString().trim();
    
    // Nếu đã có AM/PM format từ Python
    if (str.includes('SA') || str.includes('CH')) {
        const parts = str.split(' ');
        let timePart = parts[0];
        const ampm = parts[1];
        
        // Đảm bảo có đủ HH:MM:SS
        const timeParts = timePart.split(':');
        if (timeParts.length === 2) {
            timePart = `${timePart}:00`;
        }
        
        const [h, m, s] = timePart.split(':').map(Number);
        let hours = h || 0;
        const minutes = m || 0;
        
        // Convert AM/PM sang 24h
        if (ampm === 'CH' || ampm === 'PM') {
            if (hours < 12) {
                hours += 12;
            }
        } else if (ampm === 'SA' || ampm === 'AM') {
            if (hours === 12) {
                hours = 0;
            }
        }
        
        const totalMinutes = hours * 60 + minutes;
        console.log(`  OUTPUT (AM/PM): "${str}" -> ${hours}:${minutes} -> ${totalMinutes} phút`);
        return totalMinutes;
    }
    
    // Kiểm tra nếu là "08:00:00" (không có AM/PM)
    if (str.includes(':') && !str.includes(' ') && !str.includes('SA') && !str.includes('CH') && 
        !str.includes('AM') && !str.includes('PM')) {
        
        console.log(`  ⚠️ WARNING: Time "${str}" không có AM/PM, xử lý đặc biệt`);
        
        const timeParts = str.split(':');
        const h = parseInt(timeParts[0]) || 0;
        const m = parseInt(timeParts[1]) || 0;
        
        // Giả sử là SA nếu < 12, CH nếu >= 12
        const ampm = h < 12 ? 'SA' : 'CH';
        let hours = h;
        
        // Nếu là CH và hours > 12, giữ nguyên (đã là 24h format)
        if (ampm === 'CH' && hours > 12) {
            // Giữ nguyên hours (ví dụ: 13 -> 13)
        } else if (ampm === 'CH' && hours === 0) {
            hours = 12; // 00:00 -> 12:00 SA
        }
        
        const totalMinutes = hours * 60 + m;
        console.log(`  OUTPUT (no AM/PM): "${str}" -> ${hours}:${m} ${ampm} -> ${totalMinutes} phút`);
        return totalMinutes;
    }

    const parts = str.split(' ');
    let timePart = parts[0];
    let ampm = parts.length > 1 ? parts[1].toUpperCase() : '';

    // Đảm bảo có đủ HH:MM:SS
    const timeParts = timePart.split(':');
    if (timeParts.length === 2) {
        timePart = `${timeParts[0]}:${timeParts[1]}:00`;
    }

    const [h, m, s] = timePart.split(':').map(Number);
    let hours = h || 0;
    const minutes = m || 0;

    console.log(`  Parsed: hours=${hours}, minutes=${minutes}, ampm="${ampm}"`);

    // ⭐️ QUAN TRỌNG: Fix logic AM/PM
    if (ampm === 'CH' || ampm === 'PM') {
        if (hours < 12) {
            hours += 12;
        }
        // Nếu hours = 12 và là CH, giữ nguyên 12
        if (hours === 12 && (ampm === 'CH' || ampm === 'PM')) {
            hours = 12; // 12 CH = 12:00
        }
    } else if (ampm === 'SA' || ampm === 'AM') {
        if (hours === 12) {
            hours = 0; // 12 SA = 00:00
        }
    } else {
        // Không có AM/PM, mặc định là 24h format
        // Giữ nguyên
    }

    const totalMinutes = hours * 60 + minutes;
    console.log(`  OUTPUT: "${timeStr}" -> ${hours}:${minutes} -> ${totalMinutes} phút`);

    return totalMinutes;
}

// ⭐️ HÀM CHUẨN HÓA THỜI GIAN - LUÔN CÓ AM/PM
function normalizeTimeFormat(timeStr) {
    if (!timeStr || !timeStr.includes(':')) {
        return '08:00:00 SA';
    }

    const str = timeStr.toString().trim();
    
    // Nếu đã có AM/PM, trả về nguyên bản
    if (str.includes('SA') || str.includes('CH') || 
        str.includes('AM') || str.includes('PM')) {
        return str;
    }
    
    // Xử lý trường hợp không có AM/PM (ví dụ: "08:00:00")
    const timeParts = str.split(':');
    let hours = parseInt(timeParts[0]) || 8;
    let minutes = parseInt(timeParts[1]) || 0;
    const seconds = parseInt(timeParts[2]) || 0;
    
    let ampm = 'SA';
    
    if (hours === 0) {
        hours = 12;
        ampm = 'SA';
    } else if (hours < 12) {
        ampm = 'SA';
    } else if (hours === 12) {
        ampm = 'CH';
    } else {
        hours = hours - 12;
        ampm = 'CH';
    }
    
    return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')} ${ampm}`;
}

// ⭐️ THÊM: Hàm fix duration mạnh mẽ hơn
function fixEventDuration(event) {
    console.log(`🔧 Fixing duration for: "${event.subject}"`);
    
    // Đảm bảo có startTime và endTime
    if (!event.startTime) {
        event.startTime = '08:00:00 SA';
    }
    if (!event.endTime) {
        event.endTime = '09:00:00 SA';
    }
    
    // Nếu không có AM/PM, thêm vào
    if (!event.startTime.includes('SA') && !event.startTime.includes('CH') &&
        !event.startTime.includes('AM') && !event.startTime.includes('PM')) {
        event.startTime = normalizeTimeFormat(event.startTime);
    }
    if (!event.endTime.includes('SA') && !event.endTime.includes('CH') &&
        !event.endTime.includes('AM') && !event.endTime.includes('PM')) {
        event.endTime = normalizeTimeFormat(event.endTime);
    }
    
    // Tính minutes
    event.startMinutes = timeToMinutes(event.startTime);
    event.endMinutes = timeToMinutes(event.endTime);
    
    // Fix duration nếu cần
    if (event.endMinutes <= event.startMinutes) {
        console.warn(`⚠️ Duration issue: ${event.startTime} - ${event.endTime} (${event.endMinutes - event.startMinutes} mins)`);
        
        // Thêm duration dựa trên task type hoặc mặc định
        let durationToAdd = 60; // 60 phút mặc định
        
        // Ước lượng duration dựa trên task type
        const subject = event.subject.toLowerCase();
        if (subject.includes('ôn thi') || subject.includes('thi')) {
            durationToAdd = 120; // 2 giờ cho ôn thi
        } else if (subject.includes('bài tập') || subject.includes('assignment')) {
            durationToAdd = 90; // 1.5 giờ cho bài tập
        } else if (subject.includes('tiếng anh') || subject.includes('ielts')) {
            durationToAdd = 120; // 2 giờ cho học tiếng Anh
        } else if (event.type === 'class') {
            durationToAdd = 60; // 1 giờ cho lớp học
        }
        
        // Tính endTime mới
        const newEndMinutes = event.startMinutes + durationToAdd;
        const newHours = Math.floor(newEndMinutes / 60);
        const newMinutes = newEndMinutes % 60;
        
        // Giữ AM/PM từ startTime
        const startParts = event.startTime.split(' ');
        const ampm = startParts.length > 1 ? startParts[1] : 'SA';
        
        event.endTime = `${newHours.toString().padStart(2, '0')}:${newMinutes.toString().padStart(2, '0')}:00 ${ampm}`;
        event.endMinutes = newEndMinutes;
        
        console.log(`✅ Fixed: ${event.subject} -> ${event.startTime} - ${event.endTime} (${durationToAdd} phút)`);
    }
    
    // Tính duration
    event.durationMinutes = event.endMinutes - event.startMinutes;
    
    return event;
}

// ⭐️ HÀM ĐỊNH DẠNG THỜI GIAN HIỂN THỊ
function formatTimeForDisplay(timeStr) {
    console.log(`🔍 formatTimeForDisplay INPUT: "${timeStr}"`);

    if (!timeStr || timeStr === 'undefined' || timeStr === 'null') {
        console.warn("⚠️ Invalid time string, returning N/A");
        return 'N/A';
    }

    console.log(`🔍 formatTimeForDisplay INPUT: "${timeStr}"`);
    
    // Chuyển thành string
    const str = timeStr.toString().trim();
    
    // Nếu đã có AM/PM
    if (str.includes('SA') || str.includes('CH') || 
        str.includes('AM') || str.includes('PM')) {
        
        const parts = str.split(' ');
        if (parts.length >= 2) {
            const timePart = parts[0];
            const ampm = parts[1];
            
            const [h, m, s] = timePart.split(':').map(num => parseInt(num) || 0);
            let hours = h || 0;
            const minutes = m || 0;
            
            // Đảm bảo hiển thị đúng format HH:MM
            const displayHours = hours > 12 ? hours - 12 : (hours === 0 ? 12 : hours);
            return `${displayHours}:${minutes.toString().padStart(2, '0')} ${ampm}`;
        }
    }
    
    // Nếu là format 24h (ví dụ: "13:15:00")
    if (str.includes(':') && !str.includes(' ')) {
        const timeParts = str.split(':');
        let hours = parseInt(timeParts[0]) || 0;
        const minutes = parseInt(timeParts[1]) || 0;
        
        let ampm = 'SA';
        if (hours >= 12) {
            ampm = 'CH';
            if (hours > 12) {
                hours -= 12;
            }
        }
        if (hours === 0) {
            hours = 12;
        }
        
        const result = `${hours}:${minutes.toString().padStart(2, '0')} ${ampm}`;
        console.log(`  ↳ OUTPUT: "${str}" -> "${result}"`);
        return result;
    }
    
    console.warn(`⚠️ Cannot format time: "${str}"`);
    return 'N/A';
}

// ⭐️ HÀM KIỂM TRA VÀ CHUẨN HÓA THỜI GIAN
function normalizeEventTime(event) {
    console.log(`🔧 Normalizing event: "${event.subject}"`);

    let startTime = event.startTime;
    let endTime = event.endTime;

    // Đảm bảo không bị undefined/null
    if (!startTime) {
        console.warn(`⚠️ Event "${event.subject}" has no startTime, using default`);
        startTime = '08:00:00 SA';
    }

    if (!endTime) {
        console.warn(`⚠️ Event "${event.subject}" has no endTime, using default`);
        endTime = '09:00:00 SA';
    }

    // Chuẩn hóa format thời gian LUÔN có AM/PM
    startTime = normalizeTimeFormat(startTime);
    endTime = normalizeTimeFormat(endTime);

    // Hàm chuẩn hóa đơn giản
    function normalizeTimeFormat(timeStr) {
        if (!timeStr || !timeStr.includes(':')) {
            return '08:00:00 SA';
        }

        const parts = timeStr.toString().trim().split(' ');
        let timePart = parts[0];
        let ampm = parts.length > 1 ? parts[1].toUpperCase() : '';

        // Đảm bảo có đủ HH:MM:SS
        const timeParts = timePart.split(':');
        if (timeParts.length === 2) {
            timePart = `${timeParts[0]}:${timeParts[1]}:00`;
        }

        // Nếu không có AM/PM, thêm dựa trên giờ
        if (!ampm) {
            const hours = parseInt(timeParts[0]) || 8;
            if (hours === 0) {
                ampm = 'SA';
                timePart = `12:${timeParts[1] || '00'}:00`;
            } else if (hours < 12) {
                ampm = 'SA';
            } else if (hours === 12) {
                ampm = 'CH';
            } else {
                ampm = 'CH';
                const hour12 = hours - 12;
                timePart = `${hour12}:${timeParts[1] || '00'}:00`;
            }
        }

        return `${timePart} ${ampm}`;
    }

    // Kiểm tra và fix duration
    const startMinutes = timeToMinutes(startTime);
    const endMinutes = timeToMinutes(endTime);

    let durationMinutes = endMinutes - startMinutes;

    // ⭐️ FIX: Nếu duration <= 0 hoặc quá ngắn, set mặc định
    if (durationMinutes <= 0) {
        console.warn(`⚠️ Event "${event.subject}" có duration không hợp lệ: ${durationMinutes} phút`);

        // Set endTime = startTime + 60 phút
        const fixedHours = Math.floor((startMinutes + 60) / 60);
        const fixedMinutes = (startMinutes + 60) % 60;

        // Giữ AM/PM từ startTime
        const startParts = startTime.split(' ');
        const ampm = startParts.length > 1 ? startParts[1] : 'SA';

        endTime = `${fixedHours.toString().padStart(2, '0')}:${fixedMinutes.toString().padStart(2, '0')}:00 ${ampm}`;
        durationMinutes = 60;

        console.log(`✅ Fixed: ${event.subject} -> ${startTime} - ${endTime} (${durationMinutes} phút)`);
    }

    return {
        ...event,
        startTime: startTime,
        endTime: endTime,
        durationMinutes: durationMinutes,
        _normalized: true
    };
}

// ⭐️ HÀM TÍNH VỊ TRÍ EVENT ĐƠN GIẢN
function calculateEventPosition(event) {
    const normalizedEvent = normalizeEventTime(event);

    const startMinutes = timeToMinutes(normalizedEvent.startTime);
    const endMinutes = timeToMinutes(normalizedEvent.endTime);

    const startHour = Math.floor(startMinutes / 60);
    const startMinute = startMinutes % 60;
    const endHour = Math.floor(endMinutes / 60);
    const endMinute = endMinutes % 60;

    const durationMinutes = endMinutes - startMinutes;

    return {
        startHour: startHour,
        startMinute: startMinute,
        endHour: endHour,
        endMinute: endMinute,
        durationMinutes: durationMinutes,
        normalizedEvent: normalizedEvent
    };
}

// ⭐️ HÀM TÍNH TOÁN VỊ TRÍ EVENT TRÁNH CHỒNG LẤN
function calculateEventPositions(events) {
    if (!events || events.length === 0)
        return [];

    console.log(`🔧 Calculating positions for ${events.length} events`);

    // 1. Sắp xếp theo thời gian bắt đầu
    const sortedEvents = [...events].sort((a, b) => {
        if (a.startMinutes === b.startMinutes) {
            return a.endMinutes - b.endMinutes; // Nếu bắt đầu cùng lúc, ưu tiên kết thúc sớm hơn
        }
        return a.startMinutes - b.startMinutes;
    });

    // 2. Tạo groups với thuật toán đúng hơn
    const groups = [];
    let currentGroup = [];
    let currentGroupEnd = 0;

    for (let i = 0; i < sortedEvents.length; i++) {
        const event = sortedEvents[i];
        
        if (currentGroup.length === 0) {
            // Bắt đầu group mới
            currentGroup.push(event);
            currentGroupEnd = event.endMinutes;
        } else if (event.startMinutes < currentGroupEnd) {
            // Event chồng lấn với group hiện tại, thêm vào
            currentGroup.push(event);
            if (event.endMinutes > currentGroupEnd) {
                currentGroupEnd = event.endMinutes;
            }
        } else {
            // Event không chồng lấn, tạo group mới
            groups.push([...currentGroup]);
            currentGroup = [event];
            currentGroupEnd = event.endMinutes;
        }
        
        // Nếu là event cuối, thêm group hiện tại vào groups
        if (i === sortedEvents.length - 1 && currentGroup.length > 0) {
            groups.push(currentGroup);
        }
    }

    console.log(`🔧 Created ${groups.length} event groups`);

    // 3. Tính toán vị trí cho từng nhóm
    const positionedEvents = [];

    groups.forEach((group, groupIndex) => {
        // Sắp xếp group theo thời gian bắt đầu
        group.sort((a, b) => a.startMinutes - b.startMinutes);
        
        // Tìm số cột tối đa cần thiết cho group này
        const columns = [];
        
        group.forEach(event => {
            let placed = false;
            
            // Tìm cột trống để đặt event
            for (let col = 0; col < columns.length; col++) {
                const lastEventInCol = columns[col][columns[col].length - 1];
                if (!lastEventInCol || lastEventInCol.endMinutes <= event.startMinutes) {
                    columns[col].push(event);
                    placed = true;
                    break;
                }
            }
            
            // Nếu không tìm được cột trống, tạo cột mới
            if (!placed) {
                columns.push([event]);
            }
        });
        
        const totalColumns = columns.length;
        
        // Gán vị trí cho từng event
        columns.forEach((column, colIndex) => {
            column.forEach(event => {
                const isFixed = event.isFixed || event.type === 'class';
                
                // Tính width dựa trên số cột
                // Đảm bảo width không quá nhỏ (ít nhất 40%)
                const widthPercentage = Math.max(40, 100 / totalColumns);
                const leftPercentage = colIndex * widthPercentage;
                
                positionedEvents.push({
                    ...event,
                    width: widthPercentage,
                    left: leftPercentage,
                    groupIndex: groupIndex,
                    columnIndex: colIndex,
                    totalColumns: totalColumns,
                    zIndex: isFixed ? 100 + colIndex : 50 + colIndex
                });
            });
        });
    });

    return positionedEvents;
}

async function generateSmartSchedule() {
    // currentCollectionId set in the inline script of smart-schedule.jsp
    if (typeof window.currentCollectionId === 'undefined' || !window.currentCollectionId) {
        alert("Vui lòng chọn một lịch để áp dụng.");
        return;
    }

    const startTime = document.getElementById('aiStartTime').value;
    const endTime = document.getElementById('aiEndTime').value;
    const priority = document.getElementById('aiPriority').value;
    const includeWeekends = document.getElementById('aiWeekends').checked;

    // UI Loading State
    const btn = document.getElementById('btnGenerate');
    const originalText = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin text-xl"></i> Đang tính toán...';

    // Normalize time to 24h
    function to24h(timeStr) {
        if (!timeStr)
            return "08:00";

        timeStr = timeStr.trim();
        const isPM = timeStr.toUpperCase().includes('CH') || timeStr.toUpperCase().includes('PM');
        const isAM = timeStr.toUpperCase().includes('SA') || timeStr.toUpperCase().includes('AM');

        const parts = timeStr.replace(/[^0-9:]/g, '').split(':');
        let hours = parseInt(parts[0]);
        let minutes = parts.length > 1 ? parseInt(parts[1]) : 0;

        if (isNaN(hours))
            return "08:00";

        if (isPM && hours < 12)
            hours += 12;
        if (isAM && hours === 12)
            hours = 0;

        return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
    }

    const payload = {
        action: 'preview',
        collectionId: parseInt(window.currentCollectionId),
        startTime: to24h(startTime),
        endTime: to24h(endTime),
        priorityFocus: priority,
        includeWeekends: includeWeekends,
        getFixedClasses: true
    };

    console.log("📤 SmartSchedule Payload:", payload);

    try {
        const response = await fetch('/api/smart-schedule/generate', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(payload)
        });

        const result = await response.json();
        console.log("📥 Server response:", result);

         if (result.success) {
            // ⭐️ THÊM: Tính toán minutes cho mọi event
            if (result.previewData && Array.isArray(result.previewData)) {
                result.previewData = result.previewData.map(event => {
                    // Tính toán minutes
                    event.startMinutes = timeToMinutes(event.startTime);
                    event.endMinutes = timeToMinutes(event.endTime);
                    
                    // Fix duration nếu cần
                    if (event.endMinutes <= event.startMinutes) {
                        event.endMinutes = event.startMinutes + 60;
                    }
                    
                    return event;
                });
            }
            
            currentPreviewData = result.previewData;
            renderPreview(result.previewData);
        } else {
            alert("Lỗi: " + (result.error || result.message));
        }

    } catch (error) {
        console.error("Smart Schedule Error:", error);
        alert("Đã xảy ra lỗi khi kết nối với máy chủ AI.");
    } finally {
        if (btn) {
            btn.disabled = false;
            btn.innerHTML = originalText;
        }
    }
}

function renderPreview(scheduleData) {
    console.log("🎨 Starting renderPreview with", scheduleData?.length || 0, "events");
    
    // ⭐️ SỬA: Sử dụng hàm fixEventDuration mới
    if (scheduleData) {
        scheduleData = scheduleData.map(event => {
            return fixEventDuration(event);
        });
    }
    
    // Lấy giá trị từ DOM
    const includeWeekends = document.getElementById('aiWeekends')?.checked || false;
    
    // Validate dữ liệu
    if (scheduleData) {
        scheduleData = scheduleData.filter(event => {
            if (!event.startTime || !event.endTime) {
                console.warn(`⚠️ Skipping event without time: ${event.subject}`);
                return false;
            }
            return true;
        });
    }
    
    const previewDiv = document.getElementById('aiPreviewState');
    previewDiv.innerHTML = '';
    previewDiv.className = "w-full overflow-hidden";

    if (!scheduleData || scheduleData.length === 0) {
        previewDiv.innerHTML = `
            <div class="text-center p-8">
                <span class="material-icons-outlined text-4xl text-slate-400">event_busy</span>
                <p class="text-slate-500 mt-2">Không tìm thấy task nào để sắp xếp.</p>
            </div>`;
        return;
    }

    // Tính toán fixedClasses trước
    const fixedClasses = scheduleData.filter(e => e.isFixed || e.type === 'class');
    const selfStudyTasks = scheduleData.filter(e => !e.isFixed && e.type !== 'class');
    
    console.log(`  Fixed classes: ${fixedClasses.length}`);
    console.log(`  Self-study tasks: ${selfStudyTasks.length}`);
    
    // ⭐️ DEBUG: Log tất cả events
    console.log("📊 ALL EVENTS:");
    scheduleData.forEach((event, idx) => {
        console.log(`  ${idx+1}. ${event.dayOfWeek} ${event.startTime}-${event.endTime}: ${event.subject} (${event.durationMinutes} mins)`);
    });
    
    // ⭐️ TRUYỀN TẤT CẢ DỮ LIỆU CẦN THIẾT
    previewDiv.innerHTML = buildCalendarHTML({
        scheduleData: scheduleData,
        includeWeekends: includeWeekends,
        fixedClassesCount: fixedClasses.length,
        totalTasks: scheduleData.length,
        fixedClasses: fixedClasses  // Truyền cả mảng nếu cần
    });
    
    console.log("✅ renderPreview completed");
}

// ⭐️ SỬA: Nhận object tham số thay vì nhiều tham số
function buildCalendarHTML(params) {
    const {
        scheduleData,
        includeWeekends,
        fixedClassesCount,
        totalTasks,
        fixedClasses
    } = params;

    console.log("🏗️ Building calendar HTML with params:", {
        includeWeekends,
        fixedClassesCount,
        totalTasks
    });

    const daysToShow = includeWeekends ?
            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'] :
            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    // Nhóm events theo ngày
    const eventsByDay = {};
    daysToShow.forEach(day => {
        eventsByDay[day] = scheduleData.filter(event => event.dayOfWeek === day);
    });

    // Tính toán positions cho từng ngày
    const positionedEventsByDay = {};
    daysToShow.forEach(day => {
        if (eventsByDay[day].length > 0) {
            positionedEventsByDay[day] = calculateEventPositions(eventsByDay[day]);
        }
    });

    let html = `
        <style>
        .calendar-event {
            position: absolute;
            border-radius: 6px;
            padding: 2px 4px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.3);
            font-size: 11px;
            line-height: 1.2;
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
            box-sizing: border-box; /* Thêm dòng này */
            margin: 1px; /* Thêm khoảng cách giữa các event */
        }
        
        .event-title {
            font-weight: 600;
            margin-bottom: 1px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            max-height: 2.4em; /* Giới hạn chiều cao */
        }
        
        .event-time {
            font-size: 9px;
            opacity: 0.9;
            margin-top: 1px;
            white-space: nowrap; /* Giữ thời gian trên 1 dòng */
        }
        
        /* Màu sắc cho các loại event */
        .fixed-class {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border-color: #fbbf24;
            color: #92400e;
        }
        
        .study-english {
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
            border-color: #60a5fa;
            color: #1e40af;
        }
        
        .study-exam {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            border-color: #f87171;
            color: #991b1b;
        }
        
        .study-math {
            background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
            border-color: #4ade80;
            color: #166534;
        }
        
        .work-task {
            background: linear-gradient(135deg, #fed7aa 0%, #fdba74 100%);
            border-color: #fb923c;
            color: #9a3412;
        }
        
        .other-task {
            background: linear-gradient(135deg, #e9d5ff 0%, #d8b4fe 100%);
            border-color: #c084fc;
            color: #6b21a8;
        }
        </style>
        <div class="flex flex-col h-full max-h-[800px]">
            <div class="flex justify-between items-center mb-4 px-2">
                <h3 class="text-xl font-bold text-slate-800 dark:text-white">Dự Kiến Lịch Trình</h3>
                <div class="flex items-center gap-4">
                    <span class="text-sm text-slate-500">${totalTasks} tasks</span>
                    <div class="flex items-center gap-2 px-3 py-1 bg-amber-50 border border-amber-200 rounded-lg">
                        <div class="w-3 h-3 bg-yellow-400 rounded-full"></div>
                        <span class="text-xs text-amber-700 font-medium">${fixedClassesCount} lớp cố định</span>
                    </div>
                </div>
            </div>
            
            <div class="flex-1 overflow-auto bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-700 shadow-sm relative">
                <table class="w-full border-collapse">
                    <thead>
                        <tr>
                            <th class="sticky top-0 left-0 z-20 bg-slate-50 dark:bg-slate-800 p-2 w-16 border-b border-r border-slate-200 dark:border-slate-700">Giờ</th>
                            ${daysToShow.map(day =>
            `<th class="sticky top-0 z-10 bg-slate-50 dark:bg-slate-800 p-2 border-b border-l border-slate-200 dark:border-slate-700 min-w-[100px] text-xs font-bold text-slate-500 uppercase">${day}</th>`
    ).join('')}
                        </tr>
                    </thead>
                    <tbody>
    `;

    // Time slots từ 0-23h
    for (let hour = 0; hour < 24; hour++) {
        const displayHour = hour === 0 ? 12 : hour > 12 ? hour - 12 : hour;
        const ampm = hour < 12 ? 'SA' : 'CH';

        html += `<tr class="h-16 border-b border-slate-100 dark:border-slate-800">`;
        html += `<td class="sticky left-0 z-10 bg-white dark:bg-slate-900 text-xs text-slate-400 text-center align-top p-1 border-r border-slate-100 dark:border-slate-800">${displayHour}:00 ${ampm}</td>`;

        // Day columns
        daysToShow.forEach(day => {
            html += `<td class="p-0 border-r border-slate-100 dark:border-slate-800 relative align-top transition-colors hover:bg-slate-50/50 min-h-[64px]" data-day="${day}" data-hour="${hour}">`;

            // Render events cho ngày này
            const events = positionedEventsByDay[day] || [];
            events.forEach(event => {
                const eventStartHour = Math.floor(event.startMinutes / 60);
                const eventEndHour = Math.ceil(event.endMinutes / 60);

                // Kiểm tra nếu event nằm trong giờ này
                const isInThisHour = (
                        (hour >= eventStartHour && hour < eventEndHour) ||
                        (hour === eventStartHour && hour === eventEndHour) ||
                        (hour === eventStartHour) ||
                        (hour === eventEndHour && (event.endMinutes % 60) > 0)
                        );

                if (!isInThisHour)
                    return;

                // Tính toán vị trí
                let topPercentage = 0;
                let heightPercentage = 100;

                if (hour === eventStartHour) {
                    topPercentage = ((event.startMinutes % 60) / 60) * 100;
                    if (hour === eventEndHour) {
                        heightPercentage = (((event.endMinutes % 60) - (event.startMinutes % 60)) / 60) * 100;
                    } else {
                        heightPercentage = 100 - topPercentage;
                    }
                } else if (hour === eventEndHour) {
                    heightPercentage = ((event.endMinutes % 60) / 60) * 100;
                }

                // Đảm bảo giá trị hợp lệ
                topPercentage = Math.max(0, Math.min(100, topPercentage));
                heightPercentage = Math.max(20, Math.min(100, heightPercentage));

                // Chọn màu
                let colorClass = "other-task";
                const isFixedClass = event.isFixed || event.type === 'class';

                if (isFixedClass) {
                    colorClass = "fixed-class";
                } else if (event.type && (event.type.includes("HỌC_TẬP") ||
                        event.subject.toLowerCase().includes("học") ||
                        event.type === 'self-study' ||
                        event.type === 'study')) {

                    if (event.subject.toLowerCase().includes("tiếng anh") ||
                            event.subject.toLowerCase().includes("ielts")) {
                        colorClass = "study-english";
                    } else if (event.subject.toLowerCase().includes("ôn thi") ||
                            event.subject.toLowerCase().includes("thi")) {
                        colorClass = "study-exam";
                    } else if (event.subject.toLowerCase().includes("toán") ||
                            event.subject.toLowerCase().includes("assignment")) {
                        colorClass = "study-math";
                    } else {
                        colorClass = "study-english";
                    }
                } else if (event.type && (event.type.includes("CÔNG_VIỆC") ||
                        event.subject.toLowerCase().includes("làm"))) {
                    colorClass = "work-task";
                }

                // Thời gian hiển thị
                const displayStart = formatTimeForDisplay(event.startTime);
                const displayEnd = formatTimeForDisplay(event.endTime);

                let timeDisplay = '';
                try {
                    const startDisplay = formatTimeForDisplay(event.startTime);
                    const endDisplay = formatTimeForDisplay(event.endTime);

                    if (hour === eventStartHour) {
                        timeDisplay = startDisplay.replace(' SA', '').replace(' CH', '');
                        if (hour === eventEndHour) {
                            timeDisplay += '-' + endDisplay.replace(' SA', '').replace(' CH', '').substring(0, 5);
                        } else {
                            timeDisplay += '-...';
                        }
                    } else if (hour === eventEndHour) {
                        timeDisplay = '...-' + endDisplay.replace(' SA', '').replace(' CH', '').substring(0, 5);
                    }
                } catch (error) {
                    console.error("Error formatting time display:", error);
                    timeDisplay = '';
                }

                // Thay đổi cách tính toán width và left
                const width = event.width || 96;
                const left = event.left || 2;

                // Đảm bảo không vượt quá 100%
                const adjustedWidth = Math.min(width, 98);
                const adjustedLeft = Math.min(left, 98 - adjustedWidth);

                html += `
                    <div class="calendar-event ${colorClass} ${isFixedClass ? 'fixed-class' : 'self-study-event'}"
                         style="
                            top: ${topPercentage}%;
                            height: ${heightPercentage}%;
                            width: ${adjustedWidth}%;
                            left: ${adjustedLeft}%;
                            z-index: ${event.zIndex || 20};
                         "
                         title="${event.subject} 
                ${isFixedClass ? '[LỚP HỌC CỐ ĐỊNH]' : ''}
                Thời gian: ${displayStart} - ${displayEnd}
                Duration: ${event.durationMinutes} phút">
                        <div class="p-1 h-full flex flex-col justify-between">
                            <div class="event-title truncate">${event.subject}</div>
                            ${timeDisplay ? `<div class="event-time">${timeDisplay}</div>` : ''}
                        </div>
                    </div>
                `;
            });

            html += `</td>`;
        });

        html += `</tr>`;
    }

    // Footer với legend
    html += `
                    </tbody>
                </table>
                
                <div class="mt-4 p-4 bg-slate-50 dark:bg-slate-800 border-t border-slate-200 dark:border-slate-700">
                    <div class="flex flex-wrap items-center gap-4 text-sm">
                        <div class="flex items-center gap-2">
                            <div class="w-4 h-4 bg-yellow-100 border-2 border-yellow-300 rounded"></div>
                            <span class="font-medium text-amber-700">Lớp học cố định</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <div class="w-4 h-4 bg-blue-100 border border-blue-200 rounded"></div>
                            <span>Học tiếng Anh</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <div class="w-4 h-4 bg-red-100 border border-red-200 rounded"></div>
                            <span>Ôn thi</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <div class="w-4 h-4 bg-green-100 border border-green-200 rounded"></div>
                            <span>Bài tập Toán</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <div class="w-4 h-4 bg-orange-100 border border-orange-200 rounded"></div>
                            <span>Công việc</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <div class="w-4 h-4 bg-indigo-100 border border-indigo-200 rounded"></div>
                            <span>Khác</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="mt-6 flex gap-3 justify-end bg-white dark:bg-slate-900 pt-4 border-t border-slate-100 dark:border-slate-800 sticky bottom-0">
                 <button onclick="cancelPreview()" class="px-6 py-2.5 rounded-xl border border-slate-300 text-slate-600 font-semibold hover:bg-slate-100 transition-colors">
                    Hủy
                </button>
                <button onclick="confirmSaveSchedule()" class="px-8 py-2.5 bg-green-500 hover:bg-green-600 text-white font-bold rounded-xl shadow-lg shadow-green-200 transition-all flex items-center gap-2">
                    <span class="material-icons-outlined">check</span>
                    Xác Nhận & Lưu
                </button>
            </div>
        </div>
    `;

    return html;
}

// ⭐️ THÊM: Hàm fixedClasses cần được tính toán ở đây
function getFixedClasses(scheduleData) {
    return (scheduleData || []).filter(e => e.isFixed || e.type === 'class');
}

function createScheduleEventElement(eventData) {
    const element = document.createElement('div');
    element.className = `calendar-event ${eventData.isFixed ? 'fixed-class' : 'self-study'}`;

    // Tính toán style
    const startHour = Math.floor(eventData.startMinutes / 60);
    const startMinute = eventData.startMinutes % 60;
    const endHour = Math.floor(eventData.endMinutes / 60);
    const endMinute = eventData.endMinutes % 60;

    // Thiết lập dataset như tasks.js
    element.dataset.scheduleId = eventData.scheduleId || '';
    element.dataset.taskId = eventData.taskId || '';
    element.dataset.dayOfWeek = eventData.dayOfWeek || '';
    element.dataset.startTime = eventData.startTime || '';
    element.dataset.endTime = eventData.endTime || '';
    element.dataset.duration = eventData.durationMinutes || '';

    // Thêm nội dung
    element.innerHTML = `
        <div class="event-content">
            <div class="event-title">${eventData.subject}</div>
            <div class="event-time">
                ${formatTimeForDisplay(eventData.startTime).substring(0, 5)} - 
                ${formatTimeForDisplay(eventData.endTime).substring(0, 5)}
            </div>
        </div>
    `;

    return element;
}

function cancelPreview() {
    window.location.reload();
}

async function confirmSaveSchedule() {
    if (!window.currentCollectionId)
        return;

    const previewDiv = document.getElementById('aiPreviewState');
    previewDiv.innerHTML = '<div class="flex flex-col items-center justify-center h-64"><i class="fa-solid fa-spinner fa-spin text-4xl text-indigo-600 mb-4"></i><p>Đang lưu...</p></div>';

    const payload = {
        action: 'save',
        collectionId: parseInt(window.currentCollectionId)
    };

    try {
        const response = await fetch('/api/smart-schedule/generate', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(payload)
        });

        const result = await response.json();

        if (result.success) {
            previewDiv.innerHTML = `
                <div class="flex flex-col items-center justify-center h-full animate-fadeIn">
                    <div class="text-green-500 text-6xl mb-6">
                        <span class="material-icons-outlined" style="font-size: 80px;">check_circle</span>
                    </div>
                    <h3 class="text-3xl font-bold text-slate-800 dark:text-white mb-2">Đã Lưu Thành Công!</h3>
                    <p class="text-lg text-slate-500 dark:text-slate-400 mb-8">Lịch trình đã được cập nhật vào bộ sưu tập của bạn.</p>
                    
                        <div class="flex gap-4">
                            <a href="/schedule" class="px-8 py-3 bg-white border border-slate-200 text-slate-700 font-bold rounded-xl hover:bg-slate-50 transition-colors shadow-sm">
                                Xem Lịch
                            </a>
                            <button onclick="showFeedbackModal()" class="px-8 py-3 bg-yellow-400 text-white font-bold rounded-xl hover:bg-yellow-500 transition-colors shadow-lg shadow-yellow-200 flex items-center gap-2">
                                <span class="material-icons-outlined">rate_review</span>
                                Gửi Phản Hồi
                            </button>
                            <button onclick="window.location.reload()" class="px-8 py-3 bg-indigo-600 text-white font-bold rounded-xl hover:bg-indigo-700 transition-colors shadow-lg shadow-indigo-200">
                                Tạo Lại
                            </button>
                        </div>
                </div>
            `;
        } else {
            alert("Lỗi khi lưu: " + result.message);
            cancelPreview();
        }
    } catch (e) {
        console.error(e);
        alert("Lỗi kết nối khi lưu.");
    }
}


// Feedback Logic
let selectedRating = 0;

function selectRating(rating) {
    selectedRating = rating;
    document.getElementById('feedbackRating').value = rating;

    document.querySelectorAll('.rating-btn').forEach(btn => {
        btn.classList.add('opacity-50', 'filter', 'grayscale');
        btn.classList.remove('opacity-100', 'scale-125', 'grayscale-0');
    });

    const activeBtn = document.querySelector(`.rating-btn[data-rating="${rating}"]`);
    if (activeBtn) {
        activeBtn.classList.remove('opacity-50', 'filter', 'grayscale');
        activeBtn.classList.add('opacity-100', 'scale-125', 'grayscale-0');
    }
}

function showFeedbackModal() {
    const modal = document.getElementById('feedbackModal');
    if (modal) {
        modal.classList.remove('hidden');
        selectRating(0);
        document.getElementById('feedbackComment').value = '';
    }
}

function closeFeedbackModal() {
    const modal = document.getElementById('feedbackModal');
    if (modal) {
        modal.classList.add('hidden');
    }
}

async function submitFeedback() {
    if (selectedRating === 0) {
        alert("Vui lòng chọn mức độ hài lòng của bạn!");
        return;
    }

    const comment = document.getElementById('feedbackComment').value;
    const collectionId = window.currentCollectionId ? parseInt(window.currentCollectionId) : -1;

    const payload = {
        rating: selectedRating,
        comment: comment,
        collectionId: collectionId
    };

    try {
        const btn = document.querySelector('button[onclick="submitFeedback()"]');
        const originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang gửi...';

        const response = await fetch('/api/feedback/submit', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(payload)
        });

        const result = await response.json();

        if (result.success) {
            alert("Cảm ơn bạn đã đóng góp ý kiến!");
            closeFeedbackModal();
        } else {
            alert("Lỗi: " + result.message);
        }

    } catch (e) {
        console.error(e);
        alert("Có lỗi xảy ra khi gửi phản hồi.");
    } finally {
        const btn = document.querySelector('button[onclick="submitFeedback()"]');
        if (btn) {
            btn.disabled = false;
            btn.innerHTML = "Gửi Góp Ý";
        }
    }
}