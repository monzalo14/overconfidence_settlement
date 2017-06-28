********************************************************************************

use "$directorio\DB\Calculadora_wod.dta", clear	
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen
merge m:m folio using "$directorio/_aux/Programa_Aleatorizacion.dta", keep(1 3) keepusing(tratamientoquelestoco seconcilio p_actor)
drop _merge

********************************************************************************

rename tratamientoquelestoco treatment
drop if treatment==0


* Qué es lo que pidió
gen asked_indemconst=(A_7_2_1==1 | A_7_2_2==1 | A_7_2_3==1 | A_7_2_4==1 | A_7_2_5==1 | A_7_2_6==1 | A_7_2_7==1 | A_7_2_8==1 | A_7_2_9==1)
gen asked_sarimssinfo=(A_7_2_1==2 | A_7_2_2==2 | A_7_2_3==2 | A_7_2_4==2 | A_7_2_5==2 | A_7_2_6==2 | A_7_2_7==2 | A_7_2_8==2 | A_7_2_9==2)
gen asked_reinstalacion=(A_7_2_1==3 | A_7_2_2==3 | A_7_2_3==3 | A_7_2_4==3 | A_7_2_5==3 | A_7_2_6==3 | A_7_2_7==3 | A_7_2_8==3 | A_7_2_9==3)
gen asked_rechrextrat=(A_7_2_1==4 | A_7_2_2==4 | A_7_2_3==4 | A_7_2_4==4 | A_7_2_5==4 | A_7_2_6==4 | A_7_2_7==4 | A_7_2_8==4 | A_7_2_9==4)
gen asked_primdom=(A_7_2_1==5 | A_7_2_2==5 | A_7_2_3==5 | A_7_2_4==5 | A_7_2_5==5 | A_7_2_6==5 | A_7_2_7==5 | A_7_2_8==5 | A_7_2_9==5)
gen asked_primavac=(A_7_2_1==6 | A_7_2_2==6 | A_7_2_3==6 | A_7_2_4==6 | A_7_2_5==6 | A_7_2_6==6 | A_7_2_7==6 | A_7_2_8==6 | A_7_2_9==6)
gen asked_nosabe=(A_7_2_1==.s)	

*Correctly knows
gen correct_indemconst=(asked_indemconst==indemconsttdummy)
gen correct_sarimssinfo=(asked_sarimssinfo==sarimssinfo)
gen correct_reinstalacion=(asked_reinstalacion==reinstalaciont)
gen correct_rechrextrat=(asked_rechrextrat==rechrextradummy)
gen correct_primdom=(asked_primdom==primadominical)
gen correct_primavac=(asked_primavac==primavactdummy)
	*A_7_1=sabe
gen correct_sabe=( A_7_1_O==90) 
	
	
	
*Create index variable that shows how much employee knows about the lawsuit
*We create several indices

************************************knows_pca***********************************

/*
	IMPORTANTE: 
En este do file nos limitamos a crear los indices, 
con anterioridad realizamos el análisis descrito arriba. Lo complementamos 
analizando la correlación entre los distintos indices obtenidos y 
observamos que la correlación es muy alta. Asimismo se busco el método que 
tuviera la interpretación mas sencilla-como aquella en que los score coeff
fueran todos positivos cuando así lo sugería el índice.
*/

local knows " A_4_3 A_7_1 correct_* "
do "$sharelatex\DoFiles\Indices_FA.do" ///
 "Knowledge" "`knows'" 0 0 

gen knows_pca=Indice_Knowledge
xtile knows_pca_xtile=knows_pca, nq(3)

************************************knows_sum***********************************

egen knows_sum=rowtotal(`knows')
xtile knows_sum_xtile=knows_sum, nq(3)


********************************************************************************
qui corr knows_pca knows_sum
mat C=r(C)
local cor=C[2,1]
local cor : di %3.2f `cor'


scatter knows_pca knows_sum, msymbol(circle_hollow) mlc(blue) ///
	xtitle("SUM index") ///
	   ytitle("PCA index") ///
	   scheme(s2mono) graphregion(color(none)) note("Correlation: `cor'")	 
graph export "$sharelatex/Figuras/scatter_index.pdf", replace


tabplot  knows_pca_ knows_sum_, percent showval ///
	xtitle("SUM index quantiles") ///
	   ytitle("PCA index quantiles") ///
	   graphregion(color(none))
graph export "$sharelatex/Figuras/tabplot_index.pdf", replace

	   
/***********************
       REGRESSIONS
************************/


********************************************************************************	


*ITT

eststo clear

*ITT
eststo: reg seconcilio i.treatment##i.knows_sum_xtile   , robust  
estadd scalar Erre=e(r2)
qui su knows_sum if e(sample)
estadd scalar indvarmean=r(mean)

eststo: reg seconcilio i.treatment##c.knows_sum   , robust  
estadd scalar Erre=e(r2)
qui su knows_sum if e(sample)
estadd scalar indvarmean=r(mean)

eststo: reg seconcilio i.treatment##i.knows_pca_xtile   , robust  
estadd scalar Erre=e(r2)
qui su knows_pca_xtile if e(sample)
estadd scalar indvarmean=r(mean)

eststo: reg seconcilio i.treatment##c.knows_pca   , robust  
estadd scalar Erre=e(r2)
qui su knows_pca if e(sample)
estadd scalar indvarmean=r(mean)





esttab using "$sharelatex\Tables\ITT_pca.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "indvarmean IndVarMean") replace 
