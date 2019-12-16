CREATE TABLE IF NOT EXISTS supplicants (
  supplicant_id SERIAL,
  NAME VARCHAR,
  address VARCHAR,
  telephone_number VARCHAR,
  email VARCHAR,
  PRIMARY KEY (supplicant_id)
) WITHOUT OIDS;
 
CREATE TABLE IF NOT EXISTS cases (
  case_id SERIAL,
  category VARCHAR,
  description TEXT,
  supplicant_id int8,
  case_status VARCHAR NOT NULL,
  operator_id int8,
  industry_affiliation VARCHAR,
  source_of_knowledge_jc VARCHAR,
  application_date_time TIMESTAMP,
  meeting_date_time TIMESTAMP,
  done bool NOT NULL,
  PRIMARY KEY (case_id)
) WITHOUT OIDS;
 
ALTER TABLE cases ADD CONSTRAINT cases_supplicant_id_foreign FOREIGN KEY (supplicant_id) REFERENCES supplicants (supplicant_id) ;
 
CREATE TABLE IF NOT EXISTS documents (
  document_id SERIAL,
  title TEXT,
  case_id int8 NOT NULL,
  TYPE VARCHAR,
  data_id int8,
  PRIMARY KEY (document_id)
) WITHOUT OIDS;
 
ALTER TABLE documents ADD CONSTRAINT documents_case_id_foreign FOREIGN KEY (case_id) REFERENCES cases (case_id) ;
 
CREATE TABLE IF NOT EXISTS site_users (
  user_id SERIAL,
  NAME VARCHAR,
  ROLE int8,
  st_login VARCHAR NOT NULL,
  personal_data TEXT,
  password_hash VARCHAR,
  cookie TEXT,
  PRIMARY KEY (user_id),
  UNIQUE(st_login, cookie)
) WITHOUT OIDS;
 
CREATE TABLE IF NOT EXISTS applications (
  application_id SERIAL,
  title VARCHAR,
  case_id int8 NOT NULL,
  description TEXT,
  addressee_user_id int8 NOT NULL,
  STATUS VARCHAR NOT NULL,
  date_time TIMESTAMP,
  PRIMARY KEY (application_id)
) WITHOUT OIDS;
 
ALTER TABLE applications ADD CONSTRAINT applications_addressee_user_id_foreign FOREIGN KEY (addressee_user_id) REFERENCES site_users (user_id) ;
ALTER TABLE applications ADD CONSTRAINT applications_case_id_foreign FOREIGN KEY (case_id) REFERENCES cases (case_id) ;
 
CREATE TABLE IF NOT EXISTS administration (
  admin_id SERIAL,
  NAME VARCHAR,
  TYPE VARCHAR,
  email VARCHAR,
  user_id int8 NOT NULL,
  PRIMARY KEY (admin_id)
) WITHOUT OIDS;
 
ALTER TABLE administration ADD CONSTRAINT administration_user_id_foreign FOREIGN KEY (user_id) REFERENCES site_users (user_id) ;
 
CREATE TABLE IF NOT EXISTS notifications (
  notification_id SERIAL,
  TEXT TEXT NOT NULL,
  STATUS VARCHAR NOT NULL,
  user_id int8 NOT NULL,
  date_time TIMESTAMP,
  event_data json,
  PRIMARY KEY (notification_id)
) WITHOUT OIDS;
 
ALTER TABLE notifications ADD CONSTRAINT notifications_user_id_foreign FOREIGN KEY (user_id) REFERENCES site_users (user_id) ;
 
CREATE TABLE IF NOT EXISTS teachers (
  teacher_id SERIAL,
  competence VARCHAR,
  user_id int8 NOT NULL,
  PRIMARY KEY (teacher_id)
) WITHOUT OIDS;
 
ALTER TABLE teachers ADD CONSTRAINT teachers_user_id_foreign FOREIGN KEY (user_id) REFERENCES site_users (user_id) ;
 
CREATE TABLE IF NOT EXISTS case_teachers_relations (
  relation_id SERIAL,
  case_id int8 NOT NULL,
  teacher_id int8 NOT NULL,
  ROLE VARCHAR,
  PRIMARY KEY (relation_id)
) WITHOUT OIDS;
 
ALTER TABLE case_teachers_relations ADD CONSTRAINT case_teachers_relations_case_id_foreign FOREIGN KEY (case_id) REFERENCES cases (case_id) ;
ALTER TABLE case_teachers_relations ADD CONSTRAINT case_teachers_relations_teacher_id_foreign FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id) ;
 
CREATE TABLE IF NOT EXISTS students (
  student_id SERIAL,
  teacher_id int8,
  functional_group VARCHAR,
  points DECIMAL DEFAULT 0.0,
  user_id int8 NOT NULL,
  subgroup_name VARCHAR,
  PRIMARY KEY (student_id)
) WITHOUT OIDS;
 
CREATE TABLE IF NOT EXISTS students_subgroup (
  NAME VARCHAR NOT NULL,
  admin_id int8 NOT NULL,
  PRIMARY KEY (NAME)
) WITHOUT OIDS;
 
ALTER TABLE students ADD CONSTRAINT students_user_id_foreign FOREIGN KEY (user_id) REFERENCES site_users (user_id) ;
ALTER TABLE students ADD CONSTRAINT students_teacher_id_foreign FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id) ;
ALTER TABLE students ADD CONSTRAINT students_subgroup_name_foreign FOREIGN KEY (subgroup_name) REFERENCES students_subgroup (NAME) ;
 
ALTER TABLE students_subgroup ADD CONSTRAINT students_subgroup_admin_id_foreign FOREIGN KEY (admin_id) REFERENCES students (student_id) ;
 
CREATE TABLE IF NOT EXISTS case_student_relations (
  relation_id SERIAL,
  case_id int8 NOT NULL,
  student_id int8 NOT NULL,
  ROLE VARCHAR,
  PRIMARY KEY (relation_id)
) WITHOUT OIDS;
 
ALTER TABLE case_student_relations ADD CONSTRAINT case_student_relations_case_id_foreign FOREIGN KEY (case_id) REFERENCES cases (case_id) ;
ALTER TABLE case_student_relations ADD CONSTRAINT case_student_relations_student_id_foreign FOREIGN KEY (student_id) REFERENCES students (student_id) ;
 
CREATE TABLE IF NOT EXISTS rejected_requests (
  request_id SERIAL,
  reason TEXT,
  operator_id int8,
  supplicant_name VARCHAR,
  request_text TEXT,
  date_time TIMESTAMP,
  PRIMARY KEY (request_id)
) WITHOUT OIDS;
 
ALTER TABLE rejected_requests ADD CONSTRAINT rejected_requests_operator_id_foreign FOREIGN KEY (operator_id) REFERENCES students (student_id) ;
 
CREATE TABLE IF NOT EXISTS points_feed (
  event_id SERIAL,
  student_id int8 NOT NULL,
  teacher_id int8 NOT NULL,
  points DECIMAL NOT NULL,
  reason TEXT,
  date_time TIMESTAMP,
  PRIMARY KEY (event_id)
) WITHOUT OIDS;
 
ALTER TABLE points_feed ADD CONSTRAINT points_feed_student_id_foreign FOREIGN KEY (student_id) REFERENCES students (student_id) ;
ALTER TABLE points_feed ADD CONSTRAINT points_feed_teacher_id_foreign FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id) ;
 
CREATE TABLE IF NOT EXISTS cases_feed (
  event_id SERIAL,
  case_id int8 NOT NULL,
  case_status VARCHAR NOT NULL,
  date_time TIMESTAMP,
  event_data json,
  done bool NOT NULL,
  PRIMARY KEY (event_id)
) WITHOUT OIDS;
 
ALTER TABLE cases_feed ADD CONSTRAINT cases_feed_case_id_foreign FOREIGN KEY (case_id) REFERENCES cases (case_id) ;
 
CREATE TABLE IF NOT EXISTS duty_roster (
  duty_id SERIAL,
  student_id int8 NOT NULL,
  class_room VARCHAR,
  start_date_time TIMESTAMP,
  finish_date_time TIMESTAMP,
  PRIMARY KEY (duty_id)
) WITHOUT OIDS;
 
ALTER TABLE duty_roster ADD CONSTRAINT duty_roster_student_id_foreign FOREIGN KEY (student_id) REFERENCES students (student_id) ;