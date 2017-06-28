use "$directorio\DB\DB3\Base_Seguimiento.dta", clear
merge m:m fechalista expediente anio using "$sharelatex\DB\citatorios.dta"



*Persistent conciliation variable
replace seconcilio=1 if c1_fecha_con==fechalista
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)


*Presence employee
replace p_actor=(p_actor==1)

rename tratamientoquelestoco treatment


eststo clear

*Summons on conciliaton and presence of employee

eststo: reg p_actor citatorio, robust	
estadd scalar Erre=e(r2)
qui su p_actor if e(sample)
estadd scalar DepVarMean=r(mean)

eststo: reg sellevotratamiento citatorio, robust	
estadd scalar Erre=e(r2)
qui su sellevotratamiento if e(sample)
estadd scalar DepVarMean=r(mean)

eststo: reg seconcilio citatorio, robust	
estadd scalar Erre=e(r2)
qui su seconcilio if e(sample)
estadd scalar DepVarMean=r(mean)

eststo: reg seconcilio i.citatorio##p_actor, robust	
estadd scalar Erre=e(r2)
qui su seconcilio if e(sample)
estadd scalar DepVarMean=r(mean)


*************************
esttab using "$sharelatex/Tables/summons.csv", se star(* 0.1 ** 0.05 *** 0.01)  ///
	scalars("Erre R-squared" "DepVarMean DepVarMean") replace 
	



