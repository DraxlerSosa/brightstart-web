-- BrightStart database schema (MySQL 8 / Azure Database for MySQL)
-- Run this first, then seed.sql.
-- Table names are lower-case on purpose: Azure MySQL (and Linux) can be case-sensitive.

CREATE DATABASE IF NOT EXISTS brightstart CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE brightstart;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS tblauthtoken, tblperformance, tblattendance, tblenrolment, tblsession,
                     tbldonation, tblvolunteer, tblprogram, tblstudent, administrator;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE administrator (
    AdminID      INT AUTO_INCREMENT PRIMARY KEY,
    FullName     VARCHAR(100) NOT NULL,
    Email        VARCHAR(150) NOT NULL UNIQUE,
    Username     VARCHAR(50)  NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,                 -- bcrypt
    Role         VARCHAR(20)  NOT NULL DEFAULT 'Volunteer',   -- Admin | Coordinator | Volunteer | Management
    Verified     TINYINT(1)   NOT NULL DEFAULT 0,       -- admin approval gate
    GoogleSub    VARCHAR(64)  NULL,                     -- set after Google SSO
    CreatedAt    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE tblauthtoken (
    TokenID   INT AUTO_INCREMENT PRIMARY KEY,
    AdminID   INT NOT NULL,
    TokenHash CHAR(64) NOT NULL UNIQUE,                 -- sha256 of the bearer token
    ExpiresAt DATETIME NOT NULL,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AdminID) REFERENCES administrator(AdminID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tblstudent (
    StudentID     INT AUTO_INCREMENT PRIMARY KEY,
    FirstName     VARCHAR(60) NOT NULL,
    LastName      VARCHAR(60) NOT NULL,
    DateOfBirth   DATE NOT NULL,
    Gender        VARCHAR(20) NOT NULL,
    CommunityArea VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    EnrolmentDate DATE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tblprogram (
    ProgramID   INT AUTO_INCREMENT PRIMARY KEY,
    ProgramName VARCHAR(100) NOT NULL,
    Description TEXT,
    StartDate   DATE NOT NULL,
    EndDate     DATE NOT NULL,
    Status      VARCHAR(20) NOT NULL DEFAULT 'Active'   -- Active | Pending | Closed
) ENGINE=InnoDB;

CREATE TABLE tblvolunteer (
    VolunteerID       INT AUTO_INCREMENT PRIMARY KEY,
    FullName          VARCHAR(100) NOT NULL,
    ContactEmail      VARCHAR(150) NOT NULL,
    ContactNumber     VARCHAR(20)  NOT NULL,
    SubjectSpeciality VARCHAR(100) NOT NULL,
    JoinDate          DATE NOT NULL,
    Status            VARCHAR(20) NOT NULL DEFAULT 'Active'   -- Active | Inactive
) ENGINE=InnoDB;

CREATE TABLE tblsession (
    SessionID   INT AUTO_INCREMENT PRIMARY KEY,
    ProgramID   INT NOT NULL,
    VolunteerID INT NOT NULL,
    SessionDate DATE NOT NULL,
    StartTime   TIME NOT NULL,
    EndTime     TIME NOT NULL,
    Venue       VARCHAR(120) NOT NULL,
    FOREIGN KEY (ProgramID)   REFERENCES tblprogram(ProgramID)     ON DELETE CASCADE,
    FOREIGN KEY (VolunteerID) REFERENCES tblvolunteer(VolunteerID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tblenrolment (
    EnrolmentID   INT AUTO_INCREMENT PRIMARY KEY,
    StudentID     INT NOT NULL,
    ProgramID     INT NOT NULL,
    EnrolmentDate DATE NOT NULL,
    Status        VARCHAR(20) NOT NULL DEFAULT 'Active',  -- Active | Completed | Withdrawn
    FOREIGN KEY (StudentID) REFERENCES tblstudent(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (ProgramID) REFERENCES tblprogram(ProgramID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tblattendance (
    AttendanceID     INT AUTO_INCREMENT PRIMARY KEY,
    SessionID        INT NOT NULL,
    StudentID        INT NOT NULL,
    AttendanceStatus VARCHAR(20) NOT NULL DEFAULT 'Present',  -- Present | Absent | Excused
    Notes            VARCHAR(255) NULL,
    FOREIGN KEY (SessionID) REFERENCES tblsession(SessionID) ON DELETE CASCADE,
    FOREIGN KEY (StudentID) REFERENCES tblstudent(StudentID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tblperformance (
    PerformanceID  INT AUTO_INCREMENT PRIMARY KEY,
    StudentID      INT NOT NULL,
    ProgramID      INT NOT NULL,
    AssessmentDate DATE NOT NULL,
    Score          DECIMAL(5,2) NOT NULL,
    Grade          VARCHAR(5) NOT NULL,
    Comments       TEXT,
    FOREIGN KEY (StudentID) REFERENCES tblstudent(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (ProgramID) REFERENCES tblprogram(ProgramID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tbldonation (
    DonationID     INT AUTO_INCREMENT PRIMARY KEY,
    DonorName      VARCHAR(100) NOT NULL,
    DonorContact   VARCHAR(150) NOT NULL,
    DonationAmount DECIMAL(10,2) NOT NULL,
    DonationDate   DATE NOT NULL,
    DonationType   VARCHAR(30) NOT NULL,                 -- Cash | Bank Transfer | In-Kind
    Notes          VARCHAR(255) NULL
) ENGINE=InnoDB;
