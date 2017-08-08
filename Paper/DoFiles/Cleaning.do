/*******************************************************************************
This do file generates all previous variables and does some cleaning of the data
*******************************************************************************/
global fechacortem="02/03/2016"
global fechacorte="27/05/2016"


********************************************************************************

import delimited  "$sharelatex\Raw\pilot_operation.csv", clear


*Generate variables
gen fecha=date(fechalista,"DMY")
order fecha
qui su fecha if fechalista=="$fechacorte"
keep if fecha<=`r(mean)'

qui su fecha if fechalista=="$fechacortem"
drop if fecha<`r(mean)'


gen fechaNext=date(fechasiguienteaudiencia,"DMY")
format fecha fechaNext %d
gen time_between=fechaNext-fecha
gen control=(tratamientoquelestoco==1)
gen calculator=(tratamientoquelestoco==2)
gen conciliator=(tratamientoquelestoco==3)

mvencode p_actor p_ractor p_demandado p_rdemandado, mv(0)
replace seconcilio=0 if seconcilio==.
replace sellevotratamiento=(sellevotratamiento>0) if !missing(sellevotratamiento)
replace sellevotratamiento=0 if missing(sellevotratamiento)

replace p_actor=(p_actor!=0)
replace p_ractor=(p_ractor!=0)
replace p_demandado=(p_demandado!=0)
replace p_rdemandado=(p_rdemandado!=0)

tostring expediente, gen(s_expediente)
tostring anio, gen(s_anio)
gen slength=length(s_expediente)

replace s_expediente="0"+s_expediente if slength==3
replace s_expediente="00"+s_expediente if slength==2
replace s_expediente="000"+s_expediente if slength==1

gen folio=s_expediente+"-"+s_anio
order folio
sort folio

label define tratamientoquelestoco 0 "Not in experiment" 1 "Control" 2 "Calculator" 3 "Conciliator"
label values tratamientoquelestoco tratamientoquelestoco

*Drop
drop if missing(expediente)
drop if missing(anio)
duplicates drop folio fecha, force


save "$sharelatex\DB\pilot_operation.dta", replace


********************************************************************************
/*Data preparation (Surveys)*/	

use "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta", clear
rename RA_fecha fecha
gen Age=(fecha-RA_1_1)/365
gen Tenure=2016-RA_1_5
rename RA_1_6 litigiosha
rename RA_1_7 litigiosesta
rename RA_3_1 numempleados
rename RA_4_1_2 porc_pago
rename RA_5_1 A_5_1
rename RA_5_2 probotro  
label var probotro "5.02 Si preguntáramos a la otra parte qué probabilidad tienen ellos de ganar"
rename RA_5_3 A_5_3
rename RA_5_4 A_5_4
rename RA_5_5 A_5_5
gen comp_ra=A_5_5
rename RA_5_6 A_5_6
rename RA_5_7 A_5_7
rename RA_5_8 A_5_8
rename RA_5_9 A_5_9
rename RA_5_10 dineromerecetrab
save "$sharelatex/DB/Append Encuesta Inicial Representante Actor.dta", replace

use "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta", clear
duplicates drop
rename RD_fecha fecha
gen Age=(fecha-RD1_1)/365
gen Tenure=2016-RD1_5
rename RD1_6 litigiosha
rename RD1_7 litigiosesta
rename RD3_1 numempleados
rename RD5_1_1 A_5_1
rename RD5_2_1 probotro  
label var probotro "5.02 Si preguntáramos a la otra parte qué probabilidad tienen ellos de ganar"
rename RD5_3 A_5_3
rename RD5_4 A_5_4
rename RD5_5 A_5_5
gen comp_rd=A_5_5
rename RD5_6 A_5_6
rename RD5_7 A_5_7
rename RD5_8 A_5_8
rename RD5_9 A_5_9
rename RD5_10 dineromerecetrab
duplicates drop folio fecha, force
save "$sharelatex/DB/Append Encuesta Inicial Representante Demandado.dta", replace

use "$sharelatex/Raw/Append Encuesta Inicial Actor.dta", clear
rename A_fecha fecha
gen Age=(fecha-A_1_1)/365
rename A_3_1 numempleados
rename A_4_2_2 porc_pago
rename A_5_2 probotro  
gen comp_a=A_5_5
label var probotro "5.02 Si preguntáramos a la otra parte qué probabilidad tienen ellos de ganar"
label var A_9_4 "9.04 ¿Qué tan de acuerdo está con el siguiente enunciado: En este momento no me"
save "$sharelatex/DB/Append Encuesta Inicial Actor.dta", replace

use "$sharelatex/Raw/Append Encuesta Inicial Demandado.dta", clear
rename D_fecha fecha
save "$sharelatex/DB/Append Encuesta Inicial Demandado.dta", replace

use "$sharelatex/Raw/Append Encuesta de Salida.dta", clear
rename ES_fecha fecha
*Drop duplicates
local vartitulo2: var label ES_1_2
local vartitulo3: var label ES_1_3
local vartitulo4: var label ES_1_4
local vartitulo5: var label ES_1_5
collapse ES_1_2-ES_1_5 , by(folio fecha ES_1_1)
drop if inlist(ES_1_2,1,2,3)!=1
label variable ES_1_2 "`vartitulo2'"
label variable ES_1_3 "`vartitulo3'"
label variable ES_1_4 "`vartitulo4'"
label variable ES_1_5 "`vartitulo5'"
save "$sharelatex/DB/Append Encuesta de Salida.dta", replace

*Dummy database only used for compliance in the exit survey
collapse ES_1_2, by(folio fecha)
save "$sharelatex/DB/exit_compliance.dta", replace

********************************************************************************
/*Homologation of variables in the 3 survey datasets*/

local varlist $varsurvey

local n=0
foreach var in `varlist' {
	local n=`n'+1
	}

local k=0
foreach var in `varlist' {
	local k=`k'+1
	
	qui use "$sharelatex/DB/Append Encuesta Inicial Actor.dta", clear
	qui capture confirm variable `var'
		*Variable is in dataset
	if !_rc!=0 {
		global vartitulo: var label `var'
		qui use "$sharelatex/DB/Append Encuesta Inicial Representante Actor.dta", clear
		qui capture confirm variable `var'
			*Variable is not in dataset
		if !_rc==0 {
			qui gen `var'=.
			label var `var' "$vartitulo"
			qui save "$sharelatex/DB/Append Encuesta Inicial Representante Actor.dta", replace
			}		
		qui use "$sharelatex/DB/Append Encuesta Inicial Representante Demandado.dta", clear
		qui capture confirm variable `var'
			*Variable is not in dataset
		if !_rc==0 {
			qui gen `var'=.
			label var `var' "$vartitulo"
			qui save "$sharelatex/DB/Append Encuesta Inicial Representante Demandado.dta", replace
			}				
		}
		*If variable is not in dataset it is somewhere else
	else {	
		qui use "$sharelatex/DB/Append Encuesta Inicial Representante Actor.dta", clear
		qui capture confirm variable `var'
			*Variable is in dataset
		if !_rc!=0 {
			global vartitulo: var label `var'
			qui use "$sharelatex/DB/Append Encuesta Inicial Actor.dta", clear
			qui capture confirm variable `var'
				*Variable is not in dataset
			if !_rc==0 {
				qui gen `var'=.
				label var `var' "$vartitulo"
				qui save "$sharelatex/DB/Append Encuesta Inicial Actor.dta", replace
				}		
			qui use "$sharelatex/DB/Append Encuesta Inicial Representante Demandado.dta", clear
			qui capture confirm variable `var'
				*Variable is not in dataset
			if !_rc==0 {
				qui gen `var'=.
				label var `var' "$vartitulo"
				qui save "$sharelatex/DB/Append Encuesta Inicial Representante Demandado.dta", replace
				}				
			}
			*If still variable is not in dataset it must be in last dataset
		else {	
			qui use "$sharelatex/DB/Append Encuesta Inicial Representante Demandado.dta", clear
			qui capture confirm variable `var'
				*Variable must be in dataset (If statemnet works only as a filter)
			if !_rc!=0 {
				global vartitulo: var label `var'
				qui use "$sharelatex/DB/Append Encuesta Inicial Representante Actor.dta", clear
				qui capture confirm variable `var'
					*Variable is not in dataset
				if !_rc==0 {
					qui gen `var'=.
					label var `var' "$vartitulo"
					qui save "$sharelatex/DB/Append Encuesta Inicial Representante Actor.dta", replace
					}		
				qui use "$sharelatex/DB/Append Encuesta Inicial Actor.dta", clear
				qui capture confirm variable `var'
					*Variable is not in dataset
				if !_rc==0 {
					qui gen `var'=.
					label var `var' "$vartitulo"
					qui save "$sharelatex/DB/Append Encuesta Inicial Actor.dta", replace
					}				
				}
			}
		}
		
		*Progress bar

	if `k'==1 {
		di "Progress"
		di "--------"
		}
	if `k'==floor(`n'/10) {
		di "10%"
		}
	if `k'==floor(`n'*2/10) {
		di "20%"
		}
	if `k'==floor(`n'*3/10) {
		di "30%"
		}
	if `k'==floor(`n'*4/10) {
		di "40%"
		}
	if `k'==floor(`n'*5/10) {
		di "50%"
		}
	if `k'==floor(`n'*6/10) {
		di "60%"
		}
	if `k'==floor(`n'*7/10) {
		di "70%"
		}
	if `k'==floor(`n'*8/10) {
		di "80%"
		}
	if `k'==floor(`n'*9/10) {
		di "90%"
		}
	if `k'==floor(`n') {
		di "100%"
		di "--------"
		di "        "
		}	
	}

********************************************************************************

import delimited "$sharelatex\Raw\pilot_casefiles.csv", clear

capture rename ao anio
capture rename exp expediente

capture destring salariodiario, replace force
capture destring jornadasemana, replace force
capture destring antigedad, replace force

capture replace expediente=floor(expediente)
capture tostring expediente, gen(s_expediente)
capture tostring anio, gen(s_anio)
capture gen slength=length(s_expediente)

capture replace s_expediente="0"+s_expediente if slength==3
capture replace s_expediente="00"+s_expediente if slength==2
capture replace s_expediente="000"+s_expediente if slength==1

capture gen folio=s_expediente+"-"+s_anio


save "$sharelatex\DB\pilot_casefiles.dta", replace

*DB Calculadora without duplicates (WOD)
use "$sharelatex\DB\pilot_casefiles.dta", clear
duplicates tag folio, gen(tag)

keep if tag==0
save "$sharelatex\DB\pilot_casefiles_wod.dta", replace
********************************************************************************

