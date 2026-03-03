-- queries_assignment.sql
USE pelajarin_lms;

-- =========================================================
-- i) SQL FUNDAMENTALS
-- =========================================================

-- 1) Tampilkan seluruh data course
SELECT * FROM courses;

-- 2) Tampilkan nama course dan harga saja
SELECT title, price FROM courses;

-- 3) Tampilkan course dengan durasi antara 2 sampai 4 jam
SELECT *
FROM courses
WHERE duration_hours BETWEEN 2 AND 4;

-- 4) Tampilkan course yang modulnya >= 6 ATAU level intermediate
SELECT *
FROM courses
WHERE modules_count >= 6 OR level = 'intermediate';

-- 5) Tampilkan 5 course dengan modul terbanyak
SELECT *
FROM courses
ORDER BY modules_count DESC, id DESC
LIMIT 5;


-- =========================================================
-- ii) AGGREGATE & CONDITIONAL LOGIC
-- =========================================================

-- 1) Hitung total user yang terdaftar
SELECT COUNT(*) AS total_users FROM users;

-- 2) Hitung total course yang published
SELECT COUNT(*) AS total_courses_published
FROM courses
WHERE is_published = 1;

-- 3) Hitung jumlah course per kategori
SELECT cc.name AS category_name, COUNT(c.id) AS total_courses
FROM course_categories cc
LEFT JOIN courses c ON c.category_id = cc.id
GROUP BY cc.id, cc.name
ORDER BY total_courses DESC, category_name ASC;

-- 4) Hitung rata-rata durasi course per kategori
SELECT cc.name AS category_name, AVG(c.duration_hours) AS avg_duration_hours
FROM course_categories cc
LEFT JOIN courses c ON c.category_id = cc.id
GROUP BY cc.id, cc.name
ORDER BY avg_duration_hours DESC;

-- 5) Kategori yang memiliki minimal 1 course
SELECT cc.name AS category_name, COUNT(c.id) AS total_courses
FROM course_categories cc
LEFT JOIN courses c ON c.category_id = cc.id
GROUP BY cc.id, cc.name
HAVING COUNT(c.id) >= 1
ORDER BY total_courses DESC;

-- Conditional Logic: label harga
SELECT
  id,
  title,
  price,
  CASE WHEN price = 0 THEN 'Free' ELSE 'Paid' END AS price_label
FROM courses
ORDER BY id;


-- =========================================================
-- iii) JOIN STATEMENTS
-- =========================================================

-- 1) Daftar course beserta nama kategorinya
SELECT c.id, c.title, cc.name AS category_name, c.level, c.modules_count, c.duration_hours
FROM courses c
JOIN course_categories cc ON cc.id = c.category_id
ORDER BY c.id;

-- 2) Semua kategori meskipun belum memiliki course
SELECT cc.id, cc.name, c.id AS course_id, c.title
FROM course_categories cc
LEFT JOIN courses c ON c.category_id = cc.id
ORDER BY cc.id, c.id;

-- 3) Semua user meskipun belum pernah mengupload course
SELECT u.id, u.full_name, u.role, c.id AS course_id, c.title
FROM users u
LEFT JOIN courses c ON c.instructor_id = u.id
ORDER BY u.id, c.id;

-- 4) Daftar course beserta nama instructor yang membuat course tersebut
SELECT c.id, c.title, u.full_name AS instructor_name, c.level
FROM courses c
JOIN users u ON u.id = c.instructor_id
ORDER BY c.id;

-- 5) Tampilkan daftar course beserta silabusnya (sesuai UI detail page)
SELECT c.title, s.module_order, s.module_title
FROM courses c
JOIN course_syllabus s ON s.course_id = c.id
WHERE c.id = 1
ORDER BY s.module_order;


-- =========================================================
-- iv) OPTIMIZATION (Index + EXPLAIN) - safe rerun
-- =========================================================

SET @db := DATABASE();

-- drop idx_category jika sudah ada
SET @sql := (
  SELECT IF(
    EXISTS(
      SELECT 1
      FROM information_schema.statistics
      WHERE table_schema = @db
        AND table_name = 'courses'
        AND index_name = 'idx_category'
    ),
    'DROP INDEX idx_category ON courses;',
    'SELECT ''idx_category not exists'';'
  )
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- drop idx_instructor jika sudah ada
SET @sql := (
  SELECT IF(
    EXISTS(
      SELECT 1
      FROM information_schema.statistics
      WHERE table_schema = @db
        AND table_name = 'courses'
        AND index_name = 'idx_instructor'
    ),
    'DROP INDEX idx_instructor ON courses;',
    'SELECT ''idx_instructor not exists'';'
  )
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- create index
CREATE INDEX idx_category ON courses(category_id);
CREATE INDEX idx_instructor ON courses(instructor_id);

-- EXPLAIN contoh query join + filter
EXPLAIN
SELECT c.title, cc.name AS category_name
FROM courses c
JOIN course_categories cc ON cc.id = c.category_id
WHERE c.level = 'beginner';