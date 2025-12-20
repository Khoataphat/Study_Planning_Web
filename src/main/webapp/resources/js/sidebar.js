document.addEventListener('DOMContentLoaded', () => {
    const sidebar = document.getElementById('sidebar');
    const body = document.body;
    const navLinks = document.querySelectorAll('.nav-link');
    const delayStep = 0.05;
    
    // Khóa (key) dùng để lưu trạng thái trong localStorage
    const STORAGE_KEY = 'isSidebarExpanded';

    // ===============================================
    // 1. ÁP DỤNG TRẠNG THÁI ĐÃ LƯU KHI TẢI TRANG
    // ===============================================
    const savedState = localStorage.getItem(STORAGE_KEY);
    
    if (savedState === 'true') {
        // Áp dụng class nếu trạng thái đã lưu là mở rộng
        body.classList.add('sidebar-expanded');
        
        // Kích hoạt hiệu ứng stagger ngay lập tức (vì trang đang mở)
        navLinks.forEach((link, index) => {
             const textSpan = link.querySelector('.sidebar-text');
             if (textSpan) {
                const delay = (index * delayStep) + 's';
                textSpan.style.setProperty('--stagger-delay', delay);
             }
         });
    }

    // ===============================================
    // 2. LƯU TRẠNG THÁI MỚI KHI NGƯỜI DÙNG TƯƠNG TÁC
    // ===============================================
    if (sidebar) {
        sidebar.addEventListener('click', (e) => {
            if (e.target.closest('a')) {
                return;
            }

            // Chuyển đổi class
            body.classList.toggle('sidebar-expanded');

            const isExpanded = body.classList.contains('sidebar-expanded');
            
            // LƯU TRẠNG THÁI MỚI VÀO localStorage
            localStorage.setItem(STORAGE_KEY, isExpanded);

            // Áp dụng hiệu ứng stagger
            navLinks.forEach((link, index) => {
                const textSpan = link.querySelector('.sidebar-text');
                if (textSpan) {
                    if (isExpanded) {
                        const delay = (index * delayStep) + 's';
                        textSpan.style.setProperty('--stagger-delay', delay);
                    } else {
                        textSpan.style.setProperty('--stagger-delay', '0s');
                    }
                }
            });
        });
    }
});