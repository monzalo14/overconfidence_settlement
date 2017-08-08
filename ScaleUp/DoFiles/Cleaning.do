/*******************************************************************************
This do file generates all previous variables and does some cleaning of the data
*******************************************************************************/

clear
set more off

********************************************************************************
import delimited "$directorio\DB\bases_iniciales.csv", clear
duplicates drop  exp anio junta, force
save "$directorio\DB\Iniciales_wod.dta", replace

********************************************************************************
import delimited "$directorio\DB\seguimiento_audiencias_mc.csv", clear 


*Checar con Moni Posili

drop update*
drop junta_2
drop v1
*Necesito una variable que indiue junta

*Presence of parts
foreach var of varlist p_* {
	replace `var'=1 if !missing(`var') & `var'>1
	}
 

/***********************
   GENERATE VARIABLES
************************/


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


save "$directorio\DB\Seguimiento_Juntas.dta", replace



********************************************************************************
import delimited "$directorio\DB\predicciones.csv", clear

gen aux_id=substr(id_exp, strpos(id_exp,"/")+1,length(id_exp))

*Junta
gen junta=substr(id_exp,1,strpos(id_exp,"/")-1)  
destring junta, force replace

*Exp
gen exp=substr(aux_id,1,strpos(aux_id,"/")-1) 
destring exp, force replace

*Anio
gen anio=substr(aux_id,strpos(aux_id,"/")+1,length(aux_id)) 
destring anio, force replace
	
duplicates drop  exp anio junta, force
drop aux_id 

save "$directorio\DB\predicciones.dta", replace

********************************************************************************
