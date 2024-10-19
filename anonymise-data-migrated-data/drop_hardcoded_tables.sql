-- PROCEDURE: public.drop_hardcoded_tables()

-- DROP PROCEDURE IF EXISTS public.drop_hardcoded_tables();

CREATE OR REPLACE PROCEDURE public.drop_hardcoded_tables(
	)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Drop each table if it exists
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseHistory_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseHolds_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.laacases_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseLinks_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseNotes_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACasePayments_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseVisits_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAADefaultersWelfare_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseAdditionalData_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseArrangements_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseAssignments_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseAttachments_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseBalance_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseCallLog_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseCharges_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseDetails_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseWorkflow_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACases_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAAClientInvoiceRuns_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAAClientPaymentRuns_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAADefaulters_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAADefaultersContactAddresses_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAADefaultersContactAddressesAudit_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAADefaultersEMails_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAADefaultersEMailsAudit_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAADefaultersPhones_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAADefaultersPhonesAudit_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAALACESAssignments_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAALACESAudit_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAALACESCases_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAALACESCasesActions_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAALACESDatawarehouse_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAALACESExperianAssociations_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAALACESExperianEntries_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAALACESExperianMortgageEntries_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAALACESLandRegistryAssociations_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAALACESLandRegistryEntries_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAALACESProperties_20240916';
EXECUTE 'DROP TABLE IF EXISTS anonymised.LAACaseRefunds_20240916';

END;
$BODY$;
ALTER PROCEDURE public.drop_hardcoded_tables()
    OWNER TO "cpSB74T20Z";