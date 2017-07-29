/*******************************************************************************
This do file generates all previous variables and does some cleaning of the data
*******************************************************************************/
global fechacortem="02/03/2016"
global fechacorte="27/05/2016"


********************************************************************************

use "$sharelatex\DB\Iniciales.dta", clear
duplicates drop  exp anio junta, force
save "$sharelatex\DB\Iniciales_wod.dta", replace

********************************************************************************
import delimited "$sharelatex\Raw\seguimiento_audiencias_mc.csv", clear 


*Checar con Moni Posili

drop update*
drop junta_2
*Necesito una variable que indiue junta

*Presence of parts
foreach var of varlist p_* {
	replace `var'=1 if !missing(`var') & `var'>1
	}
 

/***********************
   GENERATE VARIABLES
************************/

*Junta
gen junta=.
replace junta=7 if junta_7==1
replace junta=9 if junta_9==1
replace junta=11 if junta_11==1
replace junta=16 if junta_16==1
replace junta=2 if missing(junta)

*Treatment variable
gen dia_tratamiento=(num_actor!=0 & num_actor!=.)


*Update in beleifs

foreach var of varlist ea8_prob_pago_s ea1_prob_pago ea9_cantidad_pago_s ea2_cantidad_pago ///
	era4_prob_pago_s era1_prob_pago era5_cantidad_pago_s era2_cantidad_pago ///
	erd4_prob_pago_s erd1_prob_pago erd5_cantidad_pago_s erd2_cantidad_pago {
	
	qui su `var'
	replace `var'= 10 if `var'==0 & `r(max)'==100
	qui xtile perc_`var'=`var', n(99)
	qui su `var'
	replace `var'=. if perc_`var'>=99 & `r(max)'!=100
	
	}

foreach var of varlist  ea2_cantidad_pago ea9_cantidad_pago_s ///
	era2_cantidad_pago	era5_cantidad_pago_s ///
	erd2_cantidad_pago erd5_cantidad_pago_s	 {
	
	gen `var'_m1=`var'+1
	gen log_`var'=log(`var'_m1)
	drop `var'_m1
		
	}		
	
gen diff_prob_a=(ea8_prob_pago_s-ea1_prob_pago)
gen diff_pago_a=(ea9_cantidad_pago_s-ea2_cantidad_pago)

gen diff_prob_ra=(era4_prob_pago_s-era1_prob_pago)
gen diff_pago_ra=(era5_cantidad_pago_s-era2_cantidad_pago)

gen diff_prob_rd=(erd4_prob_pago_s-erd1_prob_pago)
gen diff_pago_rd=(erd5_cantidad_pago_s-erd2_cantidad_pago)

	
foreach var of varlist diff_* {
	qui xtile perc_`var'=`var', n(99)
	replace `var'=. if perc_`var'>=95
	}
	
	
gen update_prob_a=diff_prob_a/ea1_prob_pago
gen update_pago_a=diff_pago_a/ea2_cantidad_pago

gen update_prob_ra=diff_prob_ra/era1_prob_pago
gen update_pago_ra=diff_pago_ra/era2_cantidad_pago

gen update_prob_rd=diff_prob_rd/erd1_prob_pago
gen update_pago_rd=diff_pago_rd/erd2_cantidad_pago

	
foreach var of varlist update_* {
	qui xtile perc_`var'=`var', n(99)
	replace `var'=. if perc_`var'>=95
	}
	
*Conciliators
gen ANA=(conciliadores=="ANA")
gen LUCIA=(conciliadores=="LUCIA")
gen JACQUIE=(conciliadores=="JACQUIE")
gen MARINA=(conciliadores=="MARINA")
gen KARINA=(conciliadores=="KARINA")
gen MARIBEL=(conciliadores=="MARIBEL")
gen DEYANIRA=(conciliadores=="DEYANIRA")
gen GUSTAVO=(conciliadores=="GUSTAVO")
gen CORRAL=(conciliadores=="CORRAL")
gen AGUSTIN=(conciliadores=="AGUSTIN")
gen MARGARITA=(conciliadores=="MARGARITA")
gen LUPITA=(conciliadores=="LUPITA")
gen ISAAC=(conciliadores=="ISAAC")
gen HIGUERA=(conciliadores=="HIGUERA")
gen DOCTOR=(conciliadores=="DOCTOR")
gen CESAR=(conciliadores=="CESAR")


egen ANA_D = noccur(conciliadores), string("ANA")
egen LUCIA_D = noccur(conciliadores), string("LUCIA")
egen JACQUIE_D = noccur(conciliadores), string("JACQUIE")
egen MARINA_D = noccur(conciliadores), string("MARINA")
egen KARINA_D = noccur(conciliadores), string("KARINA")
egen MARIBEL_D = noccur(conciliadores), string("MARIBEL")
egen DEYANIRA_D = noccur(conciliadores), string("DEYANIRA")
egen GUSTAVO_D = noccur(conciliadores), string("GUSTAVO")
egen CORRAL_D = noccur(conciliadores), string("CORRAL")
egen AGUSTIN_D = noccur(conciliadores), string("AGUSTIN")
egen MARGARITA_D = noccur(conciliadores), string("MARGARITA")
egen LUPITA_D = noccur(conciliadores), string("LUPITA")
egen ISAAC_D = noccur(conciliadores), string("ISAAC")
egen HIGUERA_D = noccur(conciliadores), string("HIGUERA")
egen DOCTOR_D = noccur(conciliadores), string("DOCTOR")
egen CESAR_D = noccur(conciliadores), string("CESAR")


replace ANA=1 if ANA_D==1
replace LUCIA=1 if LUCIA_D==1
replace JACQUIE=1 if JACQUIE_D==1
replace MARINA=1 if MARINA_D==1
replace KARINA=1 if KARINA_D==1
replace MARIBEL=1 if MARIBEL_D==1
replace DEYANIRA=1 if DEYANIRA_D==1
replace GUSTAVO=1 if GUSTAVO_D==1
replace CORRAL=1 if CORRAL_D==1
replace AGUSTIN=1 if AGUSTIN_D==1
replace MARGARITA=1 if MARGARITA_D==1
replace LUPITA=1 if LUPITA_D==1
replace ISAAC=1 if ISAAC_D==1
replace HIGUERA=1 if HIGUERA_D==1
replace DOCTOR=1 if DOCTOR_D==1
replace CESAR=1 if CESAR_D==1


*Who showed up
gen v0=0
replace v0=1 if p_actor==0 & p_ractor==0 & p_dem==0 & p_rdem==0 
gen v1=0
replace v1=1 if p_actor==1 & p_ractor==0 & p_dem==0 & p_rdem==0 
gen v2=0
replace v2=1 if p_actor==0 & p_ractor==1 & p_dem==0 & p_rdem==0 
gen v3=0
replace v3=1 if p_actor==0 & p_ractor==0 & p_dem==1 & p_rdem==0 
gen v4=0
replace v4=1 if p_actor==0 & p_ractor==0 & p_dem==0 & p_rdem==1 
gen v12=0
replace v12=1 if p_actor==1 & p_ractor==1 & p_dem==0 & p_rdem==0 
gen v13=0
replace v13=1 if p_actor==1 & p_ractor==0 & p_dem==1 & p_rdem==0 
gen v14=0
replace v14=1 if p_actor==1 & p_ractor==0 & p_dem==0 & p_rdem==1 
gen v23=0
replace v23=1 if p_actor==0 & p_ractor==1 & p_dem==1 & p_rdem==0 
gen v24=0
replace v24=1 if p_actor==0 & p_ractor==1 & p_dem==0 & p_rdem==1 
gen v34=0
replace v34=1 if p_actor==0 & p_ractor==0 & p_dem==1 & p_rdem==1 
gen v123=0
replace v123=1 if p_actor==1 & p_ractor==1 & p_dem==1 & p_rdem==0 
gen v124=0
replace v124=1 if p_actor==1 & p_ractor==1 & p_dem==0 & p_rdem==1 
gen v134=0
replace v134=1 if p_actor==1 & p_ractor==0 & p_dem==1 & p_rdem==1 
gen v234=0
replace v234=1 if p_actor==0 & p_ractor==1 & p_dem==1 & p_rdem==1 
gen v1234=0
replace v1234=1 if p_actor==1 & p_ractor==1 & p_dem==1 & p_rdem==1

**********

*Label var
label var convenio "Convenio"
label define convenio 0 "No concilio" 1 "Concilio" 
label values convenio convenio	

label var calcu_p_actora "Calculadora Actora"
label define calc 0 "No" 1 "Yes" 
label values calcu_p_actora calc	

label var calcu_p_dem "Calculadora Demandado" 
label values calcu_p_dem calc	

label var registro_p_actora "Survey Plaintiff"
label define surv 0 "No" 1 "Yes" 
label values registro_p_actora surv	

label var registro_p_dem "Survey Defendant" 
label values registro_p_dem surv	

label variable ea1_prob_pago "Initial prob employee"
label variable ea2_cantidad_pago "Initial amount employee"
label variable ea8_prob_pago_s "Exit prob employee"
label variable ea9_cantidad_pago_s "Exit amount employee"

label variable era1_prob_pago "Initial prob employee's lawyer"
label variable era2_cantidad_pago "Initial amount employee's lawyer"
label variable era4_prob_pago_s "Exit prob employee's lawyer"
label variable era5_cantidad_pago_s "Exit amount employee's lawyer"

label variable erd1_prob_pago "Initial prob firm's lawyer"
label variable erd2_cantidad_pago "Initial amount firm's lawyer"
label variable erd4_prob_pago_s "Exit prob firm's lawyer"
label variable erd5_cantidad_pago_s "Exit amount firm's lawyer"

label variable ea4_compra "Buys goods"
label variable ea6_trabaja "Works"
label variable ea7_busca_trabajo "Looking for a job"


save "$sharelatex\DB\Seguimiento_Juntas.dta", replace
********************************************************************************

use "$sharelatex\Raw\Programa_Aleatorizacion.dta", clear


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


save "$sharelatex\DB\Programa_Aleatorizacion.dta", replace


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
*Eliminamos duplicados
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
save "$sharelatex/DB/SalidaCompliance.dta", replace

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

use "$sharelatex\Raw\Calculadora.dta", clear

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


save "$sharelatex\DB\Calculadora.dta", replace

*DB Calculadora without duplicates
use "$sharelatex\DB\Calculadora.dta", clear
duplicates tag folio, gen(tag)

keep if tag==0
save "$sharelatex\DB\Calculadora_wod.dta", replace
********************************************************************************

