// Contact page JS – form validation + UX enhancements

document.addEventListener('DOMContentLoaded', function () {

    const form = document.querySelector('.ct-form');
    if (!form) return;

    // ── Client-side validation ──────────────────────────────────────────
    form.addEventListener('submit', function (e) {
        let valid = true;

        const required = form.querySelectorAll('[required]');
        required.forEach(function (field) {
            clearError(field);
            if (!field.value.trim()) {
                showError(field, 'Trường này không được để trống.');
                valid = false;
            }
        });

        // Phone format
        const phone = form.querySelector('#phone');
        if (phone && phone.value.trim()) {
            const cleaned = phone.value.replace(/[\s.\-]/g, '');
            if (!/^(0|\+84)[0-9]{9}$/.test(cleaned)) {
                showError(phone, 'Số điện thoại không hợp lệ.');
                valid = false;
            }
        }

        // Email format (optional field)
        const email = form.querySelector('#email');
        if (email && email.value.trim()) {
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value.trim())) {
                showError(email, 'Email không hợp lệ.');
                valid = false;
            }
        }

        if (!valid) {
            e.preventDefault();
            // Scroll to first error
            const firstErr = form.querySelector('.ct-field-error');
            if (firstErr) firstErr.scrollIntoView({ behavior: 'smooth', block: 'center' });
        } else {
            // Loading state
            const btn = form.querySelector('.ct-submit-btn');
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang gửi...';
            btn.disabled = true;
        }
    });

    // ── Auto-scroll to success/error alert ─────────────────────────────
    const alert = document.querySelector('.ct-alert');
    if (alert) {
        setTimeout(function () {
            alert.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }, 300);
    }

    // ── Helpers ─────────────────────────────────────────────────────────
    function showError(field, msg) {
        field.style.borderColor = '#e53e3e';
        const err = document.createElement('span');
        err.className = 'ct-field-error';
        err.style.cssText = 'color:#e53e3e;font-size:0.78rem;margin-top:3px;display:block';
        err.textContent = msg;
        field.parentNode.appendChild(err);
    }

    function clearError(field) {
        field.style.borderColor = '';
        const prev = field.parentNode.querySelector('.ct-field-error');
        if (prev) prev.remove();
    }

    // Clear error on input
    form.querySelectorAll('input, textarea, select').forEach(function (field) {
        field.addEventListener('input', function () { clearError(field); });
    });
});
