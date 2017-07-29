
***********************************************************


*Graphs: Number of cases: Overall, selected for the experiment, and actually treated

use "$sharelatex\DB\Programa_Aleatorizacion.dta", clear


twoway (histogram fecha, discrete frequency  color(gs10)) ///
       (histogram fecha if tratamientoquelestoco!=0,discrete frequency  ///
	   fcolor(none) lcolor(black)), legend(order(1 "All" 2 "Selected" )) ///
	   title("Casefiles: all vs selected for experiment") ///
	   xtitle("Date") ytitle("Frequency") ///
	   graphregion(color(none)) scheme(s2mono)
graph export "$sharelatex/Figuras/All_Selected.pdf", replace 


twoway (histogram fecha if sellevotratamiento==1, discrete frequency color(gs10)) ///
       (histogram fecha if tratamientoquelestoco!=0,discrete frequency  ///
	   fcolor(none) lcolor(black)), legend(order(1 "Treated" 2 "Selected" )) ///
	   title("Casefiles: selected vs actually treated") ///
	   xtitle("Date") ytitle("Frequency") ///
	   graphregion(color(none)) scheme(s2mono)
graph export "$sharelatex/Figuras/Selected_ActuallyT.pdf", replace 

	  
twoway (histogram fecha if tratamientoquelestoco==1, discrete frequency color(gs10)) ///
       (histogram fecha if tratamientoquelestoco==2,discrete frequency fcolor(none) lcolor(black) lpattern(solid)) ///
       (histogram fecha if tratamientoquelestoco==3,discrete frequency fcolor(gs5) lcolor(gs5) lpattern(solid)) ///	   
	   , legend(order(1 "Control" 2 "Calculator" 3 "Conciliator") row(1)) ///
	   title("Number of cases by treatment") ///
	   xtitle("Date") ytitle("Frequency") ///
	   graphregion(color(none)) scheme(s2mono)
graph export "$sharelatex/Figuras/ByTreatment.pdf", replace 
	
