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