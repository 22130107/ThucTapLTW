(function () {
    const yearNodes = document.querySelectorAll('[data-current-year]');
    if (!yearNodes.length) return;

    const year = new Date().getFullYear();
    yearNodes.forEach((node) => {
        node.textContent = String(year);
    });
})();
