-- From R, need I, 20191, Computer-Aided Design, CV, 'DR 50', 'DR 101', 'DR 203', 'ENGR 21', 'ENGR 23', 'ENGR 54', 'ENGR 83', 'MATH 124' -- 'BLANK', 8 -- 0
-- TO DO: grab correct latest GPA, not from DimStudentTerm


SET NOCOUNT ON; -- for R
SET ANSI_WARNINGS OFF ; -- for R; "Warning: Null value is eliminated by an aggregate or other SET operation." from demographics append step
declare @CoR varchar(1) ;
set @CoR = 'I' ;
declare @Current_TermCode int ;
set @Current_TermCode = 20191 ;
declare @Near_Completion_Threshold int ;
set @Near_Completion_Threshold = 2 ;

SET NOCOUNT OFF ; -- for R
select
q.*
, gehist.Gap_GE_IGETC_1A
, gehist.Gap_GE_IGETC_1B
, gehist.Gap_GE_IGETC_2A
, gehist.Gap_GE_IGETC_3A
, gehist.Gap_GE_IGETC_3B
, gehist.Gap_GE_IGETC_3A3B
, gehist.Gap_GE_IGETC_4
, gehist.Gap_GE_IGETC_5A
, gehist.Gap_GE_IGETC_5B
, gehist.Gap_GE_IGETC_5C
, gehist.GE_IGETC_Req_N
, gehist.Gap_GE_CSU_A1
, gehist.Gap_GE_CSU_A2
, gehist.Gap_GE_CSU_A3
, gehist.Gap_GE_CSU_B1
, gehist.Gap_GE_CSU_B2
, gehist.Gap_GE_CSU_B3
, gehist.Gap_GE_CSU_B4
, gehist.Gap_GE_CSU_C1
, gehist.Gap_GE_CSU_C2
, gehist.Gap_GE_CSU_C1C2
, gehist.Gap_GE_CSU_D
, gehist.Gap_GE_CSU_E
, gehist.GE_CSU_Req_N
, gehist.Gap_GE_IVC_1A
, gehist.Gap_GE_IVC_1B
, gehist.Gap_GE_IVC_1C
, gehist.Gap_GE_IVC_2
, gehist.Gap_GE_IVC_3
, gehist.Gap_GE_IVC_4
, gehist.Gap_GE_IVC_5
, gehist.Gap_GE_IVC_6
, gehist.Gap_GE_IVC_7
, gehist.Gap_GE_IVC_8
, gehist.Gap_GE_IVC_9ABC
, gehist.GE_IVC_Req_N
from
(
	select
	a.*
	, max(dst.CumulativeGPAAsOfBOT) as dst_CumulativeGPAAsOfBOT
	, max(latest_gpa.CumulativeGPAAsOfEOT) as calc_CumulativeGPAAsOfBOT
	, max(dst.CumulativeUnitsEarnedAsOfBOT) as dst_CumulativeUnitsEarnedAsOfBOT
	, max(gehist.GE_IGETC) as GE_IGETC
	, max(gehist.GE_CSU) as GE_CSU
	, max(gehist.GE_IVC) as GE_IVC
	-- , 1 as Qualify
	, max(case
		-- certificates
		when a.Award_Type in ('CC', 'CO', 'CP', 'CV') and latest_gpa.CumulativeGPAAsOfEOT >= 2.0 and N_Course_01 >= 8 and N_Course_02 >= 0 and N_Course_03 >= 0 and N_Course_04 >= 0 and N_Course_05 >= 0 and N_Course_06 >= 0 and N_Course_07 >= 0 and N_Course_08 >= 0 and N_Course_09 >= 0 and N_Course_10 >= 0 and (a.Ind_Group_01 + a.Ind_Group_02 + a.Ind_Group_03 + a.Ind_Group_04 + a.Ind_Group_05 + a.Ind_Group_06 + a.Ind_Group_07 + a.Ind_Group_08 + a.Ind_Group_09 + a.Ind_Group_10 + a.Ind_Group_11 + a.Ind_Group_12 >= 0) then 1
		-- degrees
		-- -- following is wrong because units earned depends on degree applicable (AA/AS) or CSU transferrable (AAT/AST)
		-- when latest_gpa.CumulativeGPAAsOfEOT >= 2.0 and dst.CumulativeUnitsEarnedAsOfBOT >= 60 and (gehist.GE_IGETC = 1 or gehist.GE_CSU = 1 or GE_IVC = 1) then 1
		-- Note: GPA for AAT/AST should be CSU transferrable, but don't have that.
		when a.Award_Type in ('AA', 'AS') and latest_gpa.CumulativeGPAAsOfEOT >= 2.0 and a.DG_CumulativeUnitsEarnedAsOfBOT >= 60 and (gehist.GE_IGETC = 1 or gehist.GE_CSU = 1 or GE_IVC = 1) and N_Course_01 >= 8 and N_Course_02 >= 0 and N_Course_03 >= 0 and N_Course_04 >= 0 and N_Course_05 >= 0 and N_Course_06 >= 0 and N_Course_07 >= 0 and N_Course_08 >= 0 and N_Course_09 >= 0 and N_Course_10 >= 0 and (a.Ind_Group_01 + a.Ind_Group_02 + a.Ind_Group_03 + a.Ind_Group_04 + a.Ind_Group_05 + a.Ind_Group_06 + a.Ind_Group_07 + a.Ind_Group_08 + a.Ind_Group_09 + a.Ind_Group_10 + a.Ind_Group_11 + a.Ind_Group_12 >= 0) then 1
		when a.Award_Type in ('AAT', 'AST') and latest_gpa.CumulativeGPAAsOfEOT >= 2.0 and a.CSU_CumulativeUnitsEarnedAsOfBOT >= 60 and (gehist.GE_IGETC = 1 or gehist.GE_CSU = 1) and N_Course_01 >= 8 and N_Course_02 >= 0 and N_Course_03 >= 0 and N_Course_04 >= 0 and N_Course_05 >= 0 and N_Course_06 >= 0 and N_Course_07 >= 0 and N_Course_08 >= 0 and N_Course_09 >= 0 and N_Course_10 >= 0 and (a.Ind_Group_01 + a.Ind_Group_02 + a.Ind_Group_03 + a.Ind_Group_04 + a.Ind_Group_05 + a.Ind_Group_06 + a.Ind_Group_07 + a.Ind_Group_08 + a.Ind_Group_09 + a.Ind_Group_10 + a.Ind_Group_11 + a.Ind_Group_12 >= 0) then 1 -- no IVC GE
		else 0
		end) as Qualify
	-- , sum(case when dam.BK_CollegeCode=@CoR and dam.BK_AwardCategoryCode='Certificate' and dam.AwardMajorDesc=a.Award_Name then 1 else 0 end) as Award_Activity
	, sum(case when dam.BK_CollegeCode=@CoR and dam.BK_AwardTypeCode='CV' and dam.AwardMajorDesc=a.Award_Name then 1 else 0 end) as Award_Activity
	, max(case when N_Course_01 >= 8 and N_Course_02 >= 0 and N_Course_03 >= 0 and N_Course_04 >= 0 and N_Course_05 >= 0 and N_Course_06 >= 0 and N_Course_07 >= 0 and N_Course_08 >= 0 and N_Course_09 >= 0 and N_Course_10 >= 0 and (a.Ind_Group_01 + a.Ind_Group_02 + a.Ind_Group_03 + a.Ind_Group_04 + a.Ind_Group_05 + a.Ind_Group_06 + a.Ind_Group_07 + a.Ind_Group_08 + a.Ind_Group_09 + a.Ind_Group_10 + a.Ind_Group_11 + a.Ind_Group_12 >= 0) then 1 else 0 end) as Major_Req_Ind
	, max(8 + 0 + 0 + 0 + 0 + 0 + 0 + 0 + 0 + 0) as Major_Req_N
	, max(case when N_Course_01 >= 8 then 0 else 8 - N_Course_01 end) +
		max(case when N_Course_02 >= 0 then 0 else 0 - N_Course_02 end) +
		max(case when N_Course_03 >= 0 then 0 else 0 - N_Course_03 end) +
		max(case when N_Course_04 >= 0 then 0 else 0 - N_Course_04 end) +
		max(case when N_Course_05 >= 0 then 0 else 0 - N_Course_05 end) +
		max(case when N_Course_06 >= 0 then 0 else 0 - N_Course_06 end) +
		max(case when N_Course_07 >= 0 then 0 else 0 - N_Course_07 end) +
		max(case when N_Course_08 >= 0 then 0 else 0 - N_Course_08 end) +
		max(case when N_Course_09 >= 0 then 0 else 0 - N_Course_09 end) +
		max(case when N_Course_10 >= 0 then 0 else 0 - N_Course_10 end) +
		max(case 
			when a.Ind_Group_01 + a.Ind_Group_02 + a.Ind_Group_03 + a.Ind_Group_04 + a.Ind_Group_05 + a.Ind_Group_06 + a.Ind_Group_07 + a.Ind_Group_08 + a.Ind_Group_09 + a.Ind_Group_10 + a.Ind_Group_11 + a.Ind_Group_12 >= 0 then 0
			else 0 - (a.Ind_Group_01 + a.Ind_Group_02 + a.Ind_Group_03 + a.Ind_Group_04 + a.Ind_Group_05 + a.Ind_Group_06 + a.Ind_Group_07 + a.Ind_Group_08 + a.Ind_Group_09 + a.Ind_Group_10 + a.Ind_Group_11 + a.Ind_Group_12)
			end)
		as Gap_Major_Total
	, max(case when N_Course_01 >= 8 then 0 else 8 - N_Course_01 end) as Gap_Major_Course_01
	, max(case when N_Course_02 >= 0 then 0 else 0 - N_Course_02 end) as Gap_Major_Course_02
	, max(case when N_Course_03 >= 0 then 0 else 0 - N_Course_03 end) as Gap_Major_Course_03
	, max(case when N_Course_04 >= 0 then 0 else 0 - N_Course_04 end) as Gap_Major_Course_04
	, max(case when N_Course_05 >= 0 then 0 else 0 - N_Course_05 end) as Gap_Major_Course_05
	, max(case when N_Course_06 >= 0 then 0 else 0 - N_Course_06 end) as Gap_Major_Course_06
	, max(case when N_Course_07 >= 0 then 0 else 0 - N_Course_07 end) as Gap_Major_Course_07
	, max(case when N_Course_08 >= 0 then 0 else 0 - N_Course_08 end) as Gap_Major_Course_08
	, max(case when N_Course_09 >= 0 then 0 else 0 - N_Course_09 end) as Gap_Major_Course_09
	, max(case when N_Course_10 >= 0 then 0 else 0 - N_Course_10 end) as Gap_Major_Course_10
	from
	(
		select
		cur_stud.*
		, 'Computer-Aided Design' as Award_Name
		, 'CV' as Award_Type
		, sum(case when dg.SuccessFlag=1 and dt.BK_TermCode < @Current_TermCode and (dc.TransferStatusDesc like 'Transfer%CSU%') then fe.EarnedUnits else 0 end) as CSU_CumulativeUnitsEarnedAsOfBOT
		, sum(case when dg.SuccessFlag=1 and dt.BK_TermCode < @Current_TermCode and (dc.TransferStatusDesc like 'Transfer%CSU%' or dc.DegreeApplicable = 'CR/DG') then fe.EarnedUnits else 0 end) as DG_CumulativeUnitsEarnedAsOfBOT
		, sum(case when dc.CourseID in ('DR 50', 'DR 101', 'DR 203', 'ENGR 21', 'ENGR 23', 'ENGR 54', 'ENGR 83', 'MATH 124') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as N_Course_01
		, sum(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as N_Course_02
		, sum(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as N_Course_03
		, sum(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as N_Course_04
		, sum(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as N_Course_05
		, sum(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as N_Course_06
		, sum(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as N_Course_07
		, sum(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as N_Course_08
		, sum(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as N_Course_09
		, sum(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as N_Course_10
		-- Course Groups: for AA with Emphasis
		, max(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as Ind_Group_01
		, max(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as Ind_Group_02
		, max(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as Ind_Group_03
		, max(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as Ind_Group_04
		, max(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as Ind_Group_05
		, max(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as Ind_Group_06
		, max(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as Ind_Group_07
		, max(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as Ind_Group_08
		, max(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as Ind_Group_09
		, max(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as Ind_Group_10
		, max(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as Ind_Group_11
		, max(case when dc.CourseID in ('BLANK') and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as Ind_Group_12
		from
		(
			select
			ds.BK_StudentID
			, ds.SK_Student_Key
			, ds.LastName
			, ds.FirstName
			, ds.PrimaryEmailAddress
			, ds.PrimaryTelephoneNumber
			, dt.BK_TermCode
			, dt.SK_Term_Key
			, dt.TermDesc
			, sum(fe.EnrollUnits) as EnrollUnits
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
			where
			ds.CollegeOfRecord=@CoR
			and
			dt.BK_TermCode=@Current_TermCode
			and
			fe.EnrolledAsOfSectionCensusDate=1
			group by
			ds.BK_StudentID
			, ds.SK_Student_Key
			, ds.LastName
			, ds.FirstName
			, ds.PrimaryEmailAddress
			, ds.PrimaryTelephoneNumber
			, dt.BK_TermCode
			, dt.SK_Term_Key
			, dt.TermDesc
			having
			sum(fe.EnrollUnits) > 0
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
		dt.BK_TermCode<=@Current_TermCode
		group by
		cur_stud.BK_StudentID
		, cur_stud.SK_Student_Key
		, cur_stud.LastName
		, cur_stud.FirstName
		, cur_stud.PrimaryEmailAddress
		, cur_stud.PrimaryTelephoneNumber
		, cur_stud.BK_TermCode
		, cur_stud.SK_Term_Key
		, cur_stud.TermDesc
		, cur_stud.EnrollUnits
	) as a
	left join
	FactAward as fa
	on
	fa.SK_Student_Key = a.SK_Student_Key
	and
	-- fa.SK_Term_Key <= a.SK_Term_Key + 2 -- students can apply for awards 2 terms out (including summer)
	fa.SK_Term_Key <= a.SK_Term_Key -- 9/4/2018
	left join
	DimAwardMajor as dam
	on
	dam.SK_AwardMajor_Key = fa.SK_AwardMajor_Key
	left join -- 9/4/2018: apply GPA requirement elsewhere
	DimStudentTerm as dst
	on
	dst.SK_Student_Key = a.SK_Student_Key
	and
	dst.SK_Term_Key = a.SK_Term_Key
	left join
	(
		select
		*
		from
		(
			select
			BK_StudentID
			, BK_TermCode
			, CumulativeGPAAsOfEOT
			, row_number() over (partition by BK_StudentID order by BK_TermCode desc) as term_rn
			from
			[ResearchStaging].[dbo].[Recalc_GPA]
			where
			BK_TermCode < @Current_TermCode -- before current term
		) as rgpa
		where
		rgpa.term_rn = 1
	) as latest_gpa
	on
	latest_gpa.BK_StudentID = a.BK_StudentID
	left join
	[ResearchStaging].[dbo].[Leakage_GE_Hist] as gehist
	on
	gehist.BK_StudentID = a.BK_StudentID
	and
	gehist.BK_TermCode = a.BK_TermCode
	-- /* -- Uncomment this for near completions
	where
	a.N_Course_01 >= 8
	and
	a.N_Course_02 >= 0
	and
	a.N_Course_03 >= 0
	and
	a.N_Course_04 >= 0
	and
	a.N_Course_05 >= 0
	and
	a.N_Course_06 >= 0
	and
	a.N_Course_07 >= 0
	and
	a.N_Course_08 >= 0
	and
	a.N_Course_09 >= 0
	and
	a.N_Course_10 >= 0
	and
	(a.Ind_Group_01 + a.Ind_Group_02 + a.Ind_Group_03 + a.Ind_Group_04 + a.Ind_Group_05 + a.Ind_Group_06 + a.Ind_Group_07 + a.Ind_Group_08 + a.Ind_Group_09 + a.Ind_Group_10 + a.Ind_Group_11 + a.Ind_Group_12 >= 0)
	-- and
	-- dst.CumulativeGPAAsOfBOT >= 2.0 -- 9/4/2018: moved here -- 10/24/2018: moved to "Qualify" variable
	-- */ -- Uncomment this for near completions
	group by
	a.BK_StudentID
	, a.SK_Student_Key
	, a.LastName
	, a.FirstName
	, a.PrimaryEmailAddress
	, a.PrimaryTelephoneNumber
	, a.BK_TermCode
	, a.SK_Term_Key
	, a.TermDesc
	, a.EnrollUnits
	, a.Award_Name
	, a.Award_Type
	, a.CSU_CumulativeUnitsEarnedAsOfBOT
	, a.DG_CumulativeUnitsEarnedAsOfBOT
	, a.N_Course_01
	, a.N_Course_02
	, a.N_Course_03
	, a.N_Course_04
	, a.N_Course_05
	, a.N_Course_06
	, a.N_Course_07
	, a.N_Course_08
	, a.N_Course_09
	, a.N_Course_10
	, a.Ind_Group_01
	, a.Ind_Group_02
	, a.Ind_Group_03
	, a.Ind_Group_04
	, a.Ind_Group_05
	, a.Ind_Group_06
	, a.Ind_Group_07
	, a.Ind_Group_08
	, a.Ind_Group_09
	, a.Ind_Group_10
	, a.Ind_Group_11
	, a.Ind_Group_12
) as q
left join
[ResearchStaging].[dbo].[Leakage_GE_Hist] as gehist
on
gehist.BK_StudentID = q.BK_StudentID
and
gehist.BK_TermCode = q.BK_TermCode
where
-- /* -- Uncomment this for near completions
q.Qualify = 1
and
q.Award_Activity=0
-- */ -- Uncomment this for near completions
/* -- Remove this line for near completions
(
	Award_Type in ('AA', 'AS')
	and
	calc_CumulativeGPAAsOfBOT >= 2.0
	and
	(
		gehist.Gap_GE_IGETC_Total + q.Gap_Major_Total <= @Near_Completion_Threshold
		or
		gehist.Gap_GE_CSU_Total + q.Gap_Major_Total <= @Near_Completion_Threshold
		or
		gehist.Gap_GE_IVC_Total + q.Gap_Major_Total <= @Near_Completion_Threshold
	)
	and
	DG_CumulativeUnitsEarnedAsOfBOT >= (60 - 3 * @Near_Completion_Threshold)
	and
	q.Award_Activity=0
)
or
(
	Award_Type in ('AAT', 'AST')
	and
	calc_CumulativeGPAAsOfBOT >= 2.0
	and
	(
		gehist.Gap_GE_IGETC_Total + q.Gap_Major_Total <= @Near_Completion_Threshold
		or
		gehist.Gap_GE_CSU_Total + q.Gap_Major_Total <= @Near_Completion_Threshold
		or
		gehist.Gap_GE_IVC_Total + q.Gap_Major_Total <= @Near_Completion_Threshold
	)
	and
	CSU_CumulativeUnitsEarnedAsOfBOT >= (60 - 3 * @Near_Completion_Threshold)
	and
	q.Award_Activity=0
)
or
(
	Award_Type in ('CC', 'CO', 'CP', 'CV')
	and
	calc_CumulativeGPAAsOfBOT >= 2.0
	and
	q.Gap_Major_Total <= @Near_Completion_Threshold
	and
	q.Award_Activity=0
)
*/ -- Remove this line for near completions
;

