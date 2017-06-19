use "$directorio\DB\DB3\Base_Seguimiento.dta", clear
merge m:1 expediente anio using "$directorio\DB\Calculadora_wod.dta", keep(1 3) nogen
merge m:1 folio using  "$directorio/DB/Append Encuesta Inicial Actor.dta" , keep(2 3) nogen



*Persistent conciliation variable
replace seconcilio=1 if c1_fecha_con==fechalista
destring c1_se_concilio, replace force
replace c1_se_concilio=seconcilio if missing(c1_se_concilio)
replace c1_se_concilio=. if c1_se_concilio==2
bysort expediente anio : egen conciliation=max(c1_se_concilio)

*Conciliation date
replace c1_fecha_convenio=fechalista if seconcilio==1 & c1_se_concilio==1
gen fecha_con=date(c1_fecha_convenio,"DMY")
bysort expediente anio : egen fecha_convenio=max(fecha_con)
format fecha_convenio %td


*Duration
gen fechadem=date(fecha_demanda,"DMY")
gen duration=(fecha_convenio-fechadem)/30
replace duration=. if duration<0

*Private value
rename  A_5_9 private_value


*Correlation
corr private_value duration
