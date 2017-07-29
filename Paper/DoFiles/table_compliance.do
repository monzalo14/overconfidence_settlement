/*Compliance table*/

use "$sharelatex\DB\Programa_Aleatorizacion.dta", clear

*Compliance rate
levelsof tratamientoquelestoco, local(levels)
foreach l of local levels { 
	
	local c=`l'+3
	qui count if tratamientoquelestoco==`l'
	qui putexcel B`c'=(r(N)) using "$sharelatex/Tables/Compliance.xlsx", sheet("Compliance") modify
	
	qui su sellevotratamiento if tratamientoquelestoco==`l'
	qui putexcel I`c'=(r(mean)) using "$sharelatex/Tables/Compliance.xlsx", sheet("Compliance") modify
	
	}

*Compliance with survey (Baseline and exit survey)	

merge 1:1 folio fecha using "$sharelatex/DB/Append Encuesta Inicial Actor.dta", keep(1 3)
	*Identifies when employee answered
gen ans_A=(_merge==3)
drop _merge

merge 1:1 folio fecha using "$sharelatex/DB/Append Encuesta Inicial Demandado.dta", keep(1 3)
gen ans_D=(_merge==3)
drop _merge

merge 1:1 folio fecha using "$sharelatex/DB/Append Encuesta Inicial Representante Actor.dta", keep(1 3)
gen ans_RA=(_merge==3)
drop _merge

merge 1:1 folio fecha using "$sharelatex/DB/Append Encuesta Inicial Representante Demandado.dta", keep(1 3)
gen ans_RD=(_merge==3)
drop _merge

merge 1:1 folio fecha using "$sharelatex/DB/SalidaCompliance.dta", keep(1 3)

*Identificador ES no vacía (anyone answered)
gen ID_ES=(_merge==3)
drop _merge

*Identificador EE no vacía (anyone answered)
egen ID_EE=rowtotal(ans*)
replace ID_EE=(ID_EE>0)



*Compliance rate Survey
qui tab tratamientoquelestoco ID_EE, matcell(EE) 
qui putexcel J3=matrix(EE) using "$sharelatex/Tables/Compliance.xlsx", sheet("Compliance") modify
	
qui tab tratamientoquelestoco ID_ES, matcell(ES) 
qui putexcel L3=matrix(ES) using "$sharelatex/Tables/Compliance.xlsx", sheet("Compliance") modify
	
