<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentTheme" value="${empty theme ? 'light' : theme}" />
<!DOCTYPE html>
<html lang="en" class="${currentTheme == 'dark' ? 'dark' : ''}">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Smart Schedule - PlanZ</title>

        <!-- Tailwind CSS & Plugins -->
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>

        <!-- Google Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />

        <!-- Custom Config & Styles -->
        <script src="../resources/js/tailwind-config.js"></script>
        <link rel="stylesheet" href="../resources/css/pastel-overrides.css">
        <link rel="stylesheet" href="/resources/css/sidebar.css">

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

                            //new
                            "surface-light": "#FFFFFF",
                            "surface-dark": "#293548",
                            "text-light": "#1E293B",
                            "text-dark": "#E2E8F0",
                            "border-light": "#E5E7EB",
                            "border-dark": "#475569",
                            "secondary-pink": "#F9A8D4",
                            "secondary-indigo-light": "#C7D2FE",
                            "secondary-yellow": "#FDE68A",
                        },
                        fontFamily: {
                            display: ["Be Vietnam Pro", "Quicksand", "sans-serif"],
                        },
                        borderRadius: {
                            DEFAULT: "0.75rem",
                        },
                    },
                },
            };
        </script>
    </head>
    <body class="font-display bg-background-light dark:bg-background-dark text-text-color dark:text-slate-200">
        <div class="flex h-screen">
            <!-- Sidebar -->
            <aside id="sidebar" class="bg-white dark:bg-slate-900 flex flex-col py-6 space-y-8 border-r border-slate-200 dark:border-slate-800 h-screen fixed top-0 left-0 transition-all duration-500 z-40 cursor-pointer">
                <div class="w-14 h-14 bg-primary rounded-full flex items-center justify-center shrink-0 mx-auto">
                    <span class="material-icons-outlined text-white text-3xl">face</span>
                </div>

                <nav class="flex flex-col space-y-2 flex-grow w-full">
                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300" href="/dashboard">
                        <span class="material-icons-outlined text-3xl shrink-0">dashboard</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Bảng điều khiển</span>
                    </a>

                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300" href="${pageContext.request.contextPath}/schedule">
                        <span class="material-icons-outlined text-3xl shrink-0">event</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Lịch của tôi</span>
                    </a>

                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300" href="${pageContext.request.contextPath}/tasks">
                        <span class="material-icons-outlined text-3xl shrink-0">add_task</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Nhiệm vụ</span>
                    </a>

                    <!-- Active Link for Smart Schedule -->
                    <a class="nav-link w-full rounded-lg transition-colors bg-gradient-to-r from-indigo-500 to-purple-500 shadow-md shadow-primary/30 text-white" href="${pageContext.request.contextPath}/smart-schedule">
                        <span class="material-icons-outlined text-3xl shrink-0">auto_awesome</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Tạo lịch AI</span>
                    </a>

                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300" href="${pageContext.request.contextPath}/statistics">
                        <span class="material-icons-outlined text-3xl shrink-0">interests</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Thống kê</span>
                    </a>
                    <%-- Active state for Quiz --%>
                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                       href="${pageContext.request.contextPath}/QuizResultController">
                        <span class="material-icons-outlined text-3xl shrink-0">psychology</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Khám phá bản thân</span>
                    </a>
                        
                                        <%-- Timer --%>
                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                       href="${pageContext.request.contextPath}/timer">
                        <span class="material-icons-outlined text-3xl shrink-0">timer</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Bộ hẹn giờ</span>
                    </a>
                </nav>
            </aside>

            <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 overflow-y-auto">
                <header class="flex justify-between items-center mb-6">
                    <div>
                        <h1 class="text-2xl font-bold text-text-color dark:text-white flex items-center gap-2">
                            Tạo Thời Khóa Biểu Thông Minh
                            <span class="material-icons-outlined text-yellow-500">bolt</span>
                        </h1>
                        <p class="text-slate-500 dark:text-slate-400">Hãy cho chúng tôi biết ưu tiên của bạn, và AI sẽ tạo ra lịch trình hoàn hảo.</p>
                    </div>
                    <!-- User Controls -->
                    <div class="flex items-center space-x-4">
                        <button class="p-2 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" onclick="loadSettingsAndOpen()">
                            <span class="material-icons-outlined text-slate-600 dark:text-slate-300">settings</span>
                        </button>
                        <a href="/logout" class="p-2 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors">
                            <span class="material-icons-outlined text-slate-600 dark:text-slate-300">logout</span>
                        </a>
                    </div>
                </header>

                <!-- Main Content Area -->
                <div class="flex-1 flex items-center justify-center">
                    <div class="bg-white dark:bg-slate-800 rounded-3xl shadow-xl w-full max-w-6xl overflow-hidden border border-slate-100 dark:border-slate-700 flex flex-col md:flex-row min-h-[600px]">

                        <!-- Left: Controls -->
                        <div class="w-full md:w-1/3 p-10 bg-slate-50/50 dark:bg-slate-800/50 border-r border-slate-200 dark:border-slate-700">
                            <h3 class="text-xl font-bold text-slate-800 dark:text-white mb-6">Tùy Chỉnh</h3>

                            <form id="smartScheduleForm" class="space-y-8">

                                <!-- Schedule Selection -->
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2">Chọn Lịch Áp Dụng</label>
                                    <div class="relative">
                                        <select id="scheduleSelect" class="w-full pl-4 pr-10 py-3 bg-white dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-shadow appearance-none cursor-pointer">
                                            <option value="">Đang tải...</option>
                                        </select>
                                        <div class="absolute inset-y-0 right-0 flex items-center px-3 pointer-events-none text-slate-500">
                                            <span class="material-icons-outlined">expand_more</span>
                                        </div>
                                    </div>
                                    <p class="text-xs text-slate-400 mt-1">Lịch cũ trong bộ sưu tập này sẽ bị ghi đè.</p>
                                </div>

                                <!-- Priority Focus -->
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2">Ưu tiên hàng đầu</label>
                                    <div class="relative">
                                        <select id="aiPriority" class="w-full pl-4 pr-10 py-3 bg-white dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-shadow appearance-none cursor-pointer">
                                            <option value="relax">Thư giãn (Có nghỉ ngơi)</option>
                                            <option value="work">Tập trung Học tập/Làm việc</option>
                                            <option value="deadline">Chạy Deadline</option>
                                        </select>
                                        <div class="absolute inset-y-0 right-0 flex items-center px-3 pointer-events-none text-slate-500">
                                            <span class="material-icons-outlined">expand_more</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Active Hours -->
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 dark:text-slate-300 mb-2">Khung giờ rảnh</label>
                                    <div class="flex items-center gap-3">
                                        <div class="relative flex-1">
                                            <input type="time" id="aiStartTime" value="09:00" class="w-full px-4 py-3 bg-white dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl focus:ring-indigo-500">
                                        </div>
                                        <span class="text-slate-400 font-bold">-</span>
                                        <div class="relative flex-1">
                                            <input type="time" id="aiEndTime" value="17:00" class="w-full px-4 py-3 bg-white dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl focus:ring-indigo-500">
                                        </div>
                                    </div>
                                </div>

                                <!-- Toggle Options -->
                                <div class="space-y-4 pt-2">
                                    <label class="flex items-center justify-between cursor-pointer group hover:bg-slate-100 dark:hover:bg-slate-700 p-2 rounded-lg transition-colors">
                                        <span class="text-slate-700 dark:text-slate-300 font-medium">Bao gồm cuối tuần</span>
                                        <div class="relative">
                                            <input type="checkbox" id="aiWeekends" class="sr-only peer">
                                            <div class="w-11 h-6 bg-slate-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-indigo-300 dark:peer-focus:ring-indigo-800 rounded-full peer dark:bg-slate-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-indigo-600"></div>
                                        </div>
                                    </label>

                                    <label class="flex items-center justify-between cursor-pointer group hover:bg-slate-100 dark:hover:bg-slate-700 p-2 rounded-lg transition-colors">
                                        <span class="text-slate-700 dark:text-slate-300 font-medium">Tự động thêm giờ nghỉ trưa</span>
                                        <div class="relative">
                                            <input type="checkbox" id="aiBreaks" checked class="sr-only peer">
                                            <div class="w-11 h-6 bg-slate-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-indigo-300 dark:peer-focus:ring-indigo-800 rounded-full peer dark:bg-slate-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-indigo-600"></div>
                                        </div>
                                    </label>
                                </div>

                            </form>
                        </div>

                        <!-- Right: Visualization / Action -->
                        <div class="w-full md:w-2/3 p-10 bg-white dark:bg-slate-800 flex flex-col items-center justify-center relative">
                            <!-- Decorative Background Blob -->
                            <div class="absolute top-0 right-0 w-64 h-64 bg-purple-100 rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-blob"></div>
                            <div class="absolute bottom-0 left-0 w-64 h-64 bg-indigo-100 rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-blob animation-delay-2000"></div>

                            <div id="aiPreviewState" class="text-center space-y-8 z-10 max-w-lg">
                                <div class="w-72 h-auto mx-auto transform hover:scale-105 transition-transform duration-500">
                                    <!-- Use a nice placehoder image or illustration -->
                                    <img src="https://cdni.iconscout.com/illustration/premium/thumb/business-planning-4440059-3683050.png" alt="AI Planning" class="w-full drop-shadow-2xl">
                                </div>

                                <div>
                                    <h3 class="text-3xl font-bold text-slate-800 dark:text-white mb-4">Sẵn sàng để sắp xếp?</h3>
                                    <p class="text-lg text-slate-500 dark:text-slate-400">
                                        Hệ thống AI của chúng tôi sẽ phân tích danh sách nhiệm vụ của bạn và tạo ra một thời khóa biểu tối ưu, giúp bạn làm việc hiệu quả hơn mà không bị quá tải.
                                    </p>
                                </div>

                                <button onclick="generateSmartSchedule()" id="btnGenerate" class="w-full py-4 bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 text-white text-lg font-bold rounded-2xl shadow-xl shadow-indigo-200 hover:shadow-indigo-400 transform hover:-translate-y-1 transition-all flex items-center justify-center gap-3">
                                    <span class="material-icons-outlined text-3xl">auto_fix_high</span>
                                    Tạo Thời Khóa Biểu Ngay
                                </button>
                            </div>
                        </div>

                    </div>
                </div>
            </main>
        </div>
        <%-- 1. THÊM LỚP PHỦ CÀI ĐẶT TẠI ĐÂY --%>
        <%-- Đảm bảo toàn bộ HTML của lớp phủ được tải vào DOM trước khi JS chạy --%>
        <%@ include file="settings-overlay.jsp" %>   
        <script src="../resources/js/smart-schedule.js"></script>
        <script src="/resources/js/sidebar.js"></script>
        <!-- khoa -->
        <script src="/resources/js/setting.js"></script>
        <!-- Initialize Collections Dropdown -->
        <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        // Load schedule collections for the dropdown
                                        fetch('/user/collections?action=list')
                                                .then(response => response.json())
                                                .then(collections => {
                                                    const select = document.getElementById('scheduleSelect');
                                                    select.innerHTML = '<option value="">Chọn bộ sưu tập...</option>';

                                                    if (collections && collections.length > 0) {
                                                        collections.forEach(collection => {
                                                            const option = document.createElement('option');
                                                            option.value = collection.collectionId;
                                                            option.textContent = collection.collectionName;
                                                            select.appendChild(option);
                                                        });
                                                        // Select first one by default
                                                        select.value = collections[0].collectionId;
                                                        window.currentCollectionId = collections[0].collectionId;
                                                    } else {
                                                        select.innerHTML = '<option value="">Chưa có bộ sưu tập nào</option>';
                                                    }
                                                })
                                                .catch(error => console.error('Error loading collections:', error));

                                        // Sync currentCollectionId on change
                                        document.getElementById('scheduleSelect').addEventListener('change', function (e) {
                                            window.currentCollectionId = e.target.value;
                                        });
                                    });
        </script>

        <!-- Feedback Modal -->
        <div id="feedbackModal" class="fixed inset-0 z-50 hidden" aria-labelledby="modal-title" role="dialog" aria-modal="true">
            <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" onclick="closeFeedbackModal()"></div>
            <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
                <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
                    <div class="relative transform overflow-hidden rounded-2xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
                        <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                            <div class="sm:flex sm:items-start">
                                <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left w-full">
                                    <h3 class="text-xl font-bold leading-6 text-gray-900 mb-4" id="modal-title">Góp ý về Thời khóa biểu của bạn</h3>
                                    
                                    <p class="text-sm text-gray-500 mb-4">Mức độ hài lòng của bạn?</p>
                                    
                                    <div class="flex justify-center gap-4 mb-6" id="ratingContainer">
                                        <button onclick="selectRating(1)" class="rating-btn text-3xl opacity-50 hover:opacity-100 hover:scale-110 transition-all filter grayscale hover:grayscale-0" data-rating="1">😫</button>
                                        <button onclick="selectRating(2)" class="rating-btn text-3xl opacity-50 hover:opacity-100 hover:scale-110 transition-all filter grayscale hover:grayscale-0" data-rating="2">😟</button>
                                        <button onclick="selectRating(3)" class="rating-btn text-3xl opacity-50 hover:opacity-100 hover:scale-110 transition-all filter grayscale hover:grayscale-0" data-rating="3">😐</button>
                                        <button onclick="selectRating(4)" class="rating-btn text-3xl opacity-50 hover:opacity-100 hover:scale-110 transition-all filter grayscale hover:grayscale-0" data-rating="4">🙂</button>
                                        <button onclick="selectRating(5)" class="rating-btn text-3xl opacity-50 hover:opacity-100 hover:scale-110 transition-all filter grayscale hover:grayscale-0" data-rating="5">🤩</button>
                                    </div>
                                    <input type="hidden" id="feedbackRating" value="0">

                                    <div class="mt-2">
                                        <textarea id="feedbackComment" rows="4" class="w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 p-2" placeholder="Hãy chia sẻ cảm nhận của bạn để chúng tôi có thể cải thiện tốt hơn nhé..."></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
                            <button type="button" onclick="submitFeedback()" class="inline-flex w-full justify-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 sm:ml-3 sm:w-auto">Gửi Góp Ý</button>
                            <button type="button" onclick="closeFeedbackModal()" class="mt-3 inline-flex w-full justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto">Để sau</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </body>

</html>
