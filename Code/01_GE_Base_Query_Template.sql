declare @CoR varchar(1) ;
set @CoR = '{CoR}' ;
declare @Current_TermCode int ;
set @Current_TermCode = {Cur_TermCode} ;

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
		{ge_var_calcs}
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
