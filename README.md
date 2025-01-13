# CSTATE_ACMEPHARMADB

Project Overview

This SQL script manages the database for Acme Pharmaceuticals' double-blind drug trials. It was developed as part of an educational assignment for the IT-112 course at Cincinnati State Technical College. The database supports two studies: 12345 and 54321, and includes functionality for handling patients, sites, visits, and drug kits.

Author

Name: Jack Lorenz

Date: December 12, 2023

Course: IT-112 (Fall 2023)

Instructor: Tomie Gartland

Features

Schema Creation: Defines tables, views, and relationships for managing trial data.

Data Integrity: Includes primary keys, constraints, and relationships to ensure data consistency.

Procedures and Functions: Provides stored procedures and functions for patient management and drug assignment.

Modular Design: Includes sections for dropping and recreating objects, ensuring clean resets.

Table of Contents

Abstract

Prerequisites

Database Schema

Setup Instructions

Usage

Stored Procedures and Functions

Views

License

Abstract

This database handles operations for Acme Pharmaceuticals' double-blind drug trials, including participant enrollment, visit tracking, and drug assignment. It is a mock system designed for educational purposes.

Prerequisites

SQL Server or a compatible RDBMS.

Basic knowledge of SQL scripting and database management.

Database Schema

Tables

TStudies

intStudyID (Primary Key): Unique identifier for each study.

strStudyDesc: Description of the study.

TSites

intSiteID (Primary Key): Unique identifier for each site.

intStudyID: Foreign key linking to TStudies.

strName: Site name.

Additional fields: Address, city, state, ZIP code, phone.

TPatients

intPatientID (Primary Key): Unique identifier for each patient.

intSiteID: Foreign key linking to TSites.

dtmDOB: Date of birth.

Additional fields: Gender, patient number.

Additional Tables:

TVisits, TVisitTypes, TDrugKits, TGenders, TStates, TRandomCodes, TWithdrawReasons.

Relationships

Enforced through primary and foreign keys.

Ensures consistency between studies, sites, patients, and visits.

Setup Instructions

Preparation:

Ensure the dbIT112Final database exists or create it.

Use the USE dbIT112Final; command to select the database.

Execution:

Run the script in a SQL Server Management Studio (SSMS) or a similar tool.

Objects will be dropped and recreated to reset the database.

Verification:

Use queries to check the existence of tables and data integrity.

Usage

Managing Studies: Add, update, or delete study information.

Site Management: Define and manage trial sites.

Patient Management: Enroll and track patients.

Drug Kits: Assign drug kits to patients.

Stored Procedures and Functions

uspAddPatient4: Adds a new patient to the database.

uspScreenPatient6: Screens a patient for eligibility.

uspRandomizePatient: Assigns a randomization code to a patient.

uspWithdrawPatient4: Withdraws a patient from the study.

dbo.GetNextTreatment: Function for assigning drug kits.

Views

vAllPatients2: Lists all patients.

vAllRandomizedPatients4: Lists all randomized patients.

vAvailableDrug: Shows available drug kits.

Additional views support specific queries for studies and random codes.

License

This script is for educational purposes only and is not intended for production use.

For any questions or further assistance, contact the author or course instructor.
