clear
set more off
global directorio C:\Users\chasi_000\Dropbox\Statistics\P10



local varlst salario_int_diario anio_nac tipo_jornada horas_sem per_horas hextra_ley hextra_triple monto_hextra_sem c_sal_caidos tope monto_indem c_hextra cambio_abogado_ac dummy_trabajador_base c_prima_dom



import delimited "$directorio\DB\DB2\BASE INICIALES AUDIENCIAS MC append 04_11_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\DB2\Iniciales_1.dta", replace


import delimited "$directorio\DB\DB2\BASE INICIALES AUDIENCIAS MC append 18_11_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\DB2\Iniciales_2.dta", replace


import delimited "$directorio\DB\DB2\BASE INICIALES AUDIENCIAS MC append 11_11_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\DB2\Iniciales_3.dta", replace


import delimited "$directorio\DB\DB2\BASE INICIALES AUDIENCIAS MC append 07_10_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\DB2\Iniciales_4.dta", replace


import delimited "$directorio\DB\DB2\BASE INICIALES AUDIENCIAS MC append 14_10_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\DB2\Iniciales_5.dta", replace


import delimited "$directorio\DB\DB2\BASE INICIALES AUDIENCIAS MC append 21_10_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\DB2\Iniciales_6.dta", replace


import delimited "$directorio\DB\DB2\BASE INICIALES AUDIENCIAS MC append 28_10_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\DB2\Iniciales_7.dta", replace



use "$directorio\DB\DB2\Iniciales_1.dta", clear


forvalues i=2/7 {
	append using "$directorio\DB\DB2\Iniciales_`i'.dta"
	}

save "$directorio\DB\DB2\Iniciales.dta", replace
