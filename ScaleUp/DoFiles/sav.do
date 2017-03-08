*gen interact=dia_tratamiento*no_encuestado

reg convenio dia_tratamiento interact , robust

test dia_tratamiento=interact

reg convenio dia_tratamiento if no_encuestado==1, robust
reg convenio dia_tratamiento if no_encuestado==0, robust



reg convenio dia_tratamiento##p_actor, r


preserve
sample 50
 tempfile temp

 save `temp'
restore
append using `temp'

reg convenio dia_tratamiento##p_actor, r

