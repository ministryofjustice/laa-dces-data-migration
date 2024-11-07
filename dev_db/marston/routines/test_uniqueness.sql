DECLARE
    current_pair RECORD;
    schema_name TEXT := 'marston';
    table_base_name TEXT;
    constructed_table_name TEXT;
    duplicate_count INTEGER;
    error_messages TEXT[] := ARRAY[]::TEXT[];
    current_condition TEXT;
BEGIN
    -- Iterate through each table and field pair
    FOR current_pair IN
        SELECT 'LAACases.csv' AS table_name, 'caseid' AS field_name UNION ALL
        SELECT 'LAACases.csv', 'casenumber' UNION ALL
        SELECT 'LAACases.csv', 'clientcasereference' UNION ALL
        SELECT 'LAACaseDetails.csv', 'caseid' UNION ALL
        SELECT 'LAACaseDetails.csv', 'clientcasereference' UNION ALL
        SELECT 'LAADefaulters.csv', 'caseid' UNION ALL
        SELECT 'LAADefaulters.csv', 'defaulterid' UNION ALL
        SELECT 'LAADefaultersPhones.csv', 'phonerecordid' UNION ALL
        SELECT 'LAADefaultersEMails.csv', 'emailrecordid' UNION ALL
        SELECT 'LAADefaultersContactAddresses.csv', 'addressrecordid' UNION ALL
        SELECT 'LAADefaultersPhonesAudit.csv', 'auditrecordid' UNION ALL
        SELECT 'LAADefaultersEMailsAudit.csv', 'auditrecordid' UNION ALL
        SELECT 'LAADefaultersContactAddressesAudit.csv', 'auditrecordid' UNION ALL
        SELECT 'LAACaseCharges.csv', 'chargerecordid' UNION ALL
        SELECT 'LAACasePayments.csv', 'paymentrecordid' UNION ALL
        SELECT 'LAACaseAssignments.csv', 'commentrecordid' UNION ALL
        SELECT 'LAACaseHolds.csv', 'holdrecordid' UNION ALL
        SELECT 'LAACaseArrangements.csv', 'arrangementid' UNION ALL
        SELECT 'LAACaseVisits.csv', 'visitrecordid' UNION ALL
        SELECT 'LAACaseAdditionalData.csv', 'additionaldatarecordid' UNION ALL
        SELECT 'LAACaseAttachments.csv', 'attachmentsrecordid' UNION ALL
        SELECT 'LAAClientPaymentRuns.csv', 'clientpaymentrunhistoryrecordid' UNION ALL
        SELECT 'LAAClientInvoiceRuns.csv', 'clientinvoicerunrecordid' UNION ALL
        -- no unique key in caselinks SELECT 'LAACaseLinks.csv', 'linkid' UNION ALL
        SELECT 'LAACaseNotes.csv', 'casenotesrecordid' UNION ALL
        SELECT 'LAACaseHistory.csv', 'casehistoryrecordid' UNION ALL
        SELECT 'LAACaseWorkflow.csv', 'casehistoryrecordid' UNION ALL
        SELECT 'LAALACESCases.csv', 'lacescaseid' UNION ALL
        SELECT 'LAALACESDatawarehouse.csv', 'recordid' UNION ALL
        SELECT 'LAALACESDatawarehouse.csv', 'lacescaseid' UNION ALL
        SELECT 'LAALACESDatawarehouse.csv', 'maatid' UNION ALL
        SELECT 'LAALACESAssignments.csv', 'recordid' UNION ALL
        SELECT 'LAALACESCaseActions.csv', 'recordid' UNION ALL
        SELECT 'LAALACESExperianEntries.csv', 'recordid' UNION ALL
        SELECT 'LAALACESExperianMortgageEntries.csv', 'recordid' UNION ALL
        SELECT 'LAALACESProperties.csv', 'recordid' UNION ALL
        SELECT 'LAALACESLandRegistryEntries.csv', 'recordid' UNION ALL
        SELECT 'LAALACESLandRegistryAssociations.csv', 'recordid' UNION ALL
        SELECT 'LAACaseCallLog.csv', 'casehistoryrecordid' UNION ALL
        SELECT 'LAACaseBalance.csv', 'caseid' UNION ALL
        SELECT 'LAALACESAudit.csv', 'auditid' UNION ALL
        SELECT 'LAACaseRefunds.csv', 'refundrecordid' UNION ALL
        SELECT 'LAADefaultersWelfare.csv', 'welfarerecordid'
    LOOP
        -- Reset current_condition for each iteration
        current_condition := NULL;
        
        -- Replace .csv with _20241018 and convert to lowercase
        table_base_name := lower(regexp_replace(current_pair.table_name, '\.csv$', '', 'i'));
        constructed_table_name := table_base_name || '_20241018';
        
        -- Output a NOTICE indicating the start of uniqueness check for the table
        RAISE NOTICE 'Uniqueness checks for %.% table has started', schema_name, constructed_table_name;
        
        -- Define additional condition if applicable
            current_condition := 'json_footer IS NULL';
        
        -- Check if the table exists
        IF NOT EXISTS (
            SELECT 1 
            FROM information_schema.tables 
            WHERE table_schema = schema_name 
              AND table_name = constructed_table_name
        ) THEN
            RAISE NOTICE 'Table %.% does not exist. Skipping...', schema_name, constructed_table_name;
            CONTINUE;
        END IF;
        
        -- Construct and execute the duplicate check query
        IF current_condition IS NOT NULL THEN
            EXECUTE format(
                'SELECT COUNT(*) FROM (
                    SELECT %I FROM %I.%I
                    WHERE %s
                    GROUP BY %I
                    HAVING COUNT(*) > 1
                ) subquery',
                current_pair.field_name,
                schema_name,
                constructed_table_name,
                current_condition,
                current_pair.field_name
            ) INTO duplicate_count;
        ELSE
            EXECUTE format(
                'SELECT COUNT(*) FROM (
                    SELECT %I FROM %I.%I
                    GROUP BY %I
                    HAVING COUNT(*) > 1
                ) subquery',
                current_pair.field_name,
                schema_name,
                constructed_table_name,
                current_pair.field_name
            ) INTO duplicate_count;
        END IF;
        
        -- Only raise NOTICE if duplicates are found
        IF duplicate_count > 0 THEN
            RAISE NOTICE 'ERROR: Found % duplicates for field % in table %.%', duplicate_count, current_pair.field_name, schema_name, constructed_table_name;
            
            -- Append an error message
            error_messages := array_append(
                error_messages, 
                format('ERROR: there are duplicate records in %I.%I table when checking %I field.', schema_name, constructed_table_name, current_pair.field_name)
            );
        END IF;
    END LOOP;
    
    -- After checking all tables, raise an exception if any duplicates were found
    IF array_length(error_messages, 1) > 0 THEN
        RAISE EXCEPTION '%', array_to_string(error_messages, E'\n');
    ELSE
        RAISE NOTICE 'All uniqueness checks passed. No duplicates found.';
    END IF;
END;