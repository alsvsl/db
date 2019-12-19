-- site_users

INSERT INTO site_users(name, role, st_login, personal_data, password_hash, cookie)
VALUES('Тимошенко Станислав Герасимович ', 1, 'st061424', '-', '43f57e46', 'ghbefrne');

INSERT INTO site_users(name, role, st_login, personal_data, password_hash, cookie)
VALUES('Иванова Полина Дмитриевна', 1, 'st064524', 'студент', '44f44e33', 'lhbafrme');

INSERT INTO site_users(name, role, st_login, personal_data, password_hash, cookie)
VALUES('Петрова Светлана Владимировна', 2, 'st068409', ' ', '44f44e33', 'ahbdsrme');

INSERT INTO site_users(name, role, st_login, password_hash)
VALUES('Светлова Влада Петровна', 2, 'st068406', '77e55e33');

INSERT INTO site_users(name, role, st_login, password_hash)
VALUES('Низамов Вячеслав Юрьевич', 25, 'st000000', '90e75f17');

-- notifications

INSERT INTO notifications(user_id, text, status)
SELECT user_id, 'some text', 'unread'
FROM site_users WHERE name = 'Светлова Влада Петровна';

INSERT INTO notifications(user_id, text, status)
SELECT user_id, 'check vk pls', 'unread'
FROM site_users WHERE name = 'Иванова Полина Дмитриевна';

-- teachers 

INSERT INTO teachers(user_id, competence)
SELECT user_id, 'гражданское право'
FROM site_users WHERE name = 'Светлова Влада Петровна';

INSERT INTO teachers(user_id, competence)
SELECT user_id, 'уголовное право'
FROM site_users WHERE name = 'Петрова Светлана Владимировна';

-- supplicants

INSERT INTO supplicants(name, address)
VALUES('Иванов Игнатий Игоревич', 'ул.Пушкина, д.23');

INSERT INTO supplicants(name, telephone_number)
VALUES('Соколова Зинаида Павловна', '88005553535');

-- students (1)
INSERT INTO students(user_id)
SELECT user_id
FROM site_users WHERE role = 1;

-- students_subgroup

INSERT INTO students_subgroup(admin_id, name)
SELECT student_id, 'Мониторинг'
FROM students
JOIN site_users ON students.user_id = site_users.user_id
WHERE site_users.name = 'Иванова Полина Дмитриевна';

-- students(2)

UPDATE ONLY students
SET (teacher_id) = 
(SELECT teacher_id FROM teachers JOIN site_users ON teachers.user_id = site_users.user_id
WHERE site_users.name = 'Петрова Светлана Владимировна');

UPDATE ONLY students
SET points = 5.0
FROM site_users WHERE students.user_id = site_users.user_id
and site_users.name = 'Тимошенко Станислав Герасимович ';

-- cases

INSERT INTO cases(supplicant_id, category, description, case_status, done)
SELECT supplicant_id, 'уголовное дело', '-', 'ждет консультации', false
FROM supplicants
WHERE supplicants.name = 'Иванов Игнатий Игоревич';

INSERT INTO cases(supplicant_id, category, description, case_status, done)
SELECT supplicant_id, 'административное дело', '-', 'ждет консультации', false
FROM supplicants
WHERE supplicants.name = 'Соколова Зинаида Павловна';


-- case_student_relations

INSERT INTO case_student_relations(case_id, student_id, role)
SELECT case_id, student_id, 'главный консультант'
FROM cases, students, site_users 
WHERE students.user_id = site_users.user_id
and site_users.name = 'Иванова Полина Дмитриевна'
and cases.category = 'уголовное дело';

INSERT INTO case_student_relations(case_id, student_id, role)
SELECT case_id, student_id, 'главный консультант'
FROM cases, students, site_users 
WHERE students.user_id = site_users.user_id
and site_users.name = 'Тимошенко Станислав Герасимович '
and cases.category = 'административное дело';

-- case_teacher_relations

INSERT INTO case_teachers_relations(case_id, teacher_id, role)
SELECT case_id, teacher_id, 'главный куратор'
FROM cases, teachers, site_users 
WHERE teachers.user_id = site_users.user_id
and site_users.name = 'Светлова Влада Петровна'
and (cases.category = 'административное дело' or cases.category = 'уголовное дело');

--rejected_requests

INSERT INTO rejected_requests(reason, supplicant_name, request_text)
VALUES('конфликт интересов', 'Василий', 'Против преподавателя СпбГУ');

INSERT INTO rejected_requests(reason, supplicant_name, request_text)
VALUES('вне компетенции юридической клиники', 'Игнат Ришатович', 'украли велосипед');

--administraton

INSERT INTO administration(name, type, user_id)
SELECT 'Низамов Вячеслав Юрьевич', 'director', user_id
FROM site_users WHERE name = 'Низамов Вячеслав Юрьевич';

--applications

INSERT INTO applications(title, case_id, description, addressee_user_id, status)
SELECT 'Проверьте пожалуйста', case_id, 'Прошу Вас проверить корректность и полноту составленного плана консультации', user_id, 'unread'
FROM site_users, cases WHERE cases.category = 'уголовное дело'
and site_users.name = 'Светлова Влада Петровна';

--documents

INSERT INTO documents(title, case_id, data_id)
SELECT 'Свидетельство о браке', case_id, '76540818' 
FROM cases, supplicants WHERE cases.supplicant_id = supplicants.supplicant_id
and supplicants.name = 'Иванов Игнатий Игоревич';

--cases_feed

INSERT INTO cases_feed(case_id, case_status, date_time, done)
SELECT case_id, 'ожидает консультации', '2019-12-01 19:10:25-07', false 
FROM cases;

--points_feed

INSERT INTO points_feed(student_id, teacher_id, points, reason, date_time)
SELECT student_id, teacher_id, 5.0 , 'good boy', '2019-12-01 19:10:25-07'
FROM students, site_users WHERE students.user_id = site_users.user_id
and site_users.name = 'Тимошенко Станислав Герасимович ';

--duty_roster

INSERT INTO duty_roster(student_id, class_room, start_date_time, finish_date_time)
SELECT student_id, 1, '2019-12-01 15:00:25-07', '2019-12-01 19:00:25-07'
FROM students, site_users WHERE students.user_id = site_users.user_id
and site_users.name = 'Тимошенко Станислав Герасимович ';
