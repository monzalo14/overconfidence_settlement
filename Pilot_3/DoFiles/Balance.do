

use "$directorio\DB\treatment_data.dta", clear

********************************************************************************
*Balance test of treatment assignment 

drop if grupo_tratamiento=="0"
egen treatment=group(grupo_tratamiento)

orth_out prob_ganar cantidad_ganar sueldo sueldo_per salario_diario, ///
				by(treatment)  vce(robust)   bdec(3)  
qui putexcel C5=matrix(r(matrix)) using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
		
local i=5		
foreach var of varlist prob_ganar cantidad_ganar sueldo sueldo_per salario_diario {
	mvtest means `var' , by(treatment) 
	local pval=round(`r(p_F)',.001)
	local pval : di %3.2f `pval'
	qui putexcel G`i'=(`pval') using "$directorio\Tables\Balance.xlsx", sheet("Balance") modify
	local i=`i'+1
	}
