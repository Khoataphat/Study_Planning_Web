<%-- 
    Document   : login
    Created on : 21 thg 11, 2025, 14:16:35
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="light" lang="vi"><head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <title>Đăng Ký Tài Khoản</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com" rel="preconnect"/>
        <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;700;800&amp;display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
        <script>
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            "primary": "#A5B4FC", // Pastel Indigo
                            "soft-blue": "#C7D2FE",
                            "pinky": "#F9A8D4",
                            "warm-yellow": "#FDE68A",
                            "slate-dark": "#1E293B",
                            "background-light": "#f8f9ff",
                            "background-dark": "#111827",
                        },
                        fontFamily: {
                            "display": ["Plus Jakarta Sans", "sans-serif"]
                        },
                        borderRadius: {"DEFAULT": "1rem", "lg": "2rem", "xl": "3rem", "full": "9999px"},
                    },
                },
            }
        </script>
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
                font-size: 20px;
            }
            .form-input-container:focus-within {
                border-color: #A5B4FC;
                box-shadow: 0 0 0 3px rgba(165, 180, 252, 0.3);
            }
            .form-input:focus {
                outline: none;
                border: none;
                box-shadow: none;
                ring: 0;
            }
            .bg-pattern {
                background-image:
                    radial-gradient(circle at 1px 1px, #e0e7ff 1px, transparent 0),
                    radial-gradient(circle at 10px 10px, #e0e7ff 1px, transparent 0);
                background-size: 20px 20px;
            }
            .dark .bg-pattern {
                background-image:
                    radial-gradient(circle at 1px 1px, #374151 1px, transparent 0),
                    radial-gradient(circle at 10px 10px, #374151 1px, transparent 0);
                background-size: 20px 20px;
            }
        </style>
        <style>
            /* CSS CHUNG */
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
                font-size: 20px;
            }

            .form-input-container:focus-within {
                border-color: #A5B4FC;
                box-shadow: 0 0 0 3px rgba(165, 180, 252, 0.3);
            }

            /* KHẮC PHỤC LỖI SLIDER: CSS THUẦN (DỰ PHÒNG) */
            #slideWrapper {
                /* Vô hiệu hóa class w-[400%] của Tailwind nếu nó không nhận */
                width: 400% !important;
            }

            #slideWrapper > div {
                /* Vô hiệu hóa class w-1/4 của Tailwind nếu nó không nhận */
                width: 25% !important;
                flex-shrink: 0 !important;
                min-height: 500px; /* Đảm bảo chiều cao tối thiểu */
            }

            .bg-pattern {
                background-image: radial-gradient(circle at 1px 1px, #e0e7ff 1px, transparent 0), radial-gradient(circle at 10px 10px, #e0e7ff 1px, transparent 0);
                background-size: 20px 20px;
            }

            .dark .bg-pattern {
                background-image: radial-gradient(circle at 1px 1px, #374151 1px, transparent 0), radial-gradient(circle at 10px 10px, #374151 1px, transparent 0);
                background-size: 20px 20px;
            }
        </style>
    </head>
<body class="font-display bg-background-light dark:bg-background-dark text-slate-dark dark:text-white antialiased">
    <div class="relative flex min-h-screen w-full flex-col items-center justify-center overflow-hidden bg-pattern p-4 lg:p-8">
        <div class="grid w-full max-w-6xl grid-cols-1 overflow-hidden rounded-lg bg-white/50 dark:bg-black/20 shadow-2xl backdrop-blur-lg md:grid-cols-2">
            
            <div class="relative hidden h-full flex-col items-center justify-center bg-pinky/20 p-10 md:flex">
                <img alt="A playful illustration of a person organizing tasks on a giant calendar with colorful sticky notes and icons, in a GenZ art style." class="w-full max-w-sm" src="https://lh3.googleusercontent.com/aida-public/AB6AXuARpcrLiXozzjiqQSZGNhQn-ar6rRVxoaJFFGY7S2Q7Y3sR0HtUGtXvQOgpHTrlr1L1vIO7iD0bSzlN7L4SIaFToML4AaQ3jWXPzvxgbUnGQ8WNjetJVzsSvZAJzzbP7dzhOGxCAauWmVfrbIBAGn_9_iGdB4jIrQoQnXSH7YAsSs09iceFTXEbaDBlh4rcxt0uJhmIGNXKYgHeP4IstlkU7DqKJVwP3chG_i9lxwC3nKYzxUeMXm1OQcPSgAUXjNSItQAmZdswH8I"/>
                <div class="absolute bottom-8 left-8 right-8 rounded-lg bg-white/60 dark:bg-black/30 p-4 text-center backdrop-blur-sm">
                    <p class="font-semibold text-slate-dark dark:text-gray-200">"Biến kế hoạch thành hiện thực, một cách thật chill."</p>
                </div>
            </div>
            
            <div class="flex w-full flex-col justify-center bg-background-light dark:bg-background-dark p-8 sm:p-12 lg:p-16">
                <div class="w-full max-w-md overflow-hidden">
                    
                    <div id="authWrapper" class="flex w-[200%] transition-transform duration-500 ease-in-out">
                        
                        <div id="loginPanel" class="w-1/2 flex-shrink-0">
                            <header class="mb-8 text-center md:text-left">
                                <div class="mb-4 inline-flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary text-3xl">stacks</span>
                                    <span class="text-xl font-bold text-slate-dark dark:text-white">PlanZ</span>
                                </div>
                                <h1 class="text-3xl font-bold tracking-tight text-slate-dark dark:text-white">Đăng nhập để tiếp tục!</h1>
                                <p class="mt-2 text-base text-gray-600 dark:text-gray-300">Chào mừng bạn quay trở lại!</p>
                            </header>

                            <form class="space-y-5" id="signinForm" action="/login" method="post">
                                <div class="flex max-w-[480px] flex-wrap items-end">
                                    <label class="flex w-full flex-col">
                                        <p class="pb-2 text-sm font-medium text-slate-dark dark:text-gray-200">Tên người dùng</p>
                                        <div class="form-input-container flex w-full items-center gap-3 overflow-hidden rounded border border-soft-blue dark:border-gray-700 bg-white dark:bg-gray-800 px-3 transition-all duration-300">
                                            <span class="material-symbols-outlined text-gray-400 dark:text-gray-500">sentiment_satisfied</span>
                                            <input class="form-input h-12 w-full flex-1 border-0 bg-transparent p-0 text-base font-normal leading-normal text-slate-dark dark:text-white placeholder:text-gray-400 dark:placeholder:text-gray-500 focus:outline-none focus:ring-0" placeholder="Tên của bạn nè" type="text" name="username"/>
                                        </div>
                                    </label>
                                </div>
                                <div class="flex max-w-[480px] flex-wrap items-end">
                                    <label class="flex w-full flex-col">
                                        <p class="pb-2 text-sm font-medium text-slate-dark dark:text-gray-200">Mật khẩu</p>
                                        <div class="form-input-container flex w-full items-center gap-3 overflow-hidden rounded border border-soft-blue dark:border-gray-700 bg-white dark:bg-gray-800 px-3 transition-all duration-300">
                                            <span class="material-symbols-outlined text-gray-400 dark:text-gray-500">lock</span>
                                            <input class="form-input h-12 w-full flex-1 border-0 bg-transparent p-0 text-base font-normal leading-normal text-slate-dark dark:text-white placeholder:text-gray-400 dark:placeholder:text-gray-500 focus:outline-none focus:ring-0" placeholder="Nhập mật khẩu" type="password" name="password"/>
                                            <button class="text-gray-400 dark:text-gray-500" type="button">
                                                <span class="material-symbols-outlined">visibility</span>
                                            </button>
                                        </div>
                                    </label>
                                </div>
                                <button class="flex h-14 w-full items-center justify-center rounded-full bg-warm-yellow px-6 text-base font-bold text-slate-dark shadow-lg shadow-warm-yellow/30 transition hover:bg-opacity-80 focus:outline-none focus:ring-2 focus:ring-warm-yellow/50 focus:ring-offset-2 dark:focus:ring-offset-background-dark" type="submit">
                                    Đăng nhập
                                </button>
                            </form>

                            <div class="relative my-8 flex items-center">
                                <div class="flex-grow border-t border-gray-300 dark:border-gray-700"></div>
                                <span class="mx-4 flex-shrink text-sm text-gray-500 dark:text-gray-400">Hoặc</span>
                                <div class="flex-grow border-t border-gray-300 dark:border-gray-700"></div>
                            </div>
                            <p class="mt-8 text-center text-sm text-gray-600 dark:text-gray-400">
                                Chưa có tài khoản?
                                <a id="switchToSignup" class="font-bold text-primary hover:underline cursor-pointer">Đăng ký ngay</a>
                            </p>
                        </div>
                        
                        <div id="signupPanel" class="w-1/2 flex-shrink-0 pl-16">
                            <header class="mb-8 text-center md:text-left">
                                <div class="mb-4 inline-flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary text-3xl">stacks</span>
                                    <span class="text-xl font-bold text-slate-dark dark:text-white">PlanZ</span>
                                </div>
                                <h1 class="text-3xl font-bold tracking-tight text-slate-dark dark:text-white">Sẵn sàng bùng nổ năng suất chưa?</h1>
                                <p class="mt-2 text-base text-gray-600 dark:text-gray-300">Cùng tạo thời khóa biểu chất lừ của riêng bạn nào!</p>
                            </header>

                            <form class="space-y-5" id="signupForm" action="/register" method="post">
                                <% String error = (String) request.getAttribute("error"); %>
                                <% if(error != null) { %>
                                    <div class="p-3 text-red-500 bg-red-100 border border-red-400 rounded">
                                        <%= error %>
                                    </div>
                                <% } %>
                                <div class="flex max-w-[480px] flex-wrap items-end">
                                    <label class="flex w-full flex-col">
                                        <p class="pb-2 text-sm font-medium text-slate-dark dark:text-gray-200">Tên người dùng</p>
                                        <div class="form-input-container flex w-full items-center gap-3 overflow-hidden rounded border border-soft-blue dark:border-gray-700 bg-white dark:bg-gray-800 px-3 transition-all duration-300">
                                            <span class="material-symbols-outlined text-gray-400 dark:text-gray-500">sentiment_satisfied</span>
                                            <input class="form-input h-12 w-full flex-1 border-0 bg-transparent p-0 text-base font-normal leading-normal text-slate-dark dark:text-white placeholder:text-gray-400 dark:placeholder:text-gray-500 focus:outline-none focus:ring-0" placeholder="Tên của bạn nè" type="text" name="username"/>
                                        </div>
                                    </label>
                                </div>
                                <div class="flex max-w-[480px] flex-wrap items-end">
                                    <label class="flex w-full flex-col">
                                        <p class="pb-2 text-sm font-medium text-slate-dark dark:text-gray-200">Email</p>
                                        <div class="form-input-container flex w-full items-center gap-3 overflow-hidden rounded border border-soft-blue dark:border-gray-700 bg-white dark:bg-gray-800 px-3 transition-all duration-300">
                                            <span class="material-symbols-outlined text-gray-400 dark:text-gray-500">mail</span>
                                            <input class="form-input h-12 w-full flex-1 border-0 bg-transparent p-0 text-base font-normal leading-normal text-slate-dark dark:text-white placeholder:text-gray-400 dark:placeholder:text-gray-500 focus:outline-none focus:ring-0" placeholder="Nhập email của bạn" type="email" name="email"/>
                                        </div>
                                    </label>
                                </div>
                                <div class="flex max-w-[480px] flex-wrap items-end">
                                    <label class="flex w-full flex-col">
                                        <p class="pb-2 text-sm font-medium text-slate-dark dark:text-gray-200">Mật khẩu</p>
                                        <div class="form-input-container flex w-full items-center gap-3 overflow-hidden rounded border border-soft-blue dark:border-gray-700 bg-white dark:bg-gray-800 px-3 transition-all duration-300">
                                            <span class="material-symbols-outlined text-gray-400 dark:text-gray-500">lock</span>
                                            <input class="form-input h-12 w-full flex-1 border-0 bg-transparent p-0 text-base font-normal leading-normal text-slate-dark dark:text-white placeholder:text-gray-400 dark:placeholder:text-gray-500 focus:outline-none focus:ring-0" placeholder="Tạo mật khẩu" type="password" name="password"/>
                                            <button class="text-gray-400 dark:text-gray-500" type="button">
                                                <span class="material-symbols-outlined">visibility</span>
                                            </button>
                                        </div>
                                    </label>
                                </div>
                                <button class="flex h-14 w-full items-center justify-center rounded-full bg-warm-yellow px-6 text-base font-bold text-slate-dark shadow-lg shadow-warm-yellow/30 transition hover:bg-opacity-80 focus:outline-none focus:ring-2 focus:ring-warm-yellow/50 focus:ring-offset-2 dark:focus:ring-offset-background-dark" type="submit">
                                    Bắt đầu thôi!
                                </button>
                            </form>

                            <p class="mt-8 text-center text-sm text-gray-600 dark:text-gray-400">
                                Đã có tài khoản?
                                <a id="switchToLogin" class="font-bold text-primary hover:underline cursor-pointer">Đăng nhập ngay</a>
                            </p>
                        </div>

                    </div>
                    </div>
                <div class="flex items-center justify-center gap-4 mt-8">
                    <a href="/oauth/google" class="flex h-12 w-12 items-center justify-center rounded-full border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 transition hover:bg-gray-50 dark:hover:bg-gray-700">
                        <img alt="Google logo" class="h-6 w-6" src="https://lh3.googleusercontent.com/aida-public/AB6AXuB030qILtK0iJs_cEfIHxVLcduDzfy8-vWoEhw5L6LekoVbJq9E5fApTQvZQG0zEF34sBvfJbugdw_CYwr9lRxQsZoqg0jfDUrliX29RVdV6BICqvZHIcMVKZw8Jkata5qdi4aUrzwqL4Gn82j5YdqEKIEGkUK52kVzRv9PT7h1ZwPZbOSPPMYLxPFfbOKCuk2fOyMBkp0VR7wGTVNBdceDhACh_jfuPvbTLs1KlbzScpSOEqlgNSAFVuiyEWItiRtuTGBhsa1Nqxg"/>
                    </a>
                    <a href="/auth/facebook" class="flex h-12 w-12 items-center justify-center rounded-full border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 transition hover:bg-gray-50 dark:hover:bg-gray-700">
                        <img alt="Facebook logo" class="h-6 w-6" src="https://lh3.googleusercontent.com/aida-public/AB6AXuD-sRZ3m-vgrmCoKwAatk50b4O6rvShI-WH4Gpy9u-ITGtwVp_OqORK5xEhovqIH4UvyKXGBmWJIpGIbcVhShRlsicSRySXuu4Htvw4Jf-PE8KbZVcxWOtpLtIQEhS9_dXVps1BGzP5MspuSKvUUXJGIEp-cAAJu0a2WCCjut_-los-4Ot01Jbx0KuQaTG2VzESp4xFksGrTvAWAdFih72ZyoyMK2NpdYlbIVqQWTJzRSFXpKXfh_y3M_mwRCAPV0IsFB4vLVCNHTY"/>
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Lấy các phần tử cần thiết
        const authWrapper = document.getElementById('authWrapper');
        const switchToSignupButton = document.getElementById('switchToSignup');
        const switchToLoginButton = document.getElementById('switchToLogin');

        // Hàm chuyển sang ĐĂNG KÝ (Trượt sang trái)
        if (switchToSignupButton) {
            switchToSignupButton.addEventListener('click', (e) => {
                e.preventDefault(); 
                // Sử dụng transform để trượt, Tailwind CSS đã định nghĩa transition
                authWrapper.style.transform = 'translateX(-50%)';
            });
        }

        // Hàm chuyển về ĐĂNG NHẬP (Trượt về vị trí ban đầu)
        if (switchToLoginButton) {
            switchToLoginButton.addEventListener('click', (e) => {
                e.preventDefault(); 
                // Trượt về vị trí 0%
                authWrapper.style.transform = 'translateX(0)';
            });
        }
    </script>
    <script>
        // Check for server-side error flag to auto-switch to Signup panel
        <% if (request.getAttribute("isRegisterError") != null && (boolean) request.getAttribute("isRegisterError")) { %>
            const wrapper = document.getElementById('authWrapper');
            if(wrapper) {
                wrapper.style.transform = 'translateX(-50%)';
            }
        <% } %>
    </script>
</body>
</html>