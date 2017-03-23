/* Tabla de summary statistics de variables dependeintes e independientes de las 
diversas regresiones */

global sharelatex C:\Users\chasi_000\Dropbox\Apps\ShareLaTeX\Overconfidence and settlement



/*									PUBLIC LAWYER								*/
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************

	*DB: Calculator:5005
import delimited "$directorio\DB\observaciones_tope.csv", clear 

for var c_antiguedad c_indem-c_desc_ob c_recsueldo liq_total: ///
	capture replace X=0 if X<0 & X~=.
	
*Wizorise all at 99th percentile
for var c_* liq_total liq_total_tope: capture egen X99 = pctile(X) , p(99)
for var c_* liq_total liq_total_tope: ///
	capture replace X=X99 if X>X99 & X~=.
drop *99

keep if abogado_pub==1

*Variables
	*We define win as liq_total>0
	gen win=(liq_total>0)
	*Ratio amount won/amount asked
	gen won_asked=liq_total/c_total
	*Salario diario
	destring salario_diario, force replace
	*Conciliation
	gen con=(modo_termino==1)
	*Expiry
	gen expiry=(modo_termino==4)
	*Drop
	gen drp=(modo_termino==2)
	*Court/no recovery
	gen court_nr=(modo_termino==3 & win==0)	
	*Court/positive recovery
	gen court_pr=(modo_termino==3 & win==1)		
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
foreach var of varlist win liq_total c_total won_asked con expiry drp court_nr court_pr ///
	con_1m con_6m duracion  ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_pub") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_pub") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_pub") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_pub") modify			
		
		
	local n=`n'+2
	local m=`m'+2
	}

	
*PANEL B (B�sicas)
local n=5
local m=6
foreach var of varlist abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem   ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_pub") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_pub") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_pub") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_pub") modify				
		
	local n=`n'+2
	local m=`m'+2
	}
	

*PANEL C (Estrat�gicas)
local n=5
local m=6
foreach var of varlist reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_pub") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_pub") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_pub") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_pub") modify			
		
		
	local n=`n'+2
	local m=`m'+2
	}
	
********************************************************************************
	*DB: Subcourt 7
keep if junta==7
	
 
*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total won_asked con expiry drp court_nr court_pr ///
	con_1m con_6m duracion  ///
	{
	qui su `var'

	*Obs
	qui putexcel F`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_pub") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel G`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_pub") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel G`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_pub") modify			
		
		
	local n=`n'+2
	local m=`m'+2
	}

	
*PANEL B (B�sicas)
local n=5
local m=6
foreach var of varlist abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem  ///
	{
	qui su `var'

	*Obs
	qui putexcel F`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_pub") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel G`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_pub") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel G`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_pub") modify				
		
	local n=`n'+2
	local m=`m'+2
	}
	

*PANEL C (Estrat�gicas)
local n=5
local m=6
foreach var of varlist reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	{
	qui su `var'

	*Obs
	qui putexcel F`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_pub") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel G`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_pub") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel G`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_pub") modify			
		
		
	local n=`n'+2
	local m=`m'+2
	}

********************************************************************************
	*DB: March Pilot
use "$directorio\DB\DB3\Base_Seguimiento.dta", clear
merge m:1 expediente anio using "$directorio\DB\Calculadora_wod.dta", keep(1 3) nogen


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

*Homologaci�n de variables
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
  

keep if abogado_pub==1


*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total con con_1m con_6m ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_pub") modify
	*Obs
	qui putexcel D`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_pub") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel E`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_pub") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel E`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_pub") modify			

	local n=`n'+2
	local m=`m'+2
	}

	
*PANEL B (B�sicas)
local n=5
local m=6
foreach var of varlist abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem  ///
	{
	qui su `var'
	
	*Obs
	qui putexcel D`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_pub") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel E`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_pub") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel E`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_pub") modify				
		
	local n=`n'+2
	local m=`m'+2
	}
	

*PANEL C (Estrat�gicas)
local n=5
local m=6
foreach var of varlist reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	{
	qui su `var'
	
	*Obs
	qui putexcel D`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_pub") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel E`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_pub") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel E`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_pub") modify			

	local n=`n'+2
	local m=`m'+2
	}

	
	
********************************************************************************
	*DB: March Pilot merged with surveys (Table 1A)
use "$directorio\DB\Calculadora_wod.dta", clear	


*Employee
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
rename A_5_1 masprob_employee
replace masprob=masprob/100
rename A_5_5 dineromasprob_employee
rename A_5_8 tiempomasprob_employee

keep if tipodeabogadocalc==1

local n=5
local m=6
foreach var of varlist masprob dineromasprob tiempomasprob ///
	{
	qui su `var'
	
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel B`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("SS_A_bylawyer") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel B`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("SS_A_bylawyer") modify					
		
	local n=`n'+2
	local m=`m'+2
	}

	*Obs
	qui putexcel B`n'=("`r(N)'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
	sheet("SS_A_bylawyer") modify	




preserve
*Employee's Lawyer
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(3)
drop masprob dineromasprob tiempomasprob
rename RA_5_1 masprob
replace masprob=masprob/100
rename RA_5_5 dineromasprob
rename RA_5_8 tiempomasprob

keep if tipodeabogadocalc==1
	
local n=13
local m=14
foreach var of varlist masprob dineromasprob tiempomasprob ///
	{
	qui su `var'
		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel B`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("SS_A_bylawyer") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel B`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("SS_A_bylawyer") modify					
		
	local n=`n'+2
	local m=`m'+2
	}

	*Obs
	qui putexcel B`n'=("`r(N)'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
	sheet("SS_A_bylawyer") modify		
	
restore

preserve
*Firm's Lawyer
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(3)
drop masprob dineromasprob tiempomasprob
rename RD5_1_1 masprob
replace masprob=masprob/100
rename RD5_5 dineromasprob
rename RD5_8 tiempomasprob

keep if tipodeabogadocalc==1
	
local n=21
local m=22
foreach var of varlist masprob dineromasprob tiempomasprob ///
	{
	qui su `var'
		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel B`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("SS_A_bylawyer") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel B`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("SS_A_bylawyer") modify					
		
	local n=`n'+2
	local m=`m'+2
	}

	*Obs
	qui putexcel B`n'=("`r(N)'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
	sheet("SS_A_bylawyer") modify
	
restore


/*									PRIVATE LAWYER				     		    */
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************

	*DB: Calculator:5005
import delimited "$directorio\DB\observaciones_tope.csv", clear 

for var c_antiguedad c_indem-c_desc_ob c_recsueldo liq_total: ///
	capture replace X=0 if X<0 & X~=.
	
*Wizorise all at 99th percentile
for var c_* liq_total liq_total_tope: capture egen X99 = pctile(X) , p(99)
for var c_* liq_total liq_total_tope: ///
	capture replace X=X99 if X>X99 & X~=.
drop *99

keep if abogado_pub==0

*Variables
	*We define win as liq_total>0
	gen win=(liq_total>0)
	*Ratio amount won/amount asked
	gen won_asked=liq_total/c_total
	*Salario diario
	destring salario_diario, force replace
	*Conciliation
	gen con=(modo_termino==1)
	*Expiry
	gen expiry=(modo_termino==4)
	*Drop
	gen drp=(modo_termino==2)
	*Court/no recovery
	gen court_nr=(modo_termino==3 & win==0)	
	*Court/positive recovery
	gen court_pr=(modo_termino==3 & win==1)
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
foreach var of varlist win liq_total c_total won_asked con expiry drp court_nr court_pr ///
	con_1m con_6m duracion  ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_privado") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_privado") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_privado") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_privado") modify			
		
		
	local n=`n'+2
	local m=`m'+2
	}

	
*PANEL B (B�sicas)
local n=5
local m=6
foreach var of varlist abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem  ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_privado") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_privado") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_privado") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_privado") modify				
		
	local n=`n'+2
	local m=`m'+2
	}
	

*PANEL C (Estrat�gicas)
local n=5
local m=6
foreach var of varlist reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_privado") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_privado") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_privado") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_privado") modify			
		
		
	local n=`n'+2
	local m=`m'+2
	}
	
	
********************************************************************************	
	*DB: Subcourt 7	
keep if junta==7
	
 
*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total won_asked con expiry drp court_nr court_pr ///
	con_1m con_6m duracion  ///
	{
	qui su `var'

	*Obs
	qui putexcel F`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_privado") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel G`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_privado") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel G`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_privado") modify			
		
		
	local n=`n'+2
	local m=`m'+2
	}

	
*PANEL B (B�sicas)
local n=5
local m=6
foreach var of varlist abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem  ///
	{
	qui su `var'

	*Obs
	qui putexcel F`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_privado") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel G`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_privado") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel G`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_privado") modify				
		
	local n=`n'+2
	local m=`m'+2
	}
	

*PANEL C (Estrat�gicas)
local n=5
local m=6
foreach var of varlist reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	{
	qui su `var'

	*Obs
	qui putexcel F`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_privado") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel G`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_privado") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel G`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_privado") modify			
		
		
	local n=`n'+2
	local m=`m'+2
	}
	
	
********************************************************************************
	*DB: March Pilot
use "$directorio\DB\DB3\Base_Seguimiento.dta", clear
merge m:1 expediente anio using "$directorio\DB\Calculadora_wod.dta", keep(1 3) nogen


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

*Homologaci�n de variables
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
  

keep if abogado_pub==0


*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total con con_1m con_6m ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_privado") modify
	*Obs
	qui putexcel D`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_privado") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel E`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_privado") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel E`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelA_privado") modify			

	local n=`n'+2
	local m=`m'+2
	}

	
*PANEL B (B�sicas)
local n=5
local m=6
foreach var of varlist abogado_pub gen trabajador_base c_antiguedad salario_diario horas_sem  ///
	{
	qui su `var'
	
	*Obs
	qui putexcel D`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_privado") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel E`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_privado") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel E`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelB_privado") modify				
		
	local n=`n'+2
	local m=`m'+2
	}
	

*PANEL C (Estrat�gicas)
local n=5
local m=6
foreach var of varlist reinst indem sal_caidos prima_antig prima_vac hextra ///
	rec20 prima_dom desc_sem desc_ob sarimssinf utilidades nulidad  ///
	vac ag codem  ///
	{
	qui su `var'
	
	*Obs
	qui putexcel D`n'=(r(N))  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_privado") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel E`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_privado") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel E`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("PanelC_privado") modify				
		
	local n=`n'+2
	local m=`m'+2
	}

	
	
********************************************************************************
	*DB: March Pilot merged with surveys (Table 1A)
use "$directorio\DB\Calculadora_wod.dta", clear	


*Employee
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
rename A_5_1 masprob_employee
replace masprob=masprob/100
rename A_5_5 dineromasprob_employee
rename A_5_8 tiempomasprob_employee

*Drop outlier
xtile perc=tiempomasprob_employee, nq(99)
replace tiempomasprob_employee=. if perc>=98

keep if tipodeabogadocalc==0

local n=5
local m=6
foreach var of varlist masprob dineromasprob tiempomasprob ///
	{
	qui su `var'
	
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("SS_A_bylawyer") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("SS_A_bylawyer") modify					
		
	local n=`n'+2
	local m=`m'+2
	}

	*Obs
	qui putexcel C`n'=("`r(N)'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
	sheet("SS_A_bylawyer") modify	
	


preserve
*Employee's Lawyer
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(3)
drop masprob dineromasprob tiempomasprob
rename RA_5_1 masprob
replace masprob=masprob/100
rename RA_5_5 dineromasprob
rename RA_5_8 tiempomasprob

keep if tipodeabogadocalc==0
	
local n=13
local m=14
foreach var of varlist masprob dineromasprob tiempomasprob ///
	{
	qui su `var'
		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("SS_A_bylawyer") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("SS_A_bylawyer") modify					
		
	local n=`n'+2
	local m=`m'+2
	}

	*Obs
	qui putexcel C`n'=("`r(N)'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
	sheet("SS_A_bylawyer") modify	
	
restore

preserve
*Firm's Lawyer
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(3)
drop masprob dineromasprob tiempomasprob
rename RD5_1_1 masprob
replace masprob=masprob/100
rename RD5_5 dineromasprob
rename RD5_8 tiempomasprob

keep if tipodeabogadocalc==0
	
local n=21
local m=22
foreach var of varlist masprob dineromasprob tiempomasprob ///
	{
	qui su `var'
		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("SS_A_bylawyer") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
		sheet("SS_A_bylawyer") modify					
		
	local n=`n'+2
	local m=`m'+2
	}

	*Obs
	qui putexcel C`n'=("`r(N)'")  using "$sharelatex/Tables/SS_bylawyer.xlsx", ///
	sheet("SS_A_bylawyer") modify		
restore