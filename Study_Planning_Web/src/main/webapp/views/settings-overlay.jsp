<%-- 
    Document   : settings-overlay
    Created on : 5 thg 12, 2025, 13:50:03
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="settingsOverlay"
     class="fixed inset-0 bg-black/40 backdrop-blur-sm hidden z-50 flex justify-end">

    <div class="w-full max-w-md rounded-lg bg-surface-light dark:bg-surface-dark p-8 shadow-lg">
        <div class="flex items-center mb-8">
            <span class="material-symbols-outlined text-4xl text-primary mr-3">
                settings
            </span>
            <h1 class="text-3xl font-bold text-text-light dark:text-text-dark">Cài đặt</h1>
        </div>
        <form class="space-y-6" id="settingForm">
            <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2"
                       for="theme-select">Theme:</label>
                <div class="relative">
                    <select
                        class="w-full appearance-none rounded border border-border-light dark:border-border-dark bg-surface-light dark:bg-surface-dark py-2 pl-3 pr-10 text-base focus:border-primary focus:outline-none focus:ring-primary dark:focus:border-primary"
                        id="theme-select" name="theme" onchange="changeTheme(this.value)">
                        <option value="light">Light</option>
                        <option value="dark">Dark</option>
                    </select>
                    <!---
                    <span class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-2">
                        <svg aria-hidden="true" class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20"
                             xmlns="http://www.w3.org/2000/svg">
                            <path clip-rule="evenodd"
                                  d="M10 3a.75.75 0 01.53.22l3.5 3.5a.75.75 0 01-1.06 1.06L10 4.81 7.03 7.78a.75.75 0 01-1.06-1.06l3.5-3.5A.75.75 0 0110 3zm-3.72 9.28a.75.75 0 011.06 0L10 15.19l2.97-2.97a.75.75 0 111.06 1.06l-3.5 3.5a.75.75 0 01-1.06 0l-3.5-3.5a.75.75 0 010-1.06z"
                                  fill-rule="evenodd"></path>
                        </svg>
                    </span>
                    --->
                </div>
            </div>
            <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2" for="language-select">Ngôn
                    ngữ:</label>
                <div class="relative">
                    <select
                        class="w-full appearance-none rounded border border-border-light dark:border-border-dark bg-surface-light dark:bg-surface-dark py-2 pl-3 pr-10 text-base focus:border-primary focus:outline-none focus:ring-primary dark:focus:border-primary"
                        id="language-select" name="language">
                        <option value="vi">Tiếng Việt</option>
                        <option value="en">English</option>
                    </select>
                    <!---
                    <span class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-2">
                        <svg aria-hidden="true" class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20"
                             xmlns="http://www.w3.org/2000/svg">
                            <path clip-rule="evenodd"
                                  d="M10 3a.75.75 0 01.53.22l3.5 3.5a.75.75 0 01-1.06 1.06L10 4.81 7.03 7.78a.75.75 0 01-1.06-1.06l3.5-3.5A.75.75 0 0110 3zm-3.72 9.28a.75.75 0 011.06 0L10 15.19l2.97-2.97a.75.75 0 111.06 1.06l-3.5 3.5a.75.75 0 01-1.06 0l-3.5-3.5a.75.75 0 010-1.06z"
                                  fill-rule="evenodd"></path>
                        </svg>
                    </span>
                    --->
                </div>
            </div>
            <div class="border-t border-border-light dark:border-border-dark my-6"></div>
            <div class="space-y-4">
                <h2 class="text-lg font-semibold text-text-light dark:text-text-dark">Thông báo</h2>
                <div class="flex items-center justify-between">
                    <span class="text-sm font-medium text-slate-700 dark:text-slate-300">Nhắc nhở sự kiện</span>
                    <label class="relative inline-flex cursor-pointer items-center">
                        <input checked="" class="peer sr-only" type="checkbox" />
                        <div
                            class="peer h-6 w-11 rounded-full bg-slate-200 after:absolute after:left-[2px] after:top-[2px] after:h-5 after:w-5 after:rounded-full after:border after:border-gray-300 after:bg-white after:transition-all after:content-[''] peer-checked:bg-primary peer-checked:after:translate-x-full peer-checked:after:border-white peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-secondary-indigo-light dark:bg-gray-700 dark:border-gray-600">
                        </div>
                    </label>
                </div>
                <div class="flex items-center justify-between">
                    <span class="text-sm font-medium text-slate-700 dark:text-slate-300">Cảnh báo deadline</span>
                    <label class="relative inline-flex cursor-pointer items-center">
                        <input checked="" class="peer sr-only" type="checkbox" />
                        <div
                            class="peer h-6 w-11 rounded-full bg-slate-200 after:absolute after:left-[2px] after:top-[2px] after:h-5 after:w-5 after:rounded-full after:border after:border-gray-300 after:bg-white after:transition-all after:content-[''] peer-checked:bg-primary peer-checked:after:translate-x-full peer-checked:after:border-white peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-secondary-indigo-light dark:bg-gray-700 dark:border-gray-600">
                        </div>
                    </label>
                </div>
                <div class="flex items-center justify-between">
                    <span class="text-sm font-medium text-slate-700 dark:text-slate-300">Thông báo hệ thống</span>
                    <label class="relative inline-flex cursor-pointer items-center">
                        <input class="peer sr-only" type="checkbox" />
                        <div
                            class="peer h-6 w-11 rounded-full bg-slate-200 after:absolute after:left-[2px] after:top-[2px] after:h-5 after:w-5 after:rounded-full after:border after:border-gray-300 after:bg-white after:transition-all after:content-[''] peer-checked:bg-primary peer-checked:after:translate-x-full peer-checked:after:border-white peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-secondary-indigo-light dark:bg-gray-700 dark:border-gray-600">
                        </div>
                    </label>
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2" for="sound-select">Âm thanh
                        thông báo:</label>
                    <div class="relative">
                        <select
                            class="w-full appearance-none rounded border border-border-light dark:border-border-dark bg-surface-light dark:bg-surface-dark py-2 pl-3 pr-10 text-base focus:border-primary focus:outline-none focus:ring-primary dark:focus:border-primary"
                            id="sound-select">
                            <option>Mặc định</option>
                            <option>Giai điệu nhẹ nhàng</option>
                            <option>Tiếng chuông</option>
                            <option>Tắt âm</option>
                        </select>
                        <!---
                        <span class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-2">
                            <svg aria-hidden="true" class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20"
                                 xmlns="http://www.w3.org/2000/svg">
                                <path clip-rule="evenodd"
                                      d="M10 3a.75.75 0 01.53.22l3.5 3.5a.75.75 0 01-1.06 1.06L10 4.81 7.03 7.78a.75.75 0 01-1.06-1.06l3.5-3.5A.75.75 0 0110 3zm-3.72 9.28a.75.75 0 011.06 0L10 15.19l2.97-2.97a.75.75 0 111.06 1.06l-3.5 3.5a.75.75 0 01-1.06 0l-3.5-3.5a.75.75 0 010-1.06z"
                                      fill-rule="evenodd"></path>
                            </svg>
                        </span>
                        --->
                    </div>
                </div>
            </div>
            <div class="flex justify-end pt-4">
                <button
                    class="rounded bg-primary px-6 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary transition-colors duration-200"
                    type="submit">
                    Lưu
                </button>
            </div>
        </form>
    </div>
            <script src="/resources/js/setting.js"></script>
</div>
