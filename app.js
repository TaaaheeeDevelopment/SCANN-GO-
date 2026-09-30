/* ==========================================================================
   Cyber Engineer Attendance System - Main JS Engine (Final Refinements)
   ========================================================================== */

let currentSessionAttendees = [];
let addedGuestStudents = [];
let activeDetailLectureObj = null;
let pendingConfirmCallback = null;

document.addEventListener('DOMContentLoaded', () => {
  if (window.lucide) {
    lucide.createIcons();
  }

  initParticleNetworks();
  setupHeaderDropdown();
  setupNavigation();
  setupCreateLectureEngine();
  initPastLectures();
  setupConfirmModalSystem();
  setupGuestSectionValidation();
});

/* ==========================================================================
   1. Particle Network Canvas Engine
   ========================================================================== */
function initParticleNetworks() {
  const canvases = document.querySelectorAll('.particle-canvas');
  canvases.forEach(canvas => {
    if (!canvas.dataset.initialized) {
      canvas.dataset.initialized = "true";
      new CardParticleEngine(canvas);
    }
  });
}

class CardParticleEngine {
  constructor(canvas) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.card = canvas.closest('.cyber-card');
    this.particles = [];
    this.maxDistance = 110;
    this.baseSpeed = 0.35;
    this.init();
  }

  init() {
    this.resize();
    this.createParticles();
    this.animate();

    if (this.card) {
      this.card.addEventListener('animationend', () => {
        setTimeout(() => this.resize(), 50);
      });
    }

    if (window.ResizeObserver && this.card) {
      const observer = new ResizeObserver(() => this.resize());
      observer.observe(this.card);
    }
    window.addEventListener('resize', () => this.resize());
  }

  resize() {
    if (!this.card) return;
    const rect = this.card.getBoundingClientRect();
    const cardW = rect.width > 0 ? rect.width : (this.card.offsetWidth || 380);
    const cardH = rect.height > 0 ? rect.height : (this.card.offsetHeight || 420);

    if (cardW === 0 || cardH === 0) return;

    this.width = cardW;
    this.height = cardH;

    const dpr = window.devicePixelRatio || 1;
    this.canvas.width = this.width * dpr;
    this.canvas.height = this.height * dpr;
    this.ctx.scale(dpr, dpr);

    const targetCount = Math.floor((this.width * this.height) / 7500);
    this.adjustParticleCount(Math.max(20, Math.min(targetCount, 50)));
  }

  adjustParticleCount(count) {
    if (this.particles.length < count) {
      for (let i = this.particles.length; i < count; i++) {
        this.particles.push(this.generateParticle());
      }
    } else if (this.particles.length > count) {
      this.particles.splice(count);
    }
  }

  generateParticle() {
    return {
      x: Math.random() * (this.width || 380),
      y: Math.random() * (this.height || 420),
      vx: (Math.random() - 0.5) * this.baseSpeed,
      vy: (Math.random() - 0.5) * this.baseSpeed,
      radius: Math.random() * 1.5 + 1.2,
      alpha: Math.random() * 0.5 + 0.45
    };
  }

  createParticles() {
    this.particles = [];
    const w = this.width || 380;
    const h = this.height || 420;
    const count = Math.floor((w * h) / 7500);
    const finalCount = Math.max(20, Math.min(count, 50));
    for (let i = 0; i < finalCount; i++) {
      this.particles.push(this.generateParticle());
    }
  }

  draw() {
    if (!this.width || !this.height) {
      this.resize();
      if (!this.width || !this.height) return;
    }

    this.ctx.clearRect(0, 0, this.width, this.height);

    for (let i = 0; i < this.particles.length; i++) {
      for (let j = i + 1; j < this.particles.length; j++) {
        const p1 = this.particles[i];
        const p2 = this.particles[j];
        const dx = p1.x - p2.x;
        const dy = p1.y - p2.y;
        const dist = Math.sqrt(dx * dx + dy * dy);

        if (dist < this.maxDistance) {
          const lineAlpha = (1 - dist / this.maxDistance) * 0.35;
          this.ctx.beginPath();
          this.ctx.moveTo(p1.x, p1.y);
          this.ctx.lineTo(p2.x, p2.y);
          this.ctx.strokeStyle = `rgba(255, 255, 255, ${lineAlpha})`;
          this.ctx.lineWidth = 0.85;
          this.ctx.stroke();
        }
      }
    }

    this.particles.forEach(p => {
      this.ctx.beginPath();
      this.ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
      this.ctx.fillStyle = `rgba(255, 255, 255, ${p.alpha})`;
      this.ctx.fill();

      p.x += p.vx;
      p.y += p.vy;

      if (p.x < 0 || p.x > this.width) p.vx *= -1;
      if (p.y < 0 || p.y > this.height) p.vy *= -1;
    });
  }

  animate = () => {
    this.draw();
    requestAnimationFrame(this.animate);
  };
}

/* ==========================================================================
   2. Top Header Dropdown Menu with Logout Confirmation
   ========================================================================== */
function setupHeaderDropdown() {
  const menuBtn = document.getElementById('header-menu-btn');
  const dropdown = document.getElementById('header-dropdown');
  const logoutBtn = document.getElementById('dropdown-btn-logout');

  if (menuBtn && dropdown) {
    menuBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      dropdown.classList.toggle('show');
    });

    document.addEventListener('click', () => {
      dropdown.classList.remove('show');
    });

    dropdown.addEventListener('click', (e) => {
      e.stopPropagation();
    });
  }

  if (logoutBtn) {
    logoutBtn.addEventListener('click', () => {
      if (dropdown) dropdown.classList.remove('show');

      openConfirmationDialog(
        'تسجيل الخروج',
        'هل أنت تأكد من تسجيل الخروج من منظومة الأدمن؟',
        () => {
          triggerFullscreenFlipTransition('login-view');
        }
      );
    });
  }
}

/* ==========================================================================
   3. Navigation & Screen Transitions
   ========================================================================== */
function setupNavigation() {
  const btnLogin = document.getElementById('btn-login');
  const btnSelectCreate = document.getElementById('btn-select-create');
  const btnSelectPast = document.getElementById('btn-select-past');
  const btnBackCreate = document.getElementById('btn-back-from-create');
  const btnBackPast = document.getElementById('btn-back-from-past');

  if (btnBackCreate) btnBackCreate.addEventListener('click', () => CyberQR.stop());

  if (btnLogin) {
    btnLogin.addEventListener('click', async () => {
      const userInput = document.getElementById('admin-name');
      const passInput = document.getElementById('admin-password');
      try {
        const res = await fetch('/api/auth/login', {
          method: 'POST',
          credentials: 'include',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            username: userInput ? userInput.value.trim() : '',
            password: passInput ? passInput.value : ''
          })
        });
        if (!res.ok) {
          showTemporaryOptionNotice('فشل تسجيل الدخول ⚠️', 'اسم المستخدم أو كلمة المرور غير صحيحة.');
          return;
        }
        if (passInput) passInput.value = '';
        triggerFullscreenFlipTransition('dashboard-view');
      } catch (err) {
        showTemporaryOptionNotice('خطأ بالاتصال ⚠️', 'تعذر الوصول للسيرفر.');
      }
    });
  }

  if (btnSelectCreate) {
    btnSelectCreate.addEventListener('click', () => {
      resetCreateFormDate();
      triggerFullscreenFlipTransition('create-lecture-view');
    });
  }

  if (btnSelectPast) {
    btnSelectPast.addEventListener('click', () => {
      renderPastLecturesGrid();
      triggerFullscreenFlipTransition('past-lectures-view');
    });
  }

  if (btnBackCreate) {
    btnBackCreate.addEventListener('click', () => {
      triggerFullscreenFlipTransition('dashboard-view');
    });
  }

  if (btnBackPast) {
    btnBackPast.addEventListener('click', () => {
      triggerFullscreenFlipTransition('dashboard-view');
    });
  }
}

function triggerFullscreenFlipTransition(targetViewId) {
  const overlay = document.getElementById('transition-overlay');
  const flipCard = document.getElementById('transition-flip-card');

  if (!overlay || !flipCard) {
    switchViewDirectly(targetViewId);
    return;
  }

  flipCard.classList.remove('flipped');
  overlay.classList.add('active');

  setTimeout(() => {
    flipCard.classList.add('flipped');
  }, 100);

  setTimeout(() => {
    switchViewDirectly(targetViewId);
  }, 480);

  setTimeout(() => {
    overlay.classList.remove('active');
    setTimeout(() => {
      flipCard.classList.remove('flipped');
    }, 300);
  }, 950);
}

function switchViewDirectly(targetViewId) {
  const views = document.querySelectorAll('.view-section');
  views.forEach(view => {
    view.classList.remove('active-view');
  });

  const targetView = document.getElementById(targetViewId);
  if (targetView) {
    targetView.classList.add('active-view');

    // Scroll to top of page smoothly so title bar & buttons are 100% visible
    window.scrollTo({ top: 0, behavior: 'smooth' });

    setTimeout(() => {
      initParticleNetworks();
      window.dispatchEvent(new Event('resize'));
    }, 100);

    if (window.lucide) {
      lucide.createIcons();
    }
  }
}

/* ==========================================================================
   4. Guest Section Validation (Prevents A -> A selection)
   ========================================================================== */
function setupGuestSectionValidation() {
  const fromSelect = document.getElementById('guest-from-section');
  const toSelect = document.getElementById('guest-to-section');

  if (fromSelect && toSelect) {
    fromSelect.addEventListener('change', () => {
      if (fromSelect.value === toSelect.value) {
        // Auto-switch 'to' select to a different section
        const options = ['A', 'B', 'C'];
        const alternative = options.find(opt => opt !== fromSelect.value) || 'B';
        toSelect.value = alternative;
      }
    });

    toSelect.addEventListener('change', () => {
      if (toSelect.value === fromSelect.value) {
        // Auto-switch 'from' select to a different section
        const options = ['A', 'B', 'C'];
        const alternative = options.find(opt => opt !== toSelect.value) || 'A';
        fromSelect.value = alternative;
      }
    });
  }
}

/* ==========================================================================
   5. Create Lecture & Guest Students Engine
   ========================================================================== */
function resetCreateFormDate() {
  const dateInput = document.getElementById('lecture-datetime');
  if (dateInput) {
    const now = new Date();
    const formatted = now.toLocaleDateString('ar-EG', {
      weekday: 'long',
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    }) + ' - ' + now.toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' });
    dateInput.value = formatted;
  }
}

function setupCreateLectureEngine() {
  const scanBtn = document.getElementById('btn-scan-qr');
  const addGuestBtn = document.getElementById('btn-add-guest-student');
  const counterEl = document.getElementById('live-attendees-counter');
  const toggleListBtn = document.getElementById('btn-toggle-attendees');
  const closeModalBtn = document.getElementById('btn-close-attendees-modal');
  const attendeesModal = document.getElementById('attendees-modal');
  const confirmBtn = document.getElementById('btn-confirm-create');

  if (addGuestBtn) {
    addGuestBtn.addEventListener('click', () => {
      const guestNameInput = document.getElementById('guest-student-name');
      const fromSecInput = document.getElementById('guest-from-section');
      const toSecInput = document.getElementById('guest-to-section');

      const guestName = guestNameInput ? guestNameInput.value.trim() : '';
      const fromSec = fromSecInput ? fromSecInput.value : 'A';
      const toSec = toSecInput ? toSecInput.value : 'B';

      if (!guestName) {
        showTemporaryOptionNotice('يرجى إدخال الاسم ⚠️', 'يرجى كتابة اسم طالب الاستضافة أولاً قبل الإضافة.');
        return;
      }

      if (fromSec === toSec) {
        showTemporaryOptionNotice('غير منطقي! ⚠️', 'لا يمكن الاستضافة من وإلى نفس الشعبة! يرجى اختيار شعبتين مختلفين.');
        return;
      }

      const guestObj = {
        id: 'GST-' + (200 + currentSessionAttendees.length + 1),
        name: guestName,
        section: toSec,
        isGuest: true,
        fromSection: fromSec,
        toSection: toSec,
        timestamp: new Date().toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' })
      };

      currentSessionAttendees.push(guestObj);
      addedGuestStudents.push(guestObj);

      if (guestNameInput) guestNameInput.value = '';
      if (counterEl) counterEl.textContent = currentSessionAttendees.length;

      renderAddedGuestBadges();
      showTemporaryOptionNotice('تم إضافة طالب الاستضافة! ✨', `تم إرفاق الطالب ${guestName} (من شعبة ${fromSec} إلى شعبة ${toSec}) بالحضور.`);
    });
  }

  if (scanBtn) {
    const scanLabel = scanBtn.querySelector('span') || scanBtn;
    const scanLabelIdle = scanLabel.textContent;
    const viewfinder = document.querySelector('.scanner-viewfinder');

    document.addEventListener('cyberqr:started', () => {
      scanLabel.textContent = 'إيقاف الكاميرا';
      if (viewfinder) viewfinder.classList.add('cam-on');
    });
    document.addEventListener('cyberqr:stopped', () => {
      scanLabel.textContent = scanLabelIdle;
      if (viewfinder) viewfinder.classList.remove('cam-on');
    });

    const handleQrScan = async (text) => {
      const selectedSectionRadio = document.querySelector('input[name="lecture-section"]:checked');
      const lectureSection = selectedSectionRadio ? selectedSectionRadio.value : 'A';
      const doctorInput = document.getElementById('lecture-doctor');

      try {
        const res = await fetch('/api/attendance/scan', {
          method: 'POST',
          credentials: 'include',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            token: text,
            lecture_section: lectureSection,
            doctor: doctorInput ? doctorInput.value : ''
          })
        });
        const data = await res.json();

        if (!res.ok) {
          showTemporaryOptionNotice('تنبيه ⚠️', data.error || 'فشل تسجيل الحضور');
          return;
        }

        currentSessionAttendees.push({
          id: text,
          name: data.name,
          section: data.section,
          isGuest: data.is_guest,
          fromSection: data.section,
          toSection: lectureSection,
          timestamp: data.time
        });

        if (counterEl) counterEl.textContent = currentSessionAttendees.length;
        showTemporaryOptionNotice('تم تسجيل الطالب! ✅', data.name + ' • ' + data.day + ' ' + data.date);
      } catch (err) {
        showTemporaryOptionNotice('خطأ بالاتصال ⚠️', 'تعذر الوصول للسيرفر.');
      }
    };

    scanBtn.addEventListener('click', async () => {
      if (CyberQR.isRunning()) { await CyberQR.stop(); return; }
      await CyberQR.start({
        containerId: 'qr-reader',
        onScan: handleQrScan,
        onError: (err) => showTemporaryOptionNotice('تعذر تشغيل الكاميرا ⚠️', String(err.name || err.message || err))
      });
    });
  }

  if (toggleListBtn && attendeesModal) {
    toggleListBtn.addEventListener('click', () => {
      renderCurrentSessionAttendeesList();
      attendeesModal.classList.add('open');
    });
  }

  if (closeModalBtn && attendeesModal) {
    closeModalBtn.addEventListener('click', () => {
      attendeesModal.classList.remove('open');
    });
  }

  if (confirmBtn) {
    confirmBtn.addEventListener('click', () => {
      CyberQR.stop();
      const rawSubject = document.getElementById('lecture-subject').value.trim();
      const rawDoctor = document.getElementById('lecture-doctor').value.trim();
      
      const subject = rawSubject || "الأمن السيبراني";
      const doctor = rawDoctor || "د. المحاضر";

      const selectedSectionRadio = document.querySelector('input[name="lecture-section"]:checked');
      const section = selectedSectionRadio ? selectedSectionRadio.value : 'A';
      const dateTime = document.getElementById('lecture-datetime').value || new Date().toLocaleString('ar-EG');

      if (currentSessionAttendees.length === 0) {
        currentSessionAttendees.push({
          id: 'STU-101',
          name: 'علي شرهان عطية',
          section: section,
          isGuest: false,
          timestamp: 'الآن'
        });
      }

      const newLecture = {
        id: 'LEC-' + Date.now(),
        subject: subject,
        section: section,
        dateTime: dateTime,
        doctor: doctor,
        attendeesCount: currentSessionAttendees.length,
        students: [...currentSessionAttendees]
      };

      saveLectureToLocalStorage(newLecture);

      currentSessionAttendees = [];
      addedGuestStudents = [];
      renderAddedGuestBadges();
      if (counterEl) counterEl.textContent = '0';

      showTemporaryOptionNotice('تم حفظ المحاضرة! 🎉', `تم إنشاء محاضرة ${subject} (شعبة ${section}) بنجاح وإضافتها للسجلات.`);

      renderPastLecturesGrid();
      triggerFullscreenFlipTransition('past-lectures-view');
    });
  }
}

function renderAddedGuestBadges() {
  const container = document.getElementById('added-guest-students-list');
  if (!container) return;

  container.innerHTML = addedGuestStudents.map((g, index) => `
    <span class="added-guest-pill">
      ${g.name} (من ${g.fromSection} إلى ${g.toSection})
      <button type="button" class="remove-guest-btn" onclick="removeGuestStudentByIndex(${index})">✕</button>
    </span>
  `).join('');
}

window.removeGuestStudentByIndex = function(index) {
  const removedObj = addedGuestStudents[index];
  if (removedObj) {
    currentSessionAttendees = currentSessionAttendees.filter(s => s !== removedObj);
    addedGuestStudents.splice(index, 1);
    
    const counterEl = document.getElementById('live-attendees-counter');
    if (counterEl) counterEl.textContent = currentSessionAttendees.length;
    
    renderAddedGuestBadges();
  }
};

function renderCurrentSessionAttendeesList() {
  const container = document.getElementById('attendees-list-container');
  if (!container) return;

  if (currentSessionAttendees.length === 0) {
    container.innerHTML = `<div style="text-align:center; color:rgba(255,255,255,0.7); padding:20px;">لم يتم تسجيل أي طلاب حتى الآن</div>`;
    return;
  }

  container.innerHTML = currentSessionAttendees.map((stu, index) => `
    <div class="attendee-row ${stu.isGuest ? 'guest-student-row' : ''}">
      <div>
        <div class="attendee-name">${index + 1}. ${escapeHtml(stu.name)}</div>
        <div style="font-size:0.78rem; opacity:0.8;">الرقم: ${escapeHtml(stu.id)} • الوقت: ${stu.timestamp}</div>
      </div>
      ${stu.isGuest ? 
        `<span class="guest-tag-badge">استضافة (من ${stu.fromSection} إلى ${stu.toSection})</span>` : 
        `<span class="attendee-sec-badge">شعبة ${stu.section}</span>`
      }
    </div>
  `).join('');
}

/* ==========================================================================
   6. LocalStorage & Past Lectures Square Cards Renderer
   ========================================================================== */
function saveLectureToLocalStorage(lecture) {
  const existing = getStoredLectures();
  existing.unshift(lecture);
  localStorage.setItem('cyber_lectures', JSON.stringify(existing));
}

function getStoredLectures() {
  const raw = localStorage.getItem('cyber_lectures');
  if (raw) {
    try {
      return JSON.parse(raw);
    } catch (e) {
      console.error('Error parsing stored lectures:', e);
    }
  }
  return [];
}

function deleteLectureById(id) {
  let lectures = getStoredLectures();
  lectures = lectures.filter(l => l.id !== id);
  localStorage.setItem('cyber_lectures', JSON.stringify(lectures));
}

function initPastLectures() {
  const stored = getStoredLectures();
  if (stored.length === 0) {
    const seedData = [
      {
        id: 'LEC-SEED-1',
        subject: 'الأمن السيبراني والشبكات',
        section: 'A',
        dateTime: 'الإثنين، 28 سبتمبر 2026 - 10:00 ص',
        doctor: 'د. علي شرهان',
        attendeesCount: 25,
        students: [
          { id: 'STU-101', name: 'علي شرهان عطية', section: 'A', isGuest: false, timestamp: '10:02 ص' },
          { id: 'STU-102', name: 'أحمد حسين جاسم', section: 'A', isGuest: false, timestamp: '10:05 ص' },
          { id: 'GST-201', name: 'حسين علي رضا', section: 'A', isGuest: true, fromSection: 'B', toSection: 'A', timestamp: '10:12 ص' }
        ]
      },
      {
        id: 'LEC-SEED-2',
        subject: 'هندسة البرمجيات',
        section: 'B',
        dateTime: 'الأحد، 27 سبتمبر 2026 - 01:30 م',
        doctor: 'د. المحاضر',
        attendeesCount: 18,
        students: [
          { id: 'STU-104', name: 'زينب حسن الفتلاوي', section: 'B', isGuest: false, timestamp: '01:32 م' },
          { id: 'STU-105', name: 'عمر فاروق البغدادي', section: 'B', isGuest: false, timestamp: '01:35 م' }
        ]
      }
    ];
    localStorage.setItem('cyber_lectures', JSON.stringify(seedData));
  }

  setupDetailModal();
}

function renderPastLecturesGrid() {
  const grid = document.getElementById('past-lectures-grid');
  if (!grid) return;

  const lectures = getStoredLectures();

  if (lectures.length === 0) {
    grid.innerHTML = `<div style="grid-column: 1/-1; text-align:center; padding:40px; color:rgba(255,255,255,0.8);">لا توجد محاضرات مسجلة حتى الآن</div>`;
    return;
  }

  grid.innerHTML = lectures.map(lec => `
    <div class="square-lecture-card" onclick="openLectureDetailModal('${lec.id}')">
      <div class="square-card-top">
        <span class="square-section-badge">شعبة ${lec.section}</span>
        <span class="square-attendees-badge">${lec.attendeesCount} طالب</span>
      </div>
      <div class="square-card-body">
        <h4 class="square-subject-title">${lec.subject}</h4>
        <div class="square-date-text">
          <i data-lucide="clock" style="width:14px; height:14px;"></i>
          ${lec.dateTime}
        </div>
      </div>
    </div>
  `).join('');

  if (window.lucide) {
    lucide.createIcons();
  }
}

function setupDetailModal() {
  const closeBtn = document.getElementById('btn-close-detail-modal');
  const modal = document.getElementById('lecture-detail-modal');
  const excelBtn = document.getElementById('btn-export-excel');
  const deleteBtn = document.getElementById('btn-delete-lecture');
  const searchInput = document.getElementById('student-search-input');

  if (closeBtn && modal) {
    closeBtn.addEventListener('click', () => {
      modal.classList.remove('open');
    });
  }

  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      const query = e.target.value.toLowerCase().trim();
      renderFilteredDetailStudents(query);
    });
  }

  if (excelBtn) {
    excelBtn.addEventListener('click', () => {
      const sec = activeDetailLectureObj && activeDetailLectureObj.section
        ? '?section=' + encodeURIComponent(activeDetailLectureObj.section)
        : '';
      window.location.href = '/api/attendance/export' + sec;
    });
  }

  if (deleteBtn) {
    deleteBtn.addEventListener('click', () => {
      if (!activeDetailLectureObj) return;

      openConfirmationDialog(
        'حذف المحاضرة',
        'هل أنت تأكد من حذف هذه المحاضرة نهائياً من سجل المحاضرات السابقة؟',
        () => {
          deleteLectureById(activeDetailLectureObj.id);
          renderPastLecturesGrid();
          if (modal) modal.classList.remove('open');
          showTemporaryOptionNotice('تم حذف المحاضرة! 🗑️', 'تمت إزالة المحاضرة وسجل حضورها بنجاح من السجلات.');
        }
      );
    });
  }
}

window.openLectureDetailModal = function(lectureId) {
  const lectures = getStoredLectures();
  const lec = lectures.find(l => l.id === lectureId);

  if (!lec) return;

  activeDetailLectureObj = lec;

  const modal = document.getElementById('lecture-detail-modal');
  document.getElementById('modal-lecture-title').textContent = `محاضرة: ${lec.subject}`;
  document.getElementById('modal-lecture-subject').textContent = lec.subject;
  document.getElementById('modal-lecture-section').textContent = `شعبة ${lec.section}`;
  document.getElementById('modal-lecture-date').textContent = lec.dateTime;
  document.getElementById('modal-lecture-doctor').textContent = lec.doctor;
  document.getElementById('modal-lecture-count').textContent = `${lec.attendeesCount} طالب`;

  const searchInput = document.getElementById('student-search-input');
  if (searchInput) searchInput.value = '';

  renderFilteredDetailStudents('');

  if (modal) {
    modal.classList.add('open');
  }
};

function renderFilteredDetailStudents(query) {
  const studentsContainer = document.getElementById('modal-lecture-students');
  if (!studentsContainer || !activeDetailLectureObj) return;

  const filtered = activeDetailLectureObj.students.filter(stu => {
    if (!query) return true;
    const nameMatch = stu.name.toLowerCase().includes(query);
    const idMatch = stu.id.toLowerCase().includes(query);
    const secMatch = (stu.section || '').toLowerCase().includes(query) || (stu.fromSection || '').toLowerCase().includes(query);
    const guestMatch = stu.isGuest && 'استضافة'.includes(query);
    return nameMatch || idMatch || secMatch || guestMatch;
  });

  if (filtered.length === 0) {
    studentsContainer.innerHTML = `<div style="text-align:center; padding:20px; color:rgba(255,255,255,0.7);">لا توجد نتائج تطابق البحث: "${escapeHtml(query)}"</div>`;
    return;
  }

  studentsContainer.innerHTML = filtered.map((stu, i) => `
    <div class="attendee-row ${stu.isGuest ? 'guest-student-row' : ''}">
      <div>
        <div class="attendee-name">${i + 1}. ${escapeHtml(stu.name)}</div>
        <div style="font-size:0.78rem; opacity:0.8;">الرقم: ${escapeHtml(stu.id)} • الوقت: ${stu.timestamp}</div>
      </div>
      ${stu.isGuest ? 
        `<span class="guest-tag-badge">استضافة (من ${stu.fromSection} إلى ${stu.toSection})</span>` : 
        `<span class="attendee-sec-badge">شعبة ${stu.section || activeDetailLectureObj.section}</span>`
      }
    </div>
  `).join('');
}

/* ==========================================================================
   6. Custom Confirmation Modal System
   ========================================================================== */
function setupConfirmModalSystem() {
  const modal = document.getElementById('confirm-dialog-modal');
  const closeBtn = document.getElementById('btn-close-confirm-modal');
  const acceptBtn = document.getElementById('btn-confirm-accept');
  const cancelBtn = document.getElementById('btn-confirm-cancel');

  if (closeBtn && modal) {
    closeBtn.addEventListener('click', () => {
      modal.classList.remove('open');
    });
  }

  if (cancelBtn && modal) {
    cancelBtn.addEventListener('click', () => {
      modal.classList.remove('open');
    });
  }

  if (acceptBtn && modal) {
    acceptBtn.addEventListener('click', () => {
      modal.classList.remove('open');
      if (typeof pendingConfirmCallback === 'function') {
        pendingConfirmCallback();
        pendingConfirmCallback = null;
      }
    });
  }
}

function openConfirmationDialog(title, message, onConfirmCallback) {
  const modal = document.getElementById('confirm-dialog-modal');
  const titleEl = document.getElementById('confirm-modal-title');
  const msgEl = document.getElementById('confirm-modal-message');

  if (titleEl) titleEl.textContent = title;
  if (msgEl) msgEl.textContent = message;

  pendingConfirmCallback = onConfirmCallback;

  if (modal) {
    modal.classList.add('open');
  }
}

/* ==========================================================================
   7. Helper Toast Notice
   ========================================================================== */
function showTemporaryOptionNotice(title, message) {
  const existingToast = document.querySelector('.cyber-toast');
  if (existingToast) existingToast.remove();

  const toast = document.createElement('div');
  toast.className = 'cyber-toast';
  toast.innerHTML = `
    <div class="toast-content">
      <div class="toast-title">${title}</div>
      <div class="toast-msg">${message}</div>
    </div>
    <button class="toast-close" onclick="this.parentElement.remove()">✕</button>
  `;

  document.body.appendChild(toast);

  if (!document.getElementById('toast-styles')) {
    const style = document.createElement('style');
    style.id = 'toast-styles';
    style.textContent = `
      .cyber-toast {
        position: fixed;
        bottom: 24px;
        left: 50%;
        transform: translateX(-50%);
        background: linear-gradient(135deg, #0012b3, #000c80);
        border: 1.5px solid rgba(0, 229, 255, 0.6);
        color: #ffffff;
        padding: 16px 24px;
        border-radius: 16px;
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5), 0 0 20px rgba(0, 229, 255, 0.3);
        display: flex;
        align-items: center;
        gap: 16px;
        z-index: 10000;
        max-width: 90%;
        width: 440px;
        animation: toastSlideUp 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
        font-family: var(--font-arabic);
      }
      @keyframes toastSlideUp {
        from { opacity: 0; transform: translate(-50%, 30px); }
        to { opacity: 1; transform: translate(-50%, 0); }
      }
      .toast-title { font-weight: 800; font-size: 1rem; color: #00e5ff; margin-bottom: 4px; }
      .toast-msg { font-size: 0.88rem; color: rgba(255, 255, 255, 0.9); line-height: 1.4; }
      .toast-close { background: none; border: none; color: #fff; font-size: 1.1rem; cursor: pointer; opacity: 0.7; }
      .toast-close:hover { opacity: 1; }
    `;
    document.head.appendChild(style);
  }

  setTimeout(() => {
    if (toast.parentElement) {
      toast.style.opacity = '0';
      toast.style.transition = 'opacity 0.3s ease';
      setTimeout(() => toast.remove(), 300);
    }
  }, 4500);
}


/* XSS-safe escaping for values coming from QR codes */
function escapeHtml(v) {
  return String(v == null ? '' : v).replace(/[&<>"']/g, ch => (
    { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch]
  ));
}