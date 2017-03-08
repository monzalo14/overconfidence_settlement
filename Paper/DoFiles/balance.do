* BALANCE TESTS

use "$directorio\_aux\Programa_Aleatorizacion.dta", clear

*Conditioning on Compliance
keep if sellevotratamiento==1

	
********************************************************************************
*Balance test of treatment assignment 

merge m:1 folio  using ///
	"$directorio\DB\Calculadora_wod.dta", keep(1 3)
drop _merge

destring     gnero	puesto	salariodiariointegrado	jornadasemanal	giro ///
	accinprincipalcalc	causadedemanda	tipodeabogadocalc	 codemandaimssinfo	///
		reinstalacin	indemnizacinconstitucional	indemnizacin20das	///
			salariosvencidos	horasextras	pagoimssinfosar	antigedad, replace force

replace giro=(giro==3)
replace accinprincipalcalc=(accinprincipalcalc==2)



orth_out gnero	puesto	jornadasemanal ///
	accinprincipalcalc	causadedemanda	tipodeabogadocalc	 codemandaimssinfo	///
		reinstalacin	indemnizacinconstitucional	indemnizacin20das	///
			salariosvencidos	horasextras	pagoimssinfosar	antigedad ///
			time_between anio ///
			p_actor p_ractor p_demandado p_rdemandado ///
			if tratamientoquelestoco!=0, ///
				by(tratamientoquelestoco)  vce(robust)   bdec(3)  
qui putexcel Q5=matrix(r(matrix)) using "$sharelatex\Tables\Balance.xlsx", sheet("Balance") modify
		
local i=5
foreach var of varlist gnero	puesto	jornadasemanal ///
	accinprincipalcalc	causadedemanda	tipodeabogadocalc	 codemandaimssinfo	///
		reinstalacin	indemnizacinconstitucional	indemnizacin20das	///
			salariosvencidos	horasextras	pagoimssinfosar	antigedad ///
			time_between anio ///
			p_actor p_ractor p_demandado p_rdemandado {
		
	*1 vs 2
	preserve	
	qui replace tratamientoquelestoco=. if tratamientoquelestoco==3	
	qui ttest `var' if tratamientoquelestoco!=0, by(tratamientoquelestoco) unequal	
	local vp=round(r(p),.01)
	qui putexcel D`i'=(`vp') using "$sharelatex\Tables\Balance.xlsx", sheet("Balance") modify
	restore
	
	*2 vs 3
	preserve	
	qui replace tratamientoquelestoco=. if tratamientoquelestoco==1	
	qui ttest `var' if tratamientoquelestoco!=0, by(tratamientoquelestoco) unequal	
	local vp=round(r(p),.01)
	qui putexcel F`i'=(`vp') using "$sharelatex\Tables\Balance.xlsx", sheet("Balance") modify
	restore	
	
	*3 vs 1
	preserve	
	qui replace tratamientoquelestoco=. if tratamientoquelestoco==2	
	qui ttest `var' if tratamientoquelestoco!=0, by(tratamientoquelestoco) unequal	
	local vp=round(r(p),.01)
	qui putexcel H`i'=(`vp') using "$sharelatex\Tables\Balance.xlsx", sheet("Balance") modify
	restore	
	
	local i=`i'+1
	}
