declare @CoR varchar(1) ;
set @CoR = 'I' ;
declare @Current_TermCode int ;
set @Current_TermCode = 20191 ;

select
b.*
, Gap_GE_IGETC_1A + Gap_GE_IGETC_1B + Gap_GE_IGETC_2A + Gap_GE_IGETC_3A + Gap_GE_IGETC_3B + Gap_GE_IGETC_3A3B + Gap_GE_IGETC_4 + Gap_GE_IGETC_5A + Gap_GE_IGETC_5B + Gap_GE_IGETC_5C as Gap_GE_IGETC_Total
, Gap_GE_CSU_A1 + Gap_GE_CSU_A2 + Gap_GE_CSU_A3 + Gap_GE_CSU_B1 + Gap_GE_CSU_B2 + Gap_GE_CSU_B3 + Gap_GE_CSU_B4 + Gap_GE_CSU_C1 + Gap_GE_CSU_C2 + Gap_GE_CSU_C1C2 + Gap_GE_CSU_D + Gap_GE_CSU_E as Gap_GE_CSU_Total
, Gap_GE_IVC_1A + Gap_GE_IVC_1B + Gap_GE_IVC_1C + Gap_GE_IVC_2 + Gap_GE_IVC_3 + Gap_GE_IVC_4 + Gap_GE_IVC_5 + Gap_GE_IVC_6 + Gap_GE_IVC_7 + Gap_GE_IVC_8 + Gap_GE_IVC_9ABC as Gap_GE_IVC_Total
from
(
	select
	a.*
	, case when
		IGETC_1A >= 1
		and
		IGETC_1B >= 1
		and
		IGETC_2A >= 1
		and
		IGETC_3A >= 1
		and
		IGETC_3B >= 1
		and
		IGETC_3A + IGETC_3B >= 3
		and
		IGETC_4 >= 3
		and
		IGETC_5A >= 1
		and
		IGETC_5B >= 1
		and
		IGETC_5C >= 1
		then 1 else 0 end as GE_IGETC
	, case when IGETC_1A >= 1 then 0 else 1 - IGETC_1A end as Gap_GE_IGETC_1A
	, case when IGETC_1B >= 1 then 0 else 1 - IGETC_1B end as Gap_GE_IGETC_1B
	, case when IGETC_2A >= 1 then 0 else 1 - IGETC_2A end as Gap_GE_IGETC_2A
	, case when IGETC_3A >= 1 then 0 else 1 - IGETC_3A end as Gap_GE_IGETC_3A
	, case when IGETC_3B >= 1 then 0 else 1 - IGETC_3B end as Gap_GE_IGETC_3B
	, case when IGETC_3A + IGETC_3B >= 3 and IGETC_3A >= 1 and IGETC_3B >= 1 then 0 else 1 end as Gap_GE_IGETC_3A3B
	, case when IGETC_4 >= 3 then 0 else 3 - IGETC_4 end as Gap_GE_IGETC_4
	, case when IGETC_5A >= 1 then 0 else 1 - IGETC_5A end as Gap_GE_IGETC_5A
	, case when IGETC_5B >= 1 then 0 else 1 - IGETC_5B end as Gap_GE_IGETC_5B
	, case when IGETC_5C >= 1 then 0 else 1 - IGETC_5C end as Gap_GE_IGETC_5C
	, 1 + 1 + 1 + 3 + 3 + 1 + 1 + 1 as GE_IGETC_Req_N
	, case when
		CSU_A1 >= 1
		and
		CSU_A2 >= 1
		and
		CSU_A3 >= 1
		and
		CSU_B1 >= 1
		and
		CSU_B2 >= 1
		and
		CSU_B3 >= 1
		and
		CSU_B4 >= 1
		and
		CSU_C1 >= 1
		and
		CSU_C2 >= 1
		and
		CSU_C1 + CSU_C2 >= 3
		and
		CSU_D >= 3
		and
		CSU_E >= 1
		then 1 else 0 end as GE_CSU
	, case when CSU_A1 >= 1 then 0 else 1 - CSU_A1 end as Gap_GE_CSU_A1
	, case when CSU_A2 >= 1 then 0 else 1 - CSU_A2 end as Gap_GE_CSU_A2
	, case when CSU_A3 >= 1 then 0 else 1 - CSU_A3 end as Gap_GE_CSU_A3
	, case when CSU_B1 >= 1 then 0 else 1 - CSU_B1 end as Gap_GE_CSU_B1
	, case when CSU_B2 >= 1 then 0 else 1 - CSU_B2 end as Gap_GE_CSU_B2
	, case when CSU_B3 >= 1 then 0 else 1 - CSU_B3 end as Gap_GE_CSU_B3
	, case when CSU_B4 >= 1 then 0 else 1 - CSU_B4 end as Gap_GE_CSU_B4
	, case when CSU_C1 >= 1 then 0 else 1 - CSU_C1 end as Gap_GE_CSU_C1
	, case when CSU_C2 >= 1 then 0 else 1 - CSU_C2 end as Gap_GE_CSU_C2
	, case when CSU_C1 + CSU_C2 >= 3 and CSU_C1 >= 1 and CSU_C2 >=1 then 0 else 1 end as Gap_GE_CSU_C1C2
	, case when CSU_D >= 3 then 0 else 3 - CSU_D end as Gap_GE_CSU_D
	, case when CSU_E >= 1 then 0 else 1 - CSU_E end as Gap_GE_CSU_E
	, 1 + 1 + 1 + 1 + 1 + 1 + 1 + 3 + 3 + 1 as GE_CSU_Req_N
	, case when
		IVC_1A >= 1
		and
		IVC_1B >= 1
		and
		IVC_1C >= 1
		and
		IVC_2 >= 1
		and
		IVC_3 >= 1
		and
		IVC_4 >= 1
		and
		IVC_5 >= 1
		and
		IVC_6 >= 1
		and
		IVC_7 >= 1
		and
		IVC_8 >= 1
		/* -- 11/28/2018
		and
		IVC_9A >= 1
		and
		IVC_9B >= 1
		and
		IVC_9C >= 1
		*/
		and
		((IVC_9A >= 1 and IVC_9B >= 1) or (IVC_9A >= 1 and IVC_9C >= 1) or (IVC_9B >= 1 and IVC_9C >= 1))
		then 1 else 0 end as GE_IVC
	, case when IVC_1A >= 1 then 0 else 1 - IVC_1A end as Gap_GE_IVC_1A
	, case when IVC_1B >= 1 then 0 else 1 - IVC_1B end as Gap_GE_IVC_1B
	, case when IVC_1C >= 1 then 0 else 1 - IVC_1C end as Gap_GE_IVC_1C
	, case when IVC_2 >= 1 then 0 else 1 - IVC_2 end as Gap_GE_IVC_2
	, case when IVC_3 >= 1 then 0 else 1 - IVC_3 end as Gap_GE_IVC_3
	, case when IVC_4 >= 1 then 0 else 1 - IVC_4 end as Gap_GE_IVC_4
	, case when IVC_5 >= 1 then 0 else 1 - IVC_5 end as Gap_GE_IVC_5
	, case when IVC_6 >= 1 then 0 else 1 - IVC_6 end as Gap_GE_IVC_6
	, case when IVC_7 >= 1 then 0 else 1 - IVC_7 end as Gap_GE_IVC_7
	, case when IVC_8 >= 1 then 0 else 1 - IVC_8 end as Gap_GE_IVC_8
	, case 
		when (IVC_9A >= 1 and IVC_9B >= 1) or (IVC_9A >= 1 and IVC_9C >= 1) or (IVC_9B >= 1 and IVC_9C >= 1) then 0
		when IVC_9A >= 1 or IVC_9B >= 1 or IVC_9C >= 1 then 1
		else 2
		end as Gap_GE_IVC_9ABC
	, 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 2 as GE_IVC_Req_N
	from
	(
		select
		cur_stud.*
		-- #ADD GE VAR CALCS CODE HERE
		, sum(case when dc.CourseID in ('WR 1', 'WR 1 H', 'ENG 1 A', 'ENG 1 AH') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IGETC_1A
, sum(case when dc.CourseID in ('WR 2', 'WR 2 H', 'ENG 1 B', 'ENG 1 BH') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IGETC_1B
, sum(case when dc.CourseID in ('CS 6 A', 'CS 6 B', 'ECON 10', 'ECON 10 H', 'MATH 2', 'MATH 3 A', 'MATH 3 AH', 'MATH 3 B', 'MATH 3 BH', 'MATH 4 A', 'MATH 8', 'MATH 10', 'MATH 11', 'MATH 24', 'MATH 24 H', 'MATH 26', 'MATH 30', 'MATH 31', 'MGT 10', 'MGT 10 H', 'PSYC 10', 'PSYC 10 H') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IGETC_2A
, sum(case when dc.CourseID in ('ARTH 1', 'ARTH 4', 'ARTH 5', 'ARTH 20', 'ARTH 22', 'ARTH 23', 'ARTH 24', 'ARTH 25', 'ARTH 26', 'ARTH 27', 'ARTH 28', 'ARTH 29', 'ARTH 30', 'ARTH 31', 'ARTH 32', 'ARTH 33', 'ARTH 50', 'DNCE 77', 'DNCE 78', 'DMA 50', 'MUS 1', 'MUS 20', 'MUS 20 H', 'MUS 21', 'MUS 27', 'MUS 28', 'PHOT 1', 'TA 20', 'TA 21', 'TA 22', 'TA 25', 'TA 25 H', 'TA 26', 'TA 26 H', 'TA 27', 'TA 29 H') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IGETC_3A
, sum(case when dc.CourseID in ('CHI 2', 'CHI 3', 'ETHN 20', 'FR 2', 'FR 3', 'FR 4', 'HIST 1', 'HIST 1 H', 'HIST 2', 'HIST 10', 'HIST 11', 'HIST 20', 'HIST 21', 'HIST 24', 'HIST 25', 'HIST 30', 'HIST 33', 'HIST 40', 'HIST 41', 'HIST 51', 'HIST 51 H', 'HUM 1', 'HUM 1 H', 'HUM 2', 'HUM 3', 'HUM 4', 'HUM 20', 'HUM 21', 'HUM 22', 'HUM 27', 'HUM 50', 'HUM 70', 'HUM 71', 'HUM 71 H', 'HUM 72', 'HUM 72 H', 'HUM 73', 'HUM 74', 'JA 2', 'JA 3', 'JA 4', 'JA 10', 'JA 21', 'JA 23', 'LIT 1', 'LIT 7', 'LIT 20', 'LIT 21', 'LIT 22', 'LIT 23', 'LIT 24', 'LIT 30', 'LIT 31', 'LIT 32', 'LIT 33', 'LIT 40', 'LIT 41', 'LIT 43', 'LIT 45', 'LIT 46', 'LIT 48', 'PHIL 1', 'PHIL 2', 'PHIL 5', 'PHIL 10', 'PHIL 11', 'PS 5', 'PS 41', 'SIGN 22', 'SIGN 23', 'SIGN 24', 'SPAN 2', 'SPAN 3', 'SPAN 4', 'SPAN 10', 'SPAN 11') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IGETC_3B
, sum(case when dc.CourseID in ('AJ 2', 'AJ 4', 'AJ 8', 'ANTH 2', 'ANTH 2 H', 'ANTH 3', 'ANTH 4', 'ANTH 7', 'ANTH 9', 'ANTH 13', 'COMM 9', 'ECON 1', 'ECON 1 H', 'ECON 2', 'ECON 2 H', 'ECON 6', 'ECON 13', 'ECON 20', 'ECON 20 H', 'ENV 1', 'ENV 6', 'ETHN 10', 'ETHN 20', 'GS 10', 'GS 20', 'GEOG 2', 'GEOG 3', 'GEOG 3 H', 'GEOG 20', 'GEOG 38', 'GLBL 1', 'GLBL 2', 'HIST 1', 'HIST 1 H', 'HIST 2', 'HIST 20', 'HIST 21', 'HIST 25', 'HIST 30', 'HIST 51', 'HIST 51 H', 'HD 4', 'HD 7', 'HD 15', 'JRNL 40', 'KNES 97', 'LGL 21', 'PS 1', 'PS 1 H', 'PS 3', 'PS 4', 'PS 6', 'PS 7', 'PS 12', 'PS 12 H', 'PS 14', 'PS 14 H', 'PS 17', 'PSYC 1', 'PSYC 1 H', 'PSYC 2', 'PSYC 3', 'PSYC 3 H', 'PSYC 5', 'PSYC 5 H', 'PSYC 6', 'PSYC 7', 'PSYC 9', 'PSYC 11', 'PSYC 20', 'PSYC 30', 'PSYC 32', 'PSYC 33', 'PSYC 37', 'PSYC 37 H', 'SOC 1', 'SOC 1 H', 'SOC 2', 'SOC 3', 'SOC 10', 'SOC 15', 'SOC 19', 'SOC 20', 'SOC 23', 'SOC 30', 'SRM 80', 'SRM 85', 'SRM 90') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IGETC_4
, sum(case when dc.CourseID in ('ASTR 20', 'ASTR 25', 'BIO 10', 'BIO 55', 'CHEM 1 A', 'CHEM 1 B', 'CHEM 3', 'CHEM 4', 'CHEM 12 A', 'CHEM 12 B', 'ERTH 20', 'GEOG 1', 'GEOG 10', 'GEOG 10 H', 'GEOL 1', 'GEOL 2', 'GEOL 3', 'GEOL 22', 'GEOL 23', 'MS 20', 'PHYS 2 A', 'PHYS 2 B', 'PHYS 4 A', 'PHYS 4 B', 'PHYS 4 C', 'PHYS 20') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IGETC_5A
, sum(case when dc.CourseID in ('ANTH 1', 'ANTH 1 H', 'BIO 1', 'BIO 1 H', 'BIO 2', 'BIO 3', 'BIO 5', 'BIO 11', 'BIO 12', 'BIO 15', 'BIO 16', 'BIO 19', 'BIO 19 H', 'BIO 21', 'BIO 30', 'BIO 32', 'BIO 43', 'BIO 44', 'BIO 55', 'BIO 71', 'BIO 72', 'BIO 80', 'BIO 81', 'BIO 82', 'BIO 83', 'BIOT 70', 'PSYC 3', 'PSYC 3 H') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IGETC_5B
, sum(case when dc.CourseID in ('ASTR 25', 'BIO 10 L', 'CHEM 1 A', 'CHEM 1 B', 'CHEM 3', 'CHEM 4', 'CHEM 12 A', 'CHEM 12 B', 'ERTH 20', 'GEOG 1', 'GEOL 1', 'GEOL 2', 'GEOL 22', 'GEOL 23', 'MS 20', 'PHYS 2 A', 'PHYS 2 B', 'PHYS 4 A', 'PHYS 4 B', 'PHYS 4 C', 'PHYS 20', 'ANTH 1 L', 'ANTH 1 L', 'BIO 1 L', 'BIO 1 L', 'BIO 2', 'BIO 5', 'BIO 11', 'BIO 11', 'BIO 12 L', 'BIO 15', 'BIO 16', 'BIO 19 L', 'BIO 19 L', 'BIO 21', 'BIO 32', 'BIO 80', 'BIO 81', 'BIO 82', 'BIO 83', 'BIOT 70 L', 'PSYC 3 L', 'PSYC 3 L') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IGETC_5C
, sum(case when dc.CourseID in ('SPAN 1') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IGETC_6
, sum(case when dc.CourseID in ('COMM 1', 'COMM 1 H', 'COMM 3') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as CSU_A1
, sum(case when dc.CourseID in ('WR 1', 'WR 1 H', 'ENG 1 A', 'ENG 1 AH') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as CSU_A2
, sum(case when dc.CourseID in ('COMM 2', 'COMM 3', 'PHIL 3', 'PSYC 13', 'PSYC 13 H', 'RD 74', 'WR 2', 'WR 2 H', 'ENG 1 B', 'ENG 1 BH') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as CSU_A3
, sum(case when dc.CourseID in ('ASTR 20', 'ASTR 25', 'BIO 10', 'CHEM 1 A', 'CHEM 1 B', 'CHEM 3', 'CHEM 4', 'CHEM 12 A', 'CHEM 12 B', 'ERTH 20', 'GEOG 1', 'GEOG 10', 'GEOG 10 H', 'GEOL 1', 'GEOL 2', 'GEOL 3', 'GEOL 22', 'GEOL 23', 'MS 20', 'PHYS 2 A', 'PHYS 2 B', 'PHYS 4 A', 'PHYS 4 B', 'PHYS 4 C', 'PHYS 20') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as CSU_B1
, sum(case when dc.CourseID in ('ANTH 1', 'ANTH 1 H', 'BIO 1', 'BIO 1 H', 'BIO 2', 'BIO 3', 'BIO 5', 'BIO 11', 'BIO 12', 'BIO 15', 'BIO 16', 'BIO 19', 'BIO 19 H', 'BIO 21', 'BIO 30', 'BIO 32', 'BIO 43', 'BIO 55', 'BIO 71', 'BIO 72', 'BIO 80', 'BIO 81', 'BIO 82', 'BIO 83', 'BIOT 70', 'PSYC 3', 'PSYC 3 H') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as CSU_B2
, sum(case when dc.CourseID in ('ASTR 25', 'BIO 10 L', 'CHEM 1 A', 'CHEM 1 B', 'CHEM 3', 'CHEM 4', 'CHEM 12 A', 'CHEM 12 B', 'ERTH 20', 'GEOG 1', 'GEOL 1', 'GEOL 2', 'GEOL 22', 'GEOL 23', 'MS 20', 'PHYS 2 A', 'PHYS 2 B', 'PHYS 4 A', 'PHYS 4 B', 'PHYS 4 C', 'PHYS 20', 'ANTH 1 L', 'BIO 1 L', 'BIO 2', 'BIO 5', 'BIO 11', 'BIO 12 L', 'BIO 15', 'BIO 16', 'BIO 19 L', 'BIO 19 L', 'BIO 21', 'BIO 32', 'BIO 80', 'BIO 81', 'BIO 82', 'BIO 83') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as CSU_B3
, sum(case when dc.CourseID in ('CS 6 A', 'CS 6 B', 'ECON 10', 'ECON 10 H', 'MGT 10', 'MGT 10 H', 'MATH 2', 'MATH 3 A', 'MATH 3 AH', 'MATH 3 B', 'MATH 3 BH', 'MATH 4 A', 'MATH 5', 'MATH 8', 'MATH 10', 'MATH 11', 'MATH 20', 'MATH 24', 'MATH 24 H', 'MATH 26', 'MATH 30', 'MATH 31', 'MATH 124', 'PSYC 10', 'PSYC 10 H') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as CSU_B4
, sum(case when dc.CourseID in ('ART 40', 'ART 42', 'ART 80', 'ARTH 1', 'ARTH 4', 'ARTH 5', 'ARTH 20', 'ARTH 22', 'ARTH 23', 'ARTH 24', 'ARTH 25', 'ARTH 26', 'ARTH 27', 'ARTH 28', 'ARTH 29', 'ARTH 30', 'ARTH 31', 'ARTH 32', 'ARTH 33', 'ARTH 50', 'COMM 10', 'COMM 30', 'DNCE 77', 'DNCE 78', 'DNCE 85', 'DMA 50', 'MUS 1', 'MUS 20', 'MUS 20 H', 'MUS 21', 'MUS 27', 'MUS 28', 'PHOT 1', 'TA 1', 'TA 8', 'TA 10', 'TA 20', 'TA 21', 'TA 22', 'TA 25', 'TA 25 H', 'TA 26', 'TA 26 H', 'TA 27', 'TA 29 H', 'TA 30', 'TA 40') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as CSU_C1
, sum(case when dc.CourseID in ('CHI 1', 'CHI 2', 'CHI 3', 'ETHN 20', 'FR 1', 'FR 1 H', 'FR 2', 'FR 3', 'FR 4', 'FR 10', 'FR 11', 'HIST 1', 'HIST 1 H', 'HIST 2', 'HIST 10', 'HIST 11', 'HIST 20', 'HIST 21', 'HIST 25', 'HIST 30', 'HIST 51', 'HIST 51 H', 'HUM 1', 'HUM 1', 'HUM 1 H', 'HUM 2', 'HUM 3', 'HUM 4', 'HUM 20', 'HUM 21', 'HUM 22', 'HUM 27', 'HUM 50', 'HUM 70', 'HUM 71', 'HUM 71 H', 'HUM 72 H', 'HUM 73', 'HUM 74', 'JA 1', 'JA 1 H', 'JA 2', 'JA 3', 'JA 4', 'JA 10', 'JA 21', 'JA 23', 'LIT 1', 'LIT 7', 'LIT 20', 'LIT 21', 'LIT 22', 'LIT 23', 'LIT 24', 'LIT 30', 'LIT 31', 'LIT 32', 'LIT 33', 'LIT 40', 'LIT 41', 'LIT 43', 'LIT 45', 'LIT 46', 'LIT 48', 'PHIL 1', 'PHIL 2', 'PHIL 5', 'PHIL 10', 'PHIL 11', 'PS 5', 'SIGN 21', 'SIGN 22', 'SIGN 23', 'SIGN 24', 'SPAN 1', 'SPAN 1 H', 'SPAN 2', 'SPAN 3', 'SPAN 4', 'SPAN 10', 'SPAN 11', 'WR 10', 'WR 11', 'WR 13') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as CSU_C2
, sum(case when dc.CourseID in ('AJ 2', 'AJ 4', 'AJ 8', 'AJ 13', 'ANTH 2', 'ANTH 2 H', 'ANTH 3', 'ANTH 4', 'ANTH 7', 'ANTH 9', 'ANTH 13', 'COMM 5', 'COMM 9', 'ECON 1', 'ECON 1 H', 'ECON 2', 'ECON 2 H', 'ECON 6', 'ECON 13', 'ECON 20', 'ECON 20 H', 'ENV 1', 'ENV 6', 'ETHN 10', 'ETHN 20', 'GS 10', 'GS 20', 'GEOG 2', 'GEOG 3', 'GEOG 3 H', 'GEOG 20', 'GEOG 38', 'GLBL 1', 'GLBL 2', 'HIST 1', 'HIST 1 H', 'HIST 2', 'HIST 20', 'HIST 21', 'HIST 24', 'HIST 25', 'HIST 30', 'HIST 33', 'HIST 40', 'HIST 41', 'HIST 51', 'HIST 51 H', 'HD 4', 'HD 7', 'HD 15', 'JRNL 40', 'KNES 97', 'LGL 21', 'MUS 21', 'PS 1', 'PS 1 H', 'PS 3', 'PS 4', 'PS 6', 'PS 7', 'PS 12', 'PS 12 H', 'PS 14', 'PS 14 H', 'PS 17', 'PS 21', 'PS 41', 'PSYC 1', 'PSYC 1 H', 'PSYC 2', 'PSYC 3', 'PSYC 3 H', 'PSYC 5', 'PSYC 5 H', 'PSYC 6', 'PSYC 7', 'PSYC 9', 'PSYC 11', 'PSYC 20', 'PSYC 30', 'PSYC 32', 'PSYC 33', 'PSYC 37', 'PSYC 37 H', 'SOC 1', 'SOC 1 H', 'SOC 2', 'SOC 3', 'SOC 10', 'SOC 15', 'SOC 19', 'SOC 20', 'SOC 23', 'SOC 30', 'SRM 80', 'SRM 85', 'SRM 90') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as CSU_D
, sum(case when dc.CourseID in ('BIO 44', 'COUN 1', 'COUN 4', 'COUN 6', 'COUN 6 H', 'COUN 10', 'COUN 102', 'COUN 103', 'COUN 120', 'COUN 150', 'DNCE 1', 'DNCE 1 A', 'DNCE 1 B', 'DNCE 2', 'DNCE 3', 'DNCE 5', 'DNCE 6', 'DNCE 7', 'DNCE 12', 'DNCE 13', 'DNCE 16', 'DNCE 17', 'DNCE 18', 'DNCE 19', 'DNCE 20', 'DNCE 22', 'DNCE 23', 'DNCE 24', 'DNCE 25', 'DNCE 26', 'DNCE 27', 'DNCE 30', 'DNCE 33', 'DNCE 34', 'DNCE 35', 'DNCE 36', 'DNCE 37', 'DNCE 38', 'DNCE 39', 'DNCE 40', 'DNCE 41', 'DNCE 42', 'DNCE 45', 'DNCE 46', 'DNCE 47', 'DNCE 48', 'DNCE 50', 'DNCE 51', 'DNCE 51 A', 'DNCE 51 B', 'DNCE 52', 'DNCE 53', 'DNCE 54', 'DNCE 55', 'DNCE 57', 'DNCE 58', 'DNCE 60', 'DNCE 61', 'DNCE 62', 'DNCE 65 A', 'DNCE 65 B', 'DNCE 65 C', 'DNCE 66 A', 'DNCE 66 B', 'DNCE 66 C', 'DNCE 67 A', 'DNCE 67 B', 'DNCE 67 C', 'DNCE 68', 'DNCE 69', 'DNCE 70', 'DNCE 71', 'DNCE 72', 'DNCE 73', 'DNCE 75', 'DNCE 86', 'DNCE 87', 'DNCE 88', 'DNCE 90', 'DNCE 91', 'DNCE 92', 'DNCE 93', 'DNCE 94', 'DNCE 95', 'DNCE 96', 'GS 20', 'HLTH 1', 'HLTH 3', 'HLTH 107', 'HLTH 131', 'HD 7', 'IA 1', 'IA 1 A', 'IA 2', 'IA 3', 'IA 4', 'IA 6', 'IA 7', 'IA 9', 'IA 10', 'IA 12', 'IA 13', 'IA 15', 'IA 18', 'IA 19', 'IA 20', 'IA 121', 'KNEA 1', 'KNES 3 A', 'KNES 3 B', 'KNES 3 C', 'KNES 4', 'KNES 5', 'KNES 6', 'KNES 7', 'KNES 11', 'KNES 12', 'KNES 13', 'KNES 20', 'KNES 22', 'KNES 23', 'KNES 25', 'KNES 26', 'KNES 27', 'KNES 28', 'KNES 61', 'KNES 62', 'KNES 63', 'KNES 64', 'KNES 71', 'KNES 72', 'KNES 73', 'KNES 74', 'KNES 76', 'KNES 77', 'KNES 78', 'KNES 79', 'KNES 81', 'KNES 82', 'KNES 83', 'KNES 84', 'KNES 97', 'KNES 98', 'NUT 1', 'NUT 2', 'PSYC 6', 'PSYC 7', 'PSYC 33', 'RD 171') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as CSU_E
, sum(case when dc.CourseID in ('WR 1', 'WR 1 H', 'ENG 1 A', 'ENG 1 AH', 'ENG 1 A', 'ENG 1 AH') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_1A
, sum(case when dc.CourseID in ('COMM 1', 'COMM 1 H', 'COMM 3') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_1B
, sum(case when dc.CourseID in ('COMM 2', 'COMM 3', 'PHIL 3', 'PSYC 3', 'PSYC 13', 'PSYC 13 H') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_1C
, sum(case when dc.CourseID in ('BIO 7', 'CS 6 A', 'CS 6 B', 'ECON 10', 'ECON 10 H', 'MGT 10', 'MGT 10 H', 'PSYC 10', 'PSYC 10 H', 'MATH 2', 'MATH 3 A', 'MATH 3 AH', 'MATH 3 B', 'MATH 3 BH', 'MATH 4 A', 'MATH 5', 'MATH 8', 'MATH 10', 'MATH 11', 'MATH 20', 'MATH 24', 'MATH 24 H', 'MATH 26', 'MATH 30', 'MATH 31', 'MATH 124', 'MATH 253') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_2
, sum(case when dc.CourseID in ('ANTH 1', 'ASTR 20', 'ASTR 25', 'BIO 1', 'BIO 2', 'BIO 5', 'BIO 10', 'BIO 11', 'BIO 12', 'BIO 15', 'BIO 15', 'BIO 16', 'BIO 19', 'BIO 19 H', 'BIO 21', 'BIO 80', 'BIO 80 H', 'BIO 81', 'BIO 81 H', 'BIOT 70', 'CHEM 1 A', 'CHEM 1 B', 'CHEM 3', 'CHEM 4', 'ERTH 20', 'ENV 1', 'GEOG 1', 'GEOL 1', 'GEOL 2', 'GEOL 22', 'GEOL 23', 'LASR 25', 'MS 20', 'PHYS 2 A', 'PHYS 4 A', 'PHYS 20', 'PSYC 3', 'PSYC 3 H') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_3
, sum(case when dc.CourseID in ('AJ 2', 'AJ 4', 'AJ 5', 'AJ 8', 'AJ 13', 'ANTH 2', 'ANTH 2 H', 'ANTH 3', 'ANTH 4', 'ANTH 7', 'ANTH 9', 'ANTH 13', 'ECON 1', 'ECON 1 H', 'ECON 2', 'ECON 2 H', 'ECON 6', 'ECON 13', 'ECON 20', 'ECON 20 H', 'ENV 1', 'ENV 6', 'GEOG 2', 'GEOG 3', 'GEOG 3 H', 'GEOG 20', 'GEOG 38', 'GS 10', 'GS 20', 'GLBL 1', 'GLBL 2', 'HLTH 5', 'HLTH 6', 'HLTH 7', 'HIST 41', 'HD 7', 'HD 15', 'HD 130', 'MGT 1', 'MGT 68', 'MGT 269', 'PS 1', 'PS 1 H', 'PS 3', 'PS 4', 'PS 6', 'PS 7', 'PS 12', 'PS 12 H', 'PS 14', 'PS 14 H', 'PS 17', 'PS 21', 'PS 41', 'PSYC 1', 'PSYC 1 H', 'PSYC 2', 'PSYC 3', 'PSYC 3 H', 'PSYC 5', 'PSYC 5', 'PSYC 5 H', 'PSYC 6', 'PSYC 7', 'PSYC 9', 'PSYC 11', 'PSYC 20', 'PSYC 30', 'PSYC 32', 'PSYC 37', 'PSYC 37 H', 'SOC 1', 'SOC 1 H', 'SOC 2', 'SOC 3', 'SOC 10', 'SOC 15', 'SOC 19', 'SOC 20', 'SOC 23', 'SOC 30') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_4
, sum(case when dc.CourseID in ('ANTH 2', 'ANTH 2 H', 'ANTH 3', 'ANTH 4', 'ANTH 7', 'ANTH 9', 'ARTH 22', 'ARTH 23', 'ARTH 27', 'COMM 9', 'DNCE 3', 'DNCE 34', 'DNCE 35', 'DNCE 61', 'GEOG 2', 'GEOG 3', 'GEOG 3 H', 'GLBL 1', 'GLBL 2', 'HLTH 6', 'HLTH 7', 'HIST 1', 'HIST 1 H', 'HIST 2', 'HIST 30', 'HIST 33', 'HIST 40', 'HIST 41', 'HD 130', 'HUM 20', 'HUM 21', 'HUM 22', 'HUM 27', 'JA 21', 'JA 23', 'KNES 97', 'LIT 46', 'MGT 68', 'MGT 269', 'MUS 2 H', 'MUS 21', 'MUS 27', 'PS 6', 'PS 17', 'PS 41', 'SIGN 23', 'SOC 3', 'SOC 19', 'SOC 20') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_5
, sum(case when dc.CourseID in ('ETHN 10', 'ETHN 20', 'GS 10', 'GS 20', 'HIST 1', 'HIST 1 H', 'HIST 2', 'HIST 10', 'HIST 11', 'HIST 20', 'HIST 21', 'HIST 24', 'HIST 25', 'HIST 30', 'HIST 33', 'HIST 40', 'HIST 41', 'HIST 51', 'HIST 51 H', 'HUM 1', 'HUM 1 H', 'HUM 2', 'HUM 3', 'HUM 4', 'HUM 10', 'HUM 20', 'HUM 21', 'HUM 22', 'HUM 27', 'HUM 50', 'HUM 70', 'HUM 71', 'HUM 71 H', 'HUM 72', 'HUM 72 H', 'HUM 73', 'HUM 74', 'JA 21', 'JA 23', 'JRNL 40', 'JRNL 41', 'LIT 1', 'LIT 7', 'LIT 20', 'LIT 21', 'LIT 22', 'LIT 23', 'LIT 24', 'LIT 30', 'LIT 31', 'LIT 32', 'LIT 33', 'LIT 40', 'LIT 41', 'LIT 43', 'LIT 45', 'LIT 46', 'LIT 48', 'LIT 49', 'PHIL 1', 'PHIL 2', 'PHIL 5', 'PHIL 10', 'PHIL 11', 'PS 5', 'PS 41', 'WR 10', 'WR 11', 'WR 13', 'WR 14', 'WR 15') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_6
, sum(case when dc.CourseID in ('ART 40', 'ART 41', 'ART 42', 'ART 50', 'ART 52', 'ART 53', 'ART 62', 'ART 64', 'ART 80', 'ART 81', 'ART 82', 'ART 85', 'ART 86', 'ART 186', 'ART 195', 'ARTH 1', 'ARTH 4', 'ARTH 5', 'ARTH 20', 'ARTH 22', 'ARTH 23', 'ARTH 24', 'ARTH 25', 'ARTH 26', 'ARTH 27', 'ARTH 28', 'ARTH 29', 'ARTH 30', 'ARTH 31', 'ARTH 32', 'ARTH 33', 'ARTH 50', 'ARTH 110', 'CHI 1', 'CHI 2', 'CHI 3', 'COMM 3', 'COMM 9', 'COMM 10', 'COMM 30', 'COMM 35', 'COMM 106 A', 'COMM 106 B', 'COMM 106 C', 'DMA 10', 'DMA 40', 'DMA 50', 'DMA 51', 'DMA 52', 'DMA 55', 'DMA 56', 'DMA 65', 'DMA 195', 'DNCE 1', 'DNCE 1 B', 'DNCE 2', 'DNCE 3', 'DNCE 5', 'DNCE 6', 'DNCE 7', 'DNCE 12', 'DNCE 13', 'DNCE 16', 'DNCE 17', 'DNCE 18', 'DNCE 19', 'DNCE 20', 'DNCE 22', 'DNCE 23', 'DNCE 24', 'DNCE 25', 'DNCE 26', 'DNCE 27', 'DNCE 30', 'DNCE 33', 'DNCE 34', 'DNCE 35', 'DNCE 36', 'DNCE 37', 'DNCE 38', 'DNCE 39', 'DNCE 40', 'DNCE 41', 'DNCE 42', 'DNCE 48', 'DNCE 50', 'DNCE 55', 'DNCE 57', 'DNCE 58', 'DNCE 61', 'DNCE 62', 'DNCE 65 A', 'DNCE 65 B', 'DNCE 65 C', 'DNCE 66 A', 'DNCE 66 B', 'DNCE 66 C', 'DNCE 67 A', 'DNCE 67 B', 'DNCE 67 C', 'DNCE 68', 'DNCE 69', 'DNCE 70', 'DNCE 71', 'DNCE 72', 'DNCE 73', 'DNCE 75', 'DNCE 77', 'DNCE 78', 'DNCE 85', 'DNCE 91', 'DNCE 281', 'FR 1', 'FR 1 H', 'FR 2', 'FR 3', 'FR 4', 'FR 10', 'FR 11', 'IMA 27', 'IMA 30', 'IMA 40', 'IMA 96', 'JA 1', 'JA 1 H', 'JA 2', 'JA 2 H', 'JA 3', 'JA 4', 'JA 10', 'MUS 1', 'MUS 2 H', 'MUS 3', 'MUS 4', 'MUS 5', 'MUS 6', 'MUS 7', 'MUS 20', 'MUS 20 H', 'MUS 21', 'MUS 27', 'MUS 28', 'MUS 38', 'MUS 39', 'MUS 40', 'MUS 42', 'MUS 44', 'MUS 46', 'MUS 54', 'MUS 55', 'MUS 56', 'MUS 57', 'MUS 59', 'MUS 62', 'MUS 65', 'MUS 80', 'MUS 81', 'MUS 82', 'MUS 83', 'MUS 84', 'MUS 85', 'MUS 86', 'MUS 87', 'MUS 113', 'PHOT 1', 'PHOT 51', 'PHOT 52', 'SIGN 21', 'SIGN 22', 'SIGN 23', 'SIGN 24', 'SPAN 1', 'SPAN 1 H', 'SPAN 2', 'SPAN 3', 'SPAN 4', 'SPAN 10', 'SPAN 11', 'TA 1', 'TA 9', 'TA 10', 'TA 15', 'TA 15 B', 'TA 16', 'TA 16 B', 'TA 17', 'TA 17 B', 'TA 18', 'TA 18 B', 'TA 19', 'TA 19 B', 'TA 20', 'TA 21', 'TA 22', 'TA 25', 'TA 25 H', 'TA 26', 'TA 26 H', 'TA 27', 'TA 30', 'TA 35', 'TA 40', 'TA 41', 'TA 42', 'TA 43', 'TA 44', 'TA 45', 'TA 46', 'TA 47', 'TA 51', 'TA 52', 'TA 61', 'TA 62', 'TA 63', 'TA 64', 'TA 65', 'TA 71', 'TA 72', 'TA 74', 'TA 75', 'WR 10', 'WR 11', 'WR 13', 'WR 14', 'WR 15') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_7
, sum(case when dc.CourseID in ('HIST 20', 'HIST 21', 'PS 1', 'PS 1 H') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_8
, sum(case when dc.CourseID in ('BIO 44', 'BIO 71', 'COUN 4', 'COUN 6', 'COUN 6 H', 'DNCE 51', 'DNCE 51 B', 'DNCE 70', 'DNCE 90', 'DNCE 91', 'DNCE 92', 'HLTH 1', 'HLTH 3', 'HLTH 131', 'IA 1', 'IA 1 A', 'IA 2', 'IA 3', 'IA 4', 'IA 6', 'IA 7', 'IA 9', 'IA 10', 'IA 12', 'IA 13', 'IA 15', 'IA 18', 'IA 19', 'IA 20', 'IA 121', 'KNEA 1', 'KNES 3 A', 'KNES 3 B', 'KNES 3 C', 'KNES 4', 'KNES 5', 'KNES 6', 'KNES 10', 'KNES 11', 'KNES 12', 'KNES 13', 'KNES 20', 'KNES 22', 'KNES 23', 'KNES 25', 'KNES 26', 'KNES 27', 'KNES 28', 'KNES 32', 'KNES 61', 'KNES 62', 'KNES 63', 'KNES 64', 'KNES 71', 'KNES 72', 'KNES 73', 'KNES 74', 'KNES 76', 'KNES 77', 'KNES 78', 'KNES 79', 'KNES 81', 'KNES 82', 'KNES 83', 'KNES 84', 'KNES 99', 'KNES 223', 'KNES 224', 'NUT 1', 'NUT 2', 'PSYC 33') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_9A
, sum(case when dc.CourseID in ('CIM 103', 'CIM 107', 'CIM 117', 'CIM 201 A', 'CIM 201 B', 'CIM 201 C', 'CIM 209', 'CIM 210 .1', 'CIM 210 .2', 'ENTR 117', 'LIB 10', 'LIB 11', 'LIB 112', 'RD 171') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_9B
, sum(case when dc.CourseID in ('ACCT 206', 'COUN 1', 'COUN 1 H', 'COUN 2', 'COUN 4', 'COUN 10', 'COUN 100 A', 'COUN 100 B', 'COUN 102', 'COUN 103', 'COUN 120', 'COUN 150', 'DNCE 45', 'DNCE 46', 'DNCE 47', 'DNCE 51', 'DNCE 51 B', 'DNCE 52', 'DNCE 53', 'DNCE 54', 'DNCE 68', 'DNCE 69', 'DNCE 72', 'DNCE 78', 'DNCE 86', 'DNCE 87', 'DNCE 88', 'DNCE 93', 'DNCE 94', 'DNCE 95', 'DNCE 96', 'DNCE 253', 'ECON 105', 'ET 101', 'ENTR 200', 'HLTH 2', 'HD 270', 'KNES 85', 'KNES 100', 'LGL 21', 'MGT 105', 'MGT 125', 'TU 100') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as IVC_9C
		from
		(
			select
			ds.BK_StudentID
			, ds.SK_Student_Key
			/*
			, ds.LastName
			, ds.FirstName
			, ds.PrimaryEmailAddress
			, ds.PrimaryTelephoneNumber
			*/
			, dt.BK_TermCode
			, dt.SK_Term_Key
			, dt.TermDesc
			, sum(fe.EnrollUnits) as EnrollUnits
			, max(rgpa.CumulativeUnitsAttemptedAsOfEOT) as CumulativeUnitsAttemptedAsOfEOT
			, round(max(rgpa.CumulativeGPAAsOfEOT), 2) as CumulativeGPAAsOfEOT
			from
			DimStudent as ds
			left join
			FactEnrollment as fe
			on
			fe.SK_Student_Key = ds.SK_Student_Key
			left join
			DimTermPeriod as dtp
			on
			dtp.SK_TermPeriod_Key = fe.SK_TermPeriod_Key
			inner join
			DimTerm as dt
			on
			dt.SK_Term_Key = dtp.SK_Term_Key
			left join
			DimStudentTerm as dst
			on
			dst.SK_Student_Key = ds.SK_Student_Key
			and
			dst.SK_Term_Key = dt.SK_Term_Key
			left join
			[ResearchStaging].[dbo].[Recalc_GPA] as rgpa
			on
			rgpa.BK_StudentID = ds.BK_StudentID
			and
			rgpa.BK_TermCode = dt.BK_TermCode
			where
			ds.CollegeOfRecord = @CoR
			and
			dt.BK_TermCode = @Current_TermCode
			and
			fe.EnrolledAsOfSectionCensusDate = 1
			group by
			ds.BK_StudentID
			, ds.SK_Student_Key
			/*
			, ds.LastName
			, ds.FirstName
			, ds.PrimaryEmailAddress
			, ds.PrimaryTelephoneNumber
			*/
			, dt.BK_TermCode
			, dt.SK_Term_Key
			, dt.TermDesc
			having
			sum(fe.EnrollUnits) > 0 -- enrolled in current term
			-- and -- 9/4/2018: apply GPA requirement elsewhere
			-- max(dst.CumulativeGPAAsOfBOT) >= 2.0
		) as cur_stud
		left join
		FactEnrollment as fe
		on
		fe.SK_Student_Key = cur_stud.SK_Student_Key
		left join
		DimTermPeriod as dtp
		on
		dtp.SK_TermPeriod_Key = fe.SK_TermPeriod_Key
		inner join
		DimTerm as dt
		on
		dt.SK_Term_Key = dtp.SK_Term_Key
		left join
		DimCourse as dc
		on
		dc.SK_Course_Key = fe.SK_Course_Key
		left join
		DimGrade as dg
		on
		dg.SK_Grade_Key = fe.SK_Grade_Key
		where
		dt.BK_TermCode <= @Current_TermCode
		group by
		cur_stud.BK_StudentID
		, cur_stud.SK_Student_Key
		/*
		, cur_stud.LastName
		, cur_stud.FirstName
		, cur_stud.PrimaryEmailAddress
		, cur_stud.PrimaryTelephoneNumber
		*/
		, cur_stud.BK_TermCode
		, cur_stud.SK_Term_Key
		, cur_stud.TermDesc
		, cur_stud.EnrollUnits
		, cur_stud.CumulativeUnitsAttemptedAsOfEOT
		, cur_stud.CumulativeGPAAsOfEOT
	) as a
) as b
;
