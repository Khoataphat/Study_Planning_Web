<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" class="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Management - PlanZ</title>
    
    <!-- Tailwind CSS & Plugins -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Custom Config & Styles -->
    <script src="../resources/js/tailwind-config.js"></script>
    <link rel="stylesheet" href="../resources/css/pastel-overrides.css">
    <link rel="stylesheet" href="../resources/css/tasks.css">
    <!-- khoa -->
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
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
        <link rel="stylesheet" href="/resources/css/sidebar.css">
        <!-- khoa -->
</head>
<!-- khoa -->
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

                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                       href="${pageContext.request.contextPath}/schedule">
                        <span class="material-icons-outlined text-3xl shrink-0">event</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Lịch của tôi</span>
                    </a>

                    <a class="nav-link w-full rounded-lg transition-colors bg-primary shadow-md shadow-primary/30 text-white"
                       href="${pageContext.request.contextPath}/tasks">
                        <span class="material-icons-outlined text-3xl shrink-0">add_task</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Nhiệm vụ</span>
                    </a>

                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                       href="${pageContext.request.contextPath}/statistics">
                        <span class="material-icons-outlined text-3xl shrink-0">interests</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Thống kê</span>
                    </a>
                </nav>
            </aside>

            <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 overflow-y-auto">
                <header class="flex justify-between items-center mb-6">
                    <div>
                        <h1 class="text-2xl font-bold text-text-color dark:text-white">Chào buổi sáng, ${user.username}!</h1>
                        <p class="text-slate-500 dark:text-slate-400">Đây là trang thêm task</p>
                    </div>
                    <div class="flex items-center space-x-4">
                        <button class="p-2 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" aria-label="Settings">
                            <span class="material-icons-outlined text-slate-600 dark:text-slate-300">settings</span>
                        </button>
                        <a href="/logout" class="p-2 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" aria-label="Logout">
                            <span class="material-icons-outlined text-slate-600 dark:text-slate-300">logout</span>
                        </a>
                    </div>
                </header>
<!-- khoa -->

        <!-- Main Content Area -->
        <div class="flex-1 flex min-w-0">
            
            <!-- Left Panel: Task List & Form -->
            <div class="w-[520px] flex flex-col bg-slate-50/50 border-r border-slate-200">
                
                <!-- Header -->
                <div class="px-6 py-5 bg-white/60 backdrop-blur-md border-b border-slate-200">
                    <h2 class="text-xl font-bold text-slate-dark mb-1">Task Management</h2>
                    <p class="text-sm text-slate-500">Manage your tasks and deadlines seamlessly</p>
                </div>

                <!-- Status Filter & Add Button -->
                <div class="px-6 py-4 border-b border-slate-200 space-y-3">
                    <div class="flex gap-2">
                        <button onclick="filterByStatus('all')" class="status-filter-btn active" data-status="all">
                            All
                        </button>
                        <button onclick="filterByStatus('pending')" class="status-filter-btn" data-status="pending">
                            Pending
                        </button>
                        <button onclick="filterByStatus('in_progress')" class="status-filter-btn" data-status="in_progress">
                            In Progress
                        </button>
                        <button onclick="filterByStatus('done')" class="status-filter-btn" data-status="done">
                            Done
                        </button>
                    </div>
                    
                    <!-- Add New Task Button -->
                    <button onclick="showTaskForm()" id="addTaskBtn" class="w-full btn-add-task">
                        <i class="fa-solid fa-plus"></i>
                        <span>Add New Task</span>
                    </button>
                </div>

                <!-- Task List - Now with more space! -->
                <div class="flex-1 overflow-y-auto px-4 py-4" id="taskListContainer">
                    <h3 class="text-xs font-semibold text-slate-500 uppercase tracking-wide px-2 mb-3">YOUR TASKS</h3>
                    <div id="taskList" class="space-y-2">
                        <!-- Tasks will be dynamically added here -->
                    </div>
                </div>

                <!-- Add/Edit Task Form - Collapsible -->
                <div id="taskFormContainer" class="hidden bg-white border-t-2 border-slate-200 shadow-2xl">
                    <div class="px-6 py-5">
                        <div class="flex items-center justify-between mb-4">
                            <h3 class="text-base font-bold text-slate-700" id="formTitle">Add New Task</h3>
                            <button onclick="hideTaskForm()" class="text-slate-400 hover:text-slate-600 transition-colors">
                                <i class="fa-solid fa-times text-xl"></i>
                            </button>
                        </div>
                        
                        <form id="taskForm" class="space-y-3">
                            <input type="hidden" id="taskId" value="">
                            
                            <div>
                                <label class="form-label">Task Name</label>
                                <input type="text" id="taskTitle" placeholder="e.g., Finalize project report" class="form-input" required>
                            </div>

                            <div>
                                <label class="form-label">Description (Optional)</label>
                                <textarea id="taskDescription" placeholder="Add details..." class="form-input" rows="2"></textarea>
                            </div>

                            <div class="grid grid-cols-2 gap-3">
                                <div>
                                    <label class="form-label">Priority</label>
                                    <select id="taskPriority" class="form-select">
                                        <option value="low">Low</option>
                                        <option value="medium" selected>Medium</option>
                                        <option value="high">High</option>
                                    </select>
                                </div>
                                <div>
                                    <label class="form-label">Status</label>
                                    <select id="taskStatus" class="form-select">
                                        <option value="pending" selected>Pending</option>
                                        <option value="in_progress">In Progress</option>
                                        <option value="done">Done</option>
                                    </select>
                                </div>
                            </div>

                            <div class="grid grid-cols-2 gap-3">
                                <div>
                                    <label class="form-label">Deadline</label>
                                    <input type="datetime-local" id="taskDeadline" class="form-input" required>
                                </div>
                                <div>
                                    <label class="form-label">Duration (min)</label>
                                    <input type="number" id="taskDuration" value="90" min="15" step="15" class="form-input">
                                </div>
                            </div>

                            <div class="flex gap-2 pt-2">
                                <button type="submit" class="btn-primary flex-1">
                                    <span id="submitBtnText">Save Task</span>
                                </button>
                                <button type="button" onclick="hideTaskForm()" class="btn-cancel">
                                    Cancel
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Right Panel: Calendar Timeline -->
            <div class="flex-1 flex flex-col bg-white">
                
                <!-- Header with Week Navigation -->
                <div class="px-8 py-5 bg-white/60 backdrop-blur-md border-b border-slate-200 flex items-center justify-between">
                    <div>
                        <h2 class="text-xl font-bold text-slate-dark mb-1">Generated Timetable</h2>
                        <div class="flex items-center gap-2">
                            <p class="text-sm text-slate-500" id="weekRangeDisplay">Loading...</p>
                            <span class="text-slate-300">|</span>
                            <select id="scheduleSelect" onchange="changeSchedule()" class="text-sm border-none bg-transparent text-primary font-semibold focus:ring-0 cursor-pointer p-0 pr-6">
                                <option value="">Loading schedules...</option>
                            </select>
                        </div>
                    </div>
                    <div class="flex items-center gap-3">
                        <button onclick="navigateWeek(-1)" class="week-nav-btn">
                            <i class="fa-solid fa-chevron-left"></i>
                        </button>
                        <span class="text-sm font-semibold text-slate-600" id="weekLabel">This Week</span>
                        <button onclick="navigateWeek(1)" class="week-nav-btn">
                            <i class="fa-solid fa-chevron-right"></i>
                        </button>
                        <button onclick="navigateWeek(0)" class="btn-today">
                            Today
                        </button>
                    </div>
                </div>

                <!-- Calendar Grid -->
                <!-- Calendar Grid -->
                <div class="flex-1 overflow-auto p-4"> <!-- Reduced padding for better fit -->
                    <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
                        <table class="w-full border-collapse table-fixed"> <!-- Added table-fixed -->
                            <thead>
                                <tr class="bg-slate-50 border-b border-slate-200">
                                    <th class="p-3 text-left text-xs font-semibold text-slate-500 border-r border-slate-200 w-20">Time</th>
                                    <th class="p-3 text-center text-xs font-semibold text-slate-700 border-r border-slate-200">Mon</th>
                                    <th class="p-3 text-center text-xs font-semibold text-slate-700 border-r border-slate-200">Tue</th>
                                    <th class="p-3 text-center text-xs font-semibold text-slate-700 border-r border-slate-200">Wed</th>
                                    <th class="p-3 text-center text-xs font-semibold text-slate-700 border-r border-slate-200">Thu</th>
                                    <th class="p-3 text-center text-xs font-semibold text-slate-700 border-r border-slate-200">Fri</th>
                                    <th class="p-3 text-center text-xs font-semibold text-slate-700 border-r border-slate-200">Sat</th>
                                    <th class="p-3 text-center text-xs font-semibold text-slate-700">Sun</th>
                                </tr>
                            </thead>
                            <tbody id="calendarGrid">
                                <!-- Calendar rows will be dynamically generated here -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="../resources/js/tasks.js"></script>
<!-- khoa -->
    <script src="/resources/js/sidebar.js"></script>
<!-- khoa -->
</body>
</html>
