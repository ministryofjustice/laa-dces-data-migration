BEGIN
    -- Check LAACaseDetails
    RAISE NOTICE 'Checking LAACaseDetails...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacasedetails_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseDetails:';
            PERFORM *
            FROM marston.laacasedetails_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseDetails.';
    END;

    -- Check LAADefaulters
    RAISE NOTICE 'Checking LAADefaulters...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laadefaulters_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAADefaulters:';
            PERFORM *
            FROM marston.laadefaulters_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAADefaulters.';
    END;


    -- Check LAADefaultersContactAddresses
    RAISE NOTICE 'Checking LAADefaultersContactAddresses...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laadefaulterscontactaddresses_20250106 a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
				   LEFT JOIN marston.laadefaulters_20250106 AS c ON a.defaulterid = c.defaulterid
                   WHERE (b.caseid IS NULL OR c.defaulterid is NULL) AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAADefaultersContactAddresses:';
            PERFORM *
            FROM marston.laadefaulters_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
				   LEFT JOIN marston.laadefaulters_20250106 AS c ON a.defaulterid = c.defaulterid
                   WHERE (b.caseid IS NULL OR c.defaulterid is NULL) AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAADefaultersContactAddresses.';
    END;

	-- Check LAADefaultersEmails
	RAISE NOTICE 'Checking LAADefaultersEmails...';
	BEGIN
	    IF EXISTS (SELECT 1
	               FROM marston.laadefaultersemails_20250106 a
	               LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
	               LEFT JOIN marston.laadefaulters_20250106 AS c ON a.defaulterid = c.defaulterid
	               WHERE (b.caseid IS NULL OR c.defaulterid IS NULL) AND a.json_footer IS NULL) THEN
	        RAISE NOTICE 'Error: Orphaned records found in LAADefaultersEmails:';
	        PERFORM *
	        FROM marston.laadefaultersemails_20250106 AS a
	        LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
	        LEFT JOIN marston.laadefaulters_20250106 AS c ON a.defaulterid = c.defaulterid
	        WHERE (b.caseid IS NULL OR c.defaulterid IS NULL) AND a.json_footer IS NULL
	        ORDER BY b.loadedon DESC;
	    END IF;
	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE 'Error encountered while checking LAADefaultersEmails.';
	END;

	-- Check LAADefaultersPhones
	RAISE NOTICE 'Checking LAADefaultersPhones...';
	BEGIN
	    IF EXISTS (SELECT 1
	               FROM marston.laadefaultersphones_20250106 a
	               LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
	               LEFT JOIN marston.laadefaulters_20250106 AS c ON a.defaulterid = c.defaulterid
	               WHERE (b.caseid IS NULL OR c.defaulterid IS NULL) AND a.json_footer IS NULL) THEN
	        RAISE NOTICE 'Error: Orphaned records found in LAADefaultersPhones:';
	        PERFORM *
	        FROM marston.laadefaultersphones_20250106 AS a
	        LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
	        LEFT JOIN marston.laadefaulters_20250106 AS c ON a.defaulterid = c.defaulterid
	        WHERE (b.caseid IS NULL OR c.defaulterid IS NULL) AND a.json_footer IS NULL
	        ORDER BY b.loadedon DESC;
	    END IF;
	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE 'Error encountered while checking LAADefaultersPhones.';
	END;

	-- Check LAADefaultersContactAddressesAudit
	RAISE NOTICE 'Checking LAADefaultersContactAddressesAudit...';
	BEGIN
	    IF EXISTS (SELECT 1
	               FROM marston.laadefaulterscontactaddressesaudit_20250106 a
	               LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
	               LEFT JOIN marston.laadefaulters_20250106 AS c ON a.defaulterid = c.defaulterid
	               WHERE (b.caseid IS NULL OR c.defaulterid IS NULL) AND a.json_footer IS NULL) THEN
	        RAISE NOTICE 'Error: Orphaned records found in LAADefaultersContactAddressesAudit:';
	        PERFORM *
	        FROM marston.laadefaulterscontactaddressesaudit_20250106 AS a
	        LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
	        LEFT JOIN marston.laadefaulters_20250106 AS c ON a.defaulterid = c.defaulterid
	        WHERE (b.caseid IS NULL OR c.defaulterid IS NULL) AND a.json_footer IS NULL
	        ORDER BY b.loadedon DESC;
	    END IF;
	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE 'Error encountered while checking LAADefaultersContactAddressesAudit.';
	END;

	-- Check LAADefaultersEmailsAudit
	RAISE NOTICE 'Checking LAADefaultersEmailsAudit...';
	BEGIN
	    IF EXISTS (SELECT 1
	               FROM marston.laadefaultersemailsaudit_20250106 a
	               LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
	               LEFT JOIN marston.laadefaulters_20250106 AS c ON a.defaulterid = c.defaulterid
	               WHERE (b.caseid IS NULL OR c.defaulterid IS NULL) AND a.json_footer IS NULL) THEN
	        RAISE NOTICE 'Error: Orphaned records found in LAADefaultersEmailsAudit:';
	        PERFORM *
	        FROM marston.laadefaultersemailsaudit_20250106 AS a
	        LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
	        LEFT JOIN marston.laadefaulters_20250106 AS c ON a.defaulterid = c.defaulterid
	        WHERE (b.caseid IS NULL OR c.defaulterid IS NULL) AND a.json_footer IS NULL
	        ORDER BY b.loadedon DESC;
	    END IF;
	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE 'Error encountered while checking LAADefaultersEmailsAudit.';
	END;

	-- Check LAADefaultersPhonesAudit
	RAISE NOTICE 'Checking LAADefaultersPhonesAudit...';
	BEGIN
	    IF EXISTS (SELECT 1
	               FROM marston.laadefaultersphonesaudit_20250106 a
	               LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
	               LEFT JOIN marston.laadefaulters_20250106 AS c ON a.defaulterid = c.defaulterid
	               WHERE (b.caseid IS NULL OR c.defaulterid IS NULL) AND a.json_footer IS NULL) THEN
	        RAISE NOTICE 'Error: Orphaned records found in LAADefaultersPhonesAudit:';
	        PERFORM *
	        FROM marston.laadefaultersphonesaudit_20250106 AS a
	        LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
	        LEFT JOIN marston.laadefaulters_20250106 AS c ON a.defaulterid = c.defaulterid
	        WHERE (b.caseid IS NULL OR c.defaulterid IS NULL) AND a.json_footer IS NULL
	        ORDER BY b.loadedon DESC;
	    END IF;
	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE 'Error encountered while checking LAADefaultersPhonesAudit.';
	END;

    -- Check LAACaseCharges
    RAISE NOTICE 'Checking LAACaseCharges...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacasecharges_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseCharges:';
            PERFORM *
            FROM marston.laacasecharges_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseCharges.';
    END;

    -- Check LAACasePayments
    RAISE NOTICE 'Checking LAACasePayments...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacasepayments_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACasePayments:';
            PERFORM *
            FROM marston.laacasepayments_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACasePayments.';
    END;

    -- Check LAACaseArrangements
    RAISE NOTICE 'Checking LAACaseArrangements...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacasearrangements_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseArrangements:';
            PERFORM *
            FROM marston.laacasearrangements_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseArrangements.';
    END;

    -- Check LAACaseAssignments
    RAISE NOTICE 'Checking LAACaseAssignments...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacaseassignments_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseAssignments:';
            PERFORM *
            FROM marston.laacaseassignments_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseAssignments.';
    END;

    -- Check LAACaseHolds
    RAISE NOTICE 'Checking LAACaseHolds...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacaseholds_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseHolds:';
            PERFORM *
            FROM marston.laacaseholds_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseHolds.';
    END;

    -- Check LAACaseVisits
    RAISE NOTICE 'Checking LAACaseVisits...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacasevisits_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseVisits:';
            PERFORM *
            FROM marston.laacasevisits_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseVisits.';
    END;

    -- Check LAACaseAdditionalData
    RAISE NOTICE 'Checking LAACaseAdditionalData...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacaseadditionaldata_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseAdditionalData:';
            PERFORM *
            FROM marston.laacaseadditionaldata_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseAdditionalData.';
    END;

    -- Check LAACaseAttachments
    RAISE NOTICE 'Checking LAACaseAttachments...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacaseattachments_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseAttachments:';
            PERFORM *
            FROM marston.laacaseattachments_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseAttachments.';
    END;

    -- Check LAACaseLinks
    RAISE NOTICE 'Checking LAACaseLinks...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacaselinks_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseLinks:';
            PERFORM *
            FROM marston.laacaselinks_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseLinks.';
    END;

    -- Check LAACaseNotes
    RAISE NOTICE 'Checking LAACaseNotes...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacasenotes_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseNotes:';
            PERFORM *
            FROM marston.laacasenotes_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseNotes.';
    END;

    -- Check LAACaseHistory
    RAISE NOTICE 'Checking LAACaseHistory...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacasehistory_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseHistory:';
            PERFORM *
            FROM marston.laacasehistory_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseHistory.';
    END;

    -- Check LAACaseWorkflow
    RAISE NOTICE 'Checking LAACaseWorkflow...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacaseworkflow_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseWorkflow:';
            PERFORM *
            FROM marston.laacaseworkflow_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseWorkflow.';
    END;

    -- Check LAACaseCallLog
    RAISE NOTICE 'Checking LAACaseCallLog...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacasecalllog_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseCallLog:';
            PERFORM *
            FROM marston.laacasecalllog_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseCallLog.';
    END;

    -- Check LAACaseBalance
    RAISE NOTICE 'Checking LAACaseBalance...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacasebalance_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseBalance:';
            PERFORM *
            FROM marston.laacasebalance_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseBalance.';
    END;

    -- Check LAACaseRefunds
    RAISE NOTICE 'Checking LAACaseRefunds...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laacaserefunds_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAACaseRefunds:';
            PERFORM *
            FROM marston.laacaserefunds_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAACaseRefunds.';
    END;

    -- Check LAADefaultersWelfare
    RAISE NOTICE 'Checking LAADefaultersWelfare...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laadefaulterswelfare_20250106 AS a
                   LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAADefaultersWelfare:';
            PERFORM *
            FROM marston.laadefaulterswelfare_20250106 AS a
            LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAADefaultersWelfare.';
    END;

    -- Check LAALACESDataWarehouse.MAATID to LAACaseDetails.ClientCaseReference
    RAISE NOTICE 'Checking LAALACESDataWarehouse...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laalacesdatawarehouse_20250106 AS a
                   LEFT JOIN marston.laacasedetails_20250106  AS b ON a.maatid = b.clientcasereference
                   WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: MaatIDs from LAALACESDataWarehouse not matching with ClientCaseReferences in LAACaseDetails:';
            PERFORM *
            FROM marston.laalacesdatawarehouse_20250106 AS a
            LEFT JOIN marston.laacasedetails_20250106  AS b ON a.maatid = b.clientcasereference
            WHERE b.caseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAALACESDataWarehouse.';
    END;

    -- Check LAALACESDataWarehouse
    RAISE NOTICE 'Checking LAALACESDataWarehouse...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laalacesdatawarehouse_20250106 AS a
                   LEFT JOIN marston.laalacescases_20250106 AS b ON a.lacescaseid = b.lacescaseid
                   WHERE b.lacescaseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAALACESDataWarehouse:';
            PERFORM *
            FROM marston.laalacesdatawarehouse_20250106 AS a
            LEFT JOIN marston.laalacescases_20250106 AS b ON a.lacescaseid = b.lacescaseid
            WHERE b.lacescaseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAALACESDataWarehouse.';
    END;

BEGIN
    -- Check LAALACESAssignments
    RAISE NOTICE 'Checking LAALACESAssignments...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laalacesassignments_20250106 AS a
                   LEFT JOIN marston.laalacescases_20250106 AS b ON a.lacescaseid = b.lacescaseid
                   WHERE b.lacescaseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAALACESAssignments:';
            PERFORM *
            FROM marston.laalacesassignments_20250106 AS a
            LEFT JOIN marston.laalacescases_20250106 AS b ON a.lacescaseid = b.lacescaseid
            WHERE b.lacescaseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAALACESAssignments.';
    END;

    -- Check LAALACESCaseActions
    RAISE NOTICE 'Checking LAALACESCasesActions...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laalacescasesactions_20250106 AS a
                   LEFT JOIN marston.laalacescases_20250106 AS b ON a.lacescaseid = b.lacescaseid
                   WHERE b.lacescaseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAALACESCaseActions:';
            PERFORM *
            FROM marston.laalacescasesactions_20250106 AS a
            LEFT JOIN marston.laalacescases_20250106 AS b ON a.lacescaseid = b.lacescaseid
            WHERE b.lacescaseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAALACESCasesActions.';
    END;
	
	-- Check LAALACESAudit
	RAISE NOTICE 'Checking LAALACESAudit-DataWarehouseEntries...';
	BEGIN
	    IF EXISTS (SELECT 1
	               FROM marston.laalacesaudit_20250106 AS a
	               LEFT JOIN marston.laalacesdatawarehouse_20250106 AS b ON a.rowid = b.recordid
	               WHERE a.tablename = 'DataWarehouseEntries' AND b.recordid IS NULL AND a.json_footer IS NULL) THEN
	        RAISE NOTICE 'Error: Orphaned records found in LAALACESAudit-DataWarehouseEntries:';
	        PERFORM *
	        FROM marston.laalacesaudit_20250106 AS a
	        LEFT JOIN marston.laalacesdatawarehouse_20250106 AS b ON a.rowid = b.recordid
	        WHERE b.recordid IS NULL AND a.json_footer IS NULL
	        ORDER BY b.loadedon DESC;
	    END IF;
	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE 'Error encountered while checking LAALACESAudit-DataWarehouseEntries.';
	END;
	RAISE NOTICE 'Checking LAALACESAudit-Cases...';
	BEGIN
	    IF EXISTS (SELECT 1
	               FROM marston.laalacesaudit_20250106 AS a
	               LEFT JOIN marston.laalacescases_20250106 AS b ON a.rowid = b.lacescaseid
	               WHERE a.tablename = 'Cases' AND b.lacescaseid IS NULL AND a.json_footer IS NULL) THEN
	        RAISE NOTICE 'Error: Orphaned records found in LAALACESAudit-Cases:';
	        PERFORM *
	        FROM marston.laalacesaudit_20250106 AS a
	        LEFT JOIN marston.laalacescases_20250106 AS b ON a.rowid = b.lacescaseid
	        WHERE b.lacescaseid IS NULL AND a.json_footer IS NULL
	        ORDER BY b.loadedon DESC;
	    END IF;
	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE 'Error encountered while checking LAALACESAudit-Cases.';
	END;
	RAISE NOTICE 'Checking LAALACESAudit-Properties...';
	BEGIN
	    IF EXISTS (SELECT 1
	               FROM marston.laalacesaudit_20250106 AS a
	               LEFT JOIN marston.laalacesproperties_20250106 AS b ON cast(a.rowid as integer) = b.recordid
	               WHERE a.tablename = 'Properties' AND b.recordid IS NULL AND a.json_footer IS NULL) THEN
	        RAISE NOTICE 'Error: Orphaned records found in LAALACESAudit-Properties:';
	        PERFORM *
	        FROM marston.laalacesaudit_20250106 AS a
	        LEFT JOIN marston.laalacesproperties_20250106 AS b ON a.rowid = b.recordid
	        WHERE b.recordid IS NULL AND a.json_footer IS NULL
	        ORDER BY b.loadedon DESC;
	    END IF;
	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE 'Error encountered while checking LAALACESAudit-Properties.';
	END;



	-- Check LAALACESExperianEntries
    RAISE NOTICE 'Checking LAALACESExperianEntries...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laalacesexperianentries_20250106 AS a
                   LEFT JOIN marston.laalacescases_20250106 AS b ON a.lacescaseid = b.lacescaseid
                   WHERE b.lacescaseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAALACESExperianEntries:';
            PERFORM *
            FROM marston.laalacesexperianentries_20250106 AS a
            LEFT JOIN marston.laalacescases_20250106 AS b ON a.lacescaseid = b.lacescaseid
            WHERE b.lacescaseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAALACESExperianEntries.';
    END;

    -- Check LAALACESProperties
    RAISE NOTICE 'Checking LAALACESProperties...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laalacesproperties_20250106 AS a
                   LEFT JOIN marston.laalacescases_20250106 AS b ON a.lacescaseid = b.lacescaseid
                   WHERE b.lacescaseid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAALACESProperties:';
            PERFORM *
            FROM marston.laalacesproperties_20250106 AS a
            LEFT JOIN marston.laalacescases_20250106 AS b ON a.lacescaseid = b.lacescaseid
            WHERE b.lacescaseid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAALACESProperties.';
    END;

    -- Check LAALACESLandRegistryEntries
    RAISE NOTICE 'Checking LAALACESLandRegistryEntries...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laalaceslandregistryentries_20250106 AS a
                   LEFT JOIN marston.laalacesproperties_20250106 AS b ON a.propertyid = b.recordid
                   WHERE b.recordid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAALACESLandRegistryEntries:';
            PERFORM *
            FROM marston.laalaceslandregistryentries_20250106 AS a
            LEFT JOIN marston.laalacesproperties_20250106 AS b ON a.propertyid = b.recordid
            WHERE b.recordid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAALACESLandRegistryEntries.';
    END;

    RAISE NOTICE 'Checking LAALACESLandRegistryAssociations...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laalaceslandregistryassociations_20250106 AS a
                   LEFT JOIN marston.laalaceslandregistryentries_20250106 AS b ON a.landregistryentryid = b.recordid
                   WHERE b.recordid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAALACESLandRegistryAssociations:';
            PERFORM *
            FROM marston.laalaceslandregistryassociations_20250106 AS a
            LEFT JOIN marston.laalaceslandregistryentries_20250106 AS b ON a.landregistryentryid = b.recordid
            WHERE b.recordid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAALACESLandRegistryAssociations.';
    END;

    RAISE NOTICE 'Checking LAALACESExperianMortgageEntries...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laalacesexperianmortgageentries_20250106 AS a
                   LEFT JOIN marston.laalacesexperianentries_20250106 AS b ON a.experianentryid = b.recordid
                   WHERE b.recordid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAALACESExperianMortgageEntries:';
            PERFORM *
            FROM marston.laalacesexperianmortgageentries_20250106 AS a
            LEFT JOIN marston.laalacesexperianentries_20250106 AS b ON a.experianentryid = b.recordid
            WHERE b.recordid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAALACESExperianMortgageEntries.';
    END;

    RAISE NOTICE 'Checking LAALACESExperianAssociations...';
    BEGIN
        IF EXISTS (SELECT 1
                   FROM marston.laalacesexperianassociations_20250106 AS a
                   LEFT JOIN marston.laalacesexperianentries_20250106 AS b ON a.experianentriesrecordid = b.recordid
                   WHERE b.recordid IS NULL AND a.json_footer IS NULL) THEN
            RAISE NOTICE 'Error: Orphaned records found in LAALACESExperianAssociations:';
            PERFORM *
            FROM marston.laalacesexperianassociations_20250106 AS a
            LEFT JOIN marston.laalacesexperianentries_20250106 AS b ON a.experianentriesrecordid = b.recordid
            WHERE b.recordid IS NULL AND a.json_footer IS NULL
            ORDER BY b.loadedon DESC;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error encountered while checking LAALACESExperianAssociations.';
    END;

	-- Check LAACaseAssets
	RAISE NOTICE 'Checking LAACaseAssets...';
	BEGIN
	    IF EXISTS (SELECT 1
	               FROM marston.laacaseassets_20250106 a
	               LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
	               WHERE b.caseid IS NULL AND a.json_footer IS NULL) THEN
	        RAISE NOTICE 'Error: Orphaned records found in LAACaseAssets:';
	        PERFORM *
	        FROM marston.laacaseassets_20250106 AS a
	        LEFT JOIN marston.laacases_20250106 AS b ON a.caseid = b.caseid
	        WHERE b.caseid IS NULL AND a.json_footer IS NULL
	        ORDER BY a.loadedon DESC;
	    END IF;
	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE 'Error encountered while checking LAACaseAssets.';
	END;

	
END;
END;
