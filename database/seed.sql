-- BrightStart sample data (10+ rows per table). Run after schema.sql.
-- Demo logins (all use the password  BrightStart@2026 ):
--   admin@brightstart.org        (Admin, approved)
--   coordinator@brightstart.org  (Coordinator, approved)
--   volunteer@brightstart.org    (Volunteer, approved)
--   pending1@brightstart.org     (Volunteer, PENDING - use to demo the approval workflow)
-- Change these passwords before any real use.
USE brightstart;

INSERT INTO administrator (FullName,Email,Username,PasswordHash,Role,Verified) VALUES
('Dennis Moima',      'admin@brightstart.org',       'dennis.admin',  '$2b$10$zcHz9isiPS1ksQ3Qw2vl.OSiMi8/GB7BGGuSBXbrPESxTidohSft.','Admin',1),
('Kgothatso Magatsela','coordinator@brightstart.org','kgothatso.m',   '$2b$10$zcHz9isiPS1ksQ3Qw2vl.OSiMi8/GB7BGGuSBXbrPESxTidohSft.','Coordinator',1),
('Keabetswe Modiba',  'volunteer@brightstart.org',   'keabetswe.m',   '$2b$10$zcHz9isiPS1ksQ3Qw2vl.OSiMi8/GB7BGGuSBXbrPESxTidohSft.','Volunteer',1),
('Chantal Mafa',      'management@brightstart.org',  'chantal.m',     '$2b$10$zcHz9isiPS1ksQ3Qw2vl.OSiMi8/GB7BGGuSBXbrPESxTidohSft.','Management',1),
('Thandi Nkosi',      'thandi.nkosi@brightstart.org','thandi.n',      '$2b$10$zcHz9isiPS1ksQ3Qw2vl.OSiMi8/GB7BGGuSBXbrPESxTidohSft.','Coordinator',1),
('Sipho Dlamini',     'sipho.dlamini@brightstart.org','sipho.d',      '$2b$10$zcHz9isiPS1ksQ3Qw2vl.OSiMi8/GB7BGGuSBXbrPESxTidohSft.','Volunteer',1),
('Lerato Molefe',     'lerato.molefe@brightstart.org','lerato.m',     '$2b$10$zcHz9isiPS1ksQ3Qw2vl.OSiMi8/GB7BGGuSBXbrPESxTidohSft.','Volunteer',1),
('Pieter van Wyk',    'pieter.vanwyk@brightstart.org','pieter.vw',    '$2b$10$zcHz9isiPS1ksQ3Qw2vl.OSiMi8/GB7BGGuSBXbrPESxTidohSft.','Management',1),
('Pending Volunteer', 'pending1@brightstart.org',    'pending.one',   '$2b$10$zcHz9isiPS1ksQ3Qw2vl.OSiMi8/GB7BGGuSBXbrPESxTidohSft.','Volunteer',0),
('Pending Coordinator','pending2@brightstart.org',   'pending.two',   '$2b$10$zcHz9isiPS1ksQ3Qw2vl.OSiMi8/GB7BGGuSBXbrPESxTidohSft.','Coordinator',0);

INSERT INTO tblstudent (FirstName,LastName,DateOfBirth,Gender,CommunityArea,ContactNumber,EnrolmentDate) VALUES
('Lebo','Mokoena','2011-03-14','Female','Mamelodi','0821234501','2026-02-03'),
('Thabo','Sithole','2010-07-22','Male','Atteridgeville','0829876502','2026-02-03'),
('Naledi','Khumalo','2012-01-09','Female','Soshanguve','0834567803','2026-02-04'),
('Sibusiso','Ndlovu','2009-11-30','Male','Mamelodi','0719988704','2026-02-04'),
('Zanele','Mahlangu','2011-05-18','Female','Hammanskraal','0762233405','2026-02-05'),
('Katlego','Molefe','2010-09-02','Male','Soshanguve','0845566706','2026-02-05'),
('Ayanda','Zulu','2012-04-25','Female','Atteridgeville','0823344507','2026-02-06'),
('Tshepo','Mabaso','2009-08-12','Male','Mamelodi','0817788908','2026-02-06'),
('Palesa','Radebe','2011-12-01','Female','Garankuwa','0728899009','2026-02-09'),
('Mpho','Tau','2010-02-17','Male','Soshanguve','0831122310','2026-02-09'),
('Refilwe','Dube','2012-06-28','Female','Hammanskraal','0769900111','2026-02-10'),
('Bongani','Nkosi','2009-10-05','Male','Atteridgeville','0847766512','2026-02-10'),
('Karabo','Pillay','2011-03-03','Female','Mamelodi','0825544313','2026-02-11'),
('Lungile','Cele','2010-12-19','Male','Garankuwa','0713344214','2026-02-11'),
('Neo','Maseko','2012-08-08','Female','Soshanguve','0786655415','2026-02-12');

INSERT INTO tblprogram (ProgramName,Description,StartDate,EndDate,Status) VALUES
('Maths Mastery','Weekly maths tutoring for Grades 6-9 focusing on problem solving.','2026-02-02','2026-11-27','Active'),
('English Literacy','Reading, writing and comprehension support.','2026-02-02','2026-11-27','Active'),
('Science Explorers','Hands-on experiments that make science fun.','2026-02-09','2026-10-30','Active'),
('Coding Club','Introduction to programming with Scratch and Python.','2026-03-02','2026-11-20','Active'),
('Career Guidance','Workshops on careers, bursaries and CV writing.','2026-03-09','2026-09-25','Active'),
('Reading Buddies','Peer reading circles for younger learners.','2026-02-16','2026-11-13','Active'),
('Matric Revision','Intensive exam revision for matric learners.','2026-06-01','2026-11-06','Pending'),
('Life Skills','Communication, teamwork and personal development.','2026-02-23','2026-10-16','Active'),
('Art & Creativity','Drawing, painting and creative expression.','2026-03-16','2026-09-18','Active'),
('Financial Literacy','Budgeting and saving basics for teenagers.','2025-02-03','2025-11-28','Closed');

INSERT INTO tblvolunteer (FullName,ContactEmail,ContactNumber,SubjectSpeciality,JoinDate,Status) VALUES
('Thandi Nkosi','thandi.nkosi@gmail.com','0821110001','Mathematics','2025-11-10','Active'),
('Sipho Dlamini','sipho.dlamini@gmail.com','0821110002','English','2025-11-12','Active'),
('Lerato Molefe','lerato.molefe@gmail.com','0821110003','Natural Sciences','2025-12-01','Active'),
('Pieter van Wyk','pieter.vanwyk@gmail.com','0821110004','Computer Science','2026-01-08','Active'),
('Nomsa Khoza','nomsa.khoza@gmail.com','0821110005','Career Guidance','2026-01-15','Active'),
('Johan Botha','johan.botha@gmail.com','0821110006','Reading & Literacy','2026-01-20','Active'),
('Amina Patel','amina.patel@gmail.com','0821110007','Accounting','2026-01-22','Active'),
('Mandla Zwane','mandla.zwane@gmail.com','0821110008','Life Skills','2026-02-02','Active'),
('Sarah Jacobs','sarah.jacobs@gmail.com','0821110009','Visual Arts','2026-02-05','Active'),
('Kabelo Sebola','kabelo.sebola@gmail.com','0821110010','Mathematics','2025-10-01','Inactive');

-- Sessions 1-6 are in the past, 7-12 are upcoming (dates are relative to today)
INSERT INTO tblsession (ProgramID,VolunteerID,SessionDate,StartTime,EndTime,Venue) VALUES
(1,1,DATE_SUB(CURDATE(),INTERVAL 28 DAY),'15:00:00','17:00:00','Mamelodi Community Hall'),
(2,2,DATE_SUB(CURDATE(),INTERVAL 24 DAY),'14:00:00','16:00:00','Atteridgeville Library'),
(3,3,DATE_SUB(CURDATE(),INTERVAL 21 DAY),'15:00:00','17:00:00','Soshanguve Youth Centre'),
(4,4,DATE_SUB(CURDATE(),INTERVAL 17 DAY),'16:00:00','18:00:00','Mamelodi Computer Lab'),
(5,5,DATE_SUB(CURDATE(),INTERVAL 14 DAY),'13:00:00','15:00:00','Hammanskraal Hall'),
(6,6,DATE_SUB(CURDATE(),INTERVAL 7 DAY),'14:00:00','15:30:00','Garankuwa Library'),
(1,1,DATE_ADD(CURDATE(),INTERVAL 2 DAY),'15:00:00','17:00:00','Mamelodi Community Hall'),
(2,2,DATE_ADD(CURDATE(),INTERVAL 4 DAY),'14:00:00','16:00:00','Atteridgeville Library'),
(3,3,DATE_ADD(CURDATE(),INTERVAL 7 DAY),'15:00:00','17:00:00','Soshanguve Youth Centre'),
(4,4,DATE_ADD(CURDATE(),INTERVAL 9 DAY),'16:00:00','18:00:00','Mamelodi Computer Lab'),
(8,8,DATE_ADD(CURDATE(),INTERVAL 12 DAY),'14:00:00','16:00:00','Hammanskraal Hall'),
(9,9,DATE_ADD(CURDATE(),INTERVAL 15 DAY),'13:00:00','15:00:00','Garankuwa Library');

INSERT INTO tblenrolment (StudentID,ProgramID,EnrolmentDate,Status) VALUES
(1,1,'2026-02-03','Active'),(2,1,'2026-02-03','Active'),(3,2,'2026-02-04','Active'),
(4,3,'2026-02-04','Active'),(5,2,'2026-02-05','Active'),(6,4,'2026-03-02','Active'),
(7,5,'2026-03-09','Active'),(8,4,'2026-03-02','Active'),(9,6,'2026-02-16','Active'),
(10,1,'2026-02-09','Completed'),(11,2,'2026-02-10','Active'),(12,3,'2026-02-10','Withdrawn'),
(13,8,'2026-02-23','Active'),(14,9,'2026-03-16','Active'),(15,6,'2026-02-16','Active');

INSERT INTO tblattendance (SessionID,StudentID,AttendanceStatus,Notes) VALUES
(1,1,'Present','Participated well'),(1,2,'Present',NULL),(1,10,'Absent','No message received'),
(2,3,'Present','Great reading today'),(2,5,'Present',NULL),(2,11,'Excused','Family event'),
(3,4,'Present','Enjoyed the experiment'),(3,12,'Absent',NULL),(3,13,'Present',NULL),
(4,6,'Present','Finished first Scratch project'),(4,8,'Present',NULL),(4,14,'Excused','Medical appointment'),
(5,7,'Present','Asked good questions'),(5,9,'Present',NULL),(5,15,'Absent',NULL),
(6,9,'Present',NULL),(6,15,'Present','Read aloud confidently'),(6,3,'Present',NULL),
(1,4,'Present',NULL),(2,1,'Absent','Sick');

INSERT INTO tblperformance (StudentID,ProgramID,AssessmentDate,Score,Grade,Comments) VALUES
(1,1,'2026-04-10',78.50,'B','Strong improvement in algebra.'),
(2,1,'2026-04-10',65.00,'C','Needs more practice with fractions.'),
(3,2,'2026-04-12',82.00,'A','Excellent comprehension.'),
(4,3,'2026-04-15',71.25,'B','Good practical work.'),
(5,2,'2026-04-12',58.00,'D','Struggles with spelling; extra support planned.'),
(6,4,'2026-05-05',90.00,'A','Natural at logic and problem solving.'),
(7,5,'2026-05-08',74.00,'B','Clear career goals.'),
(8,4,'2026-05-05',68.50,'C','Improving steadily.'),
(9,6,'2026-04-20',85.00,'A','Reads fluently and helps others.'),
(10,1,'2026-06-02',92.00,'A','Completed the programme with distinction.'),
(11,2,'2026-04-12',63.00,'C','Participation is improving.'),
(13,8,'2026-05-20',77.00,'B','Works well in teams.');

INSERT INTO tbldonation (DonorName,DonorContact,DonationAmount,DonationDate,DonationType,Notes) VALUES
('Mogale Family Trust','info@mogaletrust.org.za',5000.00,'2026-02-14','Bank Transfer','Annual contribution'),
('Anonymous Donor','anonymous@example.com',500.00,'2026-02-20','Cash',NULL),
('Pretoria Rotary Club','admin@pretoriarotary.org.za',7500.00,'2026-03-05','Bank Transfer','For learning materials'),
('Naomi Steyn','naomi.steyn@gmail.com',250.00,'2026-03-18','Cash',NULL),
('TechStart SA','csr@techstart.co.za',12000.00,'2026-04-02','Bank Transfer','Sponsor laptops for Coding Club'),
('Jabu Mthembu','jabu.mthembu@gmail.com',300.00,'2026-04-10','Cash',NULL),
('Bright Books Store','hello@brightbooks.co.za',1800.00,'2026-04-25','In-Kind','Donated 60 storybooks'),
('Ellen Fourie','ellen.fourie@gmail.com',1000.00,'2026-05-06','Bank Transfer',NULL),
('Sunrise Bakery','orders@sunrisebakery.co.za',600.00,'2026-05-19','In-Kind','Snacks for 6 sessions'),
('Ahmed Cassim','ahmed.cassim@gmail.com',2000.00,'2026-06-01','Bank Transfer','Monthly supporter'),
('Gauteng Education Partners','grants@gep.org.za',15000.00,'2026-06-15','Bank Transfer','Quarterly grant'),
('Lindiwe Ngcobo','lindiwe.ngcobo@gmail.com',150.00,'2026-07-04','Cash',NULL);
