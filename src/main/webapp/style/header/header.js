(function () {
    const header = document.querySelector('.site-header');
    if (!header) return;

    const updateHeaderState = () => {
        header.classList.toggle('no-padding', window.scrollY > 16);
    };

    updateHeaderState();
    window.addEventListener('scroll', updateHeaderState, { passive: true });

    // Mobile fallback: click cart button to open mini-cart because hover is unreliable on touch screens.
    const cartWrap = header.querySelector('.cart-wrap');
    if (!cartWrap) return;

    const cartBtn = cartWrap.querySelector('.cart-btn');
    const miniCart = cartWrap.querySelector('.mini-cart');
    if (!cartBtn || !miniCart) return;

    const isMobile = () => window.matchMedia('(max-width: 992px)').matches;

    cartBtn.addEventListener('click', (event) => {
        if (!isMobile()) return;
        event.preventDefault();
        const shouldOpen = !cartWrap.classList.contains('is-open');
        cartWrap.classList.toggle('is-open', shouldOpen);
        miniCart.style.display = shouldOpen ? 'block' : 'none';
    });

    document.addEventListener('click', (event) => {
        if (!isMobile()) return;
        if (cartWrap.contains(event.target)) return;
        cartWrap.classList.remove('is-open');
        miniCart.style.display = 'none';
    });
})();
