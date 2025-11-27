<%-- 
    Document   : basic-setup
    Created on : 27 thg 11, 2025, 21:06:52
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi"><head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <title>Personalization</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&amp;display=swap" rel="stylesheet"/>
        <script>
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            primary: "#A5B4FC",
                            "background-light": "#f8fafc",
                            "background-dark": "#0f172a",
                        },
                        fontFamily: {
                            display: ["Poppins", "sans-serif"],
                        },
                        borderRadius: {
                            DEFAULT: "1rem", // Using 1rem for a modern, rounded look
                        },
                    },
                },
            };
        </script>
        <style>
            .chip-checkbox:checked + label {
                background-color: #4338ca;
                color: #ffffff;
                transform: translateY(-2px);
                box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            }
        </style>
    </head>
    <body class="bg-background-light dark:bg-background-dark font-display text-slate-800 dark:text-slate-200 antialiased">
        <div class="flex flex-col items-center justify-center min-h-screen p-4 sm:p-6 md:p-8">
            <div class="w-full max-w-4xl mx-auto">
                <header class="text-center mb-8 md:mb-12">
                    <h1 class="text-3xl sm:text-4xl md:text-5xl font-bold text-slate-900 dark:text-white mb-2">Cho chúng tôi biết về bạn</h1>
                    <p class="text-base sm:text-lg text-slate-600 dark:text-slate-400">Chọn những gì phù hợp nhất với bạn để cá nhân hóa trải nghiệm.</p>
                </header>
                <main>
                    <form id="setup-form" action="basic-setup/save" method="POST"> 

                        <div id="step-1" class="step-content">
                            <p class="text-base sm:text-lg text-slate-600 dark:text-slate-400 mb-4 hidden">
                                Bước 
                                <span id="current-step">1</span>/3: 
                                <span id="step-subtitle">Mục tiêu học tập (Goals)</span>
                            </p>
                            
                            <h2 class="text-xl sm:text-2xl font-semibold mb-6 text-center text-slate-700 dark:text-slate-300">
                                Bạn đang muốn **đạt được điều gì** trong thời gian tới?
                            </h2>
                            <div class="flex flex-wrap justify-center items-center gap-3 sm:gap-4">
                                <input class="hidden chip-checkbox" id="goal1" type="radio" name="goals" value="TangGPA"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-indigo-200 text-slate-900" for="goal1">Tăng GPA</label>
                                
                                <input class="hidden chip-checkbox" id="goal2" type="radio" name="goals" value="OnThiGiuaKy"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-indigo-200 text-slate-900" for="goal2">Ôn thi giữa kỳ</label>
                                
                                <input class="hidden chip-checkbox" id="goal3" type="radio" name="goals" value="OnThiCuoiKy"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-indigo-200 text-slate-900" for="goal3">Ôn thi cuối kỳ</label>
                                
                                <input class="hidden chip-checkbox" id="goal4" type="radio" name="goals" value="LuyenIELTS"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-indigo-200 text-slate-900" for="goal4">Luyện IELTS</label>
                                
                                <input class="hidden chip-checkbox" id="goal5" type="radio" name="goals" value="HocLapTrinh"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-indigo-200 text-slate-900" for="goal5">Học lập trình</label>
                                
                                <input class="hidden chip-checkbox" id="goal6" type="radio" name="goals" value="HocNgoaiNgu"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-indigo-200 text-slate-900" for="goal6">Học ngoại ngữ</label>
                                
                                <input class="hidden chip-checkbox" id="goal7" type="radio" name="goals" value="CaiThienKyNangMem"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-indigo-200 text-slate-900" for="goal7">Cải thiện kỹ năng mềm</label>
                                
                                <input class="hidden chip-checkbox" id="goal8" type="radio" name="goals" value="ChuanBiPhongVan"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-indigo-200 text-slate-900" for="goal8">Chuẩn bị phỏng vấn</label>
                                
                                <input class="hidden chip-checkbox" id="goal9" type="radio" name="goals" value="LuyenChungChi"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-indigo-200 text-slate-900" for="goal9">Luyện chứng chỉ (MOS/Google/...)</label>
                                
                            </div>
                        </div>

                        <div id="step-2" class="step-content hidden">
                            <p class="text-base sm:text-lg text-slate-600 dark:text-slate-400 mb-4 hidden">
                                Bước 
                                <span id="current-step">1</span>/3: 
                                <span id="step-subtitle">Phong cách học (Study Style)</span>
                            </p>
                            
                            <h2 class="text-xl sm:text-2xl font-semibold mb-6 text-center text-slate-700 dark:text-slate-300">
                                Bạn **học tập hiệu quả nhất** với phong cách nào?
                            </h2>
                            <div class="flex flex-wrap justify-center items-center gap-3 sm:gap-4">
                                <input class="hidden chip-checkbox" id="style1" type="radio" name="study_style" value="DeepWork"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-purple-200 text-slate-900" for="style1">Deep Work</label>
                                
                                <input class="hidden chip-checkbox" id="style2" type="radio" name="study_style" value="Pomodoro"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-purple-200 text-slate-900" for="style2">Pomodoro</label>
                                
                                <input class="hidden chip-checkbox" id="style3" type="radio" name="study_style" value="NganTapTrungNhanh"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-purple-200 text-slate-900" for="style3">Ngắn – tập trung nhanh</label>
                                
                                <input class="hidden chip-checkbox" id="style4" type="radio" name="study_style" value="HocNhom"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-purple-200 text-slate-900" for="style4">Học nhóm</label>
                                
                                <input class="hidden chip-checkbox" id="style5" type="radio" name="study_style" value="TuHocMotMinh"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-purple-200 text-slate-900" for="style5">Tự học một mình</label>
                                
                                <input class="hidden chip-checkbox" id="style6" type="radio" name="study_style" value="DeXaoNhac"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-purple-200 text-slate-900" for="style6">Dễ xao nhãng</label>
                                
                                <input class="hidden chip-checkbox" id="style7" type="radio" name="study_style" value="CanNhacNho"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-purple-200 text-slate-900" for="style7">Cần nhắc nhở</label>
                            </div>
                        </div>

                        <div id="step-3" class="step-content hidden">
                            <p class="text-base sm:text-lg text-slate-600 dark:text-slate-400 mb-4 hidden">
                                Bước 
                                <span id="current-step">1</span>/3: 
                                <span id="step-subtitle">Năng lượng & thói quen (Lifestyle)</span>
                            </p>
                            
                            <h2 class="text-xl sm:text-2xl font-semibold mb-6 text-center text-slate-700 dark:text-slate-300">
                                **Năng lượng** và **thói quen** học tập của bạn như thế nào?
                            </h2>
                            <div class="flex flex-wrap justify-center items-center gap-3 sm:gap-4">
                                <input class="hidden chip-checkbox" id="life1" type="radio" name="lifestyle" value="MorningPerson"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-yellow-200 text-slate-900" for="life1">Morning person</label>
                                
                                <input class="hidden chip-checkbox" id="life2" type="radio" name="lifestyle" value="NightOwl"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-yellow-200 text-slate-900" for="life2">Night owl</label>
                                
                                <input class="hidden chip-checkbox" id="life3" type="radio" name="lifestyle" value="NangLuongBuoiSang"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-yellow-200 text-slate-900" for="life3">Năng lượng buổi sáng</label>
                                
                                <input class="hidden chip-checkbox" id="life4" type="radio" name="lifestyle" value="NangLuongBuoiToi"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-yellow-200 text-slate-900" for="life4">Năng lượng buổi tối</label>
                                
                                <input class="hidden chip-checkbox" id="life5" type="radio" name="lifestyle" value="HayBuonNgu"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-yellow-200 text-slate-900" for="life5">Hay buồn ngủ</label>
                                
                                <input class="hidden chip-checkbox" id="life6" type="radio" name="lifestyle" value="DeStress"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-yellow-200 text-slate-900" for="life6">Dễ stress</label>
                                
                                <input class="hidden chip-checkbox" id="life7" type="radio" name="lifestyle" value="LamViecTotDuoiApLuc"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-yellow-200 text-slate-900" for="life7">Làm việc tốt dưới áp lực</label>
                                
                                <input class="hidden chip-checkbox" id="life8" type="radio" name="lifestyle" value="CanLichNheNhang"/>
                                <label class="cursor-pointer select-none rounded-full px-5 py-3 text-sm sm:text-base font-semibold transition-all duration-300 ease-in-out hover:shadow-md hover:-translate-y-1 bg-yellow-200 text-slate-900" for="life8">Cần lịch nhẹ nhàng</label>
                                
                            </div>
                        </div>
                    </form>
                </main>
            </div>
            <footer class="fixed bottom-0 right-0 p-6 sm:p-8 flex gap-4"> 

                <button id="prev-button" type="button" class="hidden bg-white text-slate-900 border border-slate-300 dark:bg-slate-700 dark:text-slate-200 rounded-full px-8 py-3 font-bold text-lg shadow-lg hover:bg-slate-100 dark:hover:bg-slate-600 focus:outline-none focus:ring-4 focus:ring-slate-400 dark:focus:ring-slate-500 transition-all duration-300 ease-in-out">
                    Quay lại
                </button>

                <button id="next-button" type="button" class="bg-slate-900 text-white dark:bg-slate-200 dark:text-slate-900 rounded-full px-8 py-3 font-bold text-lg shadow-lg hover:bg-slate-700 dark:hover:bg-white focus:outline-none focus:ring-4 focus:ring-slate-400 dark:focus:ring-slate-500 transition-all duration-300 ease-in-out">
                    Tiếp theo
                </button>
            </footer>
        </div>

        <script src="/resources/js/basic-setup.js"></script>

    </body>
</html>
