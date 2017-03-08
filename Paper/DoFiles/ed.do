use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep( 2 3)

*******
use "$directorio\DB\DB2\Seguimiento_Juntas.dta", clear


*******


use "$directorio\_aux\Programa_Aleatorizacion.dta", clear


merge 1:1 folio fecha using "$directorio/_aux/Append Encuesta Inicial Actor.dta", keep(1 3)
	*Identifies when employee answered
gen ans_A=(_merge==3)
drop _merge

merge 1:1 folio fecha using "$directorio/_aux/Append Encuesta Inicial Demandado.dta", keep(1 3)
gen ans_D=(_merge==3)
drop _merge

merge 1:1 folio fecha using "$directorio/_aux/Append Encuesta Inicial Representante Actor.dta", keep(1 3)
gen ans_RA=(_merge==3)
drop _merge

merge 1:1 folio fecha using "$directorio/_aux/Append Encuesta Inicial Representante Demandado.dta", keep(1 3)
gen ans_RD=(_merge==3)
drop _merge

merge 1:1 folio fecha using "$directorio/_aux/SalidaCompliance.dta", keep(1 3)


*******


use "$directorio\_aux\Programa_Aleatorizacion.dta", clear
merge m:1 folio using "$directorio\DB\Calculadora_wod.dta", keep(1 3)
drop _merge


********


import delimited "$directorio\DB\observaciones_tope.csv", clear 


for var c_antiguedad c_indem-c_desc_ob c_recsueldo liq_total: ///
	capture replace X=0 if X<0 & X~=.
	
*Wizorise all at 99th percentile
for var c_* liq_total liq_total_tope: capture egen X99 = pctile(X) , p(99)
for var c_* liq_total liq_total_tope: ///
	capture replace X=X99 if X>X99 & X~=.
drop *99


******


use "$directorio\DB\Calculadora_wod.dta", clear	
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
  
 


 *Employee
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3)
rename A_5_1 masprob_employee
rename A_5_5 dineromasprob_employee



*Employee's Lawyer
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(2 3)
rename RA_5_1 masprob_law_emp
replace masprob=masprob/100
rename RA_5_5 dineromasprob_law_emp



*Firm's Lawyer
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3)
rename RD5_1_1 masprob_law_firm
replace masprob=masprob/100
rename RD5_5 dineromasprob_law_firm


******


use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(3)

*****

************************************Employee************************************
use  "$directorio\DB\Calculadora.dta", clear
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor) nogen
merge m:1 folio using "$directorio/DB/Append Encuesta Inicial Actor.dta", keep(2 3) nogen

replace seconcilio=0 if seconcilio==.
duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99



************************************Employe's Lawyer****************************
use  "$directorio\DB\Calculadora.dta", clear
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor) nogen
merge m:m folio using "$directorio/DB/Append Encuesta Inicial Representante Actor.dta", keep(2 3) nogen

replace seconcilio=0 if seconcilio==.
duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99


************************************Firm's Lawyer*******************************
use  "$directorio\DB\Calculadora.dta", clear
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor) nogen
merge m:m folio using "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta", keep(2 3) nogen

replace seconcilio=0 if seconcilio==.
duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99





*************************************EMPLOYEE***********************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force


*Regression with crossed effect overconfidence
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

rename A_5_1 Prob_win

gen oc_=Prob_win-Prob_win_calc
gen rel_oc=oc_/Prob_win_calc

rename tratamientoquelestoco treatment

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



********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force


*Regression with crossed effect overconfidence
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

rename RA_5_1 Prob_win

gen oc_=Prob_win-Prob_win_calc
gen rel_oc=oc_/Prob_win_calc


rename tratamientoquelestoco treatment

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



********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force


*Regression with crossed effect overconfidence
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100

rename RD5_1_1 Prob_win

gen oc_=Prob_win-Prob_win_calc
gen rel_oc=oc_/Prob_win_calc


rename tratamientoquelestoco treatment

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






************************************Employee************************************
use  "$directorio\DB\Calculadora.dta", clear
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor) nogen
merge m:1 folio using "$directorio/DB/Append Encuesta Inicial Actor.dta", keep(2 3) nogen

replace seconcilio=0 if seconcilio==.
duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99

*Nos quedamos con los que tuvieron tratamiento de la calculadora
keep if tratamientoquelestoco==2

	*Dinero
gen diff_amount=(A_5_5-exp_comp)/1000




************************************Employe's Lawyer****************************
use  "$directorio\DB\Calculadora.dta", clear
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor) nogen
merge m:m folio using "$directorio/DB/Append Encuesta Inicial Representante Actor.dta", keep(2 3) nogen

replace seconcilio=0 if seconcilio==.
duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99

*Nos quedamos con los que tuvieron tratamiento de la calculadora
keep if tratamientoquelestoco==2

gen diff_amount=(RA_5_5-exp_comp)/1000




************************************Firm's Lawyer*******************************
use  "$directorio\DB\Calculadora.dta", clear
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor) nogen
merge m:m folio using "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta", keep(2 3) nogen

replace seconcilio=0 if seconcilio==.
duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99

*Nos quedamos con los que tuvieron tratamiento de la calculadora
keep if tratamientoquelestoco==2

gen diff_amount=(RD5_5-exp_comp)/1000



*************************************EMPLOYEE***********************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=97

*Regression with crossed effect overconfidence
gen oc_=A_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_oc=oc_, nq(100)
drop if perc_oc>=98
xtile perc_rel=rel_oc, nq(100)
drop if perc_rel>=98


rename tratamientoquelestoco treatment

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




********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=98

*Regression with crossed effect overconfidence
gen oc_=RA_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_oc=oc_, nq(100)
drop if perc_oc>=98

rename tratamientoquelestoco treatment

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



********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=98

*Regression with crossed effect overconfidence
gen oc_=RD5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_oc=oc_, nq(100)
drop if perc_oc>=98

rename tratamientoquelestoco treatment

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



*************************************EMPLOYEE***********************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_a=A_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_rel=rel_oc, nq(100)
drop if perc_rel>=98


rename tratamientoquelestoco treatment

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



********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_ra=RA_5_5-comp_esp
gen rel_oc=oc_/comp_esp

rename tratamientoquelestoco treatment

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



********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_rd=RD5_5-comp_esp
gen rel_oc=oc_/comp_esp

rename tratamientoquelestoco treatment

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


***********



use "$directorio\DB\DB3\Base_Seguimiento.dta", clear
merge m:1 expediente anio using "$directorio\DB\Calculadora_wod.dta", keep(1 3)
drop _merge

*Persistent conciliation variable
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)


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
 
*File Order
sort anio expediente
gen orden_exp=_n

*Presence employee
replace p_actor=(p_actor==1)

rename tratamientoquelestoco treatment



*******************


*************************************EMPLOYEE***********************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m expediente anio using "$directorio\DB\DB3\Base_Seguimiento.dta", keep(1 3) keepusing(tratamientoquelestoco c1_se_concilio seconcilio  p_actor)
drop _merge

*Persistent conciliation variable
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

duplicates drop folio tratamientoqueles conciliation, force

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_a=A_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_rel=rel_oc, nq(100)
drop if perc_rel>=98

rename tratamientoquelestoco treatment

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



********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m expediente anio using "$directorio\DB\DB3\Base_Seguimiento.dta", keep(1 3) keepusing(tratamientoquelestoco c1_se_concilio seconcilio  p_actor)
drop _merge

*Persistent conciliation variable
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

duplicates drop folio tratamientoqueles conciliation, force

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_ra=RA_5_5-comp_esp
gen rel_oc=oc_/comp_esp

rename tratamientoquelestoco treatment

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





********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m expediente anio using "$directorio\DB\DB3\Base_Seguimiento.dta", keep(1 3) keepusing(tratamientoquelestoco c1_se_concilio seconcilio  p_actor)
drop _merge

*Persistent conciliation variable
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

duplicates drop folio tratamientoqueles conciliation, force

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=99

*Regression with crossed effect overconfidence
gen oc_rd=RD5_5-comp_esp
gen rel_oc=oc_/comp_esp

rename tratamientoquelestoco treatment

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
	
 
 
 *******************************************
 
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
  

  ********************************************************************
 

 use "$directorio\DB\Calculadora_wod.dta", clear	


*Employee
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
rename A_5_1 masprob_employee
replace masprob=masprob/100
rename A_5_5 dineromasprob_employee
rename A_5_8 tiempomasprob_employee



*Employee's Lawyer
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(3)
drop masprob dineromasprob tiempomasprob
rename RA_5_1 masprob
replace masprob=masprob/100
rename RA_5_5 dineromasprob
rename RA_5_8 tiempomasprob



*Firm's Lawyer
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(3)
drop masprob dineromasprob tiempomasprob
rename RD5_1_1 masprob
replace masprob=masprob/100
rename RD5_5 dineromasprob
rename RD5_8 tiempomasprob



*******************************************************************************


use "$directorio\DB\DB3\Base_Seguimiento.dta", clear
merge m:1 expediente anio using "$directorio\DB\Calculadora_wod.dta", keep(1 3)
drop _merge


*Persistent conciliation variable
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

gen fecha_con=date(c1_fecha_convenio,"DMY")
bysort expediente anio : egen fecha_convenio=max(fecha_con)
format fecha_convenio %td


*Mini cortes

	*June
gen june="30/06/2016"
gen cortejune=date(june,"DMY")
gen convenio_june=conciliation
replace convenio_june=0 if fecha_convenio>=cortejune & !missing(conciliation)

	*July
gen july="30/07/2016"
gen cortejuly=date(july,"DMY")
gen convenio_july=conciliation
replace convenio_july=0 if fecha_convenio>=cortejuly & !missing(conciliation)

	*August
gen aug="30/08/2016"
gen corteaug=date(aug,"DMY")
gen convenio_aug=conciliation
replace convenio_aug=0 if fecha_convenio>=corteaug & !missing(conciliation)

	*September
gen sept="30/09/2016"
gen cortesept=date(sept,"DMY")
gen convenio_sept=conciliation
replace convenio_sept=0 if fecha_convenio>=cortesept & !missing(conciliation)

	*October
gen oct="30/10/2016"
gen corteoct=date(oct,"DMY")
gen convenio_oct=conciliation
replace convenio_oct=0 if fecha_convenio>=corteoct & !missing(conciliation)



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
 
*File Order
sort anio expediente
gen orden_exp=_n

*Presence employee
replace p_actor=(p_actor==1)

rename tratamientoquelestoco treatment


********************************************************


*EMPLOYEE LAWYER
use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)

	*Expectations variables	
*Dinero
gen diff_amount=RA_5_5-exp_comp
rename RA_5_5 amount
*Prob
rename RA_5_1 Prob_win
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100
gen diff_prob=Prob_win-Prob_win_calc
*Tiempo
rename RA_5_8 time


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



**********


*FIRM LAWYER
use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)

	*Expectations variables	
*Dinero
gen diff_amount=RD5_5-exp_comp
rename RD5_5 amount
*Prob
rename RD5_1_1 Prob_win
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100
gen diff_prob=Prob_win-Prob_win_calc
*Tiempo
rename RD5_8 time


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



*******
*EMPLOYEE
use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=97

	*Expectations variables	
*Dinero
gen diff_amount=A_5_5-exp_comp
rename A_5_5 amount
*Prob
rename A_5_1 Prob_win
gen Prob_win_calc=prob_laudopos/(prob_laudopos+prob_laudocero)
replace Prob_win_calc=Prob_win_calc*100
gen diff_prob=Prob_win-Prob_win_calc
*Tiempo
rename A_5_8 time


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


******



*************************************EMPLOYEE***********************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=A_5_5, nq(100)
drop if perc>=97

*Regression with crossed effect overconfidence
gen oc_=A_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_oc=oc_, nq(100)
drop if perc_oc>=98
xtile perc_rel=rel_oc, nq(100)
drop if perc_rel>=98

*Log of OC
replace oc_=log(oc_)
replace rel_oc=log(rel_oc)

rename tratamientoquelestoco treatment

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




********************************EMPLOYEE'S LAWYER*******************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RA_5_5, nq(100)
drop if perc>=98

*Regression with crossed effect overconfidence
gen oc_=RA_5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_oc=oc_, nq(100)
drop if perc_oc>=98

*Log of OC
replace oc_=log(oc_)
replace rel_oc=log(rel_oc)

rename tratamientoquelestoco treatment

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



********************************FIRM'S LAWYER*******************************
********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:m folio using  "$directorio/DB/Append Encuesta Inicial Representante Demandado.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

replace seconcilio=0 if seconcilio==.
replace seconcilio=seconcilio*100

duplicates drop folio tratamientoqueles secon, force

*Outliers
xtile perc=RD5_5, nq(100)
drop if perc>=98

*Regression with crossed effect overconfidence
gen oc_=RD5_5-comp_esp
gen rel_oc=oc_/comp_esp

*Outliers
xtile perc_oc=oc_, nq(100)
drop if perc_oc>=98

*Log of OC
replace oc_=log(oc_)
replace rel_oc=log(rel_oc)

rename tratamientoquelestoco treatment

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

