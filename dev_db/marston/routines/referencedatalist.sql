
BEGIN
    RETURN QUERY
    SELECT DISTINCT 'LAACaseDetails_20240916' AS table_name, 'CurrentStatus' AS column_name, CurrentStatus::TEXT AS value
    FROM marston.LAACaseDetails_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseDetails_20240916', 'OpenClosedStatus', OpenClosedStatus::TEXT
    FROM marston.LAACaseDetails_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseDetails_20240916', 'CourtCode', CourtCode::TEXT
    FROM marston.LAACaseDetails_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseDetails_20240916', 'CourtName', CourtName::TEXT
    FROM marston.LAACaseDetails_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseDetails_20240916', 'Outcome', Outcome::TEXT
    FROM marston.LAACaseDetails_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseDetails_20240916', 'IncomeSanctionApplied', IncomeSanctionApplied::TEXT
    FROM marston.LAACaseDetails_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersPhones_20240916', 'Type', Type::TEXT
    FROM marston.LAADefaultersPhones_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersPhones_20240916', 'Status', Status::TEXT
    FROM marston.LAADefaultersPhones_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersPhones_20240916', 'Source', Source::TEXT
    FROM marston.LAADefaultersPhones_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersPhones_20240916', 'IsPreferred', IsPreferred::TEXT
    FROM marston.LAADefaultersPhones_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersPhones_20240916', 'IsRightPartyConfirmed', IsRightPartyConfirmed::TEXT
    FROM marston.LAADefaultersPhones_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersEMails_20240916', 'Status', Status::TEXT
    FROM marston.LAADefaultersEMails_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersEMails_20240916', 'Source', Source::TEXT
    FROM marston.LAADefaultersEMails_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersEMails_20240916', 'IsConsented', IsConsented::TEXT
    FROM marston.LAADefaultersEMails_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersEMails_20240916', 'IsPreferred', IsPreferred::TEXT
    FROM marston.LAADefaultersEMails_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersEMails_20240916', 'IsRightPartyConfirmed', IsRightPartyConfirmed::TEXT
    FROM marston.LAADefaultersEMails_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersContactAddresses_20240916', 'WarrantAddr', WarrantAddr::TEXT
    FROM marston.LAADefaultersContactAddresses_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersContactAddresses_20240916', 'BusinessAddress', BusinessAddress::TEXT
    FROM marston.LAADefaultersContactAddresses_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersContactAddresses_20240916', 'IsPrimarycontactAddress', IsPrimarycontactAddress::TEXT
    FROM marston.LAADefaultersContactAddresses_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersContactAddresses_20240916', 'IsAddressConfirmed', IsAddressConfirmed::TEXT
    FROM marston.LAADefaultersContactAddresses_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersContactAddresses_20240916', 'Source', Source::TEXT
    FROM marston.LAADefaultersContactAddresses_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersPhonesAudit_20240916', 'Field', Field::TEXT
    FROM marston.LAADefaultersPhonesAudit_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersEMailsAudit_20240916', 'Field', Field::TEXT
    FROM marston.LAADefaultersEMailsAudit_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersContactAddressesAudit_20240916', 'Field', Field::TEXT
    FROM marston.LAADefaultersContactAddressesAudit_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseCharges_20240916', 'ChargeDescription', ChargeDescription::TEXT
    FROM marston.LAACaseCharges_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseCharges_20240916', 'RemitTo', RemitTo::TEXT
    FROM marston.LAACaseCharges_20240916
    UNION ALL
    SELECT DISTINCT 'LAACasePayments_20240916', 'PaymentType', PaymentType::TEXT
    FROM marston.LAACasePayments_20240916
    UNION ALL
    SELECT DISTINCT 'LAACasePayments_20240916', 'Status', Status::TEXT
    FROM marston.LAACasePayments_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseAssignments_20240916', 'Action', Action::TEXT
    FROM marston.LAACaseAssignments_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseHolds_20240916', 'HoldReason', HoldReason::TEXT
    FROM marston.LAACaseHolds_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseArrangements_20240916', 'InstalmentFrequency', InstalmentFrequency::TEXT
    FROM marston.LAACaseArrangements_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseArrangements_20240916', 'Status', Status::TEXT
    FROM marston.LAACaseArrangements_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseVisits_20240916', 'Action', Action::TEXT
    FROM marston.LAACaseVisits_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseAttachments_20240916', 'AttachmentType', AttachmentType::TEXT
    FROM marston.LAACaseAttachments_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseNotes_20240916', 'NoteType', NoteType::TEXT
    FROM marston.LAACaseNotes_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseHistory_20240916', 'NoteType', NoteType::TEXT
    FROM marston.LAACaseHistory_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseWorkflow_20240916', 'Phase', Phase::TEXT
    FROM marston.LAACaseWorkflow_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseWorkflow_20240916', 'Stage', Stage::TEXT
    FROM marston.LAACaseWorkflow_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESCases_20240916', 'CaseStatus', CaseStatus::TEXT
    FROM marston.LAALACESCases_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESCases_20240916', 'IssueSource', IssueSource::TEXT
    FROM marston.LAALACESCases_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESCases_20240916', 'JointCreditAgreementExists', JointCreditAgreementExists::TEXT
    FROM marston.LAALACESCases_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESCases_20240916', 'IsFoundCreditPositionConsistentWithDeclared', IsFoundCreditPositionConsistentWithDeclared::TEXT
    FROM marston.LAALACESCases_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESCases_20240916', 'WasUploadedManually', WasUploadedManually::TEXT
    FROM marston.LAALACESCases_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESDatawarehouse_20240916', 'HasPartner', HasPartner::TEXT
    FROM marston.LAALACESDatawarehouse_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESDatawarehouse_20240916', 'HasPartnerContraryInterest', HasPartnerContraryInterest::TEXT
    FROM marston.LAALACESDatawarehouse_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESDatawarehouse_20240916', 'IsAllEvidenceProvided', IsAllEvidenceProvided::TEXT
    FROM marston.LAALACESDatawarehouse_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESDatawarehouse_20240916', 'IsSufficientCapitalAndEquity', IsSufficientCapitalAndEquity::TEXT
    FROM marston.LAALACESDatawarehouse_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESCasesActions_20240916', 'ActionType', ActionType::TEXT
    FROM marston.LAALACESCasesActions_20240916 
    UNION ALL
    SELECT DISTINCT 'LAALACESCasesActions_20240916', 'NewStatus', NewStatus::TEXT
    FROM marston.LAALACESCasesActions_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESExperianEntries_20240916', 'ResidencyScore', ResidencyScore::TEXT
    FROM marston.LAALACESExperianEntries_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESExperianEntries_20240916', 'IsBankrupt', IsBankrupt::TEXT
    FROM marston.LAALACESExperianEntries_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESExperianEntries_20240916', 'HasCCJ', HasCCJ::TEXT
    FROM marston.LAALACESExperianEntries_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESExperianEntries_20240916', 'HasIVA', HasIVA::TEXT
    FROM marston.LAALACESExperianEntries_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESExperianEntries_20240916', 'PropensityToPayScore', PropensityToPayScore::TEXT
    FROM marston.LAALACESExperianEntries_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESExperianAssociations_20240916', 'IsIgnored', IsIgnored::TEXT
    FROM marston.LAALACESExperianAssociations_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESProperties_20240916', 'ResidentialDescription', ResidentialDescription::TEXT
    FROM marston.LAALACESProperties_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESProperties_20240916', 'IsMainProperty', IsMainProperty::TEXT
    FROM marston.LAALACESProperties_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESProperties_20240916', 'IsPercentageSetByUser', IsPercentageSetByUser::TEXT
    FROM marston.LAALACESProperties_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESProperties_20240916', 'LandRegistryStatus', LandRegistryStatus::TEXT
    FROM marston.LAALACESProperties_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESProperties_20240916', 'ExperianStatus', ExperianStatus::TEXT
    FROM marston.LAALACESProperties_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESProperties_20240916', 'VerificationStatus', VerificationStatus::TEXT
    FROM marston.LAALACESProperties_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESLandRegistryAssociations_20240916', 'IsIgnored', IsIgnored::TEXT
    FROM marston.LAALACESLandRegistryAssociations_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseCallLog_20240916', 'ActionType', ActionType::TEXT
    FROM marston.LAACaseCallLog_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESAudit_20240916', 'TableName', TableName::TEXT
    FROM marston.LAALACESAudit_20240916
    UNION ALL
    SELECT DISTINCT 'LAALACESAudit_20240916', 'ColumnName', ColumnName::TEXT
    FROM marston.LAALACESAudit_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseRefunds_20240916', 'Status', Status::TEXT
    FROM marston.LAACaseRefunds_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseRefunds_20240916', 'RefundType', RefundType::TEXT
    FROM marston.LAACaseRefunds_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseRefunds_20240916', 'RefundMethod', RefundMethod::TEXT
    FROM marston.LAACaseRefunds_20240916
    UNION ALL
    SELECT DISTINCT 'LAACaseRefunds_20240916', 'LoadedBy', LoadedBy::TEXT
    FROM marston.LAACaseRefunds_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersWelfare_20240916', 'WelfareCategory', WelfareCategory::TEXT
    FROM marston.LAADefaultersWelfare_20240916
    UNION ALL
    SELECT DISTINCT 'LAADefaultersWelfare_20240916', 'proofproivded', proofproivded::TEXT
    FROM marston.LAADefaultersWelfare_20240916;
    
    -- Optionally, you can include a final ORDER BY clause if needed
    -- ORDER BY table_name, column_name, value;
END;
