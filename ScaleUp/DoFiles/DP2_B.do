clear
set more off
global directorio C:\Users\chasi_000\Dropbox\Statistics\P10



local varlst salario_int_diario anio_nac tipo_jornada horas_sem per_horas hextra_ley hextra_triple monto_hextra_sem c_sal_caidos tope monto_indem c_hextra cambio_abogado_ac dummy_trabajador_base c_prima_dom



import delimited "$directorio\DB\DB2\BASE INICIALES AUDIENCIAS MC Append General.csv", clear

foreach var of varlist `varlst'{
	destring `var', replace force
	}


save "$directorio\DB\DB2\Iniciales.dta", replace
