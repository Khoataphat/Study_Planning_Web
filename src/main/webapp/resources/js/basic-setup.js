document.addEventListener('DOMContentLoaded', function() {
    // 1. Lấy các phần tử HTML cần thiết
    const stepContents = document.querySelectorAll('.step-content');
    const nextButton = document.getElementById('next-button');
    const prevButton = document.getElementById('prev-button'); 
    
    // Khắc phục lỗi: Lấy các ID nằm trong các bước đang được hiển thị
    const currentStepSpan = document.getElementById('current-step');
    const stepSubtitleSpan = document.getElementById('step-subtitle');
    
    const setupForm = document.getElementById('setup-form');
    let currentStep = 1;

    // 2. Định nghĩa tiêu đề và thông tin các bước
    const stepTitles = [
        { title: "Mục tiêu học tập (Goals)" },
        { title: "Phong cách học (Study Style)" },
        { title: "Năng lượng & thói quen (Lifestyle)" }
    ];

    // 3. Hàm cập nhật giao diện (ẩn/hiện bước, đổi nút)
    function updateUI() {
        // Ẩn tất cả các bước
        stepContents.forEach(div => div.classList.add('hidden'));

        // Hiện bước hiện tại
        const currentStepDiv = document.getElementById(`step-${currentStep}`);
        if (currentStepDiv) {
            currentStepDiv.classList.remove('hidden');
        }

        // Cập nhật số bước và tiêu đề phụ (Khắc phục lỗi TypeError)
        // Lưu ý: Mặc dù các ID nằm trong các bước, JS vẫn tìm thấy chúng khi chúng được render.
        if (currentStepSpan && stepSubtitleSpan) {
            currentStepSpan.textContent = currentStep;
            stepSubtitleSpan.textContent = stepTitles[currentStep - 1].title;
        }


        // Cập nhật nút TIẾP THEO/HOÀN THÀNH
        if (currentStep === stepContents.length) {
            nextButton.textContent = 'Hoàn thành';
            nextButton.type = 'submit';
        } else {
            nextButton.textContent = 'Tiếp theo';
            nextButton.type = 'button';
        }
        
        // Cập nhật nút QUAY LẠI
        if (currentStep > 1) {
            prevButton.classList.remove('hidden'); // Hiển thị nút Quay lại từ bước 2 trở đi
        } else {
            prevButton.classList.add('hidden'); // Ẩn nút Quay lại ở bước 1
        }
    }

    // 4. Xử lý sự kiện khi nhấn nút TIẾP THEO/HOÀN THÀNH
    nextButton.addEventListener('click', function() {
        if (currentStep < stepContents.length) {
            currentStep++;
            updateUI();
        } else {
            // Bước cuối: Gửi form
            setupForm.submit();
        }
    });

    // 5. Xử lý sự kiện khi nhấn nút QUAY LẠI
    prevButton.addEventListener('click', function() {
        if (currentStep > 1) {
            currentStep--;
            updateUI();
        }
    });
    
    // 6. Khởi tạo giao diện lần đầu
    updateUI();
});