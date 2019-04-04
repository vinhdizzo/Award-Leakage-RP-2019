# README

## Repo description

This repo contains code and logic for identifying award (degree and certificate) completers at Irvine Valley College.

This accompanies the Award Leakage presentation presented at the RP Conference 2019 in Burlingame, CA, on April 3, 2019.

## File descriptions

  - [Award Leakage - RP 2019.pdf](/Award Leakage%20-%20RP%202019.pdf): presentation
  - `Background` folder
	- [AA_AS IVC GE 18-19 with name.pdf](Background/AA_AS%20IVC%20GE%2018-19%20with%20name.pdf): Local/native IVC general education requirements.
	- [CSU GE 18-19 with name .pdf](Background/CSU%20GE%2018-19%20with%20name%20.pdf): CSU general education requirements.
	- [IGETC GE 18-19 with name.pdf](Background/IGETC%20GE%2018-19%20with%20name.pdf): IGETC general education requirements.
	- [Irvine+Valley+College+2018-19+Catalog+July+2018+Edition.pdf](Background/Irvine+Valley+College+2018-19+Catalog+July+2018+Edition.pdf): IVC 2018-2019 catalog (major requirements).
  - `Input` folder
	- [GE Patterns 2018-2019.xlsx](Input/GE%20Patterns%202018-2019.xlsx): Transcribed GE requirements (3 sheets for 3 patterns).
	- [IVC Award Requirements.xlsx](Input/IVC%20Award%20Requirements.xlsx): Transcribed major requirements for different certificates and degrees.
  - `Code` folder
	- [01_GE_Base_Query_Template.sql](Code/01_GE_Base_Query_Template.sql): a base query for flagging whether a student meets each of the three GE patterns.
	- [02_Create_GE_Flags.R](Code/02_Create_GE_Flags.R): code that ingests the 3 GE pattern requirements, substitutes these requirements into `01_GE_Base_Query_Template.sql`, and flags each student for the three GE patterns.
	- [03_Accounting_Award_Example_Query.sql](Code/03_Accounting_Award_Example_Query.sql): Example query for identifying students that meet the Accounting certificate requirements.
	- [04_Award_Query_Template.sql](Code/04_Award_Query_Template.sql): A query template (similar to the previous) that could be used to substitute major requirements (eg, for other majors) listed in `IVC Award Requirements.xlsx`.
	- [05_Generate_Student_Candidate_List.R](Code/05_Generate_Student_Candidate_List.R): code that ingests the the major requirements (`IVC Award Requirements.xlsx`), substitutes these requirements into `04_Award_Query_Template.sql`, and flags whether each student qualifies for the award.  This is replicated for every award.
	- `Generated Code` subfolder
		- [000 - General Education.sql](Code/Generated%20Code/000%20-%20General%20Education.sql): code generated from `02_Create_GE_Flags.R` that creates GE flags.
		- `001 - Accounting - CV - 20191.sql` -- `147 - Social And Behavioral Sciences - AA - 20191.sql`: code generated from `05_Generate_Student_Candidate_List.R` that identifies award completers.
		
## Key steps for replication at local college

   - Transcribe GE requirements into a spreadsheet similar to [GE Patterns 2018-2019.xlsx](Input/GE%20Patterns%202018-2019.xlsx)
   - Transcribe Major requirements into a spreadsheet similar to [IVC Award Requirements.xlsx](Input/IVC%20Award%20Requirements.xlsx)
   - Course requirements
      - `Course_List_XX` (`XX` = 01, ..., 10): group of course requirements.
      - `N_Course_XX` (`XX` = 01, ..., 10): number of courses from `Course_List_XX` that needs to be completed for the major.
   - Areas that need to be completed. (Sometimes, a major requires a set of courses to be completed from a list, but the courses need to span at least `M` areas.  Use the previous course requirements columns for the former, and the following for the latter; both will be used):
      - `Group_YY` (`YY` = 01, ..., 12): list of courses that belong to area `YY`.
      - `N_Groups`: the number of groups where at least 1 course must be completed from `Group_01` - `Group_12`.