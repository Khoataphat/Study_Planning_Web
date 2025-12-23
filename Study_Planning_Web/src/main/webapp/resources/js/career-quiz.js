// career-quiz.js
class CareerQuiz {
    constructor(config) {
        this.config = config;
        this.currentQuestion = 0;
        this.totalQuestions = config.totalQuestions;
        this.answers = new Array(this.totalQuestions).fill(null);
        this.startTime = new Date();
        this.quizInitialized = false;
        this.isSubmitting = false;
        
        // Category mapping
        this.categories = [
            { id: 'tech', name: 'Công nghệ', icon: '💻', color: '#3b82f6' },
            { id: 'business', name: 'Kinh doanh', icon: '📊', color: '#10b981' },
            { id: 'creative', name: 'Sáng tạo', icon: '🎨', color: '#8b5cf6' },
            { id: 'science', name: 'Khoa học', icon: '🔬', color: '#ef4444' },
            { id: 'education', name: 'Giáo dục', icon: '📚', color: '#f59e0b' },
            { id: 'social', name: 'Xã hội', icon: '🤝', color: '#ec4899' }
        ];
        
        this.init();
    }
    
    init() {
        console.log('Initializing Career Quiz with', this.totalQuestions, 'questions');
        
        // Hide loading
        this.hideLoading();
        
        if (this.totalQuestions > 0) {
            // Initialize category indicators
            this.initCategoryIndicators();
            
            // Initialize question category hints
            this.initCategoryHints();
            
            // Show first question
            this.showQuestion(0);
            this.quizInitialized = true;
            
            // Update progress
            this.updateProgress();
            
            // Load saved progress
            this.loadSavedProgress();
            
            // Setup event listeners
            this.setupEventListeners();
            
            // Update navigation buttons
            this.updateNavButtons();
        }
    }
    
    hideLoading() {
        const loadingEl = document.getElementById('quiz-status');
        if (loadingEl) {
            loadingEl.style.display = 'none';
        }
    }
    
    initCategoryIndicators() {
        const container = document.getElementById('category-indicators');
        if (!container) return;
        
        container.innerHTML = '';
        
        this.categories.forEach(category => {
            const indicator = document.createElement('div');
            indicator.className = 'category-indicator';
            indicator.id = `indicator-${category.id}`;
            indicator.innerHTML = `${category.icon} ${category.name}`;
            indicator.style.setProperty('--category-color', category.color);
            container.appendChild(indicator);
        });
    }
    
    initCategoryHints() {
        this.config.questions.forEach((question, index) => {
            const hintEl = document.getElementById(`category-hint-${index}`);
            if (!hintEl) return;
            
            // Find top 2 categories for this question
            const weights = Object.entries(question.weights);
            weights.sort((a, b) => b[1] - a[1]);
            
            const topCategories = weights.slice(0, 2);
            const hintText = topCategories.map(([cat, weight]) => {
                const category = this.categories.find(c => c.id === cat);
                return category ? `${category.icon} ${category.name}` : '';
            }).filter(Boolean).join(' • ');
            
            if (hintText) {
                hintEl.textContent = `Liên quan: ${hintText}`;
            }
        });
    }
    
    showQuestion(index) {
        if (index < 0 || index >= this.totalQuestions) {
            console.error('Invalid question index:', index);
            return;
        }
        
        // Hide all questions
        document.querySelectorAll('.question-container').forEach(container => {
            container.classList.remove('active');
        });
        
        // Show requested question
        const questionId = `question-${index + 1}`;
        const questionEl = document.getElementById(questionId);
        
        if (questionEl) {
            questionEl.classList.add('active');
            this.currentQuestion = index;
            
            // Update UI
            this.updateProgress();
            this.updateCategoryIndicators();
            this.updateNavButtons();
            this.updateQuickNav();
            
            // Scroll to top
            window.scrollTo({ top: 0, behavior: 'smooth' });
            
            // Highlight current answer if exists
            this.highlightCurrentAnswer();
        } else {
            console.error('Question element not found:', questionId);
        }
    }
    
    highlightCurrentAnswer() {
        const currentAnswer = this.answers[this.currentQuestion];
        if (currentAnswer) {
            const questionEl = document.getElementById(`question-${this.currentQuestion + 1}`);
            if (questionEl) {
                const questionId = questionEl.getAttribute('data-question-id');
                const radio = document.querySelector(`#q${questionId}_${currentAnswer}`);
                if (radio) {
                    radio.checked = true;
                }
            }
        }
    }
    
    showPrevQuestion() {
        if (this.currentQuestion > 0) {
            this.showQuestion(this.currentQuestion - 1);
        }
    }
    
    nextQuestion() {
        // Validate current question
        if (!this.validateCurrentQuestion()) {
            this.showError('Vui lòng chọn mức độ phù hợp trước khi tiếp tục!');
            return;
        }
        
        this.hideError();
        
        if (this.currentQuestion < this.totalQuestions - 1) {
            this.showQuestion(this.currentQuestion + 1);
        } else {
            this.validateAndSubmit();
        }
    }
    
    validateCurrentQuestion() {
        const questionEl = document.getElementById(`question-${this.currentQuestion + 1}`);
        if (!questionEl) return false;
        
        const questionId = questionEl.getAttribute('data-question-id');
        const selectedValue = document.querySelector(`input[name="question_${questionId}"]:checked`);
        
        if (selectedValue) {
            this.answers[this.currentQuestion] = parseInt(selectedValue.value);
            return true;
        }
        
        return false;
    }
    
    selectOption(questionIndex, value) {
        if (questionIndex < 0 || questionIndex >= this.totalQuestions) {
            console.error('Invalid question index in selectOption:', questionIndex);
            return;
        }
        
        this.answers[questionIndex] = value;
        this.hideError();
        this.showSuccess('Đã lưu câu trả lời!');
        
        // Auto-advance on last option selection
        if (value === 5 && questionIndex === this.currentQuestion) {
            setTimeout(() => {
                if (questionIndex < this.totalQuestions - 1) {
                    this.nextQuestion();
                }
            }, 500);
        }
    }
    
    resetQuestion(index) {
        if (index < 0 || index >= this.totalQuestions) return;
        
        const questionEl = document.getElementById(`question-${index + 1}`);
        if (questionEl) {
            const questionId = questionEl.getAttribute('data-question-id');
            // Uncheck all radio buttons for this question
            document.querySelectorAll(`input[name="question_${questionId}"]`).forEach(radio => {
                radio.checked = false;
            });
        }
        
        this.answers[index] = null;
        this.showSuccess('Đã xóa câu trả lời!');
    }
    
    updateProgress() {
        const progress = this.totalQuestions > 0 ? 
            ((this.currentQuestion + 1) / this.totalQuestions) * 100 : 0;
        
        // Update progress bar
        const progressFill = document.getElementById('progress-fill');
        if (progressFill) {
            progressFill.style.width = progress + '%';
        }
        
        // Update completion percentage
        const completionPercent = document.getElementById('completion-percent');
        if (completionPercent) {
            completionPercent.textContent = Math.round(progress) + '%';
        }
        
        // Update current question number
        const currentQuestionEl = document.getElementById('current-question');
        if (currentQuestionEl) {
            currentQuestionEl.textContent = this.currentQuestion + 1;
        }
    }
    
    updateCategoryIndicators() {
        // Reset all indicators
        document.querySelectorAll('.category-indicator').forEach(ind => {
            ind.classList.remove('active');
        });
        
        // Get current question weights
        const currentQuestion = this.config.questions[this.currentQuestion];
        if (!currentQuestion) return;
        
        // Find categories with weight > 0
        Object.entries(currentQuestion.weights).forEach(([categoryId, weight]) => {
            if (weight > 0) {
                const indicator = document.getElementById(`indicator-${categoryId}`);
                if (indicator) {
                    indicator.classList.add('active');
                }
            }
        });
    }
    
    updateNavButtons() {
        // Update previous button visibility
        const prevButtons = document.querySelectorAll('.prev-btn');
        prevButtons.forEach(btn => {
            if (btn) {
                btn.classList.toggle('hidden', this.currentQuestion === 0);
            }
        });
        
        // Update next button text on last question
        if (this.currentQuestion === this.totalQuestions - 1) {
            const nextButtons = document.querySelectorAll('.next-btn');
            nextButtons.forEach(btn => {
                if (btn) {
                    btn.querySelector('.btn-text').textContent = 'Xem kết quả';
                    btn.onclick = () => this.validateAndSubmit();
                }
            });
        }
    }
    
    updateQuickNav() {
        document.querySelectorAll('.quick-nav-btn').forEach((btn, index) => {
            btn.classList.toggle('active', index === this.currentQuestion);
        });
    }
    
    showError(message) {
        const errorEl = document.getElementById('error-message');
        const errorText = document.getElementById('error-text');
        
        if (errorEl && errorText) {
            errorText.textContent = message;
            errorEl.classList.remove('hidden');
            
            // Auto-hide after 5 seconds
            setTimeout(() => {
                this.hideError();
            }, 5000);
            
            // Shake animation
            errorEl.style.animation = 'none';
            setTimeout(() => {
                errorEl.style.animation = 'shake 0.5s';
            }, 10);
        }
    }
    
    hideError() {
        const errorEl = document.getElementById('error-message');
        if (errorEl) {
            errorEl.classList.add('hidden');
        }
    }
    
    showSuccess(message) {
        const successEl = document.getElementById('success-message');
        const successText = document.getElementById('success-text');
        
        if (successEl && successText) {
            successText.textContent = message;
            successEl.classList.remove('hidden');
            
            // Auto-hide after 3 seconds
            setTimeout(() => {
                successEl.classList.add('hidden');
            }, 3000);
        }
    }
    
    validateAndSubmit() {
        if (this.isSubmitting) return;
        
        console.log('Validating and submitting quiz...');
        
        // Check if all questions are answered
        const unansweredQuestions = [];
        for (let i = 0; i < this.totalQuestions; i++) {
            if (this.answers[i] === null) {
                unansweredQuestions.push(i + 1);
            }
        }
        
        if (unansweredQuestions.length > 0) {
            const errorMsg = `Vui lòng trả lời câu ${unansweredQuestions.join(', ')} trước khi nộp bài!`;
            this.showError(errorMsg);
            
            // Show first unanswered question
            const firstUnanswered = unansweredQuestions[0] - 1;
            if (firstUnanswered >= 0) {
                this.showQuestion(firstUnanswered);
            }
            return;
        }
        
        // Calculate time spent
        const endTime = new Date();
        const timeSpent = Math.round((endTime - this.startTime) / 1000);
        
        // Add time spent as hidden input
        const timeInput = document.createElement('input');
        timeInput.type = 'hidden';
        timeInput.name = 'time_spent';
        timeInput.value = timeSpent;
        
        const form = document.getElementById('careerQuizForm');
        if (form) {
            form.appendChild(timeInput);
            
            // Show confirmation dialog
            if (confirm('Bạn đã hoàn thành tất cả câu hỏi!\nBấm OK để xem kết quả phân tích chi tiết.')) {
                this.isSubmitting = true;
                
                // Show submitting state
                const submitBtn = document.querySelector('.submit-btn');
                if (submitBtn) {
                    const originalText = submitBtn.querySelector('.btn-text').textContent;
                    submitBtn.querySelector('.btn-text').textContent = 'Đang xử lý...';
                    submitBtn.disabled = true;
                }
                
                // Submit form
                console.log('Submitting form...');
                form.submit();
            }
        } else {
            console.error('Form not found');
            this.showError('Có lỗi xảy ra. Vui lòng thử lại!');
        }
    }
    
    saveProgress() {
        if (this.answers.some(answer => answer !== null)) {
            const progressData = {
                answers: this.answers,
                currentQuestion: this.currentQuestion,
                timestamp: new Date().getTime(),
                userId: this.config.userId
            };
            
            localStorage.setItem('career_quiz_progress', JSON.stringify(progressData));
            this.showSuccess('Đã lưu tiến độ thành công!');
        } else {
            this.showError('Chưa có câu trả lời nào để lưu!');
        }
    }
    
    loadSavedProgress() {
        try {
            const saved = localStorage.getItem('career_quiz_progress');
            if (saved) {
                const data = JSON.parse(saved);
                const now = new Date().getTime();
                const oneHour = 60 * 60 * 1000;
                
                // Check if saved for same user and within last hour
                if (data.userId === this.config.userId && now - data.timestamp < oneHour) {
                    this.answers = data.answers;
                    const savedQuestion = Math.min(data.currentQuestion, this.totalQuestions - 1);
                    
                    // Restore radio selections
                    this.answers.forEach((answer, index) => {
                        if (answer !== null) {
                            const questionEl = document.getElementById(`question-${index + 1}`);
                            if (questionEl) {
                                const questionId = questionEl.getAttribute('data-question-id');
                                if (questionId) {
                                    const radio = document.querySelector(`#q${questionId}_${answer}`);
                                    if (radio) {
                                        radio.checked = true;
                                    }
                                }
                            }
                        }
                    });
                    
                    // Show saved question
                    if (savedQuestion >= 0) {
                        this.showQuestion(savedQuestion);
                        this.showSuccess('Đã khôi phục tiến độ bài quiz trước đó!');
                    }
                } else {
                    // Clear expired data
                    localStorage.removeItem('career_quiz_progress');
                }
            }
        } catch (e) {
            console.error('Error loading saved progress:', e);
            localStorage.removeItem('career_quiz_progress');
        }
    }
    
    setupEventListeners() {
        // Keyboard navigation
        document.addEventListener('keydown', (event) => {
            if (!this.quizInitialized || this.isSubmitting) return;
            
            switch(event.key) {
                case 'ArrowLeft':
                    event.preventDefault();
                    if (this.currentQuestion > 0) {
                        this.showQuestion(this.currentQuestion - 1);
                    }
                    break;
                    
                case 'ArrowRight':
                    event.preventDefault();
                    this.nextQuestion();
                    break;
                    
                case '1':
                case '2':
                case '3':
                case '4':
                case '5':
                    event.preventDefault();
                    const value = parseInt(event.key);
                    this.selectOption(this.currentQuestion, value);
                    
                    // Update radio button
                    const questionEl = document.getElementById(`question-${this.currentQuestion + 1}`);
                    if (questionEl) {
                        const questionId = questionEl.getAttribute('data-question-id');
                        if (questionId) {
                            const radio = document.querySelector(`#q${questionId}_${value}`);
                            if (radio) {
                                radio.checked = true;
                            }
                        }
                    }
                    break;
                    
                case 'Enter':
                    event.preventDefault();
                    if (event.ctrlKey) {
                        this.saveProgress();
                    } else if (this.currentQuestion < this.totalQuestions - 1) {
                        this.nextQuestion();
                    } else {
                        this.validateAndSubmit();
                    }
                    break;
                    
                case 's':
                case 'S':
                    if (event.ctrlKey) {
                        event.preventDefault();
                        this.saveProgress();
                    }
                    break;
            }
        });
        
        // Save progress on page unload
        window.addEventListener('beforeunload', (event) => {
            if (this.answers.some(answer => answer !== null) && !this.isSubmitting) {
                this.saveProgress();
            }
        });
    }
}

// Initialize quiz when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    if (window.quizConfig) {
        window.careerQuiz = new CareerQuiz(window.quizConfig);
    }
});

// Add shake animation
const style = document.createElement('style');
style.textContent = `
    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-5px); }
        75% { transform: translateX(5px); }
    }
`;
document.head.appendChild(style);