const heroActions = document.querySelector('.hero-actions');
const quickInstall = document.querySelector('.mobile-install');
if (heroActions && quickInstall && 'IntersectionObserver' in window) {
  const observer = new IntersectionObserver(([entry]) => {
    quickInstall.classList.toggle('is-visible', !entry.isIntersecting && entry.boundingClientRect.bottom < 0);
  });
  observer.observe(heroActions);
}
