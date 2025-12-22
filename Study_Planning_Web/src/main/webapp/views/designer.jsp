<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" class="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Schedule Designer - PlanZ</title>
    
    <!-- Tailwind CSS & Plugins -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Custom Config & Styles -->
    <script src="../resources/js/tailwind-config.js"></script>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        // Đã thay đổi primary về một màu nổi hơn cho dễ nhìn
                        primary: "#4F46E5", // Thay #A5B4FC bằng Indigo 600
                        "background-light": "#F8FAFC",
                        "background-dark": "#0F172A",
                        // New pastel colors
                        "pastel-purple": "#A5B4FC",
                        "pastel-light-purple": "#C7D2FE",
                        "pastel-pink": "#F9A8D4",
                        "pastel-yellow": "#FDE68A",
                        "text-color": "#1E293B",
                        "pinky": "#F9A8D4",
                    },
                    fontFamily: {
                        display: ["Quicksand", "sans-serif"],
                    },
                    borderRadius: {
                        DEFAULT: "0.75rem",
                    },
                },
            },
        };
    </script>
    <link rel="stylesheet" href="../resources/css/pastel-overrides.css">
    <link rel="stylesheet" href="../resources/css/designer.css">
    <link rel="stylesheet" href="/resources/css/sidebar.css">
</head>
<body class="font-display bg-background-light dark:bg-background-dark text-text-color dark:text-slate-200">
    <div class="flex h-screen">
        <aside 
            id="sidebar"
            class="bg-white dark:bg-slate-900 flex flex-col py-6 space-y-8 border-r border-slate-200 dark:border-slate-800 
            h-screen fixed top-0 left-0 transition-all duration-500 z-40 cursor-pointer"
            >

            <div class="w-14 h-14 bg-primary rounded-full flex items-center justify-center shrink-0 mx-auto">
                <span class="material-icons-outlined text-white text-3xl">face</span>
            </div>

            <nav class="flex flex-col space-y-2 flex-grow w-full">

                <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                   href="/dashboard">
                    <span class="material-icons-outlined text-3xl shrink-0">dashboard</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Bảng điều khiển</span>
                </a>

                <%-- Active state for Designer (under My Schedule context) --%>
                <a class="nav-link w-full rounded-lg transition-colors bg-primary shadow-md shadow-primary/30 text-white"
                   href="${pageContext.request.contextPath}/schedule">
                    <span class="material-icons-outlined text-3xl shrink-0">event</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Lịch của tôi</span>
                </a>

                <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                   href="${pageContext.request.contextPath}/tasks">
                    <span class="material-icons-outlined text-3xl shrink-0">add_task</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Nhiệm vụ</span>
                </a>

                <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300" 
                   href="${pageContext.request.contextPath}/smart-schedule">
                    <span class="material-icons-outlined text-3xl shrink-0">auto_awesome</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Tạo lịch AI</span>
                </a>

                <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                   href="${pageContext.request.contextPath}/statistics">
                    <span class="material-icons-outlined text-3xl shrink-0">interests</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Thống kê</span>
                </a>

                <%-- Active state for Quiz --%>
                <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                   href="${pageContext.request.contextPath}/QuizResultController">
                    <span class="material-icons-outlined text-3xl shrink-0">psychology</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Khám phá bản thân</span>
                </a>
            </nav>
        </aside>

        <!-- Main Content Area -->
        <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 overflow-y-auto ml-20 lg:ml-64 transition-all duration-500">
            
            <!-- Designer Header -->
            <header class="flex justify-between items-center mb-6 bg-white rounded-2xl p-4 shadow-sm border border-slate-100">
                <div>
                    <h2 class="text-lg font-bold text-slate-800">Tạo Thời Khóa Biểu Mới</h2>
                    <p class="text-xs text-slate-500">Kéo thả sự kiện vào lịch để bắt đầu</p>
                </div>
                <div class="flex items-center gap-3">
                    <button class="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-lg transition-all">
                        <i class="fa-solid fa-bell"></i>
                    </button>
                    <button class="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-lg transition-all">
                        <i class="fa-solid fa-cog"></i>
                    </button>
                    <button onclick="saveSchedule()" class="px-6 py-2 bg-primary text-white rounded-lg font-semibold hover:bg-primary/90 transition-all flex items-center gap-2">
                        <i class="fa-solid fa-save"></i>
                        Lưu
                    </button>
                </div>
            </header>

            <!-- Calendar Grid -->
            <div class="flex-1 overflow-auto">
                <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
                    <table class="w-full border-collapse">
                        <thead>
                            <tr class="bg-slate-50">
                                <th class="p-3 text-left text-xs font-semibold text-slate-500 border-b border-slate-200 w-20">Giờ</th>
                                <th class="p-3 text-center text-xs font-semibold text-slate-700 border-b border-l border-slate-200">Thứ 2</th>
                                <th class="p-3 text-center text-xs font-semibold text-slate-700 border-b border-l border-slate-200">Thứ 3</th>
                                <th class="p-3 text-center text-xs font-semibold text-slate-700 border-b border-l border-slate-200">Thứ 4</th>
                                <th class="p-3 text-center text-xs font-semibold text-slate-700 border-b border-l border-slate-200">Thứ 5</th>
                                <th class="p-3 text-center text-xs font-semibold text-slate-700 border-b border-l border-slate-200">Thứ 6</th>
                                <th class="p-3 text-center text-xs font-semibold text-slate-700 border-b border-l border-slate-200">Thứ 7</th>
                                <th class="p-3 text-center text-xs font-semibold text-slate-700 border-b border-l border-slate-200">Chủ Nhật</th>
                            </tr>
                        </thead>
                        <tbody id="scheduleGrid">
                            <!-- Time slots will be generated here -->
                        </tbody>
                    </table>
                </div>
            </div>
        </main>

        <!-- Right Sidebar - Tools & Event Details -->
        <aside class="w-80 flex flex-col bg-white border-l border-slate-200 overflow-y-auto">
            
            <!-- Tool Box -->
            <div class="p-4 border-b border-slate-200">
                <h3 class="text-sm font-bold text-slate-700 mb-3">Hộp công cụ</h3>
                <div class="grid grid-cols-2 gap-2">
                    <div class="task-item p-3 bg-indigo-100 rounded-xl text-center cursor-move border-2 border-indigo-200"
                         draggable="true" 
                         ondragstart="dragTask(event)"
                         data-task-type="study"
                         data-task-name="Học tập"
                         data-task-color="#A5B4FC">
                        <div class="text-xl mb-1">📚</div>
                        <p class="text-xs font-semibold text-indigo-900">Học tập</p>
                    </div>
                    <div class="task-item p-3 bg-pink-100 rounded-xl text-center cursor-move border-2 border-pink-200"
                         draggable="true" 
                         ondragstart="dragTask(event)"
                         data-task-type="break"
                         data-task-name="Giải lao"
                         data-task-color="#F9A8D4">
                        <div class="text-xl mb-1">☕</div>
                        <p class="text-xs font-semibold text-pink-900">Giải lao</p>
                    </div>
                    <div class="task-item p-3 bg-yellow-100 rounded-xl text-center cursor-move border-2 border-yellow-200"
                         draggable="true" 
                         ondragstart="dragTask(event)"
                         data-task-type="work"
                         data-task-name="Làm việc"
                         data-task-color="#FDE047">
                        <div class="text-xl mb-1">💼</div>
                        <p class="text-xs font-semibold text-yellow-900">Làm việc</p>
                    </div>
                    <div class="task-item p-3 bg-blue-100 rounded-xl text-center cursor-move border-2 border-blue-200"
                         draggable="true" 
                         ondragstart="dragTask(event)"
                         data-task-type="hobby"
                         data-task-name="Sở thích"
                         data-task-color="#93C5FD">
                        <div class="text-xl mb-1">🎨</div>
                        <p class="text-xs font-semibold text-blue-900">Sở thích</p>
                    </div>
                </div>
            </div>

            <!-- Event Details Form -->
            <div class="p-4 flex-1">
                <h3 class="text-sm font-bold text-slate-700 mb-3">Chi tiết sự kiện</h3>
                
                <div class="space-y-3">
                    <!-- Event Name -->
                    <div>
                        <label class="text-xs font-semibold text-slate-600 mb-2 block">Tên sự kiện</label>
                        <input type="text" id="eventName" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:border-primary focus:ring-1 focus:ring-primary" placeholder="Ví dụ: Học Toán">
                    </div>

                    <!-- Time Range -->
                    <div class="grid grid-cols-2 gap-3">
                        <div>
                            <label class="text-xs font-semibold text-slate-600 mb-2 block">Bắt đầu</label>
                            <input type="time" id="startTime" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:border-primary focus:ring-1 focus:ring-primary" value="09:00">
                        </div>
                        <div>
                            <label class="text-xs font-semibold text-slate-600 mb-2 block">Kết thúc</label>
                            <input type="time" id="endTime" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:border-primary focus:ring-1 focus:ring-primary" value="11:00">
                        </div>
                    </div>

                    <!-- Description -->
                    <div>
                        <label class="text-xs font-semibold text-slate-600 mb-2 block">Mô tả</label>
                        <textarea id="eventDesc" rows="2" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:border-primary focus:ring-1 focus:ring-primary resize-none" placeholder="Thêm mô tả ngắn..."></textarea>
                    </div>

                    <!-- Repeat -->
                    <div>
                        <label class="text-xs font-semibold text-slate-600 mb-2 block">Lặp lại</label>
                        <select id="eventRepeat" class="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:border-primary focus:ring-1 focus:ring-primary">
                            <option>Không lặp lại</option>
                            <option>Hàng tuần</option>
                            <option>Hàng tháng</option>
                        </select>
                    </div>

                    <!-- Action Buttons -->
                    <!-- Action Buttons -->
                    <div class="pt-3 space-y-2">
                        <button id="btnSaveEvent" onclick="addEventToCalendar()" class="w-full py-2 bg-primary text-white rounded-lg text-sm font-semibold hover:bg-primary/90 transition-all">
                            Thêm vào lịch
                        </button>
                        <button id="btnDeleteEvent" onclick="deleteSelectedEvent()" class="w-full py-2 bg-red-400 text-white rounded-lg text-sm font-semibold hover:bg-red-500 transition-all hidden">
                            Xóa sự kiện
                        </button>
                        <button id="btnClearForm" onclick="clearForm()" class="w-full py-2 bg-slate-100 text-slate-700 rounded-lg text-sm font-semibold hover:bg-slate-200 transition-all">
                            Làm mới
                        </button>
                    </div>
                </div>
            </div>
        </aside>
    </div>

    <script src="../resources/js/designer.js"></script>
    <script src="/resources/js/sidebar.js"></script>

</body>
</html>
