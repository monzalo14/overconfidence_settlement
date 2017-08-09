/* Summary statistics table grouped by end mode of Outcomes Basic and Srategic Variables */


********************************************************************************
	*DB: Calculator:5005
import delimited "$sharelatex\DB\scaleup_hd.csv", clear 

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
	*Conciliation after...
	gen fechadem=date(fecha_demanda,"YMD")
	gen fechater=date(fecha_termino,"YMD")

	
	
	
 
********************************************************************************
preserve
*****************************MODO TERMINO: CONCILIATION*************************
keep if modo_termino==1
********************************************************************************
 
*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total  duracion  ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
foreach var of varlist win liq_total c_total  duracion  ///
	{
	qui su `var'

	*Obs
	qui putexcel D`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel E`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel E`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel D`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel E`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel E`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel D`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel E`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel E`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			

		
	local n=`n'+2
	local m=`m'+2
	}
	

********************************************************************************
restore
********************************************************************************	


********************************************************************************
preserve
*****************************MODO TERMINO: CONCILIATION*************************
keep if modo_termino==1
********************************************************************************
 
*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total  duracion  ///
	{
	qui su `var'
	*Variable 
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel A`n'=("`var'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify
	*Obs
	qui putexcel B`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel C`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel C`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
foreach var of varlist win liq_total c_total  duracion  ///
	{
	qui su `var'

	*Obs
	qui putexcel D`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel E`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel E`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel D`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel E`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel E`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel D`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel E`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel E`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			

		
	local n=`n'+2
	local m=`m'+2
	}
	

********************************************************************************
restore
********************************************************************************	


********************************************************************************
preserve
*****************************MODO TERMINO: COURT RULING*************************
keep if modo_termino==3
********************************************************************************
 
*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total  duracion  ///
	{
	qui su `var'

	*Obs
	qui putexcel F`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel G`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel G`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel F`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel G`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel G`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel F`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel G`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel G`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
foreach var of varlist win liq_total c_total  duracion  ///
	{
	qui su `var'

	*Obs
	qui putexcel H`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel I`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel I`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel H`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel I`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel I`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel H`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel I`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel I`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			

		
	local n=`n'+2
	local m=`m'+2
	}
	

********************************************************************************
restore
********************************************************************************	




********************************************************************************
preserve
*****************************MODO TERMINO: DROP*********************************
keep if modo_termino==2
********************************************************************************
 
*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total  duracion  ///
	{
	qui su `var'

	*Obs
	qui putexcel J`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel K`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel K`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel J`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel K`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel K`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel J`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel K`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel K`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
foreach var of varlist win liq_total c_total  duracion  ///
	{
	qui su `var'

	*Obs
	qui putexcel L`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel M`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel M`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel L`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel M`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel M`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel L`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel M`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel M`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			

		
	local n=`n'+2
	local m=`m'+2
	}
	

********************************************************************************
restore
********************************************************************************	



********************************************************************************
preserve
*****************************MODO TERMINO: EXPIRY*******************************
keep if modo_termino==4
********************************************************************************
 
*PANEL A (Outcomes)
local n=5
local m=6
foreach var of varlist win liq_total c_total  duracion  ///
	{
	qui su `var'

	*Obs
	qui putexcel N`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel O`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel O`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel N`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel O`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel O`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel N`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel O`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel O`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
foreach var of varlist win liq_total c_total  duracion  ///
	{
	qui su `var'

	*Obs
	qui putexcel P`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel Q`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelA") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel Q`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel P`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel Q`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelB") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel Q`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
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
	qui putexcel P`n'=(r(N))  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify		
	*Mean
	local mu=round(r(mean),0.01)
	qui putexcel Q`n'=("`mu'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			
	*Std Dev
	local std=round(r(sd),0.01)
	local sd="(`std')"
	qui putexcel Q`m'=("`sd'")  using "$sharelatex/Tables/SS_bymodotermino.xlsx", ///
		sheet("PanelC") modify			

		
	local n=`n'+2
	local m=`m'+2
	}
	

********************************************************************************
restore
********************************************************************************	
