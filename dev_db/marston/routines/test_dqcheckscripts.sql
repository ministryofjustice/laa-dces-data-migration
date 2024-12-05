/* THIS IS NOT A PROCEDURE. SCRIPTS NEED TO BE RUN MANUALLY ONE BY ONE
-- CASEDETAILS
---- CASEDETAILS - number of populated records
WITH 
    -- Aggregate maximum loadedon dates from laacasenotes_20241203
    max_casenotes AS (
        SELECT 
            caseid, 
            MAX(loadedon) AS max_loadedon_casenotes
        FROM 
            marston.laacasenotes_20241203
        GROUP BY 
            caseid
    ),
    
    -- Aggregate maximum loadedon dates from laacasehistory_20241203
    max_casehistory AS (
        SELECT 
            caseid, 
            MAX(loadedon) AS max_loadedon_casehistory
        FROM 
            marston.laacasehistory_20241203
        GROUP BY 
            caseid
    )
SELECT 
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN a.caseid IS NULL OR a.caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN clientname IS NULL OR clientname = 'NULL' THEN 1 ELSE 0 END) AS clientname_nulls,
    SUM(CASE WHEN clientcasereference IS NULL OR clientcasereference = 'NULL' THEN 1 ELSE 0 END) AS clientcasereference_nulls,
    SUM(CASE WHEN clientdefaulterreference IS NULL OR clientdefaulterreference = 'NULL' THEN 1 ELSE 0 END) AS clientdefaulterreference_nulls,
    SUM(CASE WHEN currentstatus IS NULL OR currentstatus = 'NULL' THEN 1 ELSE 0 END) AS currentstatus_nulls,
    SUM(CASE WHEN statusdate IS NULL OR statusdate = 'NULL' THEN 1 ELSE 0 END) AS statusdate_nulls,
    SUM(CASE WHEN openclosedstatus IS NULL OR openclosedstatus = 'NULL' THEN 1 ELSE 0 END) AS openclosedstatus_nulls,
    SUM(CASE WHEN caseclosuredate IS NULL OR caseclosuredate = 'NULL' THEN 1 ELSE 0 END) AS caseclosuredate_nulls,
    SUM(CASE WHEN courtcode IS NULL OR courtcode = 'NULL' THEN 1 ELSE 0 END) AS courtcode_nulls,
    SUM(CASE WHEN courtname IS NULL OR courtname = 'NULL' THEN 1 ELSE 0 END) AS courtname_nulls,
    SUM(CASE WHEN outcome IS NULL OR outcome = 'NULL' THEN 1 ELSE 0 END) AS outcome_nulls,
    SUM(CASE WHEN sentenceorderdate IS NULL OR sentenceorderdate = 'NULL' THEN 1 ELSE 0 END) AS sentenceorderdate_nulls,
    SUM(CASE WHEN currentphase IS NULL OR currentphase = 'NULL' THEN 1 ELSE 0 END) AS currentphase_nulls,
    SUM(CASE WHEN currentstage IS NULL OR currentstage = 'NULL' THEN 1 ELSE 0 END) AS currentstage_nulls,
    SUM(CASE WHEN totalenforcementcharges IS NULL OR totalenforcementcharges = 'NULL' THEN 1 ELSE 0 END) AS totalenforcementcharges_nulls,
    SUM(CASE WHEN incomesanctionapplied IS NULL OR incomesanctionapplied = 'NULL' THEN 1 ELSE 0 END) AS incomesanctionapplied_nulls,
    SUM(CASE WHEN loadedon IS NULL OR loadedon = 'NULL' THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls
FROM marston.laacasedetails_20241203 a
LEFT JOIN max_casenotes mn ON a.caseid = mn.caseid
LEFT JOIN max_casehistory mh ON a.caseid = mh.caseid
WHERE (openclosedstatus = 'OPEN'
OR GREATEST(
                COALESCE(mn.max_loadedon_casenotes, '1900-01-01'::timestamp),
                COALESCE(mh.max_loadedon_casehistory, '1900-01-01'::timestamp)
            ) >'2023-01-31' ) 
and a.json_footer is null;

---- CASEDETAILS - DATE RANGE CHECKS
SELECT 
    MIN(statusdate) AS min_statusdate, MAX(statusdate) AS max_statusdate,
    MIN(caseclosuredate) AS min_caseclosuredate, MAX(caseclosuredate) AS max_caseclosuredate,
    MIN(sentenceorderdate) AS min_sentenceorderdate, MAX(sentenceorderdate) AS max_sentenceorderdate,
    MIN(loadedon) AS min_loadedon, MAX(loadedon) AS max_loadedon
FROM marston.laacasedetails_20241203
WHERE statusdate IS NOT NULL AND statusdate <> 'NULL'
  AND caseclosuredate IS NOT NULL AND caseclosuredate <> 'NULL'
  AND sentenceorderdate IS NOT NULL AND sentenceorderdate <> 'NULL'
  AND loadedon IS NOT NULL AND loadedon <> 'NULL';

---- CASEDETAILS - Amount RANGE CHECKS
SELECT 
    MIN(CAST(totalenforcementcharges AS NUMERIC)) AS min_totalenforcementcharges,
    MAX(CAST(totalenforcementcharges AS NUMERIC)) AS max_totalenforcementcharges,
    SUM(CASE WHEN totalenforcementcharges IS NULL OR totalenforcementcharges = 'NULL' THEN 1 ELSE 0 END) AS totalenforcementcharges_nulls,
    COUNT(*) AS total_rows
FROM marston.laacasedetails_20241203
WHERE totalenforcementcharges ~ '^[0-9]+(\.[0-9]+)?$'  -- Matches valid numeric format;


/******** CASE BALANCE ************/
---- NULL Values
SELECT 
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN outstandingbalance IS NULL OR outstandingbalance = 'NULL' THEN 1 ELSE 0 END) AS outstandingbalance_nulls,
    SUM(CASE WHEN originalbalance IS NULL OR originalbalance = 'NULL' THEN 1 ELSE 0 END) AS originalbalance_nulls,
    SUM(CASE WHEN originalbalancedate IS NULL OR originalbalancedate = 'NULL' THEN 1 ELSE 0 END) AS originalbalancedate_nulls
FROM marston.laacasebalance_20241203
where json_footer is null;


-- DATE Range Checks
SELECT 
    MIN(originalbalancedate) AS min_originalbalancedate, 
    MAX(originalbalancedate) AS max_originalbalancedate
FROM marston.laacasebalance_20241203
WHERE originalbalancedate IS NOT NULL AND originalbalancedate <> 'NULL'
and json_footer is null;


-- Numeric Value Ranges
SELECT 
    MIN(CAST(outstandingbalance AS NUMERIC)) AS min_outstandingbalance,
    MAX(CAST(outstandingbalance AS NUMERIC)) AS max_outstandingbalance,
    MIN(CAST(originalbalance AS NUMERIC)) AS min_originalbalance,
    MAX(CAST(originalbalance AS NUMERIC)) AS max_originalbalance
    FROM marston.laacasebalance_20241203
WHERE outstandingbalance ~ '^[0-9]+(\.[0-9]+)?$'  -- Matches valid numeric format
  AND originalbalance ~ '^[0-9]+(\.[0-9]+)?$'
  and json_footer is null;


/******** CASE PAYMENTS TABLE **********/
--- NULL values
SELECT count(*) as totalrows,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN paymentrecordid IS NULL OR paymentrecordid = 'NULL' THEN 1 ELSE 0 END) AS paymentrecordid_nulls,
    SUM(CASE WHEN receivedon IS NULL OR receivedon = 'NULL' THEN 1 ELSE 0 END) AS receivedon_nulls,
    --SUM(CASE WHEN transactiondate IS NULL OR transactiondate = 'NULL' THEN 1 ELSE 0 END) AS transactiondate_nulls,
    SUM(CASE WHEN paymenttype IS NULL OR paymenttype = 'NULL' THEN 1 ELSE 0 END) AS paymenttype_nulls,
    SUM(CASE WHEN amount IS NULL OR amount = 'NULL' THEN 1 ELSE 0 END) AS amount_nulls,
    SUM(CASE WHEN bounceddate IS NULL OR bounceddate = 'NULL' THEN 1 ELSE 0 END) AS bounceddate_nulls,
    SUM(CASE WHEN cleareddate IS NULL OR cleareddate = 'NULL' THEN 1 ELSE 0 END) AS cleareddate_nulls,
    SUM(CASE WHEN reference IS NULL OR reference = 'NULL' THEN 1 ELSE 0 END) AS reference_nulls,
    SUM(CASE WHEN reverseddate IS NULL OR reverseddate = 'NULL' THEN 1 ELSE 0 END) AS reverseddate_nulls,
    SUM(CASE WHEN status IS NULL OR status = 'NULL' THEN 1 ELSE 0 END) AS status_nulls,
    SUM(CASE WHEN transactionfee IS NULL OR transactionfee = 'NULL' THEN 1 ELSE 0 END) AS transactionfee_nulls,
    SUM(CASE WHEN clientpaymentrunrecordid IS NULL OR clientpaymentrunrecordid = 'NULL' THEN 1 ELSE 0 END) AS clientpaymentrunrecordid_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls
FROM marston.laacasepayments_20241203
WHERE json_footer IS NULL;


-- DATE Range Checks
SELECT 
    MIN(CASE WHEN receivedon IS NOT NULL AND receivedon <> 'NULL' THEN receivedon ELSE NULL END) AS min_receivedon, 
    MAX(CASE WHEN receivedon IS NOT NULL AND receivedon <> 'NULL' THEN receivedon ELSE NULL END) AS max_receivedon,
    
    MIN(CASE WHEN transactiondate IS NOT NULL /*AND transactiondate <> 'NULL' */THEN transactiondate ELSE NULL END) AS min_transactiondate, 
    MAX(CASE WHEN transactiondate IS NOT NULL /*AND transactiondate <> 'NULL' */ THEN transactiondate ELSE NULL END) AS max_transactiondate,
    
    MIN(CASE WHEN bounceddate IS NOT NULL AND bounceddate <> 'NULL' THEN bounceddate ELSE NULL END) AS min_bounceddate, 
    MAX(CASE WHEN bounceddate IS NOT NULL AND bounceddate <> 'NULL' THEN bounceddate ELSE NULL END) AS max_bounceddate,
    
    MIN(CASE WHEN cleareddate IS NOT NULL AND cleareddate <> 'NULL' THEN cleareddate ELSE NULL END) AS min_cleareddate, 
    MAX(CASE WHEN cleareddate IS NOT NULL AND cleareddate <> 'NULL' THEN cleareddate ELSE NULL END) AS max_cleareddate,
    
    MIN(CASE WHEN reverseddate IS NOT NULL AND reverseddate <> 'NULL' THEN reverseddate ELSE NULL END) AS min_reverseddate, 
    MAX(CASE WHEN reverseddate IS NOT NULL AND reverseddate <> 'NULL' THEN reverseddate ELSE NULL END) AS max_reverseddate
FROM marston.laacasepayments_20241203
WHERE json_footer IS NULL;


-- Amount range checks
SELECT 
    MIN(CAST(amount AS NUMERIC)) AS min_amount,
    MAX(CAST(amount AS NUMERIC)) AS max_amount,
    MIN(CAST(transactionfee AS NUMERIC)) AS min_transactionfee,
    MAX(CAST(transactionfee AS NUMERIC)) AS max_transactionfee
FROM marston.laacasepayments_20241203
WHERE json_footer IS NULL
  AND amount ~ '^[0-9]+(\.[0-9]+)?$'  -- Matches valid numeric format
  AND transactionfee ~ '^[0-9]+(\.[0-9]+)?$';


/******* CASE REFUNDS *********/
--- NULL Values check
SELECT count(*) as totalrows,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN refundrecordid IS NULL OR refundrecordid = 'NULL' THEN 1 ELSE 0 END) AS refundrecordid_nulls,
    SUM(CASE WHEN refunddate IS NULL OR refunddate = 'NULL' THEN 1 ELSE 0 END) AS refunddate_nulls,
    SUM(CASE WHEN approveddate IS NULL OR approveddate = 'NULL' THEN 1 ELSE 0 END) AS approveddate_nulls,
    SUM(CASE WHEN rejecteddate IS NULL OR rejecteddate = 'NULL' THEN 1 ELSE 0 END) AS rejecteddate_nulls,
    SUM(CASE WHEN cancelleddate IS NULL OR cancelleddate = 'NULL' THEN 1 ELSE 0 END) AS cancelleddate_nulls,
    SUM(CASE WHEN completeddate IS NULL OR completeddate = 'NULL' THEN 1 ELSE 0 END) AS completeddate_nulls,
    SUM(CASE WHEN amount IS NULL OR amount = 'NULL' THEN 1 ELSE 0 END) AS amount_nulls,
    SUM(CASE WHEN status IS NULL OR status = 'NULL' THEN 1 ELSE 0 END) AS status_nulls,
    SUM(CASE WHEN refundtype IS NULL OR refundtype = 'NULL' THEN 1 ELSE 0 END) AS refundtype_nulls,
    SUM(CASE WHEN refundmethod IS NULL OR refundmethod = 'NULL' THEN 1 ELSE 0 END) AS refundmethod_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls
FROM marston.laacaserefunds_20241203
WHERE json_footer IS NULL;


--- DATE RANGE CHECK
SELECT 
    MIN(CASE WHEN refunddate IS NOT NULL AND refunddate <> 'NULL' THEN refunddate ELSE NULL END) AS min_refunddate, 
    MAX(CASE WHEN refunddate IS NOT NULL AND refunddate <> 'NULL' THEN refunddate ELSE NULL END) AS max_refunddate,
    
    MIN(CASE WHEN approveddate IS NOT NULL AND approveddate <> 'NULL' THEN approveddate ELSE NULL END) AS min_approveddate, 
    MAX(CASE WHEN approveddate IS NOT NULL AND approveddate <> 'NULL' THEN approveddate ELSE NULL END) AS max_approveddate,
    
    MIN(CASE WHEN rejecteddate IS NOT NULL AND rejecteddate <> 'NULL' THEN rejecteddate ELSE NULL END) AS min_rejecteddate, 
    MAX(CASE WHEN rejecteddate IS NOT NULL AND rejecteddate <> 'NULL' THEN rejecteddate ELSE NULL END) AS max_rejecteddate,
    
    MIN(CASE WHEN cancelleddate IS NOT NULL AND cancelleddate <> 'NULL' THEN cancelleddate ELSE NULL END) AS min_cancelleddate, 
    MAX(CASE WHEN cancelleddate IS NOT NULL AND cancelleddate <> 'NULL' THEN cancelleddate ELSE NULL END) AS max_cancelleddate,
    
    MIN(CASE WHEN completeddate IS NOT NULL AND completeddate <> 'NULL' THEN completeddate ELSE NULL END) AS min_completeddate, 
    MAX(CASE WHEN completeddate IS NOT NULL AND completeddate <> 'NULL' THEN completeddate ELSE NULL END) AS max_completeddate
FROM marston.laacaserefunds_20241203
WHERE json_footer IS NULL;


--- AMOUNT RANGE CHANGE
SELECT 
    MIN(CAST(amount AS NUMERIC)) AS min_amount,
    MAX(CAST(amount AS NUMERIC)) AS max_amount,
    SUM(CASE WHEN amount IS NULL OR amount = 'NULL' THEN 1 ELSE 0 END) AS amount_nulls
FROM marston.laacaserefunds_20241203
WHERE json_footer IS NULL
  AND amount ~ '^[0-9]+(\.[0-9]+)?$';  -- Matches valid numeric format



/********** casestatus table ************/
--- NULL values check
SELECT count(*) numberofrows,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN casehistoryrecordid IS NULL OR casehistoryrecordid = 'NULL' THEN 1 ELSE 0 END) AS casehistoryrecordid_nulls,
    SUM(CASE WHEN loadedon IS NULL OR loadedon = 'NULL' THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls,
    SUM(CASE WHEN comment IS NULL OR comment = 'NULL' THEN 1 ELSE 0 END) AS comment_nulls,
    SUM(CASE WHEN fromstatus IS NULL OR fromstatus = 'NULL' THEN 1 ELSE 0 END) AS fromstatus_nulls,
    SUM(CASE WHEN tostatus IS NULL OR tostatus = 'NULL' THEN 1 ELSE 0 END) AS tostatus_nulls
FROM marston.laacasestatus_20241203
WHERE json_footer IS NULL;


---- DATE RANGE CHECK
SELECT 
    MIN(CASE WHEN loadedon IS NOT NULL AND loadedon <> 'NULL' THEN loadedon ELSE NULL END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL AND loadedon <> 'NULL' THEN loadedon ELSE NULL END) AS max_loadedon
FROM marston.laacasestatus_20241203
WHERE json_footer IS NULL;



/********** LAACASES ****************/
---- NULL VALUES CHECK
SELECT COUNT(*) TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN loadedon IS NULL OR loadedon = 'NULL' THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN clientcasereference IS NULL OR clientcasereference = 'NULL' THEN 1 ELSE 0 END) AS clientcasereference_nulls,
    SUM(CASE WHEN previouscasereference IS NULL OR previouscasereference = 'NULL' THEN 1 ELSE 0 END) AS previouscasereference_nulls
FROM marston.laacases_20241203
WHERE json_footer IS NULL;



---- DATE RANGE CHECKS
SELECT 
    MIN(CASE WHEN loadedon IS NOT NULL AND loadedon <> 'NULL' THEN loadedon ELSE NULL END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL AND loadedon <> 'NULL' THEN loadedon ELSE NULL END) AS max_loadedon
FROM marston.laacases_20241203
WHERE json_footer IS NULL;


/********** CASE WORKFLOW *************/
---- NULL VALUES CHECK
SELECT COUNT(*) TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN casehistoryrecordid IS NULL OR casehistoryrecordid = 'NULL' THEN 1 ELSE 0 END) AS casehistoryrecordid_nulls,
    SUM(CASE WHEN loadedon IS NULL /*OR loadedon = 'NULL'*/ THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN comment IS NULL OR comment = 'NULL' THEN 1 ELSE 0 END) AS comment_nulls,
    SUM(CASE WHEN phase IS NULL OR phase = 'NULL' THEN 1 ELSE 0 END) AS phase_nulls,
    SUM(CASE WHEN stage IS NULL OR stage = 'NULL' THEN 1 ELSE 0 END) AS stage_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls,
    SUM(CASE WHEN userid IS NULL OR userid = 'NULL' THEN 1 ELSE 0 END) AS userid_nulls
FROM marston.laacaseworkflow_20241203
WHERE json_footer IS NULL;


--- DATE RANGE CHECK
SELECT 
    MIN(CASE WHEN loadedon IS NOT NULL /*AND loadedon <> 'NULL' */THEN loadedon ELSE NULL END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL /*AND loadedon <> 'NULL' */ THEN loadedon ELSE NULL END) AS max_loadedon
FROM marston.laacaseworkflow_20241203
WHERE json_footer IS NULL;



/********* CLIENTPAYMENTRUNS *************/
--- NULL VALUES CHECK
SELECT COUNT(*) TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN clientpaymentrunrecordid IS NULL OR clientpaymentrunrecordid = 'NULL' THEN 1 ELSE 0 END) AS clientpaymentrunrecordid_nulls,
    SUM(CASE WHEN clientpaymentrunhistoryrecordid IS NULL OR clientpaymentrunhistoryrecordid = 'NULL' THEN 1 ELSE 0 END) AS clientpaymentrunhistoryrecordid_nulls,
    SUM(CASE WHEN clientpaymentrundate IS NULL OR clientpaymentrundate = 'NULL' THEN 1 ELSE 0 END) AS clientpaymentrundate_nulls,
    SUM(CASE WHEN paidtoclient IS NULL OR paidtoclient = 'NULL' THEN 1 ELSE 0 END) AS paidtoclient_nulls,
    SUM(CASE WHEN paidtomarston IS NULL OR paidtomarston = 'NULL' THEN 1 ELSE 0 END) AS paidtomarston_nulls,
    SUM(CASE WHEN totalamount IS NULL OR totalamount = 'NULL' THEN 1 ELSE 0 END) AS totalamount_nulls,
    SUM(CASE WHEN vat IS NULL OR vat = 'NULL' THEN 1 ELSE 0 END) AS vat_nulls,
    SUM(CASE WHEN paiddate IS NULL OR paiddate = 'NULL' THEN 1 ELSE 0 END) AS paiddate_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls
FROM marston.laaclientpaymentruns_20241203
WHERE json_footer IS NULL;



--- DATE RANGE CHECK
SELECT 
    MIN(CASE WHEN clientpaymentrundate IS NOT NULL AND clientpaymentrundate <> 'NULL' THEN clientpaymentrundate ELSE NULL END) AS min_clientpaymentrundate, 
    MAX(CASE WHEN clientpaymentrundate IS NOT NULL AND clientpaymentrundate <> 'NULL' THEN clientpaymentrundate ELSE NULL END) AS max_clientpaymentrundate,
    
    MIN(CASE WHEN paiddate IS NOT NULL AND paiddate <> 'NULL' THEN paiddate ELSE NULL END) AS min_paiddate, 
    MAX(CASE WHEN paiddate IS NOT NULL AND paiddate <> 'NULL' THEN paiddate ELSE NULL END) AS max_paiddate
FROM marston.laaclientpaymentruns_20241203
WHERE json_footer IS NULL;


/*************** DEFAULTERS ******************/
---- NULL VALUES CHECK
SELECT COUNT(*) TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN defaulterid IS NULL OR defaulterid = 'NULL' THEN 1 ELSE 0 END) AS defaulterid_nulls,
    SUM(CASE WHEN name IS NULL OR name = 'NULL' THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN dob IS NULL OR dob = 'NULL' THEN 1 ELSE 0 END) AS dob_nulls,
    SUM(CASE WHEN nino IS NULL OR nino = 'NULL' THEN 1 ELSE 0 END) AS nino_nulls,
    SUM(CASE WHEN loadedon IS NULL OR loadedon = 'NULL' THEN 1 ELSE 0 END) AS loadedon_nulls
FROM marston.laadefaulters_20241203
WHERE json_footer IS NULL;


--- Date Range check
SELECT 
    MIN(CASE WHEN dob IS NOT NULL AND dob <> 'NULL' THEN dob ELSE NULL END) AS min_dob, 
    MAX(CASE WHEN dob IS NOT NULL AND dob <> 'NULL' THEN dob ELSE NULL END) AS max_dob,
    
    MIN(CASE WHEN loadedon IS NOT NULL AND loadedon <> 'NULL' THEN loadedon ELSE NULL END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL AND loadedon <> 'NULL' THEN loadedon ELSE NULL END) AS max_loadedon
FROM marston.laadefaulters_20241203
WHERE json_footer IS NULL;


--- Valid NiNo Format
SELECT b.clientcasereference as MAATRepId,nino
FROM marston.laadefaulters_20241203 a
inner join marston.laacasedetails_20241203 b on b.caseid = a.caseid
WHERE a.json_footer IS NULL
  AND (nino IS NOT NULL AND nino <> 'NULL')
  AND nino !~ '^(?!BG)(?!GB)(?!NK)(?!KN)(?!TN)(?!NT)(?!ZZ)(?:[A-CEGHJ-PR-TW-Z][A-CEGHJ-NPR-TW-Z])(?:\s*\d\s*){6}([A-D]|\s)$';  -- Valid NINO format



/*********** DefaultersContactAddresses ************/
--- Null value check
SELECT COUNT(*) TOTALNUMBEROFROWS, 
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN defaulterid IS NULL OR defaulterid = 'NULL' THEN 1 ELSE 0 END) AS defaulterid_nulls,
    SUM(CASE WHEN addressrecordid IS NULL OR addressrecordid = 'NULL' THEN 1 ELSE 0 END) AS addressrecordid_nulls,
    SUM(CASE WHEN addressline1 IS NULL OR addressline1 = 'NULL' THEN 1 ELSE 0 END) AS addressline1_nulls,
    SUM(CASE WHEN addressline2 IS NULL OR addressline2 = 'NULL' THEN 1 ELSE 0 END) AS addressline2_nulls,
    SUM(CASE WHEN addressline3 IS NULL OR addressline3 = 'NULL' THEN 1 ELSE 0 END) AS addressline3_nulls,
    SUM(CASE WHEN addressline4 IS NULL OR addressline4 = 'NULL' THEN 1 ELSE 0 END) AS addressline4_nulls,
    SUM(CASE WHEN addressline5 IS NULL OR addressline5 = 'NULL' THEN 1 ELSE 0 END) AS addressline5_nulls,
    SUM(CASE WHEN addresspc IS NULL OR addresspc = 'NULL' THEN 1 ELSE 0 END) AS addresspc_nulls,
    SUM(CASE WHEN warrantaddr IS NULL OR warrantaddr = 'NULL' THEN 1 ELSE 0 END) AS warrantaddr_nulls,
    SUM(CASE WHEN businessaddress IS NULL OR businessaddress = 'NULL' THEN 1 ELSE 0 END) AS businessaddress_nulls,
    SUM(CASE WHEN loadedon IS NULL /*OR loadedon = 'NULL'*/ THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN isprimarycontactaddress IS NULL OR isprimarycontactaddress = 'NULL' THEN 1 ELSE 0 END) AS isprimarycontactaddress_nulls,
    SUM(CASE WHEN isaddressconfirmed IS NULL OR isaddressconfirmed = 'NULL' THEN 1 ELSE 0 END) AS isaddressconfirmed_nulls,
    SUM(CASE WHEN source IS NULL OR source = 'NULL' THEN 1 ELSE 0 END) AS source_nulls
FROM marston.laadefaulterscontactaddresses_20241203
WHERE json_footer IS NULL;


--- date range check
SELECT COUNT(*) TOTALNUMBEROFROWS, 
    MIN(CASE WHEN loadedon IS NOT NULL /*AND loadedon <> 'NULL' */ THEN loadedon ELSE NULL END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL /*AND loadedon <> 'NULL' */ THEN loadedon ELSE NULL END) AS max_loadedon
FROM marston.laadefaulterscontactaddresses_20241203
WHERE json_footer IS NULL;


---- PostalCode format check
SELECT a.caseid, b.clientcasereference,addresspc
FROM marston.laadefaulterscontactaddresses_20241203 a
inner join marston.laacasedetails_20241203 b on b.caseid = a.caseid
WHERE a.json_footer IS NULL
  AND (addresspc IS NOT NULL AND addresspc <> 'NULL')
  AND addresspc !~ '^[A-Z0-9]{1,4} [A-Z0-9]{1,3}$';  -- Basic UK postcode format



/*********** DefaultersContactAddresses ************/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN defaulterid IS NULL OR defaulterid = 'NULL' THEN 1 ELSE 0 END) AS defaulterid_nulls,
    SUM(CASE WHEN emailrecordid IS NULL OR emailrecordid = 'NULL' THEN 1 ELSE 0 END) AS emailrecordid_nulls,
    SUM(CASE WHEN email IS NULL OR email = 'NULL' THEN 1 ELSE 0 END) AS email_nulls,
    SUM(CASE WHEN loadedon IS NULL /*OR loadedon = 'NULL'*/ THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN status IS NULL OR status = 'NULL' THEN 1 ELSE 0 END) AS status_nulls,
    SUM(CASE WHEN source IS NULL OR source = 'NULL' THEN 1 ELSE 0 END) AS source_nulls,
    SUM(CASE WHEN isconsented IS NULL OR isconsented = 'NULL' THEN 1 ELSE 0 END) AS isconsented_nulls,
    SUM(CASE WHEN ispreferred IS NULL OR ispreferred = 'NULL' THEN 1 ELSE 0 END) AS ispreferred_nulls,
    SUM(CASE WHEN isrightpartyconfirmed IS NULL OR isrightpartyconfirmed = 'NULL' THEN 1 ELSE 0 END) AS isrightpartyconfirmed_nulls
FROM marston.laadefaultersemails_20241203
WHERE json_footer IS NULL;


---- date range check
SELECT 
    MIN(loadedon) AS min_loadedon, 
    MAX(loadedon) AS max_loadedon
FROM marston.laadefaultersemails_20241203
WHERE json_footer IS NULL;


--- valid email format check
SELECT caseid,email
FROM marston.laadefaultersemails_20241203
WHERE json_footer IS NULL
  AND email IS NOT NULL
  AND email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';  -- Basic email format

/*********** DEFAULTERSPHONES TABLE ***************/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN defaulterid IS NULL OR defaulterid = 'NULL' THEN 1 ELSE 0 END) AS defaulterid_nulls,
    SUM(CASE WHEN phonerecordid IS NULL OR phonerecordid = 'NULL' THEN 1 ELSE 0 END) AS phonerecordid_nulls,
    SUM(CASE WHEN number IS NULL OR number = 'NULL' THEN 1 ELSE 0 END) AS number_nulls,
    SUM(CASE WHEN loadedon IS NULL /*OR loadedon = 'NULL' */THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN type IS NULL OR type = 'NULL' THEN 1 ELSE 0 END) AS type_nulls,
    SUM(CASE WHEN status IS NULL OR status = 'NULL' THEN 1 ELSE 0 END) AS status_nulls,
    SUM(CASE WHEN source IS NULL OR source = 'NULL' THEN 1 ELSE 0 END) AS source_nulls,
    SUM(CASE WHEN ispreferred IS NULL OR ispreferred = 'NULL' THEN 1 ELSE 0 END) AS ispreferred_nulls,
    SUM(CASE WHEN isrightpartyconfirmed IS NULL OR isrightpartyconfirmed = 'NULL' THEN 1 ELSE 0 END) AS isrightpartyconfirmed_nulls
FROM marston.laadefaultersphones_20241203
WHERE json_footer IS NULL;



--- date range check
SELECT 
    MIN(loadedon) AS min_loadedon, 
    MAX(loadedon) AS max_loadedon
FROM marston.laadefaultersphones_20241203
WHERE json_footer IS NULL;


--- Valid Phone Number Format
SELECT caseid,number
FROM marston.laadefaultersphones_20241203
WHERE json_footer IS NULL
  AND number IS NOT NULL
  AND number !~ '^[0-9+\-\s()]{7,15}$';  -- Basic phone number format



/*********** defaulterwelfare table ***********/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN defaulterid IS NULL OR defaulterid = 'NULL' THEN 1 ELSE 0 END) AS defaulterid_nulls,
    SUM(CASE WHEN welfarerecordid IS NULL OR welfarerecordid = 'NULL' THEN 1 ELSE 0 END) AS welfarerecordid_nulls,
    SUM(CASE WHEN loadedon IS NULL OR loadedon = 'NULL' THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls,
    SUM(CASE WHEN welfarecategory IS NULL OR welfarecategory = 'NULL' THEN 1 ELSE 0 END) AS welfarecategory_nulls,
    SUM(CASE WHEN proofprovided IS NULL OR proofprovided = 'NULL' THEN 1 ELSE 0 END) AS proofprovided_nulls,
    SUM(CASE WHEN note IS NULL OR note = 'NULL' THEN 1 ELSE 0 END) AS note_nulls
FROM marston.laadefaulterswelfare_20241203
WHERE json_footer IS NULL;


-- Date Range Check
SELECT 
    MIN(loadedon) AS min_loadedon, 
    MAX(loadedon) AS max_loadedon
FROM marston.laadefaulterswelfare_20241203
WHERE json_footer IS NULL;



/**************** LACESCASES TABLE ********************/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN lacescaseid IS NULL OR lacescaseid = 'NULL' THEN 1 ELSE 0 END) AS lacescaseid_nulls,
    SUM(CASE WHEN casestatus IS NULL OR casestatus = 'NULL' THEN 1 ELSE 0 END) AS casestatus_nulls,
    SUM(CASE WHEN lastupdate IS NULL /*OR lastupdate = 'NULL'*/ THEN 1 ELSE 0 END) AS lastupdate_nulls,
    SUM(CASE WHEN issuesource IS NULL OR issuesource = 'NULL' THEN 1 ELSE 0 END) AS issuesource_nulls,
    SUM(CASE WHEN jointcreditagreementexists IS NULL OR jointcreditagreementexists = 'NULL' THEN 1 ELSE 0 END) AS jointcreditagreementexists_nulls,
    SUM(CASE WHEN projectedcreditscore IS NULL OR projectedcreditscore = 'NULL' THEN 1 ELSE 0 END) AS projectedcreditscore_nulls,
    SUM(CASE WHEN isfoundcreditpositionconsistentwithdeclared IS NULL OR isfoundcreditpositionconsistentwithdeclared = 'NULL' THEN 1 ELSE 0 END) AS isfoundcreditpositionconsistentwithdeclared_nulls,
    SUM(CASE WHEN wasuploadedmanually IS NULL OR wasuploadedmanually = 'NULL' THEN 1 ELSE 0 END) AS wasuploadedmanually_nulls
FROM marston.laalacescases_20241203
WHERE json_footer IS NULL;


-- Date Range Check for lastupdate
SELECT 
    MIN(lastupdate) AS min_lastupdate, 
    MAX(lastupdate) AS max_lastupdate
FROM marston.laalacescases_20241203
WHERE json_footer IS NULL;


/********** LACESCASESACTIONS TABLE ******/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN recordid IS NULL OR recordid = 'NULL' THEN 1 ELSE 0 END) AS recordid_nulls,
    SUM(CASE WHEN lacescaseid IS NULL OR lacescaseid = 'NULL' THEN 1 ELSE 0 END) AS lacescaseid_nulls,
    SUM(CASE WHEN changedate IS NULL THEN 1 ELSE 0 END) AS changedate_nulls,
    SUM(CASE WHEN actiontype IS NULL OR actiontype = 'NULL' THEN 1 ELSE 0 END) AS actiontype_nulls,
    SUM(CASE WHEN description IS NULL OR description = 'NULL' THEN 1 ELSE 0 END) AS description_nulls,
    SUM(CASE WHEN newstatus IS NULL OR newstatus = 'NULL' THEN 1 ELSE 0 END) AS newstatus_nulls
FROM marston.laalacescasesactions_20241203
WHERE json_footer IS NULL;



-- Date Range Check for changedate
SELECT 
    MIN(changedate) AS min_changedate, 
    MAX(changedate) AS max_changedate
FROM marston.laalacescasesactions_20241203
WHERE json_footer IS NULL;


/************ lacesdatawarehouse TABLE ************/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN recordid IS NULL OR recordid = 'NULL' THEN 1 ELSE 0 END) AS recordid_nulls,
    SUM(CASE WHEN lacescaseid IS NULL OR lacescaseid = 'NULL' THEN 1 ELSE 0 END) AS lacescaseid_nulls,
    SUM(CASE WHEN debtorid IS NULL OR debtorid = 'NULL' THEN 1 ELSE 0 END) AS debtorid_nulls,
    SUM(CASE WHEN maatid IS NULL OR maatid = 'NULL' THEN 1 ELSE 0 END) AS maatid_nulls,
    SUM(CASE WHEN loadedon IS NULL /*OR loadedon = 'NULL' */ THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN firstname IS NULL OR firstname = 'NULL' THEN 1 ELSE 0 END) AS firstname_nulls,
    SUM(CASE WHEN lastname IS NULL OR lastname = 'NULL' THEN 1 ELSE 0 END) AS lastname_nulls,
    SUM(CASE WHEN dob IS NULL OR dob = 'NULL' THEN 1 ELSE 0 END) AS dob_nulls,
    SUM(CASE WHEN haspartner IS NULL OR haspartner = 'NULL' THEN 1 ELSE 0 END) AS haspartner_nulls,
    SUM(CASE WHEN haspartnercontraryinterest IS NULL OR haspartnercontraryinterest = 'NULL' THEN 1 ELSE 0 END) AS haspartnercontraryinterest_nulls,
    SUM(CASE WHEN partnerfirstname IS NULL OR partnerfirstname = 'NULL' THEN 1 ELSE 0 END) AS partnerfirstname_nulls,
    SUM(CASE WHEN partnerlastname IS NULL OR partnerlastname = 'NULL' THEN 1 ELSE 0 END) AS partnerlastname_nulls,
    SUM(CASE WHEN totalavailablecapitalassets IS NULL OR totalavailablecapitalassets = 'NULL' THEN 1 ELSE 0 END) AS totalavailablecapitalassets_nulls,
    SUM(CASE WHEN allevidencedate IS NULL OR allevidencedate = 'NULL' THEN 1 ELSE 0 END) AS allevidencedate_nulls,
    SUM(CASE WHEN numberofavailablecapitalassets IS NULL OR numberofavailablecapitalassets = 'NULL' THEN 1 ELSE 0 END) AS numberofavailablecapitalassets_nulls,
    SUM(CASE WHEN isallevidenceprovided IS NULL OR isallevidenceprovided = 'NULL' THEN 1 ELSE 0 END) AS isallevidenceprovided_nulls,
    SUM(CASE WHEN issufficientcapitalandequity IS NULL OR issufficientcapitalandequity = 'NULL' THEN 1 ELSE 0 END) AS issusufficientcapitalandequity_nulls,
    SUM(CASE WHEN casecap IS NULL OR casecap = 'NULL' THEN 1 ELSE 0 END) AS casecap_nulls,
    SUM(CASE WHEN equityverifieddate IS NULL OR equityverifieddate = 'NULL' THEN 1 ELSE 0 END) AS equityverifieddate_nulls
FROM marston.laalacesdatawarehouse_20241203
WHERE json_footer IS NULL;


-- Date Range Check for dob, loadedon, allevidencedate, and equityverifieddate
SELECT 
    MIN(CASE WHEN dob IS NOT NULL AND dob <> 'NULL' THEN dob END) AS min_dob, 
    MAX(CASE WHEN dob IS NOT NULL AND dob <> 'NULL' THEN dob END) AS max_dob,
    
    MIN(CASE WHEN loadedon IS NOT NULL THEN loadedon END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL THEN loadedon END) AS max_loadedon,
    
    MIN(CASE WHEN allevidencedate IS NOT NULL AND allevidencedate <> 'NULL' THEN allevidencedate END) AS min_allevidencedate, 
    MAX(CASE WHEN allevidencedate IS NOT NULL AND allevidencedate <> 'NULL' THEN allevidencedate END) AS max_allevidencedate,
    
    MIN(CASE WHEN equityverifieddate IS NOT NULL AND equityverifieddate <> 'NULL' THEN equityverifieddate END) AS min_equityverifieddate, 
    MAX(CASE WHEN equityverifieddate IS NOT NULL AND equityverifieddate <> 'NULL' THEN equityverifieddate END) AS max_equityverifieddate
FROM marston.laalacesdatawarehouse_20241203
WHERE json_footer IS NULL;


-- Valid Format Check for totalavailablecapitalassets (Check for numeric values)
SELECT totalavailablecapitalassets
FROM marston.laalacesdatawarehouse_20241203
WHERE json_footer IS NULL
  AND totalavailablecapitalassets IS NOT NULL and totalavailablecapitalassets <> 'NULL'
  AND totalavailablecapitalassets !~ '^[0-9]+(\.[0-9]+)?$';  -- Matches valid numeric format


-- Numeric Range Check for totalavailablecapitalassets, numberofavailablecapitalassets, and casecap
SELECT 
    MIN(CAST(totalavailablecapitalassets AS NUMERIC)) AS min_totalavailablecapitalassets, 
    MAX(CAST(totalavailablecapitalassets AS NUMERIC)) AS max_totalavailablecapitalassets,
    
    MIN(CAST(numberofavailablecapitalassets AS NUMERIC)) AS min_numberofavailablecapitalassets, 
    MAX(CAST(numberofavailablecapitalassets AS NUMERIC)) AS max_numberofavailablecapitalassets,
    
    MIN(CAST(casecap AS NUMERIC)) AS min_casecap, 
    MAX(CAST(casecap AS NUMERIC)) AS max_casecap
FROM marston.laalacesdatawarehouse_20241203
WHERE json_footer IS NULL
  AND totalavailablecapitalassets ~ '^[0-9]+(\.[0-9]+)?$'  -- Ensures valid numeric format
  AND numberofavailablecapitalassets ~ '^[0-9]+(\.[0-9]+)?$'  -- Ensures valid numeric format
  AND casecap ~ '^[0-9]+(\.[0-9]+)?$';  -- Ensures valid numeric format

/*************** laalacesexperianassociations_20241203 ******/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN experianassociationsrecordid IS NULL OR experianassociationsrecordid = 'NULL' THEN 1 ELSE 0 END) AS experianassociationsrecordid_nulls,
    SUM(CASE WHEN experianentriesrecordid IS NULL OR experianentriesrecordid = 'NULL' THEN 1 ELSE 0 END) AS experianentriesrecordid_nulls,
    SUM(CASE WHEN linkedname IS NULL OR linkedname = 'NULL' THEN 1 ELSE 0 END) AS linkedname_nulls,
    SUM(CASE WHEN isignored IS NULL OR isignored = 'NULL' THEN 1 ELSE 0 END) AS isignored_nulls
FROM marston.laalacesexperianassociations_20241203
WHERE json_footer IS NULL;


-- Valid Format Check for linkedname (allows letters, spaces, hyphens, and apostrophes)
SELECT linkedname
FROM marston.laalacesexperianassociations_20241203
WHERE json_footer IS NULL
  AND linkedname IS NOT NULL
  AND linkedname !~ '^[A-Za-z\s\''''\-]+$';  -- Allows letters, spaces, apostrophes, and hyphens

-- Valid Format Check for isignored (Ensure boolean values are valid, assuming 'Y'/'N' or 'true'/'false')
SELECT isignored
FROM marston.laalacesexperianassociations_20241203
WHERE json_footer IS NULL
  AND isignored NOT IN ('1', '0');  



/*********** lacesexperianentries ************/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN recordid IS NULL OR recordid = 'NULL' THEN 1 ELSE 0 END) AS recordid_nulls,
    SUM(CASE WHEN lacescaseid IS NULL OR lacescaseid = 'NULL' THEN 1 ELSE 0 END) AS lacescaseid_nulls,
    SUM(CASE WHEN lastupdatedate IS NULL /*OR lastupdatedate = 'NULL'*/ THEN 1 ELSE 0 END) AS lastupdatedate_nulls,
    SUM(CASE WHEN yearsatcurrentaddress IS NULL OR yearsatcurrentaddress = 'NULL' THEN 1 ELSE 0 END) AS yearsatcurrentaddress_nulls,
    SUM(CASE WHEN monthsatcurrentaddress IS NULL OR monthsatcurrentaddress = 'NULL' THEN 1 ELSE 0 END) AS monthsatcurrentaddress_nulls,
    SUM(CASE WHEN residencyscore IS NULL OR residencyscore = 'NULL' THEN 1 ELSE 0 END) AS residencyscore_nulls,
    SUM(CASE WHEN isbankrupt IS NULL OR isbankrupt = 'NULL' THEN 1 ELSE 0 END) AS isbankrupt_nulls,
    SUM(CASE WHEN hasccj IS NULL OR hasccj = 'NULL' THEN 1 ELSE 0 END) AS hasccj_nulls,
    SUM(CASE WHEN hasiva IS NULL OR hasiva = 'NULL' THEN 1 ELSE 0 END) AS hasiva_nulls,
    SUM(CASE WHEN propensitytopayscore IS NULL OR propensitytopayscore = 'NULL' THEN 1 ELSE 0 END) AS propensitytopayscore_nulls,
    SUM(CASE WHEN utdaccountscount IS NULL OR utdaccountscount = 'NULL' THEN 1 ELSE 0 END) AS utdaccountscount_nulls,
    SUM(CASE WHEN notutdaccountscount IS NULL OR notutdaccountscount = 'NULL' THEN 1 ELSE 0 END) AS notutdaccountscount_nulls,
    SUM(CASE WHEN bankaccountscount IS NULL OR bankaccountscount = 'NULL' THEN 1 ELSE 0 END) AS bankaccountscount_nulls
FROM marston.laalacesexperianentries_20241203
WHERE json_footer IS NULL;


-- Date Range Check for lastupdate (handling 'NULL' as text)
SELECT 
    MIN(CASE WHEN lastupdatedate IS NOT NULL  THEN lastupdatedate END) AS min_lastupdate, 
    MAX(CASE WHEN lastupdatedate IS NOT NULL  THEN lastupdatedate END) AS max_lastupdate
FROM marston.laalacesexperianentries_20241203
WHERE json_footer IS NULL;

-- Numeric Range Check for yearsatcurrentaddress, monthsatcurrentaddress, residencyscore, propensitytopayscore, utdaccountscount, notutdaccountscount, and bankaccountscount
SELECT 
    MIN(CAST(yearsatcurrentaddress AS NUMERIC)) AS min_yearsatcurrentaddress, 
    MAX(CAST(yearsatcurrentaddress AS NUMERIC)) AS max_yearsatcurrentaddress,

    MIN(CAST(monthsatcurrentaddress AS NUMERIC)) AS min_monthsatcurrentaddress, 
    MAX(CAST(monthsatcurrentaddress AS NUMERIC)) AS max_monthsatcurrentaddress,

    MIN(CAST(residencyscore AS NUMERIC)) AS min_residencyscore, 
    MAX(CAST(residencyscore AS NUMERIC)) AS max_residencyscore,

    MIN(CAST(propensitytopayscore AS NUMERIC)) AS min_propensitytopayscore, 
    MAX(CAST(propensitytopayscore AS NUMERIC)) AS max_propensitytopayscore,

    MIN(CAST(utdaccountscount AS NUMERIC)) AS min_utdaccountscount, 
    MAX(CAST(utdaccountscount AS NUMERIC)) AS max_utdaccountscount,

    MIN(CAST(notutdaccountscount AS NUMERIC)) AS min_notutdaccountscount, 
    MAX(CAST(notutdaccountscount AS NUMERIC)) AS max_notutdaccountscount,

    MIN(CAST(bankaccountscount AS NUMERIC)) AS min_bankaccountscount, 
    MAX(CAST(bankaccountscount AS NUMERIC)) AS max_bankaccountscount
FROM marston.laalacesexperianentries_20241203
WHERE json_footer IS NULL
  AND yearsatcurrentaddress ~ '^[0-9]+(\.[0-9]+)?$'  -- Ensure valid numeric format
  AND monthsatcurrentaddress ~ '^[0-9]+(\.[0-9]+)?$'
  AND residencyscore ~ '^[0-9]+(\.[0-9]+)?$'
  AND propensitytopayscore ~ '^[0-9]+(\.[0-9]+)?$'
  AND utdaccountscount ~ '^[0-9]+(\.[0-9]+)?$'
  AND notutdaccountscount ~ '^[0-9]+(\.[0-9]+)?$'
  AND bankaccountscount ~ '^[0-9]+(\.[0-9]+)?$';



  /*********** laalacesexperianmortgageentries_20241203.  *******/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN recordid IS NULL OR recordid = 'NULL' THEN 1 ELSE 0 END) AS recordid_nulls,
    SUM(CASE WHEN mortgage IS NULL OR mortgage = 'NULL' THEN 1 ELSE 0 END) AS mortgage_nulls,
    SUM(CASE WHEN experianentryid IS NULL OR experianentryid = 'NULL' THEN 1 ELSE 0 END) AS experianentryid_nulls,
    SUM(CASE WHEN propertyid IS NULL OR propertyid = 'NULL' THEN 1 ELSE 0 END) AS propertyid_nulls
FROM marston.laalacesexperianmortgageentries_20241203
WHERE json_footer IS NULL;

-- Valid Format Check for mortgage (Check if mortgage is a valid numeric field)
SELECT mortgage
FROM marston.laalacesexperianmortgageentries_20241203
WHERE json_footer IS NULL
  AND mortgage IS NOT NULL
  AND mortgage !~ '^[0-9]+(\.[0-9]+)?$';  -- Only allows valid numeric format

-- Valid Format Check for experianentryid and propertyid (Ensure these fields follow a valid alphanumeric format)
SELECT experianentryid, propertyid
FROM marston.laalacesexperianmortgageentries_20241203
WHERE json_footer IS NULL
  AND (experianentryid IS NOT NULL AND experianentryid !~ '^[A-Za-z0-9\-]+$')  -- Allows alphanumeric characters and hyphens
  OR (propertyid IS NOT NULL AND propertyid !~ '^[A-Za-z0-9\-]+$');  -- Allows alphanumeric characters and hyphens


-- Numeric Range Check for mortgage (Assuming mortgage amount should be between 0 and 10,000,000)
SELECT 
    MIN(CAST(mortgage AS NUMERIC)) AS min_mortgage, 
    MAX(CAST(mortgage AS NUMERIC)) AS max_mortgage
FROM marston.laalacesexperianmortgageentries_20241203
WHERE json_footer IS NULL
  AND mortgage ~ '^[0-9]+(\.[0-9]+)?$'  -- Ensure valid numeric format
  AND CAST(mortgage AS NUMERIC) BETWEEN 0 AND 10000000;  -- Modify range as needed



/********** laceslandregistryassociations table ***********/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN recordid IS NULL OR recordid = 'NULL' THEN 1 ELSE 0 END) AS recordid_nulls,
    SUM(CASE WHEN landregistryentryid IS NULL /*OR landregistryentryid = 'NULL' */ THEN 1 ELSE 0 END) AS landregistryentryid_nulls,
    SUM(CASE WHEN proprietor IS NULL OR proprietor = 'NULL' THEN 1 ELSE 0 END) AS proprietor_nulls,
    SUM(CASE WHEN isignored IS NULL OR isignored = 'NULL' THEN 1 ELSE 0 END) AS isignored_nulls
FROM marston.laalaceslandregistryassociations_20241203
WHERE json_footer IS NULL;


-- Format Check for proprietor (allows letters, spaces, apostrophes, hyphens, parentheses, ampersands, and numbers)
SELECT proprietor
FROM marston.laalaceslandregistryassociations_20241203
WHERE json_footer IS NULL
  AND proprietor IS NOT NULL
  AND proprietor !~ '^[A-Za-z0-9 \''''\-&().]+$';  -- Allows letters, numbers, spaces, apostrophes, hyphens, parentheses, and ampersands


-- Format Check for landregistryentryid (Allows alphanumeric characters and hyphens)
SELECT landregistryentryid
FROM marston.laalaceslandregistryassociations_20241203
WHERE json_footer IS NULL
  AND landregistryentryid IS NOT NULL
  AND CAST(landregistryentryid AS TEXT) !~ '^[A-Za-z0-9\-]+$';  -- Allows alphanumeric characters and hyphens

-- Boolean Check for isignored (Ensure isignored contains valid boolean values, assuming 'Y'/'N' or 'true'/'false')
SELECT isignored
FROM marston.laalaceslandregistryassociations_20241203
WHERE json_footer IS NULL
  AND isignored NOT IN ('1', '0');  



/********** laalaceslandregistryentries_20241203 **********/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN recordid IS NULL /*OR recordid = 'NULL' */ THEN 1 ELSE 0 END) AS recordid_nulls,
    SUM(CASE WHEN propertyid IS NULL /*OR propertyid = 'NULL'*/ THEN 1 ELSE 0 END) AS propertyid_nulls,
    SUM(CASE WHEN lastupdatedate IS NULL OR lastupdatedate = 'NULL' THEN 1 ELSE 0 END) AS lastupdatedate_nulls,
    SUM(CASE WHEN namematchresult IS NULL OR namematchresult = 'NULL' THEN 1 ELSE 0 END) AS namematchresult_nulls
FROM marston.laalaceslandregistryentries_20241203
WHERE json_footer IS NULL;


-- Date Range Check for lastupdatedate
SELECT 
    MIN(CASE WHEN lastupdatedate IS NOT NULL AND lastupdatedate <> 'NULL' THEN lastupdatedate END) AS min_lastupdatedate, 
    MAX(CASE WHEN lastupdatedate IS NOT NULL AND lastupdatedate <> 'NULL' THEN lastupdatedate END) AS max_lastupdatedate
FROM marston.laalaceslandregistryentries_20241203
WHERE json_footer IS NULL;

-- Format Check for propertyid (Alphanumeric format check)
SELECT propertyid
FROM marston.laalaceslandregistryentries_20241203
WHERE json_footer IS NULL
  AND propertyid IS NOT NULL
  AND CAST(propertyid AS TEXT) !~ '^[A-Za-z0-9\-]+$';  -- Allows alphanumeric characters and hyphens



/************ laalacesproperties table ***********/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN recordid IS NULL /*OR recordid = 'NULL'*/ THEN 1 ELSE 0 END) AS recordid_nulls,
    SUM(CASE WHEN lacescaseid IS NULL OR lacescaseid = 'NULL' THEN 1 ELSE 0 END) AS lacescaseid_nulls,
    SUM(CASE WHEN residentialdescription IS NULL OR residentialdescription = 'NULL' THEN 1 ELSE 0 END) AS residentialdescription_nulls,
    SUM(CASE WHEN declaredvalue IS NULL OR declaredvalue = 'NULL' THEN 1 ELSE 0 END) AS declaredvalue_nulls,
    SUM(CASE WHEN declaredmortgage IS NULL OR declaredmortgage = 'NULL' THEN 1 ELSE 0 END) AS declaredmortgage_nulls,
    SUM(CASE WHEN verifiedvalue IS NULL OR verifiedvalue = 'NULL' THEN 1 ELSE 0 END) AS verifiedvalue_nulls,
    SUM(CASE WHEN verifiedmortgage IS NULL OR verifiedmortgage = 'NULL' THEN 1 ELSE 0 END) AS verifiedmortgage_nulls,
    SUM(CASE WHEN verifieddate IS NULL OR verifieddate = 'NULL' THEN 1 ELSE 0 END) AS verifieddate_nulls,
    SUM(CASE WHEN percentageownedapplicant IS NULL OR percentageownedapplicant = 'NULL' THEN 1 ELSE 0 END) AS percentageownedapplicant_nulls,
    SUM(CASE WHEN percentageownedpartner IS NULL OR percentageownedpartner = 'NULL' THEN 1 ELSE 0 END) AS percentageownedpartner_nulls,
    SUM(CASE WHEN addressline1 IS NULL OR addressline1 = 'NULL' THEN 1 ELSE 0 END) AS addressline1_nulls,
    SUM(CASE WHEN postcode IS NULL OR postcode = 'NULL' THEN 1 ELSE 0 END) AS postcode_nulls
FROM marston.laalacesproperties_20241203
WHERE json_footer IS NULL;

-- Date Range Check for verifieddate -- obs27
SELECT 
    MIN(CASE WHEN verifieddate IS NOT NULL AND verifieddate <> 'NULL' THEN verifieddate END) AS min_verifieddate, 
    MAX(CASE WHEN verifieddate IS NOT NULL AND verifieddate <> 'NULL' THEN verifieddate END) AS max_verifieddate
FROM marston.laalacesproperties_20241203
WHERE json_footer IS NULL;

-- Numeric Range Check for declaredvalue, declaredmortgage, verifiedvalue, verifiedmortgage, percentageownedapplicant, percentageownedpartner
SELECT 
    MIN(CAST(declaredvalue AS NUMERIC)) AS min_declaredvalue, 
    MAX(CAST(declaredvalue AS NUMERIC)) AS max_declaredvalue,
    
    MIN(CAST(declaredmortgage AS NUMERIC)) AS min_declaredmortgage, 
    MAX(CAST(declaredmortgage AS NUMERIC)) AS max_declaredmortgage,

    MIN(CAST(verifiedvalue AS NUMERIC)) AS min_verifiedvalue, 
    MAX(CAST(verifiedvalue AS NUMERIC)) AS max_verifiedvalue,

    MIN(CAST(verifiedmortgage AS NUMERIC)) AS min_verifiedmortgage, 
    MAX(CAST(verifiedmortgage AS NUMERIC)) AS max_verifiedmortgage,

    MIN(CAST(percentageownedapplicant AS NUMERIC)) AS min_percentageownedapplicant, 
    MAX(CAST(percentageownedapplicant AS NUMERIC)) AS max_percentageownedapplicant,

    MIN(CAST(percentageownedpartner AS NUMERIC)) AS min_percentageownedpartner, 
    MAX(CAST(percentageownedpartner AS NUMERIC)) AS max_percentageownedpartner
FROM marston.laalacesproperties_20241203
WHERE json_footer IS NULL
  AND declaredvalue ~ '^[0-9]+(\.[0-9]+)?$'  -- Valid numeric format check
  AND declaredmortgage ~ '^[0-9]+(\.[0-9]+)?$'
  AND verifiedvalue ~ '^[0-9]+(\.[0-9]+)?$'
  AND verifiedmortgage ~ '^[0-9]+(\.[0-9]+)?$'
  AND percentageownedapplicant ~ '^[0-9]+(\.[0-9]+)?$'
  AND percentageownedpartner ~ '^[0-9]+(\.[0-9]+)?$';

-- Address Format Check (Check if address lines follow a valid format)
SELECT addressline1, addressline2, addressline3, postcode
FROM marston.laalacesproperties_20241203
WHERE json_footer IS NULL
  AND (
    addressline1 IS NOT NULL AND addressline1 !~ '^[A-Za-z0-9. \&/():'''',\-]+$'  -- Allows letters, numbers, spaces, apostrophes, commas, hyphens
    OR addressline2 IS NOT NULL AND addressline2 !~ '^[A-Za-z0-9.&/(): \'''',\-]+$'
    OR addressline3 IS NOT NULL AND addressline3 !~ '^[A-Za-z0-9.&/(): \'''',\-]+$'
	OR postcode IS NOT NULL AND postcode !~ '^[A-Za-z0-9. \-]+$'  -- Validates alphanumeric, periods, hyphens, and spaces for postcodes
  );


/******** caseadditionaldata *********/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN additionaldatarecordid IS NULL OR additionaldatarecordid = 'NULL' THEN 1 ELSE 0 END) AS additionaldatarecordid_nulls,
    SUM(CASE WHEN name IS NULL OR name = 'NULL' THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN value IS NULL OR value = 'NULL' THEN 1 ELSE 0 END) AS value_nulls,
    SUM(CASE WHEN loadedon IS NULL /*OR loadedon = 'NULL'*/ THEN 1 ELSE 0 END) AS loadedon_nulls
FROM marston.laacaseadditionaldata_20241203
WHERE json_footer IS NULL;

-- Date Range Check for loadedon
SELECT 
    MIN(CASE WHEN loadedon IS NOT NULL /*AND loadedon <> 'NULL'*/ THEN loadedon END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL /*AND loadedon <> 'NULL' */ THEN loadedon END) AS max_loadedon
FROM marston.laacaseadditionaldata_20241203
WHERE json_footer IS NULL;


/********* casearrangements table *********/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN arrangementid IS NULL OR arrangementid = 'NULL' THEN 1 ELSE 0 END) AS arrangementid_nulls,
    SUM(CASE WHEN arrangementreference IS NULL OR arrangementreference = 'NULL' THEN 1 ELSE 0 END) AS arrangementreference_nulls,
    SUM(CASE WHEN setupdate IS NULL /*OR setupdate = 'NULL'*/ THEN 1 ELSE 0 END) AS setupdate_nulls,
    SUM(CASE WHEN firstinstalmentamount IS NULL OR firstinstalmentamount = 'NULL' THEN 1 ELSE 0 END) AS firstinstalmentamount_nulls,
    SUM(CASE WHEN firstinstalmentdate IS NULL OR firstinstalmentdate = 'NULL' THEN 1 ELSE 0 END) AS firstinstalmentdate_nulls,
    SUM(CASE WHEN subsequentinstalmentamounts IS NULL OR subsequentinstalmentamounts = 'NULL' THEN 1 ELSE 0 END) AS subsequentinstalmentamounts_nulls,
    SUM(CASE WHEN numberofinstalments IS NULL OR numberofinstalments = 'NULL' THEN 1 ELSE 0 END) AS numberofinstalments_nulls,
    SUM(CASE WHEN instalmentfrequency IS NULL OR instalmentfrequency = 'NULL' THEN 1 ELSE 0 END) AS instalmentfrequency_nulls,
    SUM(CASE WHEN status IS NULL OR status = 'NULL' THEN 1 ELSE 0 END) AS status_nulls,
    SUM(CASE WHEN statusdate IS NULL OR statusdate = 'NULL' THEN 1 ELSE 0 END) AS statusdate_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls
FROM marston.laacasearrangements_20241203
WHERE json_footer IS NULL;

-- Date Range Check for setupdate, firstinstalmentdate, and statusdate
SELECT 
    MIN(CASE WHEN setupdate IS NOT NULL /*AND setupdate <> 'NULL'*/ THEN setupdate END) AS min_setupdate, 
    MAX(CASE WHEN setupdate IS NOT NULL /*AND setupdate <> 'NULL' */ THEN setupdate END) AS max_setupdate,
    MIN(CASE WHEN firstinstalmentdate IS NOT NULL AND firstinstalmentdate <> 'NULL' THEN firstinstalmentdate END) AS min_firstinstalmentdate, 
    MAX(CASE WHEN firstinstalmentdate IS NOT NULL AND firstinstalmentdate <> 'NULL' THEN firstinstalmentdate END) AS max_firstinstalmentdate,
    MIN(CASE WHEN statusdate IS NOT NULL AND statusdate <> 'NULL' THEN statusdate END) AS min_statusdate, 
    MAX(CASE WHEN statusdate IS NOT NULL AND statusdate <> 'NULL' THEN statusdate END) AS max_statusdate
FROM marston.laacasearrangements_20241203
WHERE json_footer IS NULL;

-- Numeric Range Check for amounts and number of instalments
SELECT 
    MIN(CAST(firstinstalmentamount AS numeric)) AS min_firstinstalmentamount, 
    MAX(CAST(firstinstalmentamount AS numeric)) AS max_firstinstalmentamount,
    MIN(CAST(subsequentinstalmentamounts AS numeric)) AS min_subsequentinstalmentamounts, 
    MAX(CAST(subsequentinstalmentamounts AS numeric)) AS max_subsequentinstalmentamounts,
    MIN(CAST(numberofinstalments AS numeric)) AS min_numberofinstalments, 
    MAX(CAST(numberofinstalments AS numeric)) AS max_numberofinstalments
FROM marston.laacasearrangements_20241203
WHERE json_footer IS NULL;

-- Format Check for status and arrangementreference
SELECT status, arrangementreference
FROM marston.laacasearrangements_20241203
WHERE json_footer IS NULL
  AND (
    status IS NOT NULL AND status !~ '^[A-Za-z0-9.&/():'' \-]+$'  -- Allows letters, numbers, spaces, apostrophes, ampersands, parentheses, hyphens, and periods
    OR arrangementreference IS NOT NULL AND arrangementreference !~ '^[A-Za-z0-9.&/():'' \-]+$'
  );


/********** laacaseassignments_20241203 ***********/
-- NULL and 'NULL' Values Check
-- This is now excluded from migration scope, no need to check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN commentrecordid IS NULL OR commentrecordid = 'NULL' THEN 1 ELSE 0 END) AS commentrecordid_nulls,
    SUM(CASE WHEN loadedon IS NULL /* OR loadedon = 'NULL' */ THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN comment IS NULL OR comment = 'NULL' THEN 1 ELSE 0 END) AS comment_nulls,
    SUM(CASE WHEN action IS NULL OR action = 'NULL' THEN 1 ELSE 0 END) AS action_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls
FROM marston.laacaseassignments_20241203
WHERE json_footer IS NULL;

-- Date Range Check for loadedon
SELECT 
    MIN(CASE WHEN loadedon IS NOT NULL THEN loadedon END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL  THEN loadedon END) AS max_loadedon
FROM marston.laacaseassignments_20241203
WHERE json_footer IS NULL;



/******** caseattachments *********/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_nulls,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN attachmentsrecordid IS NULL OR attachmentsrecordid = 'NULL' THEN 1 ELSE 0 END) AS attachmentsrecordid_nulls,
    SUM(CASE WHEN loadedon IS NULL  THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls,
    SUM(CASE WHEN name IS NULL OR name = 'NULL' THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN fullname IS NULL OR fullname = 'NULL' THEN 1 ELSE 0 END) AS fullname_nulls,
    SUM(CASE WHEN attachmenttype IS NULL OR attachmenttype = 'NULL' THEN 1 ELSE 0 END) AS attachmenttype_nulls
FROM marston.laacaseattachments
WHERE json_footer IS NULL;

-- Date Range Check for loadedon
SELECT 
    MIN(CASE WHEN loadedon IS NOT NULL AND loadedon <> 'NULL' THEN loadedon END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL AND loadedon <> 'NULL' THEN loadedon END) AS max_loadedon
FROM marston.laacaseattachments
WHERE json_footer IS NULL;



/*********** casehistory table *************/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN casehistoryrecordid IS NULL OR casehistoryrecordid = 'NULL' THEN 1 ELSE 0 END) AS casehistoryrecordid_nulls,
    SUM(CASE WHEN loadedon IS NULL THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN comment IS NULL OR comment = 'NULL' THEN 1 ELSE 0 END) AS comment_nulls,
    SUM(CASE WHEN notetype IS NULL OR notetype = 'NULL' THEN 1 ELSE 0 END) AS notetype_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls
FROM marston.laacasehistory_20241203
WHERE json_footer IS NULL;

-- Date Range Check for loadedon
SELECT 
    MIN(CASE WHEN loadedon IS NOT NULL  THEN loadedon END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL  THEN loadedon END) AS max_loadedon
FROM marston.laacasehistory_20241203
WHERE json_footer IS NULL;



/******* casecharges table ********/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN chargerecordid IS NULL OR chargerecordid = 'NULL' THEN 1 ELSE 0 END) AS chargerecordid_nulls,
    SUM(CASE WHEN schemechargeid IS NULL OR schemechargeid = 'NULL' THEN 1 ELSE 0 END) AS schemechargeid_nulls,
    SUM(CASE WHEN chargedescription IS NULL OR chargedescription = 'NULL' THEN 1 ELSE 0 END) AS chargedescription_nulls,
    SUM(CASE WHEN remitto IS NULL OR remitto = 'NULL' THEN 1 ELSE 0 END) AS remitto_nulls,
    SUM(CASE WHEN paidby IS NULL OR paidby = 'NULL' THEN 1 ELSE 0 END) AS paidby_nulls,
    SUM(CASE WHEN chargedate IS NULL  THEN 1 ELSE 0 END) AS chargedate_nulls,
    SUM(CASE WHEN chargeamount IS NULL OR chargeamount = 'NULL' THEN 1 ELSE 0 END) AS chargeamount_nulls,
    SUM(CASE WHEN vatamount IS NULL OR vatamount = 'NULL' THEN 1 ELSE 0 END) AS vatamount_nulls,
    SUM(CASE WHEN chargereverseddate IS NULL OR chargereverseddate = 'NULL' THEN 1 ELSE 0 END) AS chargereverseddate_nulls,
    SUM(CASE WHEN paidamount IS NULL OR paidamount = 'NULL' THEN 1 ELSE 0 END) AS paidamount_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls
FROM marston.laacasecharges_20241203
WHERE json_footer IS NULL;

-- Date Range Check for chargedate and chargereverseddate
SELECT 
    MIN(CASE WHEN chargedate IS NOT NULL THEN chargedate END) AS min_chargedate, 
    MAX(CASE WHEN chargedate IS NOT NULL THEN chargedate END) AS max_chargedate,
    MIN(CASE WHEN chargereverseddate IS NOT NULL AND chargereverseddate <> 'NULL' THEN chargereverseddate END) AS min_chargereverseddate, 
    MAX(CASE WHEN chargereverseddate IS NOT NULL AND chargereverseddate <> 'NULL' THEN chargereverseddate END) AS max_chargereverseddate
FROM marston.laacasecharges_20241203
WHERE json_footer IS NULL;

-- Numeric Range Check for chargeamount, vatamount, and paidamount
SELECT 
    MIN(CAST(chargeamount AS numeric)) AS min_chargeamount, 
    MAX(CAST(chargeamount AS numeric)) AS max_chargeamount,
    MIN(CAST(vatamount AS numeric)) AS min_vatamount, 
    MAX(CAST(vatamount AS numeric)) AS max_vatamount,
    MIN(CAST(paidamount AS numeric)) AS min_paidamount, 
    MAX(CAST(paidamount AS numeric)) AS max_paidamount
FROM marston.laacasecharges_20241203
WHERE json_footer IS NULL;

-- Format Check for chargedescription and remitto
SELECT chargedescription, remitto
FROM marston.laacasecharges_20241203
WHERE json_footer IS NULL
  AND (
    chargedescription IS NOT NULL AND chargedescription !~ '^[A-Za-z0-9.&/():'' \-]+$'  -- Allows letters, numbers, spaces, apostrophes, ampersands, parentheses, hyphens, and periods
    OR remitto IS NOT NULL AND remitto !~ '^[A-Za-z0-9.&/():'' \-]+$'
  );



/******* caselogs ********/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN casehistoryrecordid IS NULL OR casehistoryrecordid = 'NULL' THEN 1 ELSE 0 END) AS casehistoryrecordid_nulls,
    SUM(CASE WHEN loadedon IS NULL THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN comment IS NULL OR comment = 'NULL' THEN 1 ELSE 0 END) AS comment_nulls,
    SUM(CASE WHEN actiontype IS NULL OR actiontype = 'NULL' THEN 1 ELSE 0 END) AS actiontype_nulls
FROM marston.laacasecalllog_20241203
WHERE json_footer IS NULL;

-- Date Range Check for loadedon
SELECT 
    MIN(CASE WHEN loadedon IS NOT NULL THEN loadedon END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL THEN loadedon END) AS max_loadedon
FROM marston.laacasecalllog_20241203
WHERE json_footer IS NULL;


/****** caseholds table **********/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN holdrecordid IS NULL OR holdrecordid = 'NULL' THEN 1 ELSE 0 END) AS holdrecordid_nulls,
    SUM(CASE WHEN holddate IS NULL THEN 1 ELSE 0 END) AS holddate_nulls,
    SUM(CASE WHEN holduntildate IS NULL OR holduntildate = 'NULL' THEN 1 ELSE 0 END) AS holduntildate_nulls,
    SUM(CASE WHEN holdreason IS NULL OR holdreason = 'NULL' THEN 1 ELSE 0 END) AS holdreason_nulls,
    SUM(CASE WHEN recommencedon IS NULL OR recommencedon = 'NULL' THEN 1 ELSE 0 END) AS recommencedon_nulls,
    SUM(CASE WHEN recommencereason IS NULL OR recommencereason = 'NULL' THEN 1 ELSE 0 END) AS recommencereason_nulls
FROM marston.laacaseholds_20241203
WHERE json_footer IS NULL;

-- Date Range Check for holddate, holduntildate, and recommencedon
SELECT 
    MIN(CASE WHEN holddate IS NOT NULL  THEN holddate END) AS min_holddate, 
    MAX(CASE WHEN holddate IS NOT NULL  THEN holddate END) AS max_holddate,
    MIN(CASE WHEN holduntildate IS NOT NULL AND holduntildate <> 'NULL' THEN holduntildate END) AS min_holduntildate, 
    MAX(CASE WHEN holduntildate IS NOT NULL AND holduntildate <> 'NULL' THEN holduntildate END) AS max_holduntildate,
    MIN(CASE WHEN recommencedon IS NOT NULL AND recommencedon <> 'NULL' THEN recommencedon END) AS min_recommencedon, 
    MAX(CASE WHEN recommencedon IS NOT NULL AND recommencedon <> 'NULL' THEN recommencedon END) AS max_recommencedon
FROM marston.laacaseholds_20241203
WHERE json_footer IS NULL;

-- Format Check for holdreason and recommencereason
SELECT holdreason, recommencereason
FROM marston.laacaseholds_20241203
WHERE json_footer IS NULL
  AND (
    holdreason IS NOT NULL AND holdreason !~ '^[A-Za-z0-9.&/():'' \-]+$'  -- Allows letters, numbers, spaces, apostrophes, ampersands, parentheses, hyphens, and periods
    OR recommencereason IS NOT NULL AND recommencereason !~ '^[A-Za-z0-9.&/():'' \-]+$'
  );


/********* casenotes table ***********/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN casenotesrecordid IS NULL OR casenotesrecordid = 'NULL' THEN 1 ELSE 0 END) AS casenotesrecordid_nulls,
    SUM(CASE WHEN loadedon IS NULL THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN comment IS NULL OR comment = 'NULL' THEN 1 ELSE 0 END) AS comment_nulls,
    SUM(CASE WHEN notetype IS NULL OR notetype = 'NULL' THEN 1 ELSE 0 END) AS notetype_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls
FROM marston.laacasenotes_20241203
WHERE json_footer IS NULL;

-- Date Range Check for loadedon
SELECT 
    MIN(CASE WHEN loadedon IS NOT NULL THEN loadedon END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL THEN loadedon END) AS max_loadedon
FROM marston.laacasenotes_20241203
WHERE json_footer IS NULL;

-- Format Check for comment and notetype
SELECT comment, notetype
FROM marston.laacasenotes_20241203
WHERE json_footer IS NULL
  AND (
    comment IS NOT NULL AND comment !~ '^[A-Za-z0-9.&/():'' \-]+$'  -- Allows letters, numbers, spaces, apostrophes, ampersands, parentheses, hyphens, and periods
    OR notetype IS NOT NULL AND notetype !~ '^[A-Za-z0-9.&/():'' \-]+$'
  );




/********** caselinks ************/
-- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN linkid IS NULL OR linkid = 'NULL' THEN 1 ELSE 0 END) AS linkid_nulls,
    SUM(CASE WHEN linkedcaseid IS NULL OR linkedcaseid = 'NULL' THEN 1 ELSE 0 END) AS linkedcaseid_nulls,
    SUM(CASE WHEN linkedcasenumber IS NULL OR linkedcasenumber = 'NULL' THEN 1 ELSE 0 END) AS linkedcasenumber_nulls,
    SUM(CASE WHEN loadedon IS NULL THEN 1 ELSE 0 END) AS loadedon_nulls,
    SUM(CASE WHEN loadedby IS NULL OR loadedby = 'NULL' THEN 1 ELSE 0 END) AS loadedby_nulls
FROM marston.laacaselinks_20241203
WHERE json_footer IS NULL;

-- Date Range Check for loadedon
SELECT 
    MIN(CASE WHEN loadedon IS NOT NULL THEN loadedon END) AS min_loadedon, 
    MAX(CASE WHEN loadedon IS NOT NULL THEN loadedon END) AS max_loadedon
FROM marston.laacaselinks_20241203
WHERE json_footer IS NULL;

-- Format Check for casenumber, linkedcasenumber
SELECT casenumber, linkedcasenumber
FROM marston.laacaselinks_20241203
WHERE json_footer IS NULL
  AND (
    casenumber IS NOT NULL AND casenumber !~ '^[A-Za-z0-9.&/():'' \-]+$'  -- Allows letters, numbers, spaces, apostrophes, ampersands, parentheses, hyphens, and periods
    OR linkedcasenumber IS NOT NULL AND linkedcasenumber !~ '^[A-Za-z0-9.&/():'' \-]+$'
  );


  /************ casevisits table *************/
  -- NULL and 'NULL' Values Check
SELECT 
    COUNT(*) AS TOTALNUMBEROFROWS,
    SUM(CASE WHEN batch_id IS NULL OR batch_id = 'NULL' THEN 1 ELSE 0 END) AS batch_id_nulls,
    SUM(CASE WHEN caseid IS NULL OR caseid = 'NULL' THEN 1 ELSE 0 END) AS caseid_nulls,
    SUM(CASE WHEN casenumber IS NULL OR casenumber = 'NULL' THEN 1 ELSE 0 END) AS casenumber_nulls,
    SUM(CASE WHEN visitrecordid IS NULL OR visitrecordid = 'NULL' THEN 1 ELSE 0 END) AS visitrecordid_nulls,
    SUM(CASE WHEN visitdate IS NULL THEN 1 ELSE 0 END) AS visitdate_nulls,
    SUM(CASE WHEN actionid IS NULL OR actionid = 'NULL' THEN 1 ELSE 0 END) AS actionid_nulls,
    SUM(CASE WHEN action IS NULL OR action = 'NULL' THEN 1 ELSE 0 END) AS action_nulls
FROM marston.laacasevisits_20241203
WHERE json_footer IS NULL;

-- Date Range Check for visitdate
SELECT 
    MIN(CASE WHEN visitdate IS NOT NULL  THEN visitdate END) AS min_visitdate, 
    MAX(CASE WHEN visitdate IS NOT NULL THEN visitdate END) AS max_visitdate
FROM marston.laacasevisits_20241203
WHERE json_footer IS NULL;

-- Format Check for casenumber and action
SELECT casenumber, action
FROM marston.laacasevisits_20241203
WHERE json_footer IS NULL
  AND (
    casenumber IS NOT NULL AND casenumber !~ '^[A-Za-z0-9.&/():'' \-]+$'  -- Allows letters, numbers, spaces, apostrophes, ampersands, parentheses, hyphens, and periods
    OR action IS NOT NULL AND action !~ '^[A-Za-z0-9.&/():'' \-]+$'
  );

*/
