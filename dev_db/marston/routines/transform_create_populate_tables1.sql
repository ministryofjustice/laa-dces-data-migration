
DECLARE
    source_table_name TEXT;
    target_table_name TEXT;
    join_key TEXT;
    full_source_table_name TEXT;
    full_target_table_name TEXT;
    target_schema TEXT := 'transform';
    source_schema TEXT := 'marston';
BEGIN
    -- Check if batchid is 8 digits
    IF batchid !~ '^\d{8}$' THEN
        RAISE EXCEPTION 'Batch ID must be 8 digits only';
    END IF;

    -- Loop through the list of target tables and perform operations
    FOR target_table_name, join_key IN
        SELECT unnest(ARRAY[
            'maat_outcomesodfdc','maat_defendantdetails','lacesduplicates','laceskeenrichment'
			,'LAACases', 'LAACaseDetails', 'LAADefaulters'
            , 'LAADefaultersPhones', 'LAADefaultersEMails','LAADefaultersContactAddresses'
			, 'LAADefaultersPhonesAudit', 'LAADefaultersEMailsAudit','LAADefaultersContactAddressesAudit'
			, 'LAACaseCharges'
			, --10 
			'LAACasePayments', 'LAACaseAssignments','LAACaseHolds', 
			'LAACaseArrangements', 'LAACaseVisits', 'LAACaseAdditionalData'
            ,'LAACaseAttachments','LAACaseLinks','LAACaseCallLog',
            -- , 'LAAClientPaymentRuns', 'LAAClientInvoiceRuns', DB: Exclude from migration
            'LAACaseBalance',
			-- 20
            'LAACaseRefunds', 'LAADefaultersWelfare', 'LAACaseStatus'
            ,'LAACaseNotes', 'LAACaseHistory' ,'LAALACESCases', 
			'LAALACESDatawarehouse',
            -- 'LAALACESAssignments', -- Internal to Marston information, not required by Advantis 
			'LAALACESCasesActions', 'LAALACESExperianEntries', 'LAALACESProperties'
            ,'LAALACESExperianMortgageEntries', 'LAALACESExperianAssociations', 'LAALACESLandRegistryEntries', 'LAALACESLandRegistryAssociations'
            ,'LAALACESAudit'
        ]),
        unnest(ARRAY[
            'maatid','maatid', 'caseid','lacescaseid'
			,'caseid', 'caseid', 'caseid' 
            ,'caseid', 'caseid', 'caseid', 
			'caseid', 'caseid', 'caseid',
            'caseid', --10
			'caseid', 'caseid', 'caseid', 
			'caseid', 'caseid', 'caseid'
            , 'caseid', 'caseid', 'caseid'--, 'caseid','caseid', 'caseid', 
            , 'caseid', --20
			'caseid', 'caseid', 'caseid'
            ,'caseid', 'caseid' --25
            ,'lacescaseid', 'lacescaseid', 'lacescaseid', 'lacescaseid', 'lacescaseid', 'lacescaseid'
          --  ,'experianentryid', 'ExperianEntriesRecordID', 'propertyid', 'landregistryentryid' -- 26/11/2024: AC - to fix issue on DCES-619
            
        ])
    LOOP
        -- Construct table names without quotes
        source_table_name := lower(target_table_name) || '_' || batchid;
        full_source_table_name := source_schema || '.' || source_table_name;
        full_target_table_name := target_schema || '.' || lower(target_table_name);

        -- Print source table name for debugging
        RAISE NOTICE 'Processing source schema: %, source table: % into target schema: %, target table: %', source_schema, source_table_name, target_schema, target_table_name;

        -- Check if source table exists
        IF EXISTS (SELECT 1 FROM information_schema.tables 
                  WHERE table_schema = source_schema 
                  AND (table_name = source_table_name
				  OR table_name = target_table_name)) THEN
            -- Drop target table if it exists
            EXECUTE format('DROP TABLE IF EXISTS %I.%I', target_schema, lower(target_table_name));
            
            -- Special join condition for LAALACESExperianMortgageEntries
            IF target_table_name = 'LAALACESExperianMortgageEntries' THEN
                EXECUTE format(
                    'CREATE TABLE %I.%I AS 
                     SELECT src.* 
                     FROM %I.%I src
                     JOIN %I.LAALACESExperianEntries le ON le.recordid = src.experianentryid',
                    target_schema,
                    lower(target_table_name),
                    source_schema,
                    source_table_name,
                    target_schema
                );
            -- Special join condition for LAALACESExperianAssociations
            ELSIF target_table_name = 'LAALACESExperianAssociations' THEN
                EXECUTE format(
                    'CREATE TABLE %I.%I AS 
                     SELECT src.* 
                     FROM %I.%I src
                     JOIN %I.LAALACESExperianEntries le ON le.recordid = src.ExperianEntriesRecordID',
                    target_schema,
                    lower(target_table_name),
                    source_schema,
                    source_table_name,
                    target_schema
                );
            -- Special join condition for LAALACESLandRegistryEntries
            ELSIF target_table_name = 'LAALACESLandRegistryEntries' THEN
                EXECUTE format(
                    'CREATE TABLE %I.%I AS 
                     SELECT src.* 
                     FROM %I.%I src
                     JOIN %I.LAALACESProperties lp ON lp.recordid = src.propertyid',
                    target_schema,
                    lower(target_table_name),
                    source_schema,
                    source_table_name,
                    target_schema
                );
            -- Special join condition for LAALACESLandRegistryAssociations
            ELSIF target_table_name = 'LAALACESLandRegistryAssociations' THEN
                EXECUTE format(
                    'CREATE TABLE %I.%I AS 
                     SELECT src.* 
                     FROM %I.%I src
                     JOIN %I.LAALACESLandRegistryEntries lre ON lre.recordid = src.landregistryentryid
                     JOIN %I.LAALACESProperties lp ON lp.recordid = lre.propertyid',
                    target_schema,
                    lower(target_table_name),
                    source_schema,
                    source_table_name,
                    target_schema,
                    target_schema
                );
            -- Special join condition for LAALACESAudit
            ELSIF target_table_name = 'LAALACESAudit' THEN
                EXECUTE format(
                    'CREATE TABLE %I.%I AS 
                     SELECT a.*
                     FROM %I.%I a
                     JOIN transform.laalacescases b ON a.tablename = ''Cases'' AND CAST(a.rowid AS INTEGER) = CAST(b.lacescaseid AS INTEGER)
                     UNION
                     SELECT a.*
                     FROM %I.%I a
                     JOIN transform.laalacesdatawarehouse b ON a.tablename = ''DataWarehouseEntries'' AND CAST(a.rowid AS INTEGER) = CAST(b.recordid AS INTEGER)
                     UNION
                     SELECT a.*
                     FROM %I.%I a
                     JOIN transform.laalacesexperianassociations b ON a.tablename = ''ExperianAssociations'' AND CAST(a.rowid AS INTEGER) = CAST(b.ExperianAssociationsRecordID AS INTEGER)
                     UNION
                     SELECT a.*
                     FROM %I.%I a
                     JOIN transform.laalacesexperianentries b ON a.tablename = ''ExperianEntries'' AND CAST(a.rowid AS INTEGER) = CAST(b.recordid AS INTEGER)
                     UNION
                     SELECT a.*
                     FROM %I.%I a
                     JOIN transform.laalacesexperianmortgageentries b ON a.tablename = ''ExperianMortgageEntries'' AND CAST(a.rowid AS INTEGER) = CAST(b.recordid AS INTEGER)
                     UNION
                     SELECT a.*
                     FROM %I.%I a
                     JOIN transform.laalaceslandregistryassociations b ON a.tablename = ''LandRegistryAssociations'' AND CAST(a.rowid AS INTEGER) = CAST(b.recordid AS INTEGER)
                     UNION
                     SELECT a.*
                     FROM %I.%I a
                     JOIN transform.laalaceslandregistryentries b ON a.tablename = ''LandRegistryEntries'' AND CAST(a.rowid AS INTEGER) = CAST(b.recordid AS INTEGER)
                     UNION
                     SELECT a.*
                     FROM %I.%I a
                     JOIN transform.laalacesproperties b ON a.tablename = ''Properties'' AND CAST(a.rowid AS INTEGER) = CAST(b.recordid AS INTEGER)',
                    target_schema,
                    lower(target_table_name),
                    source_schema,
                    source_table_name,
                    source_schema,
                    source_table_name,
                    source_schema,
                    source_table_name,
                    source_schema,
                    source_table_name,
                    source_schema,
                    source_table_name,
                    source_schema,
                    source_table_name,
                    source_schema,
                    source_table_name,
                    source_schema,
                    source_table_name
                );
            
			ELSIF target_table_name = 'maat_outcomesodfdc' THEN
                EXECUTE format(
                    'CREATE TABLE %I.%I AS 
                     SELECT src.*
                     FROM %I.%I src
					  WHERE EXISTS (
				         SELECT 1 
				         FROM %I.MigrationScope ms 
				         WHERE cast(src.%I as text) = 
						 cast(ms.%I as text) AND ms.%I IS NOT NULL
				     )',                    
					target_schema,
                    lower(target_table_name),
                    source_schema,
                    target_table_name,
                    source_schema,
					join_key, join_key, join_key
                );
			ELSIF target_table_name = 'maat_defendantdetails' THEN
                EXECUTE format(
                    'CREATE TABLE %I.%I AS 
                     SELECT src.*
                     FROM %I.%I src
					  WHERE EXISTS (
				         SELECT 1 
				         FROM %I.MigrationScope ms 
				         WHERE cast(src.%I as text) = 
						 cast(ms.%I as text) AND ms.%I IS NOT NULL
				     )',                    
					target_schema,
                    lower(target_table_name),
                    source_schema,
                    target_table_name,
                    source_schema,
					join_key, join_key, join_key
                );
			ELSIF target_table_name = 'lacesduplicates' THEN
                EXECUTE format(
                    'CREATE TABLE %I.%I AS 
                     SELECT src.*
                     FROM %I.%I src
					  WHERE EXISTS (
				         SELECT 1 
				         FROM %I.MigrationScope ms 
				         WHERE cast(src.%I as text) = 
						 cast(ms.%I as text) AND ms.%I IS NOT NULL
				     )',                    
					target_schema,
                    lower(target_table_name),
                    source_schema,
                    target_table_name,
                    source_schema,
					join_key, join_key, join_key
                );
			ELSIF target_table_name = 'laceskeenrichment' THEN
                EXECUTE format(
                    'CREATE TABLE %I.%I AS 
                     SELECT src.*
                     FROM %I.%I src
					  WHERE EXISTS (
				         SELECT 1 
				         FROM %I.MigrationScope ms 
				         WHERE cast(src.%I as text) = 
						 cast(ms.%I as text) AND ms.%I IS NOT NULL
				     )',                    
					target_schema,
                    lower(target_table_name),
                    source_schema,
                    target_table_name,
                    source_schema,
					join_key, join_key, join_key
                );
			ELSE
                -- Recreate target table and copy data from source table with join condition
				EXECUTE format(
				    'CREATE TABLE %I.%I AS 
				     SELECT src.* 
				     FROM %I.%I src
				     WHERE EXISTS (
				         SELECT 1 
				         FROM %I.MigrationScope ms 
				         WHERE src.%I = ms.%I AND ms.%I IS NOT NULL
				     )',
				    target_schema,
				    lower(target_table_name),
				    source_schema,
				    source_table_name,
				    source_schema,
				    join_key,
				    join_key,
				    join_key
				);
            END IF;
        ELSE
            RAISE NOTICE 'Source table % does not exist, skipping.', full_source_table_name;
        END IF;
    END LOOP;

-- DCES-563 // ClientCaseReference A1043EL should be updated as 6416537
UPDATE transform.laacasedetails
SET clientcasereference = '6416537'
WHERE clientcasereference = 'A1043EL';



END;
