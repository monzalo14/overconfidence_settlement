********************************************************************************
import delimited "$directorio\DB\treatment_data.csv", clear
duplicates drop
drop if missing(fecha_alta)
drop if id_main<16 & !missing(id_main)

*Gen dummies
foreach var of varlist reclutamiento dummy_confianza dummy_desc_sem ///
	dummy_prima_dom dummy_desc_ob dummy_sarimssinfo  carta_renuncia dummy_reinst ///
	 asistio_cita  confirmo_cita dummy_convenio{ 	
	 gen `var'_n =(`var'=="TRUE") if !missing(`var')
	 drop `var'
	 rename `var'_n `var'
	 }

*Covariates
gen na_prob=0
replace na_prob=1 if missing(prob_ganar)

gen na_cant=0
replace na_cant=1 if missing(cantidad_ganar)

gen na_prob_mayor=0
replace na_prob_mayor=1 if missing(prob_mayor)

gen na_cant_mayor=0
replace na_cant_mayor=1 if missing(cant_mayor)

gen retail=(giro==46) if !missing(giro)

gen outsourcing=(giro==56) if !missing(giro)

gen mujer=(genero=="Mujer") if !missing(genero)

gen high_school=inrange(nivel_educativo,3,4) if !missing(nivel_educativo)

gen angry=inrange(nivel_enojo,3,4) if !missing(nivel_enojo)

gen diurno=(tipo_jornada=="Diurno") if !missing(tipo_jornada)

gen top_sue=(top_demandado!="NINGUNO") if !missing(top_demandado)

gen big_size=inrange(tamao_establecimiento,3,4) if !missing(tamao_establecimiento)

gen date=date(fecha_alta, "YMD")
format date %td

*Dummy Monday | Tuesday
gen dow = dow( date )
gen mon_tue=inrange(dow,1,2)


save "$directorio\DB\treatment_data.dta", replace

********************************************************************************
