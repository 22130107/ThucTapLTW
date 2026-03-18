// Toggle sidebar bằng JS + lưu trạng thái vào localStorage
(function () {
    const btn = document.getElementById('btn-toggle');
    const sidebar = document.getElementById('sidebar');
    const STORAGE_KEY = 'sidebarCollapsed';

    // Khởi tạo trạng thái từ localStorage
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved === '1') {
        document.body.classList.add('is-collapsed');
        btn.setAttribute('aria-expanded', 'false');
        sidebar.setAttribute('aria-hidden', 'true');
    } else {
        btn.setAttribute('aria-expanded', 'true');
        sidebar.setAttribute('aria-hidden', 'false');
    }

    // Sự kiện toggle
    btn.addEventListener('click', () => {
        const collapsed = document.body.classList.toggle('is-collapsed');
        // ARIA
        btn.setAttribute('aria-expanded', collapsed ? 'false' : 'true');
        sidebar.setAttribute('aria-hidden', collapsed ? 'true' : 'false');
        // Lưu
        localStorage.setItem(STORAGE_KEY, collapsed ? '1' : '0');
    });

    // Nếu người dùng phóng to/thu nhỏ cửa sổ, bạn có thể xử lý thêm nếu cần.
    // Ví dụ: tự mở sidebar khi lên desktop lớn (không bắt buộc)
    // window.addEventListener('resize', () => {
    //   if (window.innerWidth > 980 && document.body.classList.contains('is-collapsed')) {
    //     // Giữ nguyên trạng thái đã lưu; bỏ dòng này nếu muốn luôn mở trên desktop
    //   }
    // });
})();


// Đặt highlight menu theo URL hiện tại
const setActiveMenu = () => {
    // Lấy tên file hiện tại (mặc định coi trang rỗng là overview.html)
    const current = location.pathname.split('/').pop() || 'overview.html';

    document.querySelectorAll('.sidebar .menu .menu-item').forEach(a => {
        const href = a.getAttribute('href') || '';
        // Lấy phần tên file của href để so
        const file = href.split('/').pop();

        if (file && file === current) {
            a.classList.add('is-active');
        } else {
            a.classList.remove('is-active');
        }
    });
};

setActiveMenu();
