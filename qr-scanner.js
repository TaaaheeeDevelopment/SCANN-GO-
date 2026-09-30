(function () {
  'use strict';
  if (window.CyberQR) return;

  const COOLDOWN_MS = 3000;
  let scanner = null;
  let running = false;
  let busy = false;
  let last = { text: '', time: 0 };

  function emit(name) {
    document.dispatchEvent(new CustomEvent('cyberqr:' + name));
  }

  async function start({ containerId, onScan, onError }) {
    if (running || busy) return false;
    if (typeof Html5Qrcode === 'undefined') {
      if (onError) onError(new Error('مكتبة html5-qrcode ما انحملت'));
      return false;
    }
    if (!document.getElementById(containerId)) {
      if (onError) onError(new Error('عنصر الكاميرا مفقود'));
      return false;
    }

    busy = true;
    try {
      scanner = new Html5Qrcode(containerId, {
        verbose: false,
        formatsToSupport: [Html5QrcodeSupportedFormats.QR_CODE]
      });
      await scanner.start(
        { facingMode: 'environment' },
        {
          fps: 10,
          qrbox: (w, h) => {
            const s = Math.floor(Math.min(w, h) * 0.7);
            return { width: s, height: s };
          }
        },
        (text) => {
          const now = Date.now();
          if (text === last.text && now - last.time < COOLDOWN_MS) return;
          last = { text, time: now };
          if (onScan) onScan(String(text));
        },
        () => {}
      );
      running = true;
      emit('started');
      return true;
    } catch (err) {
      scanner = null;
      running = false;
      if (onError) onError(err);
      return false;
    } finally {
      busy = false;
    }
  }

  async function stop() {
    if (!scanner) return;
    const s = scanner;
    scanner = null;
    running = false;
    try { await s.stop(); } catch (e) {}
    try { s.clear(); } catch (e) {}
    emit('stopped');
  }

  window.addEventListener('pagehide', stop);
  document.addEventListener('visibilitychange', () => { if (document.hidden) stop(); });

  window.CyberQR = Object.freeze({ start, stop, isRunning: () => running });
})();
