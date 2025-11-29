<!DOCTYPE html>
<html lang="en" class="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome - PlanZ</title>
    
    <!-- Tailwind CSS & Plugins -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Custom Config & Styles -->
    <script src="js/tailwind-config.js"></script>
    <link rel="stylesheet" href="css/pastel-overrides.css">
    
    <style>
        /* Slide transitions for login/register forms */
        .form-container {
            transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.5s ease;
        }
        .login-active .form-login { transform: translateX(0); opacity: 1; pointer-events: auto; }
        .login-active .form-register { transform: translateX(100%); opacity: 0; pointer-events: none; position: absolute; top: 0; width: 100%; }
        
        .register-active .form-login { transform: translateX(-100%); opacity: 0; pointer-events: none; position: absolute; top: 0; width: 100%; }
        .register-active .form-register { transform: translateX(0); opacity: 1; pointer-events: auto; }
    </style>
</head>
<body class="font-display bg-background-light text-slate-dark antialiased overflow-x-hidden">

    <div class="relative flex min-h-screen w-full flex-col items-center justify-center overflow-hidden bg-pattern p-4 lg:p-8">
        
        <div class="grid w-full max-w-6xl grid-cols-1 overflow-hidden rounded-3xl bg-white/60 shadow-2xl backdrop-blur-xl md:grid-cols-2 border border-white/50">
            
            <!-- Left Section: Illustration -->
            <div class="relative hidden h-full flex-col items-center justify-center bg-pinky/20 p-10 md:flex">
                <!-- Decorative blobs -->
                <div class="absolute top-10 left-10 w-32 h-32 bg-primary/30 rounded-full blur-3xl"></div>
                <div class="absolute bottom-10 right-10 w-40 h-40 bg-warm-yellow/30 rounded-full blur-3xl"></div>
                
                <div class="relative z-10 text-center">
                    <div class="mb-8 inline-flex items-center justify-center w-20 h-20 rounded-full bg-white/50 backdrop-blur shadow-lg">
                        <span class="material-symbols-outlined text-4xl text-primary">rocket_launch</span>
                    </div>
                    <h2 class="text-3xl font-bold text-slate-dark mb-4">Welcome to Future</h2>
                    <p class="text-slate-600 max-w-xs mx-auto">Experience the next generation platform with unique design.</p>
                </div>
            </div>

            <!-- Right Section: Forms -->
            <div class="flex w-full flex-col justify-center bg-white/40 p-8 sm:p-12 lg:p-16 relative login-active" id="loginCard">
                
                <!-- Login Form -->
                <div class="form-container form-login w-full max-w-md mx-auto">
                    <header class="mb-8 text-center md:text-left">
                        <h1 class="text-3xl font-bold tracking-tight text-slate-dark">Sign In</h1>
                        <p class="mt-2 text-base text-gray-500">Welcome back! Please enter your details.</p>
                    </header>

                    <div class="flex justify-center gap-4 mb-8">
                        <a href="#" class="flex h-12 w-12 items-center justify-center rounded-full border border-gray-200 bg-white transition hover:bg-gray-50 hover:border-primary/50 text-slate-600">
                            <i class="fa-brands fa-google text-lg"></i>
                        </a>
                        <a href="#" class="flex h-12 w-12 items-center justify-center rounded-full border border-gray-200 bg-white transition hover:bg-gray-50 hover:border-primary/50 text-slate-600">
                            <i class="fa-brands fa-facebook-f text-lg"></i>
                        </a>
                    </div>

                    <div class="relative mb-8 flex items-center">
                        <div class="flex-grow border-t border-gray-300"></div>
                        <span class="mx-4 flex-shrink text-xs text-gray-400 uppercase font-bold">Or continue with</span>
                        <div class="flex-grow border-t border-gray-300"></div>
                    </div>

                    <form action="login" method="post" class="space-y-5">
                        <div class="space-y-2">
                            <label class="text-sm font-semibold text-slate-600">Username</label>
                            <div class="form-input-container flex items-center gap-3 px-4 py-3 bg-white rounded-xl border border-gray-200 transition-all">
                                <span class="material-symbols-outlined text-gray-400">person</span>
                                <input type="text" name="username" class="form-input bg-transparent w-full text-slate-dark placeholder-gray-400 border-none p-0 focus:ring-0" placeholder="Enter your username" required>
                            </div>
                        </div>

                        <div class="space-y-2">
                            <div class="flex justify-between">
                                <label class="text-sm font-semibold text-slate-600">Password</label>
                                <a href="#" class="text-sm font-semibold text-primary hover:text-indigo-500">Forgot Password?</a>
                            </div>
                            <div class="form-input-container flex items-center gap-3 px-4 py-3 bg-white rounded-xl border border-gray-200 transition-all">
                                <span class="material-symbols-outlined text-gray-400">lock</span>
                                <input type="password" name="password" class="form-input bg-transparent w-full text-slate-dark placeholder-gray-400 border-none p-0 focus:ring-0" placeholder="Enter your password" required>
                            </div>
                        </div>

                        <button class="w-full py-4 rounded-xl bg-gradient-to-r from-pinky to-primary text-white font-bold shadow-lg shadow-indigo-200 hover:shadow-indigo-300 hover:scale-[1.02] transition-all duration-200" type="submit">
                            SIGN IN
                        </button>
                    </form>

                    <p class="mt-8 text-center text-sm text-gray-600">
                        Don't have an account? 
                        <span id="goto-register" class="font-bold text-primary hover:text-indigo-500 cursor-pointer hover:underline">Sign Up</span>
                    </p>
                </div>

                <!-- Register Form -->
                <div class="form-container form-register w-full max-w-md mx-auto">
                    <header class="mb-8 text-center md:text-left">
                        <h1 class="text-3xl font-bold tracking-tight text-slate-dark">Create Account</h1>
                        <p class="mt-2 text-base text-gray-500">Join us and start your journey!</p>
                    </header>

                    <div class="flex justify-center gap-4 mb-8">
                        <a href="#" class="flex h-12 w-12 items-center justify-center rounded-full border border-gray-200 bg-white transition hover:bg-gray-50 hover:border-primary/50 text-slate-600">
                            <i class="fa-brands fa-google text-lg"></i>
                        </a>
                        <a href="#" class="flex h-12 w-12 items-center justify-center rounded-full border border-gray-200 bg-white transition hover:bg-gray-50 hover:border-primary/50 text-slate-600">
                            <i class="fa-brands fa-facebook-f text-lg"></i>
                        </a>
                    </div>

                    <div class="relative mb-8 flex items-center">
                        <div class="flex-grow border-t border-gray-300"></div>
                        <span class="mx-4 flex-shrink text-xs text-gray-400 uppercase font-bold">Or register with</span>
                        <div class="flex-grow border-t border-gray-300"></div>
                    </div>

                    <form id="signupForm" class="space-y-5">
                        <div class="space-y-2">
                            <label class="text-sm font-semibold text-slate-600">Username</label>
                            <div class="form-input-container flex items-center gap-3 px-4 py-3 bg-white rounded-xl border border-gray-200 transition-all">
                                <span class="material-symbols-outlined text-gray-400">person</span>
                                <input type="text" class="form-input bg-transparent w-full text-slate-dark placeholder-gray-400 border-none p-0 focus:ring-0" placeholder="Choose a username" required>
                            </div>
                        </div>

                        <div class="space-y-2">
                            <label class="text-sm font-semibold text-slate-600">Email</label>
                            <div class="form-input-container flex items-center gap-3 px-4 py-3 bg-white rounded-xl border border-gray-200 transition-all">
                                <span class="material-symbols-outlined text-gray-400">mail</span>
                                <input type="email" class="form-input bg-transparent w-full text-slate-dark placeholder-gray-400 border-none p-0 focus:ring-0" placeholder="Enter your email" required>
                            </div>
                        </div>

                        <div class="space-y-2">
                            <label class="text-sm font-semibold text-slate-600">Password</label>
                            <div class="form-input-container flex items-center gap-3 px-4 py-3 bg-white rounded-xl border border-gray-200 transition-all">
                                <span class="material-symbols-outlined text-gray-400">lock</span>
                                <input type="password" class="form-input bg-transparent w-full text-slate-dark placeholder-gray-400 border-none p-0 focus:ring-0" placeholder="Create a password" required>
                            </div>
                        </div>

                        <button class="w-full py-4 rounded-xl bg-gradient-to-r from-warm-yellow to-orange-300 text-slate-dark font-bold shadow-lg shadow-orange-100 hover:shadow-orange-200 hover:scale-[1.02] transition-all duration-200" type="submit">
                            SIGN UP
                        </button>
                    </form>

                    <p class="mt-8 text-center text-sm text-gray-600">
                        Already have an account? 
                        <span id="goto-login" class="font-bold text-primary hover:text-indigo-500 cursor-pointer hover:underline">Sign In</span>
                    </p>
                </div>

            </div>
        </div>
        
        <footer class="mt-8 text-center text-sm text-slate-400">
            <p>&copy; 2024 PlanZ. All rights reserved.</p>
        </footer>
    </div>

    <script>
        const loginCard = document.getElementById('loginCard');
        const gotoRegister = document.getElementById('goto-register');
        const gotoLogin = document.getElementById('goto-login');
        const signupForm = document.getElementById('signupForm');

        // Chuyển qua form đăng ký
        gotoRegister.addEventListener('click', () => {
            loginCard.classList.remove('login-active');
            loginCard.classList.add('register-active');
        });

        // Chuyển về form đăng nhập
        gotoLogin.addEventListener('click', () => {
            loginCard.classList.remove('register-active');
            loginCard.classList.add('login-active');
        });

        // Handle registration (placeholder)
        signupForm.addEventListener('submit', (e) => {
            e.preventDefault();
            alert("Registration successful!");
            window.location.href = "dashboard.jsp";
        });
    </script>

</body>
</html>