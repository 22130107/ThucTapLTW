function initAllSliders() {
    const sliders = document.querySelectorAll('.dm-slider');
    sliders.forEach(slider => {
        try {
            initSlider(slider);
        } catch (error) {
            console.error('Loi khoi tao dm-slider:', error);
        }
    });
}

function initHomeIntroCarousel() {
    const carousel = document.querySelector('.home-intro-carousel');
    if (!carousel) return;

    const track = carousel.querySelector('.home-intro-track');
    const slides = Array.from(carousel.querySelectorAll('.home-intro-slide'));
    const prevBtn = carousel.querySelector('.home-intro-arrow.prev');
    const nextBtn = carousel.querySelector('.home-intro-arrow.next');
    const dots = Array.from(carousel.querySelectorAll('.home-intro-dot'));

    if (!track || slides.length === 0) return;

    const intervalMs = 4500;
    let currentIndex = 0;
    let autoTimer = null;
    let touchStartX = 0;

    const renderSlide = (nextIndex) => {
        const total = slides.length;
        currentIndex = (nextIndex + total) % total;
        track.style.transform = `translateX(-${currentIndex * 100}%)`;

        slides.forEach((slide, index) => {
            slide.classList.toggle('is-active', index === currentIndex);
        });

        dots.forEach((dot, index) => {
            const isActive = index === currentIndex;
            dot.classList.toggle('is-active', isActive);
            dot.setAttribute('aria-selected', isActive ? 'true' : 'false');
        });
    };

    const stopAuto = () => {
        if (autoTimer !== null) {
            clearInterval(autoTimer);
            autoTimer = null;
        }
    };

    const startAuto = () => {
        stopAuto();
        if (carousel.dataset.autoplay === 'false') return;
        autoTimer = window.setInterval(() => {
            renderSlide(currentIndex + 1);
        }, intervalMs);
    };

    if (prevBtn) {
        prevBtn.addEventListener('click', () => {
            renderSlide(currentIndex - 1);
            startAuto();
        });
    }

    if (nextBtn) {
        nextBtn.addEventListener('click', () => {
            renderSlide(currentIndex + 1);
            startAuto();
        });
    }

    dots.forEach((dot) => {
        dot.addEventListener('click', () => {
            const targetIndex = Number(dot.dataset.slide);
            if (!Number.isFinite(targetIndex)) return;
            renderSlide(targetIndex);
            startAuto();
        });
    });

    carousel.addEventListener('mouseenter', stopAuto);
    carousel.addEventListener('mouseleave', startAuto);
    carousel.addEventListener('focusin', stopAuto);
    carousel.addEventListener('focusout', startAuto);

    carousel.addEventListener('touchstart', (event) => {
        touchStartX = (event.touches && event.touches[0]) ? event.touches[0].clientX : 0;
        stopAuto();
    }, { passive: true });

    carousel.addEventListener('touchend', (event) => {
        const touchEndX = (event.changedTouches && event.changedTouches[0])
            ? event.changedTouches[0].clientX
            : 0;
        const deltaX = touchEndX - touchStartX;

        if (Math.abs(deltaX) > 40) {
            if (deltaX > 0) {
                renderSlide(currentIndex - 1);
            } else {
                renderSlide(currentIndex + 1);
            }
        }

        startAuto();
    }, { passive: true });

    document.addEventListener('visibilitychange', () => {
        if (document.hidden) {
            stopAuto();
        } else {
            startAuto();
        }
    });

    renderSlide(0);
    startAuto();
}

function initHomePageUi() {
    initHomeIntroCarousel();
    initAllSliders();
}

function initSlider(slider) {
    const track = slider.querySelector('.dm-track');
    const prevBtn = slider.querySelector('.dm-prev');
    const nextBtn = slider.querySelector('.dm-next');
    if (!track || !prevBtn || !nextBtn) return;

    const updatePPV = () => {
        let ppv = 5;
        const w = window.innerWidth;
        if (w <= 480) ppv = 2;
        else if (w <= 768) ppv = 2;
        else if (w <= 992) ppv = 3;
        else if (w <= 1200) ppv = 4;
        track.style.setProperty("--ppv", ppv);
        cardsPerView = ppv;
        clampIndex();
        scrollToIndex(false);
    };

    const cards = Array.from(track.children);
    let cardsPerView = 5;
    let index = 0;

    const maxIndex = () => Math.max(0, cards.length - cardsPerView);

    const clampIndex = () => { index = Math.min(Math.max(0, index), maxIndex()); };
    const setDisabled = () => {
        if (index <= 0) prevBtn.setAttribute("disabled", "");
        else prevBtn.removeAttribute("disabled");
        if (index >= maxIndex()) nextBtn.setAttribute("disabled", "");
        else nextBtn.removeAttribute("disabled");
    };

    const scrollToIndex = (smooth = true) => {
        const gap = parseFloat(getComputedStyle(track).getPropertyValue("--gap")) || 14;
        const cardW = cards[0] ? cards[0].getBoundingClientRect().width : 0;
        const x = index * (cardW + gap);
        track.scrollTo({ left: x, behavior: smooth ? "smooth" : "auto" });
        setDisabled();
    };

    prevBtn.addEventListener("click", () => { index--; clampIndex(); scrollToIndex(); });
    nextBtn.addEventListener("click", () => { index++; clampIndex(); scrollToIndex(); });

    let isDown = false, startX = 0, startScroll = 0;
    const onDown = (e) => {
        isDown = true;
        startX = (e.touches && e.touches[0]) ? e.touches[0].pageX : e.pageX;
        startScroll = track.scrollLeft;
    };
    const onMove = (e) => {
        if (!isDown) return;
        const x = (e.touches && e.touches[0]) ? e.touches[0].pageX : e.pageX;
        track.scrollLeft = startScroll - (x - startX);
    };
    const onUp = () => {
        if (!isDown) return; 
        isDown = false;
        const gap = parseFloat(getComputedStyle(track).getPropertyValue("--gap")) || 14;
        const cardW = cards[0] ? cards[0].getBoundingClientRect().width : 0;
        const rawIndex = Math.round(track.scrollLeft / (cardW + gap));
        index = Math.min(Math.max(0, rawIndex), maxIndex());
        scrollToIndex();
    };

    track.addEventListener("mousedown", onDown);
    track.addEventListener("mousemove", onMove);
    window.addEventListener("mouseup", onUp);
    track.addEventListener("touchstart", onDown, { passive: true });
    track.addEventListener("touchmove", onMove, { passive: true });
    track.addEventListener("touchend", onUp);

    window.addEventListener("resize", updatePPV);

    updatePPV();
    setDisabled();
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initHomePageUi);
} else {
    initHomePageUi();
}