********************************************************************************
import delimited "$directorio\Raw\treatment_data.csv", clear
duplicates drop

replace prob_ganar=prob_ganar/100 if prob_ganar>1
save "$directorio\DB\treatment_data.dta", replace

********************************************************************************
