/**
 * Smart Schedule AI Functions
 * Handles the API interactions for the Auto-Scheduling feature.
 */

let currentPreviewData = null; // Store preview data

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

    // ⭐️ NORMALIZE TIME TO 24H FORMAT (HH:mm)
    // Input could be "09:00 SA", "2:00 CH", or "14:00"
    function to24h(timeStr) {
        if (!timeStr) return "08:00"; // Default

        // Remove whitespace
        timeStr = timeStr.trim();

        // Check for SA/CH/AM/PM
        const isPM = timeStr.toUpperCase().includes('CH') || timeStr.toUpperCase().includes('PM');
        const isAM = timeStr.toUpperCase().includes('SA') || timeStr.toUpperCase().includes('AM');

        // Extract numbers
        const parts = timeStr.replace(/[^0-9:]/g, '').split(':');
        let hours = parseInt(parts[0]);
        let minutes = parts.length > 1 ? parseInt(parts[1]) : 0;

        if (isNaN(hours)) return "08:00";

        if (isPM && hours < 12) hours += 12;
        if (isAM && hours === 12) hours = 0;

        return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
    }

    const payload = {
        action: 'preview', // Step 1: Preview
        collectionId: parseInt(window.currentCollectionId),
        startTime: to24h(startTime),
        endTime: to24h(endTime),
        priorityFocus: priority,
        includeWeekends: includeWeekends
    };

    console.log("📤 SmartSchedule Payload:", payload);

    try {
        const response = await fetch('/api/smart-schedule/generate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        const result = await response.json();

        if (result.success) {
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
    const previewDiv = document.getElementById('aiPreviewState');
    const includeWeekends = document.getElementById('aiWeekends').checked;

    // Clear previous state
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

    const daysToShow = includeWeekends ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'] : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    // Build Calendar Grid UI
    let html = `
        <div class="flex flex-col h-full max-h-[800px]">
            <div class="flex justify-between items-center mb-4 px-2">
                <h3 class="text-xl font-bold text-slate-800 dark:text-white">Dự Kiến Lịch Trình</h3>
                <span class="text-sm text-slate-500">${new Set(scheduleData.map(s => s.subject)).size} tasks planned</span>
            </div>
            
            <div class="flex-1 overflow-auto bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-700 shadow-sm relative">
                <table class="w-full border-collapse">
                    <thead>
                        <tr>
                            <th class="sticky top-0 left-0 z-20 bg-slate-50 dark:bg-slate-800 p-2 w-16 border-b border-r border-slate-200 dark:border-slate-700"></th>
                            ${daysToShow.map(day =>
        `<th class="sticky top-0 z-10 bg-slate-50 dark:bg-slate-800 p-2 border-b border-l border-slate-200 dark:border-slate-700 min-w-[100px] text-xs font-bold text-slate-500 uppercase">${day}</th>`
    ).join('')}
                        </tr>
                    </thead>
                    <tbody>
    `;

    // Time Slots 0 AM to 11 PM (23:00)
    for (let hour = 0; hour <= 23; hour++) {
        html += `<tr class="h-16 border-b border-slate-100 dark:border-slate-800">`;

        // Time Column
        html += `<td class="sticky left-0 z-10 bg-white dark:bg-slate-900 text-xs text-slate-400 text-center align-top p-1 border-r border-slate-100 dark:border-slate-800">${hour}:00</td>`;

        // Days Columns
        daysToShow.forEach(day => {
            html += `<td class="p-1 border-r border-slate-100 dark:border-slate-800 relative align-top transition-colors hover:bg-slate-50/50" data-day="${day}" data-hour="${hour}">`;

            // Find events starting in this hour
            const events = scheduleData.filter(s => {
                if (s.dayOfWeek !== day) return false;
                const h = parseInt(s.startTime.split(':')[0]);
                return h === hour;
            });

            events.forEach(event => {
                let colorClass = "bg-indigo-100 text-indigo-700 border-indigo-200";
                if (event.type && (event.type.includes("HỌC_TẬP") || event.subject.toLowerCase().includes("học") || event.type === 'self-study')) {
                    colorClass = "bg-blue-100 text-blue-700 border-blue-200";
                } else if (event.type && (event.type.includes("CÔNG_VIỆC") || event.subject.toLowerCase().includes("làm") || event.type === 'class')) {
                    colorClass = "bg-orange-100 text-orange-700 border-orange-200";
                } else if (event.type && (event.type.includes("GIẢI_TRÍ") || event.type === 'activity')) {
                    colorClass = "bg-green-100 text-green-700 border-green-200";
                }

                html += `
                    <div class="${colorClass} border p-1 rounded text-[10px] font-medium mb-1 shadow-sm leading-tight break-words cursor-help" title="${event.subject} (${event.startTime.substring(0, 5)} - ${event.endTime.substring(0, 5)})">
                        ${event.subject}
                    </div>
                `;
            });

            html += `</td>`;
        });

        html += `</tr>`;
    }

    html += `
                    </tbody>
                </table>
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

    previewDiv.innerHTML = html;
}

function cancelPreview() {
    window.location.reload();
}

async function confirmSaveSchedule() {
    if (!window.currentCollectionId) return;

    const previewDiv = document.getElementById('aiPreviewState');
    previewDiv.innerHTML = '<div class="flex flex-col items-center justify-center h-64"><i class="fa-solid fa-spinner fa-spin text-4xl text-indigo-600 mb-4"></i><p>Đang lưu...</p></div>';

    const payload = {
        action: 'save', // Step 2: Save
        collectionId: parseInt(window.currentCollectionId)
    };

    try {
        const response = await fetch('/api/smart-schedule/generate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
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
