



SELECT json_agg(
				json_build_object(
									'CaseID', cases.caseid,
									'CaseNumber', cases.casenumber,
									'ClientCaseRef-maatID', cases.clientcasereference,
									'LoadedOn', cases.loadedon,
									'PrevCaseRef', cases.previouscasereference,
									'DefendantID', defendant.defaulterid,
									'Name', defendant.Name,
									'DOB', defendant.DOB,
									'NINO', defendant.NINO,
									'LoadeOn', defendant.LoadedOn,
									'OutstandingBalance', balance.OutstandingBalance,
									'OriginalBalance', balance.OriginalBalance,
									'ClientName', casedetail.ClientName,
									'ClientCaseRef', casedetail.ClientCaseReference,
									'ClientDefaulterRef', casedetail.ClientDefaulterReference,
									'CurrentStatus', casedetail.CurrentStatus,
									'StatusDate', casedetail.StatusDate,
									'OpenClosedStatus', casedetail.OpenClosedStatus,
									'CaseClosureDate', casedetail.CaseClosureDate,
									'CourtCode', casedetail.CourtCode,
									'CourtName', casedetail.CourtName,
									'Outcome', casedetail.Outcome,
									'SentenceOrderDate', casedetail.SentenceOrderDate,
									'LoadedOn', casedetail.LoadedOn,
									'LoadedBy', casedetail.LoadedBy,
									'CASE-LINKS', (
												SELECT json_agg(
																json_build_object(
																				'LinkID', caselinks.LinkID,
																				'LinkedCaseID', caselinks.LinkedCaseID,
																				'LinkedMaatID', caselinks.clientcasereference,
																				'LoadedOn', caselinks.LoadedOn
																				 )
																)
												FROM (
													SELECT caselinks.LinkID,caselinks.LinkedCaseID,cases2.clientcasereference,caselinks.LoadedOn
													FROM marston.laacaselinks_20240810_1 caselinks,
													     marston.laacases_20240810_1 cases2
													WHERE caselinks.caseid = cases2.caseid
													AND caselinks.caseid = cases.caseid
												) caselinks
											),
									'CHARGES', (
												SELECT json_agg(
																json_build_object(
																				'ChargeRecordID', charges.ChargeRecordID,
																				'ChargeDescription', charges.ChargeDescription,
																				'RemitTo', charges.RemitTo,
																				'PaidBy', charges.PaidBy,
																				'ChargeDate', charges.ChargeDate,
																				'ChargeAmount', charges.ChargeAmount,
																				'VATAmount', charges.VATAmount,
																				'ChargeReversedDate', charges.ChargeReversedDate,
																				'LoadedBy', charges.LoadedBy
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laacasecharges_20240810_1 charges
													WHERE charges.caseid = cases.caseid
													ORDER BY charges.chargedate ASC  -- ORDER the rows here
												) charges
											),
									'PAYMENTS', (
												SELECT json_agg(
																json_build_object(
																				'PaymentRecordID', payments.PaymentRecordID,
																				'ReceivedOn', payments.ReceivedOn,
																				'TransactionDate', payments.TransactionDate,
																				'PaymentType', payments.PaymentType,
																				'Amount', payments.Amount,
																				'BouncedDate', payments.BouncedDate,
																				'ClearedDate', payments.ClearedDate,
																				'Reference', payments.Reference,
																				'ReversedDate', payments.ReversedDate,
																				'Status', payments.Status,
																				'TransactionFee', payments.TransactionFee,
																				'LoadedBy', payments.LoadedBy
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laacasepayments_20240810_1 payments
													WHERE payments.caseid = cases.caseid
													ORDER BY payments.TransactionDate ASC  -- ORDER the rows here
												) payments
											),
									'PAYMENT-ARRANGEMENTS', (
												SELECT json_agg(
																json_build_object(
																				'ArrangementID', arrangements.ArrangementID,
																				'ArrangementRef', arrangements.ArrangementReference,
																				'SetupDate', arrangements.SetupDate,
																				'FirstInstalmentAmount', arrangements.FirstInstalmentAmount,
																				'FirstInstalmentDate', arrangements.FirstInstalmentDate,
																				'SubsequentInstalmentAmounts', arrangements.SubsequentInstalmentAmounts,
																				'NumberOfInstalments', arrangements.NumberOfInstalments,
																				'InstalmentFrequency', arrangements.InstalmentFrequency,
																				'Status', arrangements.Status,
																				'StatusDate', arrangements.StatusDate
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laacasearrangements_20240810_1 arrangements
													WHERE arrangements.caseid = cases.caseid
													ORDER BY arrangements.SetupDate ASC  -- ORDER the rows here
												) arrangements
											),
									'CASE-VISITS', (
												SELECT json_agg(
																json_build_object(
																				'VisitRecordID', visits.VisitRecordID,
																				'VisitDate', visits.VisitDate,
																				'ActionID', visits.ActionID,
																				'Action', visits.Action
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laacasevisits_20240810_1 visits
													WHERE visits.caseid = cases.caseid
													ORDER BY visits.VisitDate ASC  -- ORDER the rows here
												) visits
											),
									'ADDITIONAL-DATA', (
												SELECT json_agg(
																json_build_object(
																				'AdditionalDataRecordID', additionaldata.AdditionalDataRecordID,
																				'Name', additionaldata.Name,
																				'Value', additionaldata.Value,
																				'LoadedOn', additionaldata.LoadedOn
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laacaseadditionaldata_20240810_1 additionaldata
													WHERE additionaldata.caseid = cases.caseid
													ORDER BY additionaldata.LoadedOn ASC  -- ORDER the rows here
												) additionaldata
											),
									'HOLDS', (
												SELECT json_agg(
																json_build_object(
																				'HoldRecordID', holds.HoldRecordID,
																				'HoldDate', holds.HoldDate,
																				'HoldUntilDate', holds.HoldUntilDate,
																				'HoldReason', holds.HoldReason,
																				'RecommencedOn', holds.RecommencedOn,
																				'RecommenceReason', holds.RecommenceReason
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laacaseholds_20240810_1 holds
													WHERE holds.caseid = cases.caseid
													ORDER BY holds.HoldDate ASC  -- ORDER the rows here
												) holds
											),
									'ADDRESSES', (
												SELECT json_agg(
																json_build_object(
																				'DefendantID', address.defaulterid,
																				'AddressRecordID', address.AddressRecordID,
																				'AddressLine1', address.AddressLine1,
																				'AddressLine2', address.AddressLine2,
																				'AddressLine3', address.AddressLine3,
																				'AddressLine4', address.AddressLine4,
																				'AddressLine5', address.AddressLine5,
																				'AddressPC', address.AddressPC,
																				'WarrantAddress', address.WarrantAddr,
																				'BusinessAddress', address.BusinessAddress,
																				'IsPrimaryContactAddress', address.IsPrimaryContactAddress,
																				'IsAddressConfirmed', address.IsAddressConfirmed,
																				'Source', address.Source,
																				'LoadedOn', address.LoadedOn
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laadefaulterscontactaddresses_20240810_1 address
													WHERE address.caseid = cases.caseid
													ORDER BY address.LoadedOn ASC  -- ORDER the rows here
												) address
											),
									'EMAILS', (
												SELECT json_agg(
																json_build_object(
																				'DefendantID', email.defaulterid,
																				'EmailRecordID', email.EmailRecordID,
																				'Email', email.Email,
																				'Status', email.Status,
																				'Source', email.Source,
																				'IsConsented', email.IsConsented,
																				'IsPreferred', email.IsPreferred,
																				'IsRightPartyConfirmed', email.IsRightPartyConfirmed,
																				'LoadedOn', email.LoadedOn
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laadefaultersemails_20240810_1 email
													WHERE email.caseid = cases.caseid
													ORDER BY email.LoadedOn ASC  -- ORDER the rows here
												) email
											),
									'PHONES', (
												SELECT json_agg(
																json_build_object(
																				'DefendantID', phone.defaulterid,
																				'PhoneRecordID', phone.PhoneRecordID,
																				'Number', phone.Number,
																				'Type', phone.Type,
																				'Status', phone.Status,
																				'Source', phone.Source,
																				'IsPreferred', phone.IsPreferred,
																				'IsRightPartyConfirmed', phone.IsRightPartyConfirmed,
																				'LoadedOn', phone.LoadedOn
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laadefaultersphones_20240810_1 phone
													WHERE phone.caseid = cases.caseid
													ORDER BY phone.LoadedOn ASC  -- ORDER the rows here
												) phone
											),
									'NOTES', (
												SELECT json_agg(
																json_build_object(
																				'CaseNotesRecordID', notes.CaseNotesRecordID,
																				'LoadedOn', notes.LoadedOn,
																				'Comment', notes.Comment,
																				'NoteType', notes.NoteType
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laacasenotes_20240810_1 notes
													WHERE notes.caseid = cases.caseid
													ORDER BY notes.LoadedOn ASC  -- ORDER the rows here
												) notes
											),
									'HISTORY', (
												SELECT json_agg(
																json_build_object(
																				'CaseHistoryRecordID', history.CaseHistoryRecordID,
																				'LoadedOn', history.LoadedOn,
																				'Comment', history.Comment,
																				'NoteType', history.NoteType
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laacasehistory_20240810_1 history
													WHERE history.caseid = cases.caseid
													ORDER BY history.LoadedOn ASC  -- ORDER the rows here
												) history
											),
									'ASSIGNMENTS', (
												SELECT json_agg(
																json_build_object(
																				'CommentRecordID', assignments.CommentRecordID,
																				'LoadedOn', assignments.LoadedOn,
																				'Comment', assignments.Comment,
																				'Action', assignments.Action,
																				'LoadedBy', assignments.LoadedBy
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laacaseassignments_20240810_1 assignments
													WHERE assignments.caseid = cases.caseid
													ORDER BY assignments.LoadedOn ASC  -- ORDER the rows here
												) assignments
											),
									'WORKFLOW', (
												SELECT json_agg(
																json_build_object(
																				'CaseHistoryRecordID', workflow.CaseHistoryRecordID,
																				'LoadedOn', workflow.LoadedOn,
																				'Comment', workflow.Comment,
																				'Phase', workflow.Phase,
																				'Stage', workflow.Stage
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laacaseworkflow_20240810_1 workflow
													WHERE workflow.caseid = cases.caseid
													ORDER BY workflow.LoadedOn ASC  -- ORDER the rows here
												) workflow
											),
									'ATTACHMENTS', (
												SELECT json_agg(
																json_build_object(
																				'AttachmentsRecordID', attachments.AttachmentsRecordID,
																				'LoadedOn', attachments.LoadedOn,
																				'LoadedBy', attachments.LoadedBy,
																				'Name', attachments.Name,
																				'Fullname', attachments.Fullname,
																				'AttachmentType', attachments.AttachmentType
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laacaseattachments_20240810_1 attachments
													WHERE attachments.caseid = cases.caseid
													ORDER BY attachments.LoadedOn ASC  -- ORDER the rows here
												) attachments
											),
									'LACES-DATA', (
												SELECT json_agg(
																json_build_object(
																				'RecordID', lacesdata.RecordID,
																				'LacesCaseID', lacesdata.LacesCaseID,
																				'DebtorID', lacesdata.DebtorID,
																				'MaatID', lacesdata.MaatID,
																				'LoadedOn', lacesdata.LoadedOn,
																				'FirstName', lacesdata.FirstName,
																				'LastName', lacesdata.LastName,
																				'DOB', lacesdata.DOB,
																				'HasPartner', lacesdata.HasPartner,
																				'HasPartnerContraryInterest', lacesdata.HasPartnerContraryInterest,
																				'PartnerFirstName', lacesdata.PartnerFirstName,
																				'PartnerLastName', lacesdata.PartnerLastName,
																				'TotalAvailableCapitalAssets', lacesdata.TotalAvailableCapitalAssets,
																				'AllEvidenceDate', lacesdata.AllEvidenceDate,
																				'NumOfAvailableCapitalAssets', lacesdata.NumberOfAvailableCapitalAssets,
																				'IsAllEvidenceProvided', lacesdata.IsAllEvidenceProvided,
																				'IsSufficientCapitalAndEquity', lacesdata.IsSufficientCapitalAndEquity,
																				'CaseCap', lacesdata.CaseCap,
																				'EquityVerifiedDate', lacesdata.EquityVerifiedDate,
																				'LACES-CASES', (
																							SELECT json_agg(
																											json_build_object(
																															'CaseStatus', lacescases.CaseStatus,
																															'LastUpdate', lacescases.LastUpdate,
																															'IssueSource', lacescases.IssueSource,
																															'JointCreditAgreementExists', lacescases.JointCreditAgreementExists,
																															'ProjectedCreditScore', lacescases.ProjectedCreditScore,
																															'IsFoundCreditPositionConsistentWithDeclared', lacescases.IsFoundCreditPositionConsistentWithDeclared,
																															'WasUploadedManually', lacescases.WasUploadedManually,
																															'LACES-ASSIGNMENTS', (
																																		SELECT json_agg(
																																						json_build_object(
																																										'StartDate', lacesasgmt.StartDate,
																																										'EndDate', lacesasgmt.EndDate
																																										)
																																						)
																																		FROM (
																																			SELECT *
																																			FROM marston.laalacesassignments_20240810_1 lacesasgmt
																																			WHERE lacesasgmt.lacescaseid = lacescases.lacescaseid
																																			ORDER BY lacesasgmt.StartDate ASC  -- ORDER the rows here
																																		) lacesasgmt
																																	),
																															'LACES-CASEACTIONS', (
																																		SELECT json_agg(
																																						json_build_object(
																																										'ChangeDate', lacescaseactions.ChangeDate,
																																										'ActionType', lacescaseactions.ActionType,
																																										'Description', lacescaseactions.Description,
																																										'NewStatus', lacescaseactions.NewStatus
																																										)
																																						)
																																		FROM (
																																			SELECT *
																																			FROM marston.laalacescaseactions_20240810_1 lacescaseactions
																																			WHERE lacescaseactions.lacescaseid = lacescases.lacescaseid
																																			ORDER BY lacescaseactions.ChangeDate ASC  -- ORDER the rows here
																																		) lacescaseactions
																																	),
																															'LACES-PROPERTIES', (
																																		SELECT json_agg(
																																						json_build_object(
																																										'RecordID', lacesproperties.RecordID,
																																										'ResidentialDescription', lacesproperties.ResidentialDescription,
																																										'DeclaredValue', lacesproperties.DeclaredValue,
																																										'DeclaredMortgage', lacesproperties.DeclaredMortgage,
																																										'VerifiedValue', lacesproperties.VerifiedValue,
																																										'VerifiedMortgage', lacesproperties.VerifiedMortgage,
																																										'VerifiedDate', lacesproperties.VerifiedDate,
																																										'PercentageOwnedApplicant', lacesproperties.PercentageOwnedApplicant,
																																										'PercentageOwnedPartner', lacesproperties.PercentageOwnedPartner,
																																										'Addressline1', lacesproperties.Addressline1,
																																										'Addressline2', lacesproperties.Addressline2,
																																										'Addressline3', lacesproperties.Addressline3,
																																										'PostCode', lacesproperties.PostCode,
																																										'IsMainProperty', lacesproperties.IsMainProperty,
																																										'FoundValue', lacesproperties.FoundValue,
																																										'FoundPercentageOwnedApplicant', lacesproperties.FoundPercentageOwnedApplicant,
																																										'FoundPercentageOwnedPartner', lacesproperties.FoundPercentageOwnedPartner,
																																										'IsPercentageSetByUser', lacesproperties.IsPercentageSetByUser,
																																										'LandRegistryStatus', lacesproperties.LandRegistryStatus,
																																										'ExperianStatus', lacesproperties.ExperianStatus,
																																										'VerificationStatus', lacesproperties.VerificationStatus,
																																										'LACES-LAND-REG-ENTRIES', (
																																													SELECT json_agg(
																																																	json_build_object(
																																																					'RecordID', laceslandregentries.RecordID,
																																																					'PropertyID', laceslandregentries.PropertyID,
																																																					'LastUpdateDate', laceslandregentries.LastUpdateDate,
																																																					'NameMatchResult', laceslandregentries.NameMatchResult,
																																																					'LACES-LAND-REG-ASSOCIATIONS', (
																																																								SELECT json_agg(
																																																												json_build_object(
																																																																'RecordID', laceslandregAssn.RecordID,
																																																																'LandRegistryEntryID', laceslandregAssn.LandRegistryEntryID,
																																																																'Proprietor', laceslandregAssn.Proprietor,
																																																																'IsIgnored', laceslandregAssn.IsIgnored
																																																																)
																																																												)
																																																								FROM (
																																																									SELECT *
																																																									FROM marston.laalaceslandregistryassociations_20240810_1 laceslandregAssn
																																																									WHERE laceslandregAssn.LandRegistryEntryID = laceslandregentries.RecordID
																																																								) laceslandregAssn
																																																							)
																																																					)
																																																	)
																																													FROM (
																																														SELECT *
																																														FROM marston.laalaceslandregistryentries_20240810_1 laceslandregentries
																																														WHERE laceslandregentries.PropertyID = lacesproperties.RecordID
																																													) laceslandregentries
																																												)
																																										)
																																						)
																																		FROM (
																																			SELECT *
																																			FROM marston.laalacesproperties_20240810_1 lacesproperties
																																			WHERE lacesproperties.lacescaseid = lacescases.lacescaseid
																																			ORDER BY lacesproperties.RecordId ASC  -- ORDER the rows here
																																		) lacesproperties
																																	)
																															)
																											)
																							FROM (
																								SELECT *
																								FROM marston.laalacescases_20240810_1 lacescases
																								WHERE lacescases.lacescaseid = lacesdata.lacescaseid
																								ORDER BY lacescases.LastUpdate ASC  -- ORDER the rows here
																							) lacescases
																						),
																				'LACES-EXPERIAN_ENTRIES', (
																							SELECT json_agg(
																											json_build_object(
																															'LastUpdateDate', experianentries.LastUpdateDate,
																															'YearsAtCurrentAddress', experianentries.YearsAtCurrentAddress,
																															'MonthsAtCurrentAddress', experianentries.MonthsAtCurrentAddress,
																															'ResidencyScore', experianentries.ResidencyScore,
																															'IsBankrupt', experianentries.IsBankrupt,
																															'HasCCJ', experianentries.HasCCJ,
																															'HasIVA', experianentries.HasIVA,
																															'PropensityToPayScore', experianentries.PropensityToPayScore,
																															'UtdAccountsCount', experianentries.UtdAccountsCount,
																															'NotUtdAccountsCount', experianentries.NotUtdAccountsCount,
																															'BankAccountsCount', experianentries.BankAccountsCount,
																															'LACES-EXPERIAN-MORTGAGE-ENTRIES', (
																																		SELECT json_agg(
																																						json_build_object(
																																										'RecordID', experianmortgageentries.RecordID,
																																										'Mortgage', experianmortgageentries.Mortgage,
																																										'ExperianEntryID', experianmortgageentries.ExperianEntryID,
																																										'PropertyID', experianmortgageentries.PropertyID
																																										)
																																						)
																																		FROM (
																																			SELECT *
																																			FROM marston.laalacesexperianmortgageentries_20240810_1 experianmortgageentries
																																			WHERE experianmortgageentries.ExperianEntryID = experianentries.RecordID
																																		) experianmortgageentries
																																	)
																															)
																											)
																							FROM (
																								SELECT *
																								FROM marston.laalacesexperianentries_20240810_1 experianentries
																								WHERE experianentries.lacescaseid = lacesdata.lacescaseid
																								ORDER BY experianentries.LastUpdateDate ASC  -- ORDER the rows here
																							) experianentries
																						),
																				'LACES-AUDIT(LacesDW)', (
																							SELECT json_agg(
																											json_build_object(
																															'AuditID', lacesaudit.AuditID,
																															'AuditDate', lacesaudit.AuditDate,
																															'TableName', lacesaudit.TableName,
																															'ColumnName', lacesaudit.ColumnName,
																															'RowID', lacesaudit.RowID,
																															'Value', lacesaudit.Value,
																															'Description', lacesaudit.Description
																															)
																											)
																							FROM (
																								SELECT *
																								FROM marston.laalacesaudit_20240810_1 lacesaudit
																								WHERE lacesaudit.RowID = lacesdata.RecordID
																								ORDER BY lacesaudit.AuditDate ASC  -- ORDER the rows here
																							) lacesaudit
																						)
																				 )
																)
												FROM (
													SELECT *
													FROM marston.laalacesdatawarehouse_20240810_1 lacesdata
													WHERE lacesdata.maatid = cases.clientcasereference
													ORDER BY lacesdata.LoadedOn ASC  -- ORDER the rows here
												) lacesdata
											)
								)
			) AS Cases_JSON
FROM marston.laacases_20240810_1 cases,
     marston.laadefaulters_20240810_1 defendant,
	 marston.laacasebalance_20240810_1 balance,
	 marston.laacasedetails_20240810_1 casedetail
WHERE cases.caseid = defendant.caseid
AND cases.caseid = balance.caseid
AND cases.caseid = casedetail.caseid
AND (cases.caseid in ('12846524','12846653','12846530','12846525','12846564')
	OR cases.clientcasereference in ('3499268'))



/*
ALTER TABLE marston.laalaceslandregistryassociations_20240810_1
ALTER COLUMN landregistryentryid TYPE integer
USING landregistryentryid::integer;

CREATE INDEX idx_laalacesexperianmortgageentries_20240810_1_ExperianEntryID ON marston.laalacesexperianmortgageentries_20240810_1 (ExperianEntryID);

CREATE INDEX idx_laalaceslandregistryassociations_20240810_1_landregentryid ON marston.laalaceslandregistryassociations_20240810_1 (landregistryentryid);

drop index marston.idx_laalaceslandregistryassociations_20240810_1_landregistryent

*/






