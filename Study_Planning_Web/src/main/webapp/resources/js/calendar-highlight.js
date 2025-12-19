// static/calendar-highlight.js
/**
 * Calendar Highlight Module - Fixed Version
 * Chỉ highlight khi hôm nay nằm trong tuần đang hiển thị
 */

(function() {
    'use strict';
    
    const HIGHLIGHT_CONFIG = {
        todayCellColor: 'rgba(254, 249, 195, 0.25)',
        todayHeaderColor: 'rgba(254, 249, 195, 0.4)',
        badgeBackground: '#fbbf24',
        badgeTextColor: '#78350f'
    };
    
    // ⭐️ THÊM: Lưu trữ thông tin tuần hiện tại
    let currentWeekOffset = window.currentWeekOffset || 0;
    
    /**
     * Khởi tạo module
     */
    function init() {
        console.log('🎨 Calendar Highlight đã khởi tạo');
        
        // Lắng nghe sự kiện chuyển tuần từ tasks.js
        document.addEventListener('weekChanged', function(event) {
            currentWeekOffset = event.detail.offset || 0;
            console.log('📅 Tuần đã thay đổi, offset mới:', currentWeekOffset);
            setTimeout(highlightTodayIfInWeek, 100);
        });
        
        // Lắng nghe sự kiện render calendar
        document.addEventListener('calendarRendered', function() {
            setTimeout(highlightTodayIfInWeek, 100);
        });
        
        // Hoặc wrap hàm navigateWeek
        if (window.navigateWeek) {
            const originalNavigateWeek = window.navigateWeek;
            window.navigateWeek = function(offset) {
                const result = originalNavigateWeek.apply(this, arguments);
                currentWeekOffset = window.currentWeekOffset || 0;
                console.log('🔄 CalendarHighlighter nhận biết tuần thay đổi:', currentWeekOffset);
                setTimeout(highlightTodayIfInWeek, 200);
                return result;
            };
        }
    }
    
    /**
     * ⭐️ HÀM QUAN TRỌNG: Chỉ highlight nếu hôm nay nằm trong tuần đang hiển thị
     */
    function highlightTodayIfInWeek() {
        console.log('🔍 Kiểm tra hôm nay có trong tuần hiển thị không...');
        
        // 1. Xóa highlight cũ
        removePreviousHighlight();
        
        // 2. Kiểm tra xem hôm nay có trong tuần này không
        const todayInfo = getTodayInDisplayedWeek();
        if (!todayInfo) {
            console.log('📅 Hôm nay KHÔNG nằm trong tuần này (offset:', currentWeekOffset, ')');
            return;
        }
        
        console.log('🎯 Hôm nay nằm trong tuần này:', todayInfo.dayName);
        
        // 3. Highlight nếu có
        highlightTodayHeader(todayInfo);
        highlightTodayColumn(todayInfo);
    }
    
    /**
     * Xác định xem hôm nay có trong tuần đang hiển thị không
     */
    function getTodayInDisplayedWeek() {
        const today = new Date();
        const startOfWeek = new Date();
        
        // ⭐️ TÍNH TOÁN CHÍNH XÁC TUẦN BẮT ĐẦU TỪ ĐÂU
        // Tùy thuộc vào logic của bạn (bắt đầu từ Chủ nhật hay Thứ hai)
        // Đây là ví dụ bắt đầu từ Chủ nhật (giống tasks.js)
        startOfWeek.setDate(today.getDate() - today.getDay() + (currentWeekOffset * 7));
        
        // Tính toán khoảng ngày
        const endOfWeek = new Date(startOfWeek);
        endOfWeek.setDate(startOfWeek.getDate() + 6);
        
        console.log('📅 Tuần hiển thị:', {
            start: startOfWeek.toDateString(),
            end: endOfWeek.toDateString(),
            today: today.toDateString(),
            offset: currentWeekOffset
        });
        
        // Kiểm tra nếu hôm nay nằm trong khoảng này
        if (today >= startOfWeek && today <= endOfWeek) {
            const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            const dayIndex = today.getDay(); // 0 = Sunday
            
            return {
                date: today,
                dayName: dayNames[dayIndex],
                dayIndex: dayIndex
            };
        }
        
        return null;
    }
    
    /**
     * Xóa highlight cũ
     */
    function removePreviousHighlight() {
        document.querySelectorAll('.today-highlight-cell').forEach(el => {
            el.classList.remove('today-highlight-cell');
            el.style.background = '';
        });
        
        document.querySelectorAll('.today-badge').forEach(badge => {
            badge.remove();
        });
    }
    
    /**
     * Highlight header
     */
    function highlightTodayHeader(todayInfo) {
        const headerCells = document.querySelectorAll('#calendarTable thead th');
        
        headerCells.forEach((th, index) => {
            if (index > 0) {
                const dayText = th.textContent.trim();
                if (dayText.includes(todayInfo.dayName)) {
                    th.style.background = HIGHLIGHT_CONFIG.todayHeaderColor;
                    
                    // Thêm badge đơn giản
                    const badge = document.createElement('span');
                    badge.className = 'today-badge';
                    badge.textContent = '●';
                    badge.title = 'Hôm nay';
                    badge.style.cssText = `
                        display: inline-block;
                        margin-left: 4px;
                        color: ${HIGHLIGHT_CONFIG.badgeBackground};
                        font-size: 12px;
                    `;
                    
                    th.appendChild(badge);
                }
            }
        });
    }
    
    /**
     * Highlight cột
     */
    function highlightTodayColumn(todayInfo) {
        const todayCells = document.querySelectorAll(`td[data-day="${todayInfo.dayName}"]`);
        
        todayCells.forEach(cell => {
            cell.classList.add('today-highlight-cell');
            cell.style.background = HIGHLIGHT_CONFIG.todayCellColor;
        });
    }
    
    // Export API
    window.CalendarHighlighter = {
        init,
        highlightTodayIfInWeek,
        getCurrentWeekOffset: () => currentWeekOffset
    };
    
    // Tự động khởi tạo
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        setTimeout(init, 1000);
    }
    
})();