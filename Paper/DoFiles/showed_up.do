use "$sharelatex\DB\pilot_operation.dta", clear


*Who showed up
gen v0=0
replace v0=1 if p_actor==0 & p_ractor==0 & p_demandado==0 & p_rdemandado==0 

gen v1=0
replace v1=1 if p_actor==1 & p_ractor==0 & p_demandado==0 & p_rdemandado==0 

gen v2=0
replace v2=1 if p_actor==0 & p_ractor==1 & p_demandado==0 & p_rdemandado==0 

gen v3=0
replace v3=1 if p_actor==0 & p_ractor==0 & p_demandado==1 & p_rdemandado==0 

gen v4=0
replace v4=1 if p_actor==0 & p_ractor==0 & p_demandado==0 & p_rdemandado==1 

gen v12=0
replace v12=1 if p_actor==1 & p_ractor==1 & p_demandado==0 & p_rdemandado==0 

gen v13=0
replace v13=1 if p_actor==1 & p_ractor==0 & p_demandado==1 & p_rdemandado==0 

gen v14=0
replace v14=1 if p_actor==1 & p_ractor==0 & p_demandado==0 & p_rdemandado==1 

gen v23=0
replace v23=1 if p_actor==0 & p_ractor==1 & p_demandado==1 & p_rdemandado==0 

gen v24=0
replace v24=1 if p_actor==0 & p_ractor==1 & p_demandado==0 & p_rdemandado==1 

gen v34=0
replace v34=1 if p_actor==0 & p_ractor==0 & p_demandado==1 & p_rdemandado==1 

gen v123=0
replace v123=1 if p_actor==1 & p_ractor==1 & p_demandado==1 & p_rdemandado==0 

gen v124=0
replace v124=1 if p_actor==1 & p_ractor==1 & p_demandado==0 & p_rdemandado==1 

gen v134=0
replace v134=1 if p_actor==1 & p_ractor==0 & p_demandado==1 & p_rdemandado==1 
 
gen v234=0
replace v234=1 if p_actor==0 & p_ractor==1 & p_demandado==1 & p_rdemandado==1 

gen v1234=0
replace v1234=1 if p_actor==1 & p_ractor==1 & p_demandado==1 & p_rdemandado==1 


su v* if tratamientoquelestoco==1
su v* if tratamientoquelestoco==2
su v* if tratamientoquelestoco==3

local r=3
levelsof tratamientoquelestoco if tratamientoquelestoco!=0, local(levels)
foreach l of local levels {  
	
	if `l'==1 {
		local Col="H"
		}
	if `l'==2 {
		local Col="I"
		}	
	if `l'==3 {
		local Col="J"
		}
		

	local rr=3
	
	foreach var of varlist v* {
	
		qui su `var' if tratamientoquelestoco==`l'
		qui putexcel `Col'`rr'=(r(mean)) using "$sharelatex/Tables/Showed_up.xlsx", sheet("Showed_up") modify
		local rr=`rr'+1
		
		}
	local r=`r'+1	
	}
