
DECLARE
    v_exists BOOLEAN;
BEGIN
    -- Check marston.laacases_20241203
    RAISE NOTICE 'Checks for laacases_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacases_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    loadedon IS NULL OR
                    clientcasereference IS NULL OR clientcasereference = ''NULL'' OR length(clientcasereference) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacases_20241203 table';
    END IF;

    -- Check marston.laacasedetails_20241203
    RAISE NOTICE 'Checks for laacasedetails_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacasedetails_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    clientname IS NULL OR clientname = ''NULL'' OR length(clientname) = 0 OR
                    clientcasereference IS NULL OR clientcasereference = ''NULL'' OR length(clientcasereference) = 0 OR
                    clientdefaulterreference IS NULL OR clientdefaulterreference = ''NULL'' OR length(clientdefaulterreference) = 0 OR
                    currentstatus IS NULL OR currentstatus = ''NULL'' OR length(currentstatus) = 0 OR
                    statusdate IS NULL OR
                    openclosedstatus IS NULL OR openclosedstatus = ''NULL'' OR length(openclosedstatus) = 0 OR
                    currentphase IS NULL OR currentphase = ''NULL'' OR length(currentphase) = 0 OR
                    currentstage IS NULL OR currentstage = ''NULL'' OR length(currentstage) = 0 OR
                    loadedon IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacasedetails_20241203 table';
    END IF;

    -- Check marston.laadefaulters_20241203
    RAISE NOTICE 'Checks for laadefaulters_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laadefaulters_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    defaulterid IS NULL OR defaulterid = ''NULL'' OR length(defaulterid) = 0 OR
                    name IS NULL OR name = ''NULL'' OR length(name) = 0 OR
                    loadedon IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laadefaulters_20241203 table';
    END IF;

    -- Check marston.laadefaultersphones_20241203
    RAISE NOTICE 'Checks for laadefaultersphones_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laadefaultersphones_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    phonerecordid IS NULL OR phonerecordid = ''NULL'' OR length(phonerecordid) = 0 OR
                    number IS NULL OR number = ''NULL'' OR length(number) = 0 OR
                    loadedon IS NULL OR
                    status IS NULL OR status = ''NULL'' OR length(status) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laadefaultersphones_20241203 table';
    END IF;

    -- Check marston.laadefaultersemails_20241203
    RAISE NOTICE 'Checks for laadefaultersemails_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laadefaultersemails_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    defaulterid IS NULL OR defaulterid = ''NULL'' OR length(defaulterid) = 0 OR
                    emailrecordid IS NULL OR emailrecordid = ''NULL'' OR length(emailrecordid) = 0 OR
                    email IS NULL OR email = ''NULL'' OR length(email) = 0 OR
                    loadedon IS NULL OR
                    status IS NULL OR status = ''NULL'' OR length(status) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laadefaultersemails_20241203 table';
    END IF;

    -- Check marston.laadefaulterscontactaddresses_20241203
    RAISE NOTICE 'Checks for laadefaulterscontactaddresses_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laadefaulterscontactaddresses_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    addressrecordid IS NULL OR addressrecordid = ''NULL'' OR length(addressrecordid) = 0 OR
                    loadedon IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laadefaulterscontactaddresses_20241203 table';
    END IF;

    -- Check marston.laadefaultersphonesaudit_20241203
    RAISE NOTICE 'Checks for laadefaultersphonesaudit_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laadefaultersphonesaudit_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    defaulterid IS NULL OR defaulterid = ''NULL'' OR length(defaulterid) = 0 OR
                    phonerecordid IS NULL OR phonerecordid = ''NULL'' OR length(phonerecordid) = 0 OR
                    auditrecordid IS NULL OR auditrecordid = ''NULL'' OR length(auditrecordid) = 0 OR
                    actiondate IS NULL OR
                    field IS NULL OR field = ''NULL'' OR length(field) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laadefaultersphonesaudit_20241203 table';
    END IF;

    -- Check marston.laadefaultersemailsaudit_20241203
    RAISE NOTICE 'Checks for laadefaultersemailsaudit_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laadefaultersemailsaudit_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    defaulterid IS NULL OR defaulterid = ''NULL'' OR length(defaulterid) = 0 OR
                    emailrecordid IS NULL OR emailrecordid = ''NULL'' OR length(emailrecordid) = 0 OR
                    auditrecordid IS NULL OR auditrecordid = ''NULL'' OR length(auditrecordid) = 0 OR
                    actiondate IS NULL OR
                    field IS NULL OR field = ''NULL'' OR length(field) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laadefaultersemailsaudit_20241203 table';
    END IF;

    -- Check marston.laadefaulterscontactaddressesaudit_20241203
    RAISE NOTICE 'Checks for laadefaulterscontactaddressesaudit_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laadefaulterscontactaddressesaudit_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    defaulterid IS NULL OR defaulterid = ''NULL'' OR length(defaulterid) = 0 OR
                    auditrecordid IS NULL OR auditrecordid = ''NULL'' OR length(auditrecordid) = 0 OR
                    actiondate IS NULL OR
                    field IS NULL OR field = ''NULL'' OR length(field) = 0 
                  --  oldvalue IS NULL OR oldvalue = ''NULL'' OR length(oldvalue) = 0 OR
                  --  newvalue IS NULL OR newvalue = ''NULL'' OR length(newvalue) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laadefaulterscontactaddressesaudit_20241203 table';
    END IF;

    -- Check marston.laacasecharges_20241203
    RAISE NOTICE 'Checks for laacasecharges_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacasecharges_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    chargerecordid IS NULL OR chargerecordid = ''NULL'' OR length(chargerecordid) = 0 OR
                    chargedescription IS NULL OR chargedescription = ''NULL'' OR length(chargedescription) = 0 OR
                    paidby IS NULL OR paidby = ''NULL'' OR length(paidby) = 0 OR
                    chargedate IS NULL OR
                    chargeamount IS NULL OR chargeamount = ''NULL'' OR length(chargeamount) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacasecharges_20241203 table';
    END IF;

    -- Check marston.laacasepayments_20241203
    RAISE NOTICE 'Checks for laacasepayments_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacasepayments_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    paymentrecordid IS NULL OR paymentrecordid = ''NULL'' OR length(paymentrecordid) = 0 OR
                    receivedon IS NULL OR receivedon = ''NULL'' OR length(receivedon) = 0 OR
                    transactiondate IS NULL OR
                    paymenttype IS NULL OR paymenttype = ''NULL'' OR length(paymenttype) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacasepayments_20241203 table';
    END IF;

    -- Check marston.laacaseassignments_20241203
    RAISE NOTICE 'Checks for laacaseassignments_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacaseassignments_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    commentrecordid IS NULL OR commentrecordid = ''NULL'' OR length(commentrecordid) = 0 OR
                    loadedon IS NULL OR
                    comment IS NULL OR comment = ''NULL'' OR length(comment) = 0 OR
                    action IS NULL OR action = ''NULL'' OR length(action) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacaseassignments_20241203 table';
    END IF;

    -- Check marston.laacaseholds_20241203
    RAISE NOTICE 'Checks for laacaseholds_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacaseholds_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    holdrecordid IS NULL OR holdrecordid = ''NULL'' OR length(holdrecordid) = 0 OR
                    holddate IS NULL OR
                    holdreason IS NULL OR holdreason = ''NULL'' OR length(holdreason) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacaseholds_20241203 table';
    END IF;

    -- Check marston.laacasearrangements_20241203
    RAISE NOTICE 'Checks for laacasearrangements_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacasearrangements_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    arrangementid IS NULL OR arrangementid = ''NULL'' OR length(arrangementid) = 0 OR
                    setupdate IS NULL OR
                    firstinstalmentamount IS NULL OR firstinstalmentamount = ''NULL'' OR length(firstinstalmentamount) = 0 OR
                    firstinstalmentdate IS NULL OR
                    numberofinstalments IS NULL OR numberofinstalments = ''NULL'' OR length(numberofinstalments) = 0 OR
                    instalmentfrequency IS NULL OR instalmentfrequency = ''NULL'' OR length(instalmentfrequency) = 0 OR
                    status IS NULL OR status = ''NULL'' OR length(status) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacasearrangements_20241203 table';
    END IF;

    -- Check marston.laacasevisits_20241203
    RAISE NOTICE 'Checks for laacasevisits_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacasevisits_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    visitrecordid IS NULL OR visitrecordid = ''NULL'' OR length(visitrecordid) = 0 OR
                    visitdate IS NULL OR
                    actionid IS NULL OR actionid = ''NULL'' OR length(actionid) = 0 OR
                    action IS NULL OR action = ''NULL'' OR length(action) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacasevisits_20241203 table';
    END IF;

    -- Check marston.laacaseadditionaldata_20241203
    RAISE NOTICE 'Checks for laacaseadditionaldata_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacaseadditionaldata_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    additionaldatarecordid IS NULL OR additionaldatarecordid = ''NULL'' OR length(additionaldatarecordid) = 0 OR
                    name IS NULL OR name = ''NULL'' OR length(name) = 0 OR
                    loadedon IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacaseadditionaldata_20241203 table';
    END IF;

    -- Check marston.laacaseattachments_20241203
    RAISE NOTICE 'Checks for laacaseattachments_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacaseattachments_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    attachmentsrecordid IS NULL OR attachmentsrecordid = ''NULL'' OR length(attachmentsrecordid) = 0 OR
                    loadedon IS NULL OR
                    name IS NULL OR name = ''NULL'' OR length(name) = 0 OR
                    fullname IS NULL OR fullname = ''NULL'' OR length(fullname) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacaseattachments_20241203 table';
    END IF;

    -- Check marston.laaclientpaymentruns_20241203
    RAISE NOTICE 'Checks for laaclientpaymentruns_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laaclientpaymentruns_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    clientpaymentrunrecordid IS NULL OR clientpaymentrunrecordid = ''NULL'' OR length(clientpaymentrunrecordid) = 0 OR
                    clientpaymentrunhistoryrecordid IS NULL OR clientpaymentrunhistoryrecordid = ''NULL'' OR length(clientpaymentrunhistoryrecordid) = 0 OR
                    clientpaymentrundate IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laaclientpaymentruns_20241203 table';
    END IF;

    -- Check marston.laaclientinvoiceruns_20241203
    RAISE NOTICE 'Checks for laaclientinvoiceruns_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laaclientinvoiceruns_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    clientinvoicerunrecordid IS NULL OR clientinvoicerunrecordid = ''NULL'' OR length(clientinvoicerunrecordid) = 0 OR
                    clientinvoicerundate IS NULL OR
                    chargeamount IS NULL OR chargeamount = ''NULL'' OR length(chargeamount) = 0 OR
                    vatamount IS NULL OR vatamount = ''NULL'' OR length(vatamount) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laaclientinvoiceruns_20241203 table';
    END IF;

    -- Check marston.laacaselinks_20241203
    RAISE NOTICE 'Checks for laacaselinks_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacaselinks_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    linkid IS NULL OR linkid = ''NULL'' OR length(linkid) = 0 OR
                    loadedon IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacaselinks_20241203 table';
    END IF;

    -- Check marston.laacasenotes_20241203
    RAISE NOTICE 'Checks for laacasenotes_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacasenotes_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    casenotesrecordid IS NULL OR casenotesrecordid = ''NULL'' OR length(casenotesrecordid) = 0 OR
                    loadedon IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacasenotes_20241203 table';
    END IF;

    -- Check marston.laacasehistory_20241203
    RAISE NOTICE 'Checks for laacasehistory_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacasehistory_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    casehistoryrecordid IS NULL OR casehistoryrecordid = ''NULL'' OR length(casehistoryrecordid) = 0 OR
                    loadedon IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacasehistory_20241203 table';
    END IF;

    -- Check marston.laalacescases_20241203
    RAISE NOTICE 'Checks for laalacescases_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laalacescases_20241203
            WHERE 
                json_footer IS NULL AND (
                    lacescaseid IS NULL OR lacescaseid = ''NULL'' OR length(lacescaseid) = 0 OR
                    casestatus IS NULL OR casestatus = ''NULL'' OR length(casestatus) = 0 OR
                    lastupdate IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laalacescases_20241203 table';
    END IF;

    -- Check marston.laalacesdatawarehouse_20241203
    RAISE NOTICE 'Checks for laalacesdatawarehouse_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laalacesdatawarehouse_20241203
            WHERE 
                json_footer IS NULL AND (
                    recordid IS NULL OR recordid = ''NULL'' OR length(recordid) = 0 OR
                    lacescaseid IS NULL OR lacescaseid = ''NULL'' OR length(lacescaseid) = 0 OR
                    debtorid IS NULL OR debtorid = ''NULL'' OR length(debtorid) = 0 OR
                    maatid IS NULL OR maatid = ''NULL'' OR length(maatid) = 0 OR
                    loadedon IS NULL OR
                    firstname IS NULL OR firstname = ''NULL'' OR length(firstname) = 0 OR
                    lastname IS NULL OR lastname = ''NULL'' OR length(lastname) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laalacesdatawarehouse_20241203 table';
    END IF;

    -- Check marston.laalacesassignments_20241203
    RAISE NOTICE 'Checks for laalacesassignments_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laalacesassignments_20241203
            WHERE 
                json_footer IS NULL AND (
                    recordid IS NULL OR recordid = ''NULL'' OR length(recordid) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laalacesassignments_20241203 table';
    END IF;

    -- Check marston.laalacescasesactions_20241203
    RAISE NOTICE 'Checks for laalacescasesactions_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laalacescasesactions_20241203
            WHERE 
                json_footer IS NULL AND (
                    recordid IS NULL OR recordid = ''NULL'' OR length(recordid) = 0 OR
                    lacescaseid IS NULL OR lacescaseid = ''NULL'' OR length(lacescaseid) = 0 OR
                    changedate IS NULL OR
                     ((actiontype IS NULL OR actiontype = ''NULL'' OR length(actiontype) = 0) AND
                    ((description IS NULL OR description = ''NULL'' OR length(description) = 0) AND 
                    newstatus IS NULL OR newstatus = ''NULL'' OR length(newstatus) = 0))
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laalacescasesactions_20241203 table';
    END IF;

    -- Check marston.laalacesexperianentries_20241203
    RAISE NOTICE 'Checks for laalacesexperianentries_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laalacesexperianentries_20241203
            WHERE 
                json_footer IS NULL AND (
                    recordid IS NULL OR recordid = ''NULL'' OR length(recordid) = 0 OR
                    lacescaseid IS NULL OR lacescaseid = ''NULL'' OR length(lacescaseid) = 0 OR
                    lastupdatedate IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laalacesexperianentries_20241203 table';
    END IF;

    -- Check marston.laalacesexperianmortgageentries_20241203
    RAISE NOTICE 'Checks for laalacesexperianmortgageentries_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laalacesexperianmortgageentries_20241203
            WHERE 
                json_footer IS NULL AND (
                    recordid IS NULL OR recordid = ''NULL'' OR length(recordid) = 0 OR
                    mortgage IS NULL OR mortgage = ''NULL'' OR length(mortgage) = 0 OR
                    experianentryid IS NULL OR experianentryid = ''NULL'' OR length(experianentryid) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laalacesexperianmortgageentries_20241203 table';
    END IF;

    -- Check marston.laalacesexperianassociations_20241203
    RAISE NOTICE 'Checks for laalacesexperianassociations_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laalacesexperianassociations_20241203
            WHERE 
                json_footer IS NULL AND (
                    experianassociationsrecordid IS NULL OR experianassociationsrecordid = ''NULL'' OR length(experianassociationsrecordid) = 0 OR
                    experianentriesrecordid IS NULL OR experianentriesrecordid = ''NULL'' OR length(experianentriesrecordid) = 0 OR
                    linkedname IS NULL OR linkedname = ''NULL'' OR length(linkedname) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laalacesexperianassociations_20241203 table';
    END IF;

    -- Check marston.laalacesproperties_20241203
    RAISE NOTICE 'Checks for laalacesproperties_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laalacesproperties_20241203
            WHERE 
                json_footer IS NULL AND (
                    recordid IS NULL OR 
                    lacescaseid IS NULL OR lacescaseid = ''NULL'' OR length(lacescaseid) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laalacesproperties_20241203 table';
    END IF;

    -- Check marston.laalaceslandregistryentries_20241203
    RAISE NOTICE 'Checks for laalaceslandregistryentries_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laalaceslandregistryentries_20241203
            WHERE 
                json_footer IS NULL AND (
                    recordid IS NULL OR
                    propertyid IS NULL OR 
                    lastupdatedate IS NULL 
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laalaceslandregistryentries_20241203 table';
    END IF;

    -- Check marston.laalaceslandregistryassociations_20241203
    RAISE NOTICE 'Checks for laalaceslandregistryassociations_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laalaceslandregistryassociations_20241203
            WHERE 
                json_footer IS NULL AND (
                    recordid IS NULL 
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laalaceslandregistryassociations_20241203 table';
    END IF;

    -- Check marston.laacasecalllog_20241203
    RAISE NOTICE 'Checks for laacasecalllog_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacasecalllog_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    casehistoryrecordid IS NULL OR casehistoryrecordid = ''NULL'' OR length(casehistoryrecordid) = 0 OR
                    loadedon IS NULL OR
                    comment IS NULL OR comment = ''NULL'' OR length(comment) = 0 OR
                    actiontype IS NULL OR actiontype = ''NULL'' OR length(actiontype) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacasecalllog_20241203 table';
    END IF;

    -- Check marston.laacasebalance_20241203
    RAISE NOTICE 'Checks for laacasebalance_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacasebalance_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    outstandingbalance IS NULL OR outstandingbalance = ''NULL'' OR length(outstandingbalance) = 0 OR
                    originalbalance IS NULL OR originalbalance = ''NULL'' OR length(originalbalance) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacasebalance_20241203 table';
    END IF;

    -- Check marston.laalacesaudit_20241203
    RAISE NOTICE 'Checks for laalacesaudit_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laalacesaudit_20241203
            WHERE 
                json_footer IS NULL AND (
                    auditid IS NULL OR auditid = ''NULL'' OR length(auditid) = 0 OR
                    auditdate IS NULL OR
                    tablename IS NULL OR tablename = ''NULL'' OR length(tablename) = 0 OR
                    rowid IS NULL OR rowid = ''NULL'' OR length(rowid) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laalacesaudit_20241203 table';
    END IF;

    -- Check marston.laacaserefunds_20241203
    RAISE NOTICE 'Checks for laacaserefunds_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacaserefunds_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    refundrecordid IS NULL OR refundrecordid = ''NULL'' OR length(refundrecordid) = 0
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacaserefunds_20241203 table';
    END IF;

    -- Check marston.laadefaulterswelfare_20241203
    RAISE NOTICE 'Checks for laadefaulterswelfare_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laadefaulterswelfare_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    welfarerecordid IS NULL OR welfarerecordid = ''NULL'' OR length(welfarerecordid) = 0 OR
                    loadedon IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laadefaulterswelfare_20241203 table';
    END IF;

	RAISE NOTICE 'Checks for laacasestatus_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacasestatus_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
					caseHistoryRecordId  IS NULL OR caseHistoryRecordId = ''NULL'' OR length(caseHistoryRecordId) = 0 OR
					FromStatus  IS NULL OR FromStatus = ''NULL'' OR length(FromStatus) = 0 OR
					ToStatus  IS NULL OR ToStatus = ''NULL'' OR length(ToStatus) = 0 OR
                    loadedon IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacasestatus_20241203 table';
    END IF;

	-- Check marston.laacaseassets
	RAISE NOTICE 'Checks for laacaseassets table has started';
	EXECUTE '
	    SELECT EXISTS (
	        SELECT 1 FROM marston.laacaseassets
	        WHERE 
   	            json_footer is null AND (
				caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
	            casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
	            casenotesrecordid IS NULL OR casenotesrecordid = ''NULL'' OR length(casenotesrecordid) = 0 OR
	            loadedon IS NULL OR
	            loadedby IS NULL OR loadedby = ''NULL'' OR length(loadedby) = 0
				)
		)
	' INTO v_exists;
	
	IF v_exists THEN
	    RAISE NOTICE 'ERROR: Null or empty values found on laacaseassets table';
	END IF;


    -- Check marston.laacaseworkflow_20241203
    RAISE NOTICE 'Checks for laacaseworkflow_20241203 table has started';
    EXECUTE '
        SELECT EXISTS (
            SELECT 1 FROM marston.laacaseworkflow_20241203
            WHERE 
                json_footer IS NULL AND (
                    caseid IS NULL OR caseid = ''NULL'' OR length(caseid) = 0 OR
                    casenumber IS NULL OR casenumber = ''NULL'' OR length(casenumber) = 0 OR
                    casehistoryrecordid IS NULL OR casehistoryrecordid = ''NULL'' OR length(casehistoryrecordid) = 0 OR
                    loadedon IS NULL
                )
        )
    ' INTO v_exists;

    IF v_exists THEN
        RAISE NOTICE 'ERROR: Null or empty values found on laacaseworkflow_20241203 table';
    END IF;

    RAISE NOTICE 'All specified tables have been checked.';

END;
