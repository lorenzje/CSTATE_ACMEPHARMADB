-- --------------------------------------------------------------------------------
-- ACME PHARMACEUTICALS DOUBLE BLIND TRIAL
-- AUTHOR : JACK LORENZ (2023.12.12)
----------------------------------------------------------------------------------
-- ABSTRACT:
-- The following database handles 2 studies being conducted simultaneously 
-- for the following Acme Pharmaceuticals double blind A/P drug trials:
--		12345
--		54321
-- 

--**NOTE: This is a mock script developed within Course IT-112, supplied by Cincinnati State
--		  Technical College, Fall Semester of 2023.  The professor overseeing the course
--		  at time of assignment is Tomie Gartland.
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Table of Contents
-- --------------------------------------------------------------------------------
- --------------------------------------------------------------------------------
-- Options 0.0.0
-- --------------------------------------------------------------------------------
USE dbIT112Final;     -- Get out of the master database
SET NOCOUNT ON; -- Report only errors

-- --------------------------------------------------------------------------------
--	0.1.0					    Drop Tables
-- --------------------------------------------------------------------------------
IF OBJECT_ID('TDrugKits')					IS NOT NULL DROP TABLE TDrugKits
IF OBJECT_ID('TVisits')						IS NOT NULL DROP TABLE TVisits
IF OBJECT_ID('TVisitTypes')					IS NOT NULL DROP TABLE TVisitTypes
IF OBJECT_ID('TPatients')					IS NOT NULL DROP TABLE TPatients
IF OBJECT_ID('TSites')						IS NOT NULL DROP TABLE TSites
IF OBJECT_ID('TRandomCodes')				IS NOT NULL DROP TABLE TRandomCodes
IF OBJECT_ID('TGenders')					IS NOT NULL DROP TABLE TGenders
IF OBJECT_ID('TWithdrawReasons')			IS NOT NULL DROP TABLE TWithdrawReasons
IF OBJECT_ID('TStates')						IS NOT NULL DROP TABLE TStates
IF OBJECT_ID('TStudies')					IS NOT NULL DROP TABLE TStudies

-- --------------------------------------------------------------------------------
-- 0.2.0					    Drop Procedures
-- --------------------------------------------------------------------------------
IF OBJECT_ID( 'uspAddPatient4' )                            IS NOT NULL DROP PROCEDURE    uspAddPatient4 
IF OBJECT_ID( 'uspScreenPatient6' )                         IS NOT NULL DROP PROCEDURE    uspScreenPatient6 
IF OBJECT_ID( 'uspRandomizePatient' )                      IS NOT NULL DROP PROCEDURE    uspRandomizePatient
IF OBJECT_ID( 'uspWithdrawPatient4' )                       IS NOT NULL DROP PROCEDURE    uspWithdrawPatient4 
IF OBJECT_ID( 'uspGetRandomCode5' )                         IS NOT NULL DROP PROCEDURE    uspGetRandomCode5 

-- --------------------------------------------------------------------------------
-- 0.3.0						Drop Views
-- --------------------------------------------------------------------------------
IF OBJECT_ID( 'vAllPatients2' )                                IS NOT NULL DROP VIEW vAllPatients2  
IF OBJECT_ID( 'vAllRandomizedPatients4' )					   IS NOT NULL DROP VIEW vAllRandomizedPatients4 
IF OBJECT_ID( 'vRandomCodes12345' )							   IS NOT NULL DROP VIEW vRandomCodes12345 
IF OBJECT_ID( 'vRandomCodes54321b' )						   IS NOT NULL DROP VIEW vRandomCodes54321b 
IF OBJECT_ID( 'vNextRandomCodeStudy12345b' )				   IS NOT NULL DROP VIEW vNextRandomCodeStudy12345b 
IF OBJECT_ID( 'vNextRandomCodeStudy54321c' )				   IS NOT NULL DROP VIEW vNextRandomCodeStudy54321c
IF OBJECT_ID( 'vAvailableDrug' )							   IS NOT NULL DROP VIEW vAvailableDrug 
IF OBJECT_ID( 'vWithdrawals7' )                                IS NOT NULL DROP VIEW vWithdrawals7 
----------------------------------------------------------------------------------------------------------------
-- 0.4.0						Drop Functions
----------------------------------------------------------------------------------------------------------------
IF OBJECT_ID( 'dbo.GetNextTreatment' )					   IS NOT NULL DROP FUNCTION dbo.GetNextTreatment -- Assigns a drug kit --



-- --------------------------------------------------------------------------------
-- 1.0.0						Create Tables
-- --------------------------------------------------------------------------------

CREATE TABLE TStudies 
(
    intStudyID		integer			not null
   ,strStudyDesc	VARCHAR(255)	not null
   ,CONSTRAINT TStudies_PK PRIMARY KEY ( intStudyID )
)


CREATE TABLE TSites 
(
    intSiteID		integer			not null		
   ,intSiteNumber	integer			not null
   ,intStudyID		integer			not null
   ,strName			varchar(255)	not null
   ,strAddress		varchar(255)	not null
   ,strCity			VARCHAR(255)	not null
   ,intStateID		integer			not null
   ,strZip			VARCHAR(10)		not null
   ,strPhone		VARCHAR(15)		not null
   ,CONSTRAINT TSites_PK PRIMARY KEY ( intSiteID )
)


CREATE TABLE TPatients 
(
     intPatientID			integer			not null
    ,intPatientNumber		integer			not null
    ,intSiteID				integer			not null
    ,dtmDOB					datetime		not null
    ,intGenderID			integer			not null
    ,intWeight				integer			not null
    ,intRandomCodeID		integer			
    ,CONSTRAINT TPatients_PK PRIMARY KEY ( intPatientID )
)

CREATE TABLE TVisitTypes 
(
     intVisitTypeID			integer			not null
    ,strVisitDesc			VARCHAR(255)	not null
    ,CONSTRAINT TVisitTypes_PK PRIMARY KEY ( intVisitTypeID )
)

CREATE TABLE TVisits
(
     intVisitID				integer			not null
    ,intPatientID			integer			not null
    ,dtmVisit				datetime		not null
    ,intVisitTypeID			integer			not null
    ,intWithdrawReasonID	integer			

    ,CONSTRAINT TVisits_PK PRIMARY KEY ( intVisitID )
)


CREATE TABLE TRandomCodes 
(
     intRandomCodeID		integer			not null
    ,intRandomCode			integer			not null
    ,intStudyID				integer			not null
    ,strTreatment			varchar(255)	not null
    ,blnAvailable			varchar(1)		not null
    ,CONSTRAINT TRandomCodes_PK PRIMARY KEY ( intRandomCodeID )
)

CREATE TABLE TDrugKits 
(
     intDrugKitID			integer			not null
    ,intDrugKitNumber		integer			not null
    ,intSiteID				integer			not null
    ,strTreatment			varchar(255)	not null
    ,intVisitID				integer			
    ,CONSTRAINT TDrugKits_PK PRIMARY KEY ( intDrugKitID )

)


CREATE TABLE TWithdrawReasons (
     intWithdrawReasonID		integer			not null
    ,strWithdrawDesc			VARCHAR(255)	not null
    ,CONSTRAINT TWithdrawReasons_PK PRIMARY KEY ( intWithdrawReasonID )
)


CREATE TABLE TGenders 
(
    intGenderID			integer			not null
   ,strGender			VARCHAR(255)	not null
   ,CONSTRAINT TGenders_PK PRIMARY KEY ( intGenderID )
)


CREATE TABLE TStates 
(
    intStateID			integer			not null
   ,strStateDesc		VARCHAR(255)	not null
   ,CONSTRAINT TStates_PK PRIMARY KEY ( intStateID )
)


-- --------------------------------------------------------------------------------
--						Table Relationships
-- --------------------------------------------------------------------------------
--
-- #	Child								Parent						Column(s)
-- -	-----								------						---------
-- 1	TSites								TStudies					intStudyID
-- 2	TSites								TSTates						intStateID
-- 3	TPatients							TSites						intSiteID
-- 4	TPatients							TGenders					intGenderID
-- 5	TPatients							TRandomCodes				intRandomCodeID
-- 6	TVisits								TPatients					intPatientID
-- 7	TVisits								TVisitTypes					intVisitTypeID
-- 8	TVisits								TWithdrawReasons			intWithdrawReasonID
-- 9    TRandomCodes						TStudies					intStudyID
-- 10	TDrugKits							TSites						intSiteID
-- 11	TDrugKits							TVisits						intVisitID

-- 1
ALTER TABLE TSites ADD CONSTRAINT TSites_TStudies_FK
FOREIGN KEY ( intStudyID ) REFERENCES TStudies ( intStudyID )

-- 2
ALTER TABLE TSites ADD CONSTRAINT TSites_TSTates_FK
FOREIGN KEY ( intStateID ) REFERENCES TSTates ( intStateID )

-- 3
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TSites_FK
FOREIGN KEY ( intSiteID ) REFERENCES TSites ( intSiteID )

-- 4
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TGenders_FK
FOREIGN KEY ( intGenderID ) REFERENCES TGenders ( intGenderID )

-- 5
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TRandomCodes_FK
FOREIGN KEY ( intRandomCodeID ) REFERENCES TRandomCodes ( intRandomCodeID )

-- 6
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TPatients_FK
FOREIGN KEY ( intPatientID ) REFERENCES TPatients ( intPatientID )

-- 7
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TVisitTypes_FK
FOREIGN KEY ( intVisitTypeID ) REFERENCES TVisitTypes ( intVisitTypeID )

-- 8
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TWithdrawReasons_FK
FOREIGN KEY ( intWithdrawReasonID ) REFERENCES TWithdrawReasons ( intWithdrawReasonID )

-- 9
ALTER TABLE TRandomCodes ADD CONSTRAINT TRandomCodes_TStudies_FK
FOREIGN KEY ( intStudyID ) REFERENCES TStudies ( intStudyID )

-- 10
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TSites_FK
FOREIGN KEY ( intSiteID ) REFERENCES TSites ( intSiteID )

-- 11
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TVisits_FK
FOREIGN KEY ( intVisitID ) REFERENCES TVisits ( intVisitID )

-- --------------------------------------------------------------------------------
--						Inserts
-- --------------------------------------------------------------------------------
-- TStudies
INSERT INTO TStudies (intStudyID, strStudyDesc) 
VALUES				 (1			, '12345'	  ),
					 (2			, '54321'     );

-- TVisitTypes
INSERT INTO TVisitTypes (intVisitTypeID, strVisitDesc	) 
VALUES					(1			   , 'Screening'	),
						(2			   , 'Randomization'),
						(3			   , 'Withdrawal'	);


-- TRandomCodes
INSERT INTO TRandomCodes (intRandomCodeID, intRandomCode, intStudyID, strTreatment, blnAvailable) 
VALUES					 (1, 1000, 1, 'A', 'F'),
						 (2, 1001, 1, 'P', 'T'),
					     (3, 1002, 1, 'A', 'T'),
						 (4, 1003, 1, 'P', 'T'),
						 (5, 1004, 1, 'P', 'T'),
						 (6, 1005, 1, 'A', 'T'),
						 (7, 1006, 1, 'A', 'T'),
						 (8, 1007, 1, 'P', 'T'),
						 (9, 1008, 1, 'A', 'T'),
						 (10, 1009, 1, 'P', 'T'),
						 (11, 1010, 1, 'P', 'T'),
						 (12, 1011, 1, 'A', 'T'),
						 (13, 1012, 1, 'P', 'T'),
						 (14, 1013, 1, 'A', 'T'),
						 (15, 1014, 1, 'A', 'T'),
						 (16, 1015, 1, 'A', 'T'),
						 (17, 1016, 1, 'P', 'T'),
						 (18, 1017, 1, 'P', 'T'),
						 (19, 1018, 1, 'A', 'T'),
						 (20, 1019, 1, 'P', 'T'),
					     (21, 5000, 2, 'A', 'T'),
						 (22, 5001, 2, 'A', 'T'),
						 (23, 5002, 2, 'A', 'T'),
						 (24, 5003, 2, 'A', 'T'),
						 (25, 5004, 2, 'A', 'T'),
						 (26, 5005, 2, 'A', 'T'),
						 (27, 5006, 2, 'A', 'T'),
						 (28, 5007, 2, 'A', 'T'),
						 (29, 5008, 2, 'A', 'T'),
						 (30, 5009, 2, 'A', 'T'),
						 (31, 5010, 2, 'P', 'T'),
						 (32, 5011, 2, 'P', 'T'),
						 (33, 5012, 2, 'P', 'T'),
						 (34, 5013, 2, 'P', 'T'),
						 (35, 5014, 2, 'P', 'T'),
						 (36, 5015, 2, 'P', 'T'),
						 (37, 5016, 2, 'P', 'T'),
						 (38, 5017, 2, 'P', 'T'),
						 (39, 5018, 2, 'P', 'T'),
						 (40, 5019, 2, 'P', 'T');


INSERT INTO TWithdrawReasons (intWithdrawReasonID, strWithdrawDesc					) 
VALUES						 (1					 , 'Patient withdrew consent'		),
							 (2					 , 'Adverse event'					),
							 (3					 , 'Health issue-related to study'  ),
							 (4					 , 'Health issue-unrelated to study'),
							 (5					 , 'Personal reason'				),
							 (6					 , 'Completed the study'			);

-- TGenders
INSERT INTO TGenders (intGenderID, strGender) 
VALUES				 (1			 , 'Male'	),
					 (2			 , 'Female' );

-- TStates
INSERT INTO TStates (intStateID, strStateDesc) 
VALUES				(1		   , 'Ohio'      ),
					(2		   , 'Kentucky'  ),
					(3		   , 'Indiana'   ),
					(4		   , 'New Jersey'),
					(5		   , 'Virginia'  ),
					(6		   , 'Georgia'   ),
					(7		   , 'Iowa'      );

INSERT INTO TSites (intSiteID, intSiteNumber, intStudyID, strName					, strAddress				 , strCity		 , intStateID, strZip , strPhone	) 
VALUES			   (1		 , 101			, 1			, 'Dr. Stan Heinrich'		, '123 E. Main St'			 , 'Atlanta'	 , 6		 , '25869', '1234567890'),
				   (2		 , 111			, 1			, 'Mercy Hospital'			, '3456 Elmhurst Rd.'		 , 'Secaucus'	 , 4		 , '32659', '5013629564'),
				   (3		 , 121			, 1			, 'St. Elizabeth Hospital'	, '976 Jackson Way'			 , 'Ft. Thomas'	 , 2		 , '41258', '3026521478'),
				   (4		 , 501			, 2			, 'Dr. Robert Adler'		, '9087 W. Maple Ave.'		 , 'Cedar Rapids', 3		 , '42365', '6149652574'),
				   (5		 , 511			, 2			, 'Dr. Tim Schmitz'			, '4539 Helena Run'			 , 'Mason'		 , 1		 , '45040', '5136987462'),
				   (6		 , 521			, 2			, 'Dr. Lawrence Snell'		, '9201 NW. Washington Blvd.', 'Bristol'	 , 5		 , '20163', '3876510249');


INSERT INTO TDrugKits (intDrugKitID, intDrugKitNumber, intSiteID, strTreatment, intVisitID) 
VALUES				  (1		   , 10000			 , 1		, 'A'		  , null		  ),
					  (2		   , 10001			 , 1		, 'A'		  , null		  ),
					  (3		   , 10002			 , 1		, 'A'		  , null		  ),
					  (4		   , 10003			 , 1		, 'P'		  , null		  ),
					  (5		   , 10004			 , 1		, 'P'		  , null		  ),
					  (6		   , 10005			 , 1		, 'P'		  , null		  ),
					  (7		   , 10006		     , 2		, 'A'		  , null		  ),
					  (8		   , 10007			 , 2		, 'A'		  , null		  ),
					  (9		   , 10008			 , 2		, 'A'		  , null		  ),
					  (10		   , 10009			 , 2		, 'P'		  , null),
					  (11		   , 10010			 , 2		, 'P'		  , null),
				      (12		   , 10011			 , 2		, 'P'		  , null),
					  (13		   , 10012			 , 3		, 'A'		  , null),
					  (14		   , 10013			 , 3		, 'A'		  , null),
					  (15		   , 10014			 , 3		, 'A'		  , null),
					  (16		   , 10015			 , 3		, 'P'		  , null),
					  (17		   , 10016		     , 3		, 'P'		  , null),
					  (18		   , 10017			 , 3		, 'P'		  , null),
					  (19		   , 10018			 , 4		, 'A'		  , null),
					  (20		   , 10019			 , 4		, 'A'		  , null),
					  (21		   , 10020			 , 4		, 'A'		  , null),
					  (22		   , 10021			 , 4		, 'P'		  , null),
					  (23		   , 10022			 , 4		, 'P'		  , null),
					  (24		   , 10023			 , 4		, 'P'		  , null),
					  (25		   , 10024			 , 5		, 'A'		  , null),
					  (26		   , 10025			 , 5		, 'A'		  , null),
					  (27		   , 10026			 , 5		, 'A'		  , null),
					  (28		   , 10027			 , 5		, 'P'		  , null),
					  (29		   , 10028			 , 5		, 'P'		  , null),
					  (30		   , 10029			 , 5		, 'P'		  , null),
					  (31		   , 10030			 , 6		, 'A'		  , null),
					  (32		   , 10031			 , 6		, 'A'		  , null),
					  (33		   , 10032			 , 6		, 'A'		  , null  ),
					  (34		   , 10033			 , 6		, 'P'		  , null  ),
					  (35		   , 10034			 , 6		, 'P'		  , null  ),
					  (36		   , 10035			 , 6		, 'P'		  , null  );
-- --------------------------------------------------------------------------------
--	2.0.0 - 7.0.0				Views
-- --------------------------------------------------------------------------------
--1 All Patients
go
CREATE VIEW vAllPatients2 AS 
SELECT
    TP.intPatientID,
		TP.intPatientNumber as PatientNumber, 
		TP.dtmDOB,
	    TP.intWeight,
		TG.intGenderID,
			TG.strGender,
    TSI.intSiteNumber,
		TSI.strName AS SiteName,
		TSI.strCity as SiteCity,
		TST.strStateDesc AS SiteState,
		TSI.strZip as SiteZIP,
		TSI.strPhone as SitePhone,

	TS.strStudyDesc,


    TRC.intRandomCodeID,
		TRC.strTreatment,
		TRC.blnAvailable
FROM
    TPatients AS TP
    INNER JOIN TSites AS TSI 
		ON TP.intSiteID = TSI.intSiteID
    INNER JOIN TStudies AS TS 
		ON TSI.intStudyID = TS.intStudyID
    INNER JOIN TGenders AS TG 
		ON TP.intGenderID = TG.intGenderID
    INNER JOIN TRandomCodes AS TRC 
		ON TP.intRandomCodeID = TRC.intRandomCodeID
    INNER JOIN TStates AS TST 
		ON TSI.intStateID = TST.intStateID;
go


-- 2 Randomized Patients
go
CREATE VIEW vAllRandomizedPatients4 AS 
SELECT
    TP.intPatientID,
		TP.intPatientNumber as PatientNumber, 
		TP.dtmDOB as PatientDOB,
	    TP.intWeight as PatientWeight,
			TG.strGender as PatientGender,
    TSI.intSiteNumber as SiteNumber,
		TSI.strName AS SiteName,
		TSI.strCity as SiteCity,
		TST.strStateDesc AS SiteState,
		TSI.strZip as SiteZIP,
		TSI.strPhone as SitePhone,
	TS.strStudyDesc as Study,
    TRC.intRandomCode as RandomCode,
		TRC.strTreatment as Treatment
FROM
    TPatients AS TP
    INNER JOIN TSites AS TSI 
		ON TP.intSiteID = TSI.intSiteID
    INNER JOIN TStudies AS TS 
		ON TSI.intStudyID = TS.intStudyID
    INNER JOIN TGenders AS TG 
		ON TP.intGenderID = TG.intGenderID
    INNER JOIN TRandomCodes AS TRC 
		ON TP.intRandomCodeID = TRC.intRandomCodeID
    INNER JOIN TStates AS TST 
		ON TSI.intStateID = TST.intStateID
where TP.intRandomCodeID is not null
go




-- Next Random Code Study 12345
go
CREATE VIEW vNextRandomCodeStudy12345b AS
SELECT TOP 1
    TRC.intRandomCodeID AS RandomCodeID,
		TRC.intRandomCode as NextRandomCode
FROM
    TRandomCodes as TRC
WHERE
    TRC.intStudyID = 1 -- Assuming StudyID 1 corresponds to Study 12345, adjust as needed
    AND TRC.blnAvailable = 'T'
ORDER BY
    TRC.intRandomCodeID;
go




-- 3.2 Next Available Random Codes Study 54321
go
CREATE VIEW vNextRandomCodeStudy54321c AS
SELECT TOP 1
    TRC.intRandomCodeID AS NextRandomCodeID,
	TRC.intRandomCode as NextRandomCode,
	TRC.strTreatment as Treatment
FROM
    TRandomCodes as TRC
WHERE
    TRC.intStudyID = 2
		AND blnAvailable = 'T'
		AND strTreatment = 'A'
order by
	TRC.intRandomCodeID
union 
SELECT TOP 1
    TRC.intRandomCodeID AS NextRandomCodeID,
	TRC.intRandomCode as NextRandomCode,
	TRC.strTreatment as Treatment
FROM
    TRandomCodes as TRC
WHERE
    TRC.intStudyID = 2
    AND blnAvailable = 'T'
    AND strTreatment = 'P';
go




-- 4 ALL AVAILABLE Random Codes Study 12345 
go
CREATE VIEW vRandomCodes12345 AS
SELECT
    TRC.intRandomCodeID as RandomCodeID,
    TRC.intRandomCode as RandomCode,
    TRC.intStudyID as StudyID,
    TRC.strTreatment as Treatment,
    TRC.blnAvailable as Available
FROM
    TRandomCodes as TRC
WHERE
    TRC.intStudyID = 1 and TRC.blnAvailable = 'T';
go





-- 4 ALL AVAILABLE Random Codes Study 54321  
go
CREATE VIEW vRandomCodes54321b AS
SELECT
    TRC.intRandomCodeID as RandomCodeID,
    TRC.intRandomCode as RandomCode,
    TRC.intStudyID as StudyID,
    TRC.strTreatment as Treatment,
    TRC.blnAvailable as Available
FROM
    TRandomCodes as TRC
WHERE
    TRC.intStudyID = 2 and TRC.blnAvailable = 'T';
go



 
-- 5 available drugs
go
CREATE VIEW vAvailableDrug AS
SELECT
    TDK.intDrugKitID as DrugKitID,
    TDK.intDrugKitNumber as DrugKitNumber,
    TS.strName AS SiteName,
    TDK.strTreatment
FROM
    TDrugKits as TDK
JOIN
    TSites as TS ON TDK.intSiteID = TS.intSiteID
where TDK.intVisitID is null ;
go




--6 withdrawn patients
go
CREATE VIEW vWithdrawals7 AS
SELECT distinct
    TP.intPatientID,
    TP.intPatientNumber as PatientNumber,
	TS.strName AS SiteName,
    TV.dtmVisit AS WithdrawalDate,
    WR.strWithdrawDesc AS WithdrawalReason
FROM
	TVisits as TV
inner join TPatients as TP
	on TP.intPatientID = TV.intPatientID
JOIN
    TSites as TS ON TP.intSiteID = TS.intSiteID
JOIN
    TWithdrawReasons WR ON TV.intWithdrawReasonID = WR.intWithdrawReasonID
	
WHERE
    TV.intWithdrawReasonID IS NOT NULL;
go
	
-- Adding a patient
go
create procedure uspAddPatient4
	@intPatientID			as integer output,
	@intPatientNumber		as integer,
    @intSiteID				as integer,
    @strDOB					as varchar( 255 ),
    @intGenderID			as integer,				
    @intWeight				as integer
as
set xact_abort on

begin transaction

	select @intPatientID = max( intPatientID ) + 1
	from TPatients (Tablockx)

	SELECT @intPatientID  = COALESCE( @intPatientID , 1 )

    INSERT INTO TPatients (intPatientID, intPatientNumber, intSiteID, dtmDOB, intGenderID, intWeight)
    VALUES (@intPatientID ,@intPatientNumber,@intSiteID, @strDOB, @intGenderID, @intWeight)

commit transaction
go

-- Screening a patient
go
CREATE PROCEDURE uspScreenPatient6
	@intVisitID				integer output,		
	@intPatientNumber		as integer,
    @intSiteID				as integer,
    @strDOB					as varchar(255),
    @intGenderID			as integer,				
    @intWeight				as integer,			
    @dtmVisit				datetime			
as

SET XACT_ABORT ON	

begin transaction
	declare @intPatientID	as integer = 0
	
	execute uspAddPatient4 @intPatientID OUTPUT, @intPatientNumber, @intSiteID, @strDOB, @intGenderID, @intWeight

	select @intVisitID = max( intVisitID ) + 1
	from TVisits (Tablockx)

	SELECT @intVisitID  = COALESCE( @intVisitID , 1 )

	insert into TVisits ( intVisitID, intPatientID, dtmVisit, intVisitTypeID)
	values				(@intVisitID, @intPatientID, @dtmVisit, 1)

Commit Transaction
go

-- Withdrawing a Patient
go
create procedure uspWithdrawPatient4
	@intVisitID				as integer output,
	@intPatientID			as integer,
	@dtmVisit				as datetime,
	@intWithdrawReasonID	as integer
as
set xact_abort on

begin transaction
	--declare @dtmLastVisit as datetime
	--declare LastVisit Cursor local for
	--select MAX(dtmVisit) from TVisits
	--where intPatientID = @intPatientID

	--open LastVisit	
	--Fetch from LastVisit
	--into @dtmLastVisit

	select @intVisitID = max( intVisitID ) + 1
	from TVisits (Tablockx)

	SELECT @intVisitID  = COALESCE( @intVisitID , 1 )

insert into TVisits (intVisitID, intPatientID, dtmVisit, intVisitTypeID, intWithdrawReasonID)
values				(@intVisitID, @intPatientID, @dtmVisit, 3 , @intWithdrawReasonID)

Commit Transaction
go
go
create procedure uspGetRandomCode5
		@intPatientID		as integer,
		@intStudyID			as integer
as 
begin
	Declare @intRandomNumber as integer
	Declare @intRandomCodeID as integer
	declare @PCount as integer
	declare @ACount as integer
	set @intRandomNumber  = Rand()
	
	--Select @PCount = count(*)
	--from vAllRandomizedPatients4 as VRP
	--where Treatment = 'P'

	--select @ACount = count(*)
	--from vAllRandomizedPatients4
	--where Treatment = 'A'


	if @intStudyID = 1
	begin
		DECLARE RandomCodeStudy1Cursor CURSOR local FOR
		select RandomCodeID from vNextRandomCodeStudy12345b
	
		open RandomCodeStudy1Cursor

		fetch from RandomCodeStudy1Cursor
		into @intRandomCodeID
		close RandomCodeStudy1Cursor
	end
	else
		if @intRandomNumber > .5
			begin
				DECLARE RandomCodeStudy2CursorA CURSOR local FOR
						select NextRandomCodeID 
					from vNextRandomCodeStudy54321c
					where Treatment = 'A'
				open RandomCodeStudy2CursorA

				fetch from RandomCodeStudy2CursorA
				into @intRandomCodeID
				close RandomCodeStudy2CursorA
			end
		else
			begin
				DECLARE RandomCodeStudy2CursorP CURSOR local FOR
						select NextRandomCodeID 
					from vNextRandomCodeStudy54321c
					where Treatment = 'P'
				open RandomCodeStudy2CursorP

				fetch from RandomCodeStudy2CursorP
				into @intRandomCodeID
				close RandomCodeStudy2CursorP
			end		
	Update TPatients
	set intRandomCodeID = @intRandomCodeID
	where intPatientID = @intPatientID
	Update TRandomCodes
	set blnAvailable = 'F'
	where intRandomCode = @intRandomCodeID
	end;
go

go
create function dbo.GetNextTreatment
	(@strTreatmentType	varchar)
returns integer
as
begin
	declare @intDrugKitID as integer
	declare DrugKitCursor cursor local for
	select MIN(DrugKitID)
	from vAvailableDrug
	where strTreatment = @strTreatmentType
		open DrugKitCursor
		fetch from DrugKitCursor
		into @intDrugKitID

		close DrugKitCursor
	return @intDrugKitID
end
go

go
create procedure uspRandomizePatient
		@intVisitID as integer output,
		@intPatientID as integer,
		@dtmVisit as datetime
	as
	set xact_abort on
	
begin
	declare @StudyID		as integer
	declare @DrugkitID		as integer
	declare @strTreatment	as varchar (255)
	begin
		declare PatientCursor Cursor local for
		select TST.intStudyID from vAllPatients2
			join TSites as TS
				on TS.intSiteNumber = vAllPatients2.intSiteNumber
			join TStudies as TST
				on TST.intStudyID = TS.intStudyID
		where vAllPatients2.intPatientID = @intPatientID

			open PatientCursor

			fetch from PatientCursor
			into @StudyID

			close PatientCursor
	end

	execute uspGetRandomCode5 @intPatientID, @StudyID

	select @strTreatment = TRC.strTreatment from TPatients as TP
		join TRandomCodes as TRC
			on TRC.intRandomCodeID = TP.intRandomCodeID
	where intPatientID = @intPatientID
	
	select @DrugkitID = dbo.GetNextTreatment(@strTreatment)

	select @intVisitID = max( intVisitID ) + 1
	from TVisits (Tablockx)

	SELECT @intVisitID  = COALESCE( @intVisitID , 1 )

insert into TVisits (intVisitID, intPatientID, dtmVisit, intVisitTypeID)
values				(@intVisitID, @intPatientID, @dtmVisit, 2 )
update TDrugKits
set intVisitID = @intVisitID
where intDrugKitID = @DrugkitID
end
go

--declare @intVisitID as integer = 0

--use dbIT112Final;
-- a) 8 patients for each study for screening
DECLARE @intVisitID AS INTEGER;

-- Patients for Study 1
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111001, 2, '1/1/1962', 2, 205, '2023-01-01';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111002, 2, '2/2/1963', 1, 190, '2023-01-02';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111003, 2, '3/3/1964', 2, 180, '2023-01-03';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111004, 2, '4/4/1965', 1, 200, '2023-01-04';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111005, 2, '5/5/1966', 2, 195, '2023-01-05';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111006, 2, '6/6/1967', 1, 185, '2023-01-06';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111007, 2, '7/7/1968', 2, 210, '2023-01-07';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111008, 2, '8/8/1969', 1, 175, '2023-01-08';

-- Patients for Study 2
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111009, 2, '9/9/1970', 2, 190, '2023-01-09';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111010, 2, '10/10/1971', 1, 200, '2023-01-10';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111011, 2, '11/11/1972', 2, 180, '2023-01-11';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111012, 2, '12/12/1973', 1, 205, '2023-01-12';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111013, 2, '1/1/1974', 2, 195, '2023-01-13';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111014, 2, '2/2/1975', 1, 185, '2023-01-14';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111015, 2, '3/3/1976', 2, 210, '2023-01-15';
EXECUTE uspScreenPatient6 @intVisitID OUTPUT, 111016, 2, '4/4/1977', 1, 175, '2023-01-16';

-- b) 5 patients randomized for each study

DECLARE @intPatientID1 AS INTEGER;
DECLARE @intPatientID2 AS INTEGER;
DECLARE @intPatientID3 AS INTEGER;
DECLARE @intPatientID4 AS INTEGER;
DECLARE @intPatientID5 AS INTEGER;

-- Randomized Patients for Study 1
EXECUTE uspRandomizePatient @intVisitID OUTPUT, 1, '2023-01-17';
EXECUTE uspRandomizePatient @intVisitID OUTPUT, 2, '2023-01-18';
EXECUTE uspRandomizePatient @intVisitID OUTPUT, 3, '2023-01-19';
EXECUTE uspRandomizePatient @intVisitID OUTPUT, 4, '2023-01-20';
EXECUTE uspRandomizePatient @intVisitID OUTPUT, 5, '2023-01-21';

-- Randomized Patients for Study 2
DECLARE @intPatientID6 AS INTEGER = 1;
DECLARE @intPatientID7 AS INTEGER = 2;
DECLARE @intPatientID8 AS INTEGER = 3;
DECLARE @intPatientID9 AS INTEGER = 4;
DECLARE @intPatientID10 AS INTEGER= 5;
--declare @intVisitID as integer;
EXECUTE uspRandomizePatient @intVisitID OUTPUT, 1, '2023-01-22';
EXECUTE uspRandomizePatient @intVisitID OUTPUT, 2, '2023-01-23';
EXECUTE uspRandomizePatient @intVisitID OUTPUT, 3, '2023-01-24';
EXECUTE uspRandomizePatient @intVisitID OUTPUT, 4, '2023-01-25';
EXECUTE uspRandomizePatient @intVisitID OUTPUT, 5, '2023-01-26';

-- c) 4 patients (2 randomized and 2 not randomized patients) withdrawn from each study
DECLARE @intWithdrawReasonID AS INTEGER = 1;

-- Withdraw Patients for Study 1
EXECUTE uspWithdrawPatient4 @intVisitID OUTPUT, 1, '2023-01-27', @intWithdrawReasonID;
EXECUTE uspWithdrawPatient4 @intVisitID OUTPUT, 2, '2023-01-28', @intWithdrawReasonID;
EXECUTE uspWithdrawPatient4 @intVisitID OUTPUT, 3, '2023-01-29', @intWithdrawReasonID; 
EXECUTE uspWithdrawPatient4 @intVisitID OUTPUT, 4, '2023-01-30', @intWithdrawReasonID; 

-- Withdraw Patients for Study 2
EXECUTE uspWithdrawPatient4 @intVisitID OUTPUT, 9, '2023-01-31', @intWithdrawReasonID;
EXECUTE uspWithdrawPatient4 @intVisitID OUTPUT, 10, '2023-02-01', @intWithdrawReasonID;
EXECUTE uspWithdrawPatient4 @intVisitID OUTPUT, 11, '2023-02-02', @intWithdrawReasonID; 
EXECUTE uspWithdrawPatient4 @intVisitID OUTPUT, 12, '2023-02-03', @intWithdrawReasonID; 






