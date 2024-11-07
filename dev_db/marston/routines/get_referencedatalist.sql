
BEGIN
    -- Step 1: Create a temporary table to store the results
    CREATE TEMP TABLE IF NOT EXISTS temp_referencedatalist (
        table_name    TEXT,
        column_name   TEXT,
        value         TEXT
    ) ON COMMIT DROP; -- The table will be dropped at the end of the session

    -- Step 2: Insert DISTINCT values from each table and column into the temporary table
    INSERT INTO temp_referencedatalist (table_name, column_name, value)
    SELECT DISTINCT 'LAACaseDetails_20241018' AS table_name, 'CurrentStatus' AS column_name, CurrentStatus::TEXT AS value
    FROM marston.LAACaseDetails_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseDetails_20241018', 'OpenClosedStatus', OpenClosedStatus::TEXT
    FROM marston.LAACaseDetails_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseDetails_20241018', 'CourtCode', CourtCode::TEXT
    FROM marston.LAACaseDetails_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseDetails_20241018', 'CourtName', CourtName::TEXT
    FROM marston.LAACaseDetails_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseDetails_20241018', 'Outcome', Outcome::TEXT
    FROM marston.LAACaseDetails_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseDetails_20241018', 'IncomeSanctionApplied', IncomeSanctionApplied::TEXT
    FROM marston.LAACaseDetails_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersPhones_20241018', 'Type', Type::TEXT
    FROM marston.LAADefaultersPhones_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersPhones_20241018', 'Status', Status::TEXT
    FROM marston.LAADefaultersPhones_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersPhones_20241018', 'Source', Source::TEXT
    FROM marston.LAADefaultersPhones_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersPhones_20241018', 'IsPreferred', IsPreferred::TEXT
    FROM marston.LAADefaultersPhones_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersPhones_20241018', 'IsRightPartyConfirmed', IsRightPartyConfirmed::TEXT
    FROM marston.LAADefaultersPhones_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersEMails_20241018', 'Status', Status::TEXT
    FROM marston.LAADefaultersEMails_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersEMails_20241018', 'Source', Source::TEXT
    FROM marston.LAADefaultersEMails_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersEMails_20241018', 'IsConsented', IsConsented::TEXT
    FROM marston.LAADefaultersEMails_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersEMails_20241018', 'IsPreferred', IsPreferred::TEXT
    FROM marston.LAADefaultersEMails_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersEMails_20241018', 'IsRightPartyConfirmed', IsRightPartyConfirmed::TEXT
    FROM marston.LAADefaultersEMails_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersContactAddresses_20241018', 'WarrantAddr', WarrantAddr::TEXT
    FROM marston.LAADefaultersContactAddresses_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersContactAddresses_20241018', 'BusinessAddress', BusinessAddress::TEXT
    FROM marston.LAADefaultersContactAddresses_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersContactAddresses_20241018', 'IsPrimarycontactAddress', IsPrimarycontactAddress::TEXT
    FROM marston.LAADefaultersContactAddresses_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersContactAddresses_20241018', 'IsAddressConfirmed', IsAddressConfirmed::TEXT
    FROM marston.LAADefaultersContactAddresses_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersContactAddresses_20241018', 'Source', Source::TEXT
    FROM marston.LAADefaultersContactAddresses_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersPhonesAudit_20241018', 'Field', Field::TEXT
    FROM marston.LAADefaultersPhonesAudit_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersEMailsAudit_20241018', 'Field', Field::TEXT
    FROM marston.LAADefaultersEMailsAudit_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersContactAddressesAudit_20241018', 'Field', Field::TEXT
    FROM marston.LAADefaultersContactAddressesAudit_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseCharges_20241018', 'ChargeDescription', ChargeDescription::TEXT
    FROM marston.LAACaseCharges_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseCharges_20241018', 'RemitTo', RemitTo::TEXT
    FROM marston.LAACaseCharges_20241018
    UNION ALL
    SELECT DISTINCT 'LAACasePayments_20241018', 'PaymentType', PaymentType::TEXT
    FROM marston.LAACasePayments_20241018
    UNION ALL
    SELECT DISTINCT 'LAACasePayments_20241018', 'Status', Status::TEXT
    FROM marston.LAACasePayments_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseAssignments_20241018', 'Action', Action::TEXT
    FROM marston.LAACaseAssignments_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseHolds_20241018', 'HoldReason', HoldReason::TEXT
    FROM marston.LAACaseHolds_20241018
    -- Excluded: LAACaseHolds_20241018.RecommenceReason
    UNION ALL
    SELECT DISTINCT 'LAACaseArrangements_20241018', 'InstalmentFrequency', InstalmentFrequency::TEXT
    FROM marston.LAACaseArrangements_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseArrangements_20241018', 'Status', Status::TEXT
    FROM marston.LAACaseArrangements_20241018
    -- Excluded: LAACaseArrangements_20241018.NumberOfInstalments
    UNION ALL
    SELECT DISTINCT 'LAACaseVisits_20241018', 'Action', Action::TEXT
    FROM marston.LAACaseVisits_20241018
    -- Excluded: LAACaseAdditionalData_20241018.Name
    UNION ALL
    SELECT DISTINCT 'LAACaseAttachments_20241018', 'AttachmentType', AttachmentType::TEXT
    FROM marston.LAACaseAttachments_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseNotes_20241018', 'NoteType', NoteType::TEXT
    FROM marston.LAACaseNotes_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseHistory_20241018', 'NoteType', NoteType::TEXT
    FROM marston.LAACaseHistory_20241018
    /* 
	UNION ALL
    SELECT DISTINCT 'LAACaseWorkflow_20241018', 'Phase', Phase::TEXT
    FROM marston.LAACaseWorkflow_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseWorkflow_20241018', 'Stage', Stage::TEXT
    FROM marston.LAACaseWorkflow_20241018
    */ 
	UNION ALL
    SELECT DISTINCT 'LAALACESCases_20241018', 'CaseStatus', CaseStatus::TEXT
    FROM marston.LAALACESCases_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESCases_20241018', 'IssueSource', IssueSource::TEXT
    FROM marston.LAALACESCases_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESCases_20241018', 'JointCreditAgreementExists', JointCreditAgreementExists::TEXT
    FROM marston.LAALACESCases_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESCases_20241018', 'IsFoundCreditPositionConsistentWithDeclared', IsFoundCreditPositionConsistentWithDeclared::TEXT
    FROM marston.LAALACESCases_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESCases_20241018', 'WasUploadedManually', WasUploadedManually::TEXT
    FROM marston.LAALACESCases_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESDatawarehouse_20241018', 'HasPartner', HasPartner::TEXT
    FROM marston.LAALACESDatawarehouse_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESDatawarehouse_20241018', 'HasPartnerContraryInterest', HasPartnerContraryInterest::TEXT
    FROM marston.LAALACESDatawarehouse_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESDatawarehouse_20241018', 'IsAllEvidenceProvided', IsAllEvidenceProvided::TEXT
    FROM marston.LAALACESDatawarehouse_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESDatawarehouse_20241018', 'IsSufficientCapitalAndEquity', IsSufficientCapitalAndEquity::TEXT
    FROM marston.LAALACESDatawarehouse_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESCasesActions_20241018', 'ActionType', ActionType::TEXT
    FROM marston.LAALACESCasesActions_20241018 
    /*UNION ALL
    SELECT DISTINCT 'LAALACESCasesActions_20241018', 'Description', Description::TEXT
    FROM marston.LAALACESCasesActions_20241018 */
    UNION ALL
    SELECT DISTINCT 'LAALACESCasesActions_20241018', 'NewStatus', NewStatus::TEXT
    FROM marston.LAALACESCasesActions_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESExperianEntries_20241018', 'ResidencyScore', ResidencyScore::TEXT
    FROM marston.LAALACESExperianEntries_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESExperianEntries_20241018', 'IsBankrupt', IsBankrupt::TEXT
    FROM marston.LAALACESExperianEntries_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESExperianEntries_20241018', 'HasCCJ', HasCCJ::TEXT
    FROM marston.LAALACESExperianEntries_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESExperianEntries_20241018', 'HasIVA', HasIVA::TEXT
    FROM marston.LAALACESExperianEntries_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESExperianEntries_20241018', 'PropensityToPayScore', PropensityToPayScore::TEXT
    FROM marston.LAALACESExperianEntries_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESExperianAssociations_20241018', 'IsIgnored', IsIgnored::TEXT
    FROM marston.LAALACESExperianAssociations_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESProperties_20241018', 'ResidentialDescription', ResidentialDescription::TEXT
    FROM marston.LAALACESProperties_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESProperties_20241018', 'IsMainProperty', IsMainProperty::TEXT
    FROM marston.LAALACESProperties_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESProperties_20241018', 'IsPercentageSetByUser', IsPercentageSetByUser::TEXT
    FROM marston.LAALACESProperties_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESProperties_20241018', 'LandRegistryStatus', LandRegistryStatus::TEXT
    FROM marston.LAALACESProperties_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESProperties_20241018', 'ExperianStatus', ExperianStatus::TEXT
    FROM marston.LAALACESProperties_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESProperties_20241018', 'VerificationStatus', VerificationStatus::TEXT
    FROM marston.LAALACESProperties_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESLandRegistryAssociations_20241018', 'IsIgnored', IsIgnored::TEXT
    FROM marston.LAALACESLandRegistryAssociations_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseCallLog_20241018', 'ActionType', ActionType::TEXT
    FROM marston.LAACaseCallLog_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESAudit_20241018', 'TableName', TableName::TEXT
    FROM marston.LAALACESAudit_20241018
    UNION ALL
    SELECT DISTINCT 'LAALACESAudit_20241018', 'ColumnName', ColumnName::TEXT
    FROM marston.LAALACESAudit_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseRefunds_20241018', 'Status', Status::TEXT
    FROM marston.LAACaseRefunds_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseRefunds_20241018', 'RefundType', RefundType::TEXT
    FROM marston.LAACaseRefunds_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseRefunds_20241018', 'RefundMethod', RefundMethod::TEXT
    FROM marston.LAACaseRefunds_20241018
    UNION ALL
    SELECT DISTINCT 'LAACaseRefunds_20241018', 'LoadedBy', LoadedBy::TEXT
    FROM marston.LAACaseRefunds_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersWelfare_20241018', 'WelfareCategory', WelfareCategory::TEXT
    FROM marston.LAADefaultersWelfare_20241018
    UNION ALL
    SELECT DISTINCT 'LAADefaultersWelfare_20241018', 'proofprovided', proofprovided::TEXT
    FROM marston.LAADefaultersWelfare_20241018;

    -- Step 3: Optional - Display a message upon successful execution
    RAISE NOTICE 'Aggregated DISTINCT values have been inserted into temp_referencedatalist.';
END;
