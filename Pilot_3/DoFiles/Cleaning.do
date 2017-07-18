********************************************************************************
import delimited "$directorio\DB\treatment_data.csv", clear
duplicates drop
drop if missing(fecha_alta)

*Gen dummies
foreach var of varlist reclutamiento dummy_confianza dummy_desc_sem ///
	dummy_prima_dom dummy_desc_ob dummy_sarimssinfo  carta_renuncia dummy_reinst ///
	 asistio_cita  confirmo_cita dummy_convenio{ 	
	 gen `var'_n =(`var'=="TRUE") if !missing(`var')
	 drop `var'
	 rename `var'_n `var'
	 }

*Covariates
replace prob_ganar=prob_ganar/100 if prob_ganar>1

gen retail=(giro==46) if !missing(giro)

gen outsourcing=(giro==56) if !missing(giro)

gen mujer=(genero=="Mujer") if !missing(genero)

gen high_school=inrange(nivel_educativo,3,4) if !missing(nivel_educativo)

gen angry=inrange(nivel_enojo,3,4) if !missing(nivel_enojo)

gen diurno=(tipo_jornada=="Diurno") if !missing(tipo_jornada)

gen top_sue=(top_demandado!="NINGUNO") if !missing(top_demandado)

gen big_size=inrange(tamao_establecimiento,3,4) if !missing(tamao_establecimiento)

gen date=date(fecha_alta, "DMY")
format date %td

*Dummy Monday | Tuesday
gen dow = dow( date )
gen mon_tue=inrange(dow,1,2)

save "$directorio\DB\treatment_data.dta", replace

********************************************************************************