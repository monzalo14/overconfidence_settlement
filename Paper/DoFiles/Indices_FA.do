/*Construcci�n de �ndices*/

/*						
1. Choose an appropriate factor analytic technique 
	(factor, pca, etc.).
2. Run the test.
3. Choose a rotation, if appropriate (varimax or promax, or both).
4. Determine which factors to retain using the Kaiser or 
	scree test.
5. Determine which variables are loaded on which retained factors.
6. Test the groupings using Cronbach�s a, at least 0.50
7. Generate indices using predict. 
*/


/*----------------------------------------------------------------
-----------------------------------------------------------------*/

/*USO:

do "$directorio\DoFiles\Indices_FA.do" ///
 Indice varlst pf rotacion 
	
*/

args indice   /*Nombre del Indice*/  ///
	 varlst	  /*Varlist en donde se incluyen las var del �ndice*/  ///
	 pf		  /*M�todo del FA pf=1(PF) pf=0(PCF)*/  ///
	 rotacion /*Dummy si se usa rotaci�n varimax o no*/  
	 


/*Puesto que la intenc�on es quedarse con un solo factor para la construcci�n de
un �ndice, buscamos la m�xima varianza retenida por el primer factor*/

cd $sharelatex/Figuras/FA

if `pf'==0 {
/*PCA*/
qui factor `varlst', pcf
if e(f)!=1{
loadingplot, title("Factores de carga") subtitle(`indice') scheme(s2mono) blcolor(black) /// 
 bfcolor(navy) graphregion(color(white)) 

gen indi="`indice'" 
gen  indc = subinstr(indi," ","",.) 
local ind=indc
graph export `ind'.pdf, replace 
}
}
else {
/*FA*/
qui factor `varlst', pf 

if `rotacion'==0 {
if e(f)!=1{
loadingplot, title("Factores de carga") subtitle(`indice') scheme(s2mono) blcolor(black) /// 
 bfcolor(navy) graphregion(color(white)) 

gen indi="`indice'" 
gen  indc = subinstr(indi," ","",.) 
local ind=indc
graph export `ind'.pdf, replace 
}
}

else {
/*Escogemos un m�todo de rotaci�n (promax/varimax)*/		
			
qui rotate, varimax
if e(f)!=1{
loadingplot, title("Factores de carga") subtitle(`indice') scheme(s2mono) blcolor(black) /// 
 bfcolor(navy) graphregion(color(white)) 

gen indi="`indice'" 
gen  indc = subinstr(indi," ","",.) 
local ind=indc
graph export `ind'.pdf, replace 
}
}
}


*Screeplot
screeplot, scheme(s2mono) graphregion(color(none))
graph export screeplot.pdf, replace 

/*La idea es usar todas las variables sugeridas en el �ndice, en caso de que eliminando 
una variable se aumente la alpha y su factor loading sea suf peque�o la eliminamos*/

/*Cronbach�s alpha*/

noi alpha `varlst'
						
/*Generamos el �ndice*/
if e(f)==1{
gen indi="`indice'" 
gen  indc = subinstr(indi," ","",.) 
local ind=indc
}

noi predict Indice_`ind' 
qui su Indice_`ind'

*Normalizaci�n Indice
replace Indice_`ind'=(Indice_`ind'- r(min))/(r(max)-r(min))


qui drop indi
qui drop indc

/*----------------------------------------------------------------
-----------------------------------------------------------------*/

