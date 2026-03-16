function initAllSliders() {
    const sliders = document.querySelectorAll('.dm-slider');
    sliders.forEach(slider => {
        initSlider(slider);
    });
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
        const cardW = cards[0]?.getBoundingClientRect().width || 0;
        const x = index * (cardW + gap);
        track.scrollTo({ left: x, behavior: smooth ? "smooth" : "instant" });
        setDisabled();
    };

    prevBtn.addEventListener("click", () => { index--; clampIndex(); scrollToIndex(); });
    nextBtn.addEventListener("click", () => { index++; clampIndex(); scrollToIndex(); });

    let isDown = false, startX = 0, startScroll = 0;
    const onDown = (e) => {
        isDown = true;
        startX = (e.touches ? e.touches[0].pageX : e.pageX);
        startScroll = track.scrollLeft;
    };
    const onMove = (e) => {
        if (!isDown) return;
        const x = (e.touches ? e.touches[0].pageX : e.pageX);
        track.scrollLeft = startScroll - (x - startX);
    };
    const onUp = () => {
        if (!isDown) return; 
        isDown = false;
        const gap = parseFloat(getComputedStyle(track).getPropertyValue("--gap")) || 14;
        const cardW = cards[0]?.getBoundingClientRect().width || 0;
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
    document.addEventListener("DOMContentLoaded", initAllSliders);
} else {
    initAllSliders();
}