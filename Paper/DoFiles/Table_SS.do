/* Summary statistics table for Outcomes, Basic and Strategic variables for the 3 pilots */


********************************************************************************
	*DB: Calculator:5005
import delimited "$sharelatex\Raw\observaciones_tope.csv", clear 

for var c_antiguedad c_indem-c_desc_ob c_recsueldo liq_total: ///
	capture replace X=0 if X<0 & X~=.
	
*Wizorise all at 99th percentile
for var c_* liq_total liq_total_tope: capture egen X99 = pctile(X) , p(99)
for var c_* liq_total liq_total_tope: ///
	capture replace X=X99 if X>X99 & X~=.
drop *99


*Variables
	*We define win as liq_total>0
	gen win=(liq_total>0)
	*Salario diario
	destring salario_diario, force replace
	*Conciliation
	gen con=(modo_termino==1)
	*Conciliation after...
	gen fechadem=date(fecha_demanda,"YMD")
	gen fechater=date(fecha_termino,"YMD")
		*1 month
	gen con_1m=(modo_termino==1 & fechater<=fechadem+31)
		*6 month
	gen con_6m=(modo_termino==1 & fechater<=fechadem+186)
	
 
*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total con con_1m con_6m duracion  ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify			
	*Range
	local range="[`r(min)', `r(max)']"
	qui putexcel D`n'=("`range'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify			
		
	local n=`n'+2
	local m=`m'+2
	}

	
*PANEL B (Básicas)
local n=5
local m=6
foreach var of varlist abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem   ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify			
	*Range
	local range="[`r(min)', `r(max)']"
	qui putexcel D`n'=("`range'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify			
		
	local n=`n'+2
	local m=`m'+2
	}
	

*PANEL C (Estratégicas)
local n=5
local m=6
foreach var of varlist reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify			
	*Range
	local range="[`r(min)', `r(max)']"
	qui putexcel D`n'=("`range'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify			
		
	local n=`n'+2
	local m=`m'+2
	}
	

********************************************************************************
	*DB: Subcourt 7 
keep if junta==7
	
 
*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total con con_1m con_6m duracion  ///
	{
	qui su `var'

	*Obs
	qui putexcel H`n'=(r(N))  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel I`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel I`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify			
	*Range
	local range="[`r(min)', `r(max)']"
	qui putexcel J`n'=("`range'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify			
		
	local n=`n'+2
	local m=`m'+2
	}

	
*PANEL B (Básicas)
local n=5
local m=6
foreach var of varlist abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem   ///
	{
	qui su `var'

	*Obs
	qui putexcel H`n'=(r(N))  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel I`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel I`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify			
	*Range
	local range="[`r(min)', `r(max)']"
	qui putexcel J`n'=("`range'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify			
		
	local n=`n'+2
	local m=`m'+2
	}
	

*PANEL C (Estratégicas)
local n=5
local m=6
foreach var of varlist reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	{
	qui su `var'

	*Obs
	qui putexcel H`n'=(r(N))  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel I`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel I`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify			
	*Range
	local range="[`r(min)', `r(max)']"
	qui putexcel J`n'=("`range'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify			
		
	local n=`n'+2
	local m=`m'+2
	}
	

********************************************************************************
	*DB: March Pilot
use "$sharelatex\DB\Base_Seguimiento.dta", clear
merge m:1 expediente anio using "$sharelatex\DB\pilot_casefiles_wod.dta", keep(1 3) nogen


*Persistent conciliation variable
destring c1_se_concilio, replace force
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

gen fecha_convenio=date(c1_fecha_convenio,"DMY")
format fecha_convenio %td


*Conciliation
gen con=c1_se_concilio

*Months after initial sue
gen fechadem=date(fecha_demanda,"DMY")
gen fechater=fecha_convenio
gen months_after=(fechater-fechadem)/30
replace months_after=. if months_after<0
xtile perc=months_after, nq(99)
replace months_after=. if perc>=99

*Conciliation after...
	*1 month
gen con_1m=(con==1 & fechater<=fechadem+31)
	*6 month
gen con_6m=(con==1 & fechater<=fechadem+186)
	
	
gen vac=.
gen ag=.
gen win=.
gen liq_total=.


*Homologación de variables
rename  trabbase  trabajador_base
rename  antigedad   c_antiguedad 
rename  salariodiariointegrado   salario_diario
rename  horas   horas_sem 
rename  tipodeabogadocalc  abogado_pub 
rename  reinstalacin reinst
rename  indemnizacinconstitucional indem 
rename  salcaidost sal_caidos 
rename  primaantigtdummy  prima_antig
rename  primavactdummy  prima_vac 
rename  horasextras  hextra 
drop rec20
rename  rec20diast rec20
rename  primadominical prima_dom 
rename  descansosemanal  desc_sem 
rename  descansoobligdummy desc_ob
rename  sarimssinfo  sarimssinf 
rename  utilidadest  utilidades
rename  nulidad  nulidad  
rename  codemandaimssinfo  codem 
rename  cuantificaciontrabajador c_total
  




*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total con con_1m con_6m  ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify
	*Obs
	qui putexcel E`n'=(r(N))  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel F`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel F`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify			
	*Range
	local range="[`r(min)', `r(max)']"
	qui putexcel G`n'=("`range'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify			
		
	local n=`n'+2
	local m=`m'+2
	}

	
*PANEL B (Básicas)
local n=5
local m=6
foreach var of varlist abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem   ///
	{
	qui su `var'
	
	*Obs
	qui putexcel E`n'=(r(N))  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel F`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel F`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify			
	*Range
	local range="[`r(min)', `r(max)']"
	qui putexcel G`n'=("`range'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify		
		
	local n=`n'+2
	local m=`m'+2
	}
	

*PANEL C (Estratégicas)
local n=5
local m=6
foreach var of varlist reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	{
	qui su `var'
	
	*Obs
	qui putexcel E`n'=(r(N))  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel F`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel F`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify			
	*Range
	local range="[`r(min)', `r(max)']"
	qui putexcel G`n'=("`range'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify		
		
	local n=`n'+2
	local m=`m'+2
	}

	
	
********************************************************************************
	*DB: March Pilot merged with surveys (Table 1A)
use "$sharelatex\DB\pilot_casefiles_wod.dta", clear	

preserve
*Employee
merge m:1 folio using  "$sharelatex/Raw/Append Encuesta Inicial Actor.dta" , keep(2 3)
rename A_5_1 masprob_employee
replace masprob=masprob/100
rename A_5_5 dineromasprob_employee
rename A_5_8 tiempomasprob_employee

*Drop outlier
xtile perc=tiempomasprob_employee, nq(99)
replace tiempomasprob_employee=. if perc>=98

local n=5
local m=6
foreach var of varlist masprob dineromasprob tiempomasprob ///
	{

	qui su `var' if tipodeabogadocalc!=.
	
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("SS_A") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("SS_A") modify		

	local n=`n'+2
	local m=`m'+2
	}

	*Obs
	qui su masprob if tipodeabogadocalc!=.
	qui putexcel C11=("`r(N)'")  using "$sharelatex/Tables/SS.xlsx", ///
	sheet("SS_A") modify

restore

preserve
*Employee's Lawyer
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Actor.dta" , keep(2 3)
rename RA_5_1 masprob_law_emp
replace masprob=masprob/100
rename RA_5_5 dineromasprob_law_emp
rename RA_5_8 tiempomasprob_law_emp
	
local n=13
local m=14
foreach var of varlist masprob dineromasprob tiempomasprob ///
	{

	qui su `var' if tipodeabogadocalc!=.
	
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("SS_A") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("SS_A") modify	
		
	local n=`n'+2
	local m=`m'+2
	}

	*Obs
	qui su masprob if tipodeabogadocalc!=.
	qui putexcel C19=("`r(N)'")  using "$sharelatex/Tables/SS.xlsx", ///
	sheet("SS_A") modify
	
restore


preserve
*Firm's Lawyer
merge m:m folio using  "$sharelatex/Raw/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3)
rename RD5_1_1 masprob_law_firm
replace masprob=masprob/100
rename RD5_5 dineromasprob_law_firm
rename RD5_8 tiempomasprob_law_emp

local n=21
local m=22
foreach var of varlist masprob dineromasprob tiempomasprob ///
	{

	qui su `var' if tipodeabogadocalc!=.
	
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("SS_A") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("SS_A") modify	
		
	local n=`n'+2
	local m=`m'+2
	}

	*Obs
	qui su masprob if tipodeabogadocalc!=.
	qui putexcel C27=("`r(N)'")  using "$sharelatex/Tables/SS.xlsx", ///
	sheet("SS_A") modify
	
restore


********************************************************************************
	*DB: ScaleUp
use "$scaleup\DB\Seguimiento_Juntas.dta", clear
*Merge with iniciales DB
keep if num_actores==1 
rename expediente exp
rename ao anio
duplicates drop  exp anio junta, force

merge 1:1 exp anio junta  using "$scaleup\DB\Iniciales_wod.dta", keep(3)


destring salario_diario, replace force
	
*Homologación de variables
rename convenio con


*Generate missing variables
foreach var in ///
	win liq_total c_total con con_1m con_6m  ///
	abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem   ///
	reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem ///
	{
		capture confirm variable  `var'
		if !_rc {
               qui di ""
               }
        else {
               gen `var'=.
               }
	}	



*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total con con_1m con_6m  ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify
	*Obs
	qui putexcel K`n'=(r(N))  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel L`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel L`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify			
	*Range
	local range="[`r(min)', `r(max)']"
	qui putexcel M`n'=("`range'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelA") modify			
		
	local n=`n'+2
	local m=`m'+2
	}

	
*PANEL B (Básicas)
local n=5
local m=6
foreach var of varlist abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem   ///
	{
	qui su `var'
	
	*Obs
	qui putexcel K`n'=(r(N))  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel L`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel L`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify			
	*Range
	local range="[`r(min)', `r(max)']"
	qui putexcel M`n'=("`range'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelB") modify		
		
	local n=`n'+2
	local m=`m'+2
	}
	

*PANEL C (Estratégicas)
local n=5
local m=6
foreach var of varlist reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	{
	qui su `var'
	
	*Obs
	qui putexcel K`n'=(r(N))  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel L`n'=("`mu'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel L`m'=("`sd'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify			
	*Range
	local range="[`r(min)', `r(max)']"
	qui putexcel M`n'=("`range'")  using "$sharelatex/Tables/SS.xlsx", ///
		sheet("PanelC") modify		
		
	local n=`n'+2
	local m=`m'+2
	}

	

		