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
    <script src="../js/tailwind-config.js"></script>
    <link rel="stylesheet" href="../css/pastel-overrides.css">
    <link rel="stylesheet" href="../css/tasks.css">
</head>
<body class="font-display bg-background-light text-slate-dark antialiased overflow-hidden">

    <div class="flex h-screen w-full">
        
        <!-- Left Sidebar Navigation -->
        <nav class="w-56 flex flex-col py-6 bg-white border-r border-slate-200">
            <div class="px-6 mb-8">
                <h1 class="text-xl font-bold text-primary">Task Manager</h1>
            </div>
            
            <div class="flex flex-col gap-1 px-3">
                <a href="../dashboard.jsp" class="flex items-center gap-3 px-4 py-3 rounded-xl text-slate-600 hover:bg-slate-100 transition-all">
                    <span class="material-symbols-outlined text-lg">dashboard</span>
                    Bảng điều khiển
                </a>
                <a href="schedule.jsp" class="flex items-center gap-3 px-4 py-3 rounded-xl text-slate-600 hover:bg-slate-100 transition-all">
                    <span class="material-symbols-outlined text-lg">calendar_month</span>
                    Lịch của tôi
                </a>
                <a href="tasks.jsp" class="flex items-center gap-3 px-4 py-3 rounded-xl bg-primary text-white font-semibold transition-all">
                    <span class="material-symbols-outlined text-lg">task_alt</span>
                    Nhiệm vụ
                </a>
                <a href="statistics.jsp" class="flex items-center gap-3 px-4 py-3 rounded-xl text-slate-600 hover:bg-slate-100 transition-all">
                    <span class="material-symbols-outlined text-lg">analytics</span>
                    Thống kê
                </a>
            </div>
        </nav>

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
                        <p class="text-sm text-slate-500" id="weekRangeDisplay">Loading...</p>
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
                <div class="flex-1 overflow-auto p-8">
                    <div class="calendar-grid" id="calendarGrid">
                        <!-- Calendar will be dynamically generated -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="../js/tasks.js"></script>

</body>
</html>
