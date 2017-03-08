clear
set more off
global directorio C:\Users\chasi_000\Dropbox\Apps\ShareLaTeX\overconfidence_settlement\ScaleUp



local varlst salario_int_diario anio_nac tipo_jornada horas_sem per_horas hextra_ley hextra_triple monto_hextra_sem c_sal_caidos tope monto_indem c_hextra cambio_abogado_ac dummy_trabajador_base c_prima_dom



import delimited "$directorio\DB\BASE INICIALES AUDIENCIAS MC append 04_11_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\Iniciales_1.dta", replace


import delimited "$directorio\DB\BASE INICIALES AUDIENCIAS MC append 18_11_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\Iniciales_2.dta", replace


import delimited "$directorio\DB\BASE INICIALES AUDIENCIAS MC append 11_11_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\Iniciales_3.dta", replace


import delimited "$directorio\DB\BASE INICIALES AUDIENCIAS MC append 07_10_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\Iniciales_4.dta", replace


import delimited "$directorio\DB\BASE INICIALES AUDIENCIAS MC append 14_10_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\Iniciales_5.dta", replace


import delimited "$directorio\DB\BASE INICIALES AUDIENCIAS MC append 21_10_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\Iniciales_6.dta", replace


import delimited "$directorio\DB\BASE INICIALES AUDIENCIAS MC append 28_10_16.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}

save "$directorio\DB\Iniciales_7.dta", replace



use "$directorio\DB\Iniciales_1.dta", clear


forvalues i=2/7 {
	append using "$directorio\DB\Iniciales_`i'.dta"
	}

save "$directorio\DB\Iniciales.dta", replace
