document.addEventListener("DOMContentLoaded", () => {

    // Khai báo các biến DOM để tái sử dụng
    const settingsOverlay = document.getElementById("settingsOverlay");
    const settingForm = document.getElementById("settingForm");

    // BỔ SUNG: Khai báo các SELECT FIELDS để cập nhật giá trị
    const themeSelect = document.getElementById("theme-select");
    const languageSelect = document.getElementById("language-select");
    //const soundSelect = document.getElementById("sound-select"); // Giả sử id này tồn tại
    // BỔ SUNG: Khai báo các INPUT CHECKBOX nếu cần
    //const eventReminderToggle = document.querySelector('input[name="eventReminder"]'); // Cần gán name cho input

    // HÀM CHỈ CÓ TÁC DỤNG ĐÓNG MODAL (Giữ lại để sử dụng nội bộ)
    window.closeSettings = function () {
        if (settingsOverlay) {
            settingsOverlay.classList.add("hidden");
        }
    };

    // HÀM MỚI: TẢI DỮ LIỆU CÀI ĐẶT VÀ HIỂN THỊ OVERLAY (Thay thế cho openSettings)
    // Nút Settings trong HTML giờ phải gọi hàm này: onclick="loadSettingsAndOpen()"
    window.loadSettingsAndOpen = function () {

        // 1. Tải dữ liệu từ API Controller mới
        fetch('setting')
                .then(res => {
                    // Kiểm tra HTTP status code
                    if (!res.ok) {
                        throw new Error("Lỗi tải dữ liệu: " + res.status);
                    }
                    return res.json();
                })
                .then(settings => {

                    // 2. Cập nhật các trường SELECT/INPUT với dữ liệu nhận được

                    // Cập nhật Select Fields
                    if (themeSelect && settings.theme) {
                        themeSelect.value = settings.theme;
                    }
                    if (languageSelect && settings.language) {
                        languageSelect.value = settings.language;
                    }
//                if (soundSelect && settings.sound) {
//                    soundSelect.value = settings.sound; 
//                }
//                
//                // Cập nhật Checkbox/Toggle (Ví dụ: Nhắc nhở sự kiện)
//                if (eventReminderToggle && settings.eventReminder) {
//                     // Chuyển giá trị từ server (ví dụ: "true" hoặc true) thành boolean
//                    eventReminderToggle.checked = (settings.eventReminder === true || settings.eventReminder === "true");
//                }

                    // 3. Hiển thị Overlay sau khi dữ liệu đã sẵn sàng
                    if (settingsOverlay) {
                        settingsOverlay.classList.remove("hidden");
                    }
                })
                .catch(error => {
                    console.error("Không thể tải cài đặt người dùng:", error);
                    alert("Lỗi kết nối. Không thể tải cài đặt.");
                });
    };

    // --- LOGIC MỞ/ĐÓNG VÀ FORM SUBMIT GIỮ NGUYÊN ---

    if (settingsOverlay) {
        // Lắng nghe sự kiện click vào nền mờ (Đóng Overlay)
        settingsOverlay.addEventListener('click', (e) => {
            if (e.target === settingsOverlay) {
                window.closeSettings();
            }
        });

        // Cần đảm bảo có nút đóng (closeSettings) nếu không dùng nền mờ
        const closeButton = document.getElementById("closeSettings");
        if (closeButton) {
            closeButton.addEventListener('click', window.closeSettings);
        }
    }

    // XỬ LÝ FORM SUBMIT
    if (settingForm) {
        settingForm.addEventListener("submit", async (e) => {
            e.preventDefault();

            // 1. THU THẬP DỮ LIỆU TỪ FORM
            // Lệnh này chỉ hoạt động nếu các thẻ <select> và <input> có thuộc tính 'name'
            const fd = new FormData(e.target);
            const obj = Object.fromEntries(fd);

            // KIỂM TRA DEBUG: Kiểm tra đối tượng obj trước khi gửi
            console.log("Dữ liệu Form đã thu thập:", obj);

            // Đảm bảo obj có chứa theme, language, v.v.
            if (Object.keys(obj).length === 0) {
                console.error("Lỗi: FormData không thu thập được dữ liệu. Kiểm tra thuộc tính 'name' của form elements.");
                alert("Lưu cài đặt thất bại: Dữ liệu trống.");
                return;
            }

            try {
                // 2. GỬI REQUEST POST
                const response = await fetch('update-settings', {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify(obj)
                });

                // 3. XỬ LÝ PHẢN HỒI
                if (response.ok) {
                    // Giả định hàm applySettings(obj) cập nhật UI thành công
                    // ÁP DỤNG THAY ĐỔI GIAO DIỆN Ở ĐÂY
                    applySettings(obj);

                    window.closeSettings();
                    console.log("Cài đặt đã được lưu thành công.");

                } else {
                    const errorData = await response.json().catch(() => ({error: 'Lỗi server không xác định.'}));

                    console.error("Lỗi khi cập nhật cài đặt:", response.status, errorData.error);
                    alert(`Cập nhật thất bại (${response.status}): ${errorData.error || response.statusText}`);
                }

            } catch (error) {
                console.error("Lỗi mạng/Kết nối:", error);
                alert("Lỗi kết nối. Không thể lưu cài đặt.");
            }
        });
    }

    // HÀM ÁP DỤNG CÀI ĐẶT (Giữ nguyên)
    function applySettings(settings) {
        const htmlEl = document.documentElement;
        if (settings.theme === 'dark') {
            htmlEl.classList.add('dark');
        } else {
            htmlEl.classList.remove('dark');
        }

        if (settings.language) {
            htmlEl.lang = settings.language;
        }

        console.log("Cài đặt đã được áp dụng thành công.");
    }

});