// Schedule Page JavaScript - Multiple Collections Version

document.addEventListener('DOMContentLoaded', loadSchedules);

/**
 * Load all schedule collections from server
 */
function loadSchedules() {
    const container = document.getElementById('scheduleListContainer');

    // Fetch all collections from server
    fetch('/Schedule_Student/user/collections?action=list')
        .then(response => response.json())
        .then(collections => {
            if (collections && collections.length > 0) {
                collections.forEach(collection => {
                    renderScheduleCard(container, collection);
                });
            } else {
                showNoSchedulesMessage(container);
            }
        })
        .catch(error => {
            console.error('Error loading collections:', error);
            showErrorMessage(container);
        });
}

/**
 * Render a schedule card for each collection
 */
function renderScheduleCard(container, collection) {
    const card = document.createElement('div');
    card.classList.add('schedule-card', 'bg-white/60', 'backdrop-blur-xl', 'rounded-3xl', 'p-6', 'shadow-sm', 'border', 'border-white/50', 'flex', 'flex-col', 'min-h-[250px]', 'relative', 'group');

    // Get schedule count for this collection
    fetch(`/Schedule_Student/user/schedule?action=count&collectionId=${collection.collectionId}`)
        .then(response => response.json())
        .then(data => {
            const scheduleCount = data.count || 0;

            card.innerHTML =
                '<div class="flex items-start justify-between mb-4">' +
                '<div class="flex items-center gap-3 flex-1">' +
                '<div class="w-12 h-12 rounded-xl bg-gradient-to-br from-pinky to-primary flex items-center justify-center shadow-lg">' +
                '<i class="fa-solid fa-calendar-alt text-white text-xl"></i>' +
                '</div>' +
                '<div class="flex-1">' +
                '<h3 class="text-lg font-bold text-slate-dark group-hover:text-primary transition-colors cursor-pointer" onclick="openDesigner(' + collection.collectionId + ')">' + escapeHtml(collection.collectionName) + '</h3>' +
                '<p class="text-xs text-slate-400">Click để xem/chỉnh sửa</p>' +
                '</div>' +
                '</div>' +
                '<div class="flex gap-2 opacity-0 group-hover:opacity-100 transition-opacity">' +
                '<button onclick="renameCollection(' + collection.collectionId + ', \'' + escapeHtml(collection.collectionName) + '\')" class="w-8 h-8 rounded-lg bg-blue-100 hover:bg-blue-200 flex items-center justify-center text-blue-600 transition-all" title="Đổi tên">' +
                '<i class="fa-solid fa-edit text-sm"></i>' +
                '</button>' +
                '<button onclick="deleteCollection(' + collection.collectionId + ')" class="w-8 h-8 rounded-lg bg-red-100 hover:bg-red-200 flex items-center justify-center text-red-600 transition-all" title="Xóa">' +
                '<i class="fa-solid fa-trash text-sm"></i>' +
                '</button>' +
                '</div>' +
                '</div>' +
                '<div class="flex-1 flex flex-col justify-end">' +
                '<div class="flex items-center justify-between p-4 bg-slate-50/50 rounded-xl cursor-pointer" onclick="openDesigner(' + collection.collectionId + ')">' +
                '<div class="flex items-center gap-2">' +
                '<span class="material-symbols-outlined text-primary text-sm">task_alt</span>' +
                '<span class="text-sm font-semibold text-slate-600">' + scheduleCount + ' Lịch học</span>' +
                '</div>' +
                '<div class="flex items-center gap-1 text-primary text-sm font-semibold group-hover:gap-2 transition-all">' +
                '<span>Edit</span>' +
                '<i class="fa-solid fa-arrow-right"></i>' +
                '</div>' +
                '</div>' +
                '</div>';

            container.appendChild(card);
        });
}

/**
 * Open designer for a specific collection
 */
function openDesigner(collectionId) {
    window.location.href = 'designer.jsp?collectionId=' + collectionId;
}

/**
 * Rename a collection - using custom modal
 */
let currentRenameId = null;
let currentRenameName = null;

function renameCollection(collectionId, currentName) {
    currentRenameId = collectionId;
    currentRenameName = currentName;

    // Show modal and populate input
    const modal = document.getElementById('renameModal');
    const input = document.getElementById('renameInput');
    input.value = currentName;
    modal.classList.remove('hidden');

    // Focus input and select text
    setTimeout(() => {
        input.focus();
        input.select();
    }, 100);
}

function closeRenameModal() {
    const modal = document.getElementById('renameModal');
    modal.classList.add('hidden');
    currentRenameId = null;
    currentRenameName = null;
}

function confirmRename() {
    const input = document.getElementById('renameInput');
    const newName = input.value.trim();

    if (!newName) {
        alert('Vui lòng nhập tên lịch!');
        return;
    }

    if (newName === currentRenameName) {
        closeRenameModal();
        return;
    }

    // Send update request
    fetch('/Schedule_Student/user/collections?id=' + currentRenameId, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ name: newName })
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                closeRenameModal();
                location.reload();
            } else {
                alert('Lỗi khi đổi tên: ' + (data.message || data.error));
            }
        })
        .catch(error => {
            console.error('Error renaming collection:', error);
            alert('Không thể đổi tên lịch. Vui lòng thử lại.');
        });
}

// Close modal when clicking outside
document.addEventListener('click', function (event) {
    const modal = document.getElementById('renameModal');
    if (event.target === modal) {
        closeRenameModal();
    }
});

// Close modal on Escape key
document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') {
        closeRenameModal();
    }
    // Submit on Enter key
    if (event.key === 'Enter' && !document.getElementById('renameModal').classList.contains('hidden')) {
        confirmRename();
    }
});


/**
 * Delete a collection
 */
function deleteCollection(collectionId) {
    if (confirm('Bạn có chắc muốn xóa lịch này? Tất cả các sự kiện sẽ bị xóa.')) {
        fetch('/Schedule_Student/user/collections?id=' + collectionId, {
            method: 'DELETE'
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Đã xóa lịch thành công!');
                    location.reload();
                } else {
                    alert(data.message || 'Không thể xóa lịch cuối cùng!');
                }
            })
            .catch(error => {
                console.error('Error deleting collection:', error);
                alert('Không thể xóa lịch. Vui lòng thử lại.');
            });
    }
}

/**
 * Escape HTML to prevent XSS
 */
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

/**
 * Show message when no schedules exist
 */
function showNoSchedulesMessage(container) {
    const message = document.createElement('div');
    message.className = 'col-span-full text-center py-12';
    message.innerHTML =
        '<div class="text-slate-400 mb-4">' +
        '<i class="fa-solid fa-calendar-xmark text-6xl mb-4"></i>' +
        '<p class="text-lg">Chưa có lịch học nào</p>' +
        '<p class="text-sm">Hãy tạo lịch học đầu tiên của bạn!</p>' +
        '</div>';
    container.appendChild(message);
}

/**
 * Show error message
 */
function showErrorMessage(container) {
    const message = document.createElement('div');
    message.className = 'col-span-full text-center py-12 text-red-500';
    message.innerHTML =
        '<i class="fa-solid fa-exclamation-triangle text-4xl mb-4"></i>' +
        '<p>Không thể tải lịch học. Vui lòng thử lại sau.</p>';
    container.appendChild(message);
}

/**
 * Create a new schedule collection
 */
function createNewSchedule() {
    console.log('createNewSchedule() called'); // DEBUG

    const collectionName = prompt('Nhập tên cho lịch học mới:', 'Lịch học mới');
    console.log('User entered name:', collectionName); // DEBUG

    if (collectionName && collectionName.trim() !== '') {
        console.log('Sending POST request to create collection...'); // DEBUG

        fetch('/Schedule_Student/user/collections', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ name: collectionName.trim() })
        })
            .then(response => {
                console.log('Response received:', response); // DEBUG
                return response.json();
            })
            .then(data => {
                console.log('Response data:', data); // DEBUG

                if (data.success && data.collectionId) {
                    console.log('Success! Redirecting to designer...'); // DEBUG
                    // Redirect to designer with new collection ID
                    window.location.href = 'designer.jsp?collectionId=' + data.collectionId;
                } else {
                    console.error('Failed to create collection:', data); // DEBUG
                    alert('Lỗi khi tạo lịch: ' + (data.message || data.error));
                }
            })
            .catch(error => {
                console.error('Error creating collection:', error); // DEBUG
                alert('Không thể tạo lịch mới. Vui lòng thử lại.');
            });
    } else {
        console.log('User cancelled or entered empty name'); // DEBUG
    }
}

