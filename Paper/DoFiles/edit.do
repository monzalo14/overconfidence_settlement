

use "$sharelatex\DB\Base_Seguimiento.dta", clear
capture replace expediente=floor(expediente)
capture tostring expediente, gen(s_expediente)
capture tostring anio, gen(s_anio)
capture gen slength=length(s_expediente)

capture replace s_expediente="0"+s_expediente if slength==3
capture replace s_expediente="00"+s_expediente if slength==2
capture replace s_expediente="000"+s_expediente if slength==1

capture gen folio=s_expediente+"-"+s_anio


merge m:1 folio using "$sharelatex\DB\Calculadora_wod.dta", keep(1 3)
drop _merge
merge m:1 folio using "$sharelatex/Raw/Merge_Actor_OC.dta", keep(2 3) nogen

drop if tratamientoquelestoco==0

*Persistent conciliation variable
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

gen fecha_con=date(c1_fecha_convenio,"DMY")
bysort expediente anio : egen fecha_convenio=max(fecha_con)
format fecha_convenio %td

*Drop outlier
xtile perc=A_5_8, nq(99)
replace A_5_8=. if perc>=98

*Measure of update in beliefs:  |P-E_e|/|P-E_b|
gen update_comp=abs((ES_1_4-comp_esp)/(A_5_5-comp_esp))


gen calculator=2.tratamientoquelestoco
gen conciliator=3.tratamientoquelestoco


local controls  

ivreg c1_se_concilio `controls' (update =  calculator ) , robust
ivreg c1_se_concilio `controls' (update =  conciliator ) , robust
ivreg c1_se_concilio conciliator `controls' (update = calculator) , robust
ivreg c1_se_concilio `controls' (update =  calculator conciliator) , robust


