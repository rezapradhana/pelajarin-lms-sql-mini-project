-- seed_ui_exact.sql
USE pelajarin_lms;

-- aman kalau di-run berulang
INSERT IGNORE INTO users (full_name, email, role)
VALUES ('Pelajarin Instructor', 'instructor@pelajarin.local', 'instructor');

INSERT IGNORE INTO course_categories (name)
VALUES ('Web Dev'), ('JavaScript'), ('Responsive');

-- Insert courses (pakai INSERT IGNORE supaya aman kalau run ulang)
INSERT IGNORE INTO courses
(id, category_id, instructor_id, title, short_description,
 audience_note, full_description,
 level, modules_count, duration_hours,
 is_certificate, is_project_based,
 outcome, prerequisite, price, is_published)
VALUES
(1, 1, 1, 'Web Development Dasar',
 'Belajar HTML, CSS, dan JavaScript dari nol.',
 'Cocok untuk pemula yang mau mulai dari nol.',
 'Belajar HTML, CSS, dan JavaScript dasar untuk membangun landing page sederhana yang rapi dan responsif.',
 'beginner', 6, 3.0,
 1, 1,
 'Mampu bikin landing page modern + responsif.',
 'Tidak ada (mulai dari nol).',
 0, 1),

(2, 2, 1, 'JavaScript Lanjutan',
 'Pahami logika dan konsep JS lebih dalam.',
 NULL,
 NULL,
 'intermediate', 8, 5.0,
 0, 0,
 NULL,
 NULL,
 0, 1),

(3, 3, 1, 'Responsive Design',
 'Buat website yang rapi di semua device.',
 NULL,
 NULL,
 'beginner', 5, 2.0,
 0, 0,
 NULL,
 NULL,
 0, 1);

-- Silabus untuk Web Development Dasar (course_id = 1)
INSERT INTO course_syllabus (course_id, module_order, module_title, module_description)
VALUES
(1, 1, 'Modul 1 — HTML Fundamentals', 'Struktur dokumen, semantic tags, form, dan praktik accessibility basic.'),
(1, 2, 'Modul 2 — CSS Layout (Flex/Grid)', 'Flexbox, Grid, spacing/sizing, dan strategi responsive.'),
(1, 3, 'Modul 3 — Komponen UI + Reusable Card', 'Button variants, card layout, states hover/focus/active, dan transition.'),
(1, 4, 'Modul 4–6 — Mini Project Landing Page', 'Implementasi layout, konsistensi visual, dan final touch (responsive + aksesibilitas).')
ON DUPLICATE KEY UPDATE
  module_title = VALUES(module_title),
  module_description = VALUES(module_description);