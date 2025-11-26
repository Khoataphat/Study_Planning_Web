document.addEventListener('DOMContentLoaded', function () {
    // 1. Lấy các phần tử cần thiết
    const sidebar = document.getElementById('sidebar');
    const profileSection = document.getElementById('profileSection');
    const headerTitle = document.getElementById('sidebarTitle');
    const smallLogo = document.getElementById('sidebarSmallLogo');
    const navTextSpans = document.querySelectorAll('.nav-text');

    // 2. Thiết lập trạng thái ban đầu (Mặc định là thu gọn)
    let isExpanded = false; 

    // Hàm áp dụng trạng thái thu gọn
    function collapseSidebar() {
        isExpanded = false;

        // 1. Độ rộng
        sidebar.classList.remove('w-64');
        sidebar.classList.add('w-20');
        
        // 2. Ẩn Text và Profile
        navTextSpans.forEach(span => {
            span.classList.remove('opacity-100');
            span.classList.add('opacity-0');
        });
        profileSection.classList.add('hidden');
        
        // 3. Ẩn Tiêu đề lớn, hiện Logo nhỏ
        headerTitle.classList.add('hidden');
        smallLogo.classList.remove('hidden');
    }

    // Hàm áp dụng trạng thái mở rộng
    function expandSidebar() {
        isExpanded = true;
        
        // 1. Độ rộng
        sidebar.classList.remove('w-20');
        sidebar.classList.add('w-64');

        // 2. Hiển thị Text và Profile
        navTextSpans.forEach(span => {
            span.classList.remove('opacity-0');
            span.classList.add('opacity-100');
        });
        profileSection.classList.remove('hidden');
        
        // 3. Hiện Tiêu đề lớn, ẩn Logo nhỏ
        headerTitle.classList.remove('hidden');
        smallLogo.classList.add('hidden');
    }

    // 3. Trình xử lý sự kiện click
    function handleSidebarClick() {
        if (isExpanded) {
            collapseSidebar();
        } else {
            expandSidebar();
        }
    }

    // 4. Khởi tạo trạng thái thu gọn ban đầu
    collapseSidebar();

    // 5. Thêm trình lắng nghe sự kiện CLICK vào chính sidebar
    sidebar.addEventListener('click', handleSidebarClick);
});