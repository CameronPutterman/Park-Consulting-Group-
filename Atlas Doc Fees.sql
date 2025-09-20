USE EnerGov_Tucson_Prod


SELECT
	    CF.FEENAME [Fee Name]
	  , CASE
			WHEN CREDIT.ACCOUNTNUMBER IS NULL OR TRIM(CREDIT.ACCOUNTNUMBER) = ''
			THEN DEBIT.ACCOUNTNUMBER
			ELSE CASE
					  WHEN DEBIT.ACCOUNTNUMBER IS NOT NULL AND TRIM(DEBIT.ACCOUNTNUMBER) != ''
					  THEN CREDIT.ACCOUNTNUMBER + ', '+ DEBIT.ACCOUNTNUMBER
					  ELSE CREDIT.ACCOUNTNUMBER
				 END
	    END
	--Is this the number of characters in Fee Name? 
	  , CONCAT(LEN(CF.FEENAME), '/50') AS [Character Limit]
	/* Is this SUM(CF.COMPUTEDAMOUNT)? Also, what about text like "Adjustable"?
	*/
	, FORMAT(CF.BASEAMOUNT, 'C', 'en-US') [Fee Amount] 
	--This looks like notes - 'Permit Type = Combination (BMEP).  Custom Field "Plumbing Plan Check Required?" = Yes.
	, 'Fee Conditions' 
	--This looks like notes - 'How many windows are being replaced? (NOT A CUSTOM FIELD)' 
	, 'Fee Input'
	--Found types as CAFEETYPE.NAME but the only links are SEARCHFEE, SEARCHINVOICE, SEARCHPAYMENT and none of them have data - which one is it and what is the link? 
	, 'Type of Fee' 
	--Is this a field? This looks like notes - "Fee is Existing in PROD.  NOTE:  This is not needed for the comibnation permit but will be needed for the standalone plumbing permit types."
	, 'Comments' 
	--Is this a field? This looks like notes - "Old Fee was called "Plan Check Fee - Mechanical Permit'"
	, 'Config Comments'
FROM PLPLAN P
LEFT JOIN PLPLANFEE PF ON PF.PLPLANID = P.PLPLANID
LEFT JOIN CACOMPUTEDFEE CF ON CF.CACOMPUTEDFEEID = PF.CACOMPUTEDFEEID
LEFT JOIN PLPLANTYPE PT ON PT.PLPLANTYPEID = P.PLPLANTYPEID
LEFT JOIN PLPLANTYPEWORKCLASS PTWC ON PTWC.PLPLANTYPEID = PT.PLPLANTYPEID
LEFT JOIN CAFEETEMPLATEFEE FTF ON FTF.CAFEETEMPLATEID = PTWC.CAFEETEMPLATEID
LEFT JOIN CAFEE F ON F.CAFEEID = FTF.CAFEEID
LEFT JOIN GLACCOUNT CREDIT ON CREDIT.GLACCOUNTID = F.ARCREDITACCOUNTID
LEFT JOIN GLACCOUNT DEBIT ON DEBIT.GLACCOUNTID = F.ARDEBITACCOUNTID
GROUP BY 
	CF.FEENAME
	, CASE
			WHEN CREDIT.ACCOUNTNUMBER IS NULL OR TRIM(CREDIT.ACCOUNTNUMBER) = ''
			THEN DEBIT.ACCOUNTNUMBER
			ELSE CASE
					  WHEN DEBIT.ACCOUNTNUMBER IS NOT NULL AND TRIM(DEBIT.ACCOUNTNUMBER) != ''
					  THEN CREDIT.ACCOUNTNUMBER + ', '+ DEBIT.ACCOUNTNUMBER
					  ELSE CREDIT.ACCOUNTNUMBER
				 END
	   END
	, CF.BASEAMOUNT