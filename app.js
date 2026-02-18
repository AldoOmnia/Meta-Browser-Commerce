// Meta Browser Commerce — Mockup app logic

document.addEventListener('DOMContentLoaded', () => {
  const app = document.getElementById('app');
  const buttons = document.querySelectorAll('.proto-buttons button');

  function showScreen(id) {
    const template = SCREENS[id];
    if (!template) return;

    app.innerHTML = template;
    buttons.forEach(btn => {
      btn.classList.toggle('active', btn.dataset.screen === id);
    });
  }

  buttons.forEach(btn => {
    btn.addEventListener('click', () => showScreen(btn.dataset.screen));
  });

  showScreen('home');
});
