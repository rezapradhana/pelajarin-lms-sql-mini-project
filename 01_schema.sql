-- schema.sql
DROP DATABASE IF EXISTS pelajarin_lms;
CREATE DATABASE pelajarin_lms;
USE pelajarin_lms;

CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  role ENUM('student','instructor') NOT NULL DEFAULT 'student',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE course_categories (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE courses (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category_id BIGINT UNSIGNED NOT NULL,
  instructor_id BIGINT UNSIGNED NOT NULL,

  title VARCHAR(150) NOT NULL,
  short_description VARCHAR(255) NOT NULL,
  audience_note VARCHAR(255) NULL,
  full_description TEXT NULL,

  level ENUM('beginner','intermediate','advanced') NOT NULL,
  modules_count INT UNSIGNED NOT NULL,
  duration_hours DECIMAL(4,1) NOT NULL,

  is_certificate TINYINT(1) NOT NULL DEFAULT 0,
  is_project_based TINYINT(1) NOT NULL DEFAULT 0,

  outcome TEXT NULL,
  prerequisite TEXT NULL,

  price INT UNSIGNED NOT NULL DEFAULT 0,
  is_published TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_courses_category
    FOREIGN KEY (category_id) REFERENCES course_categories(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_courses_instructor
    FOREIGN KEY (instructor_id) REFERENCES users(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT chk_duration_nonneg CHECK (duration_hours >= 0),
  CONSTRAINT chk_modules_nonneg CHECK (modules_count >= 0),
  CONSTRAINT chk_price_nonneg CHECK (price >= 0)
) ENGINE=InnoDB;

CREATE TABLE course_syllabus (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  course_id BIGINT UNSIGNED NOT NULL,
  module_order INT UNSIGNED NOT NULL,
  module_title VARCHAR(150) NOT NULL,
  module_description TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_syllabus_course
    FOREIGN KEY (course_id) REFERENCES courses(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  UNIQUE KEY uq_course_module_order (course_id, module_order)
) ENGINE=InnoDB;