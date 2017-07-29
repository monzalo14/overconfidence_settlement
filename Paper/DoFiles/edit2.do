qui su update_comp if  update_comp>=0 & update_comp <=1


*T-test 
qui xtile perc_theta_1=update_comp if tratamientoquelestoco==1 , nq(99)
ttest update_comp==1 if perc_theta_1<=90
local  r(p)

qui su update_comp
local tot_obs=`r(N)'
qui su update_comp if  update_comp>=0 & update_comp <=1 & tratamientoquelestoco==1
local perc_obs=`r(N)'/`tot_obs'*100
local perc_obs : di %3.1f `perc_obs' 



twoway (hist update_comp if  update_comp>=0 & update_comp <=1 & tratamientoquelestoco==1, ///
	percent w(.1) xlabel(0(0.1)1) ///
	text(50 0.5 " `stars' ",  color(black) size(huge) ) subtitle("Control", box bexpand) ) ///
	(scatteri 0 `r(mean)' 50 `r(mean)' if tratamientoquelestoco!=0, c(l) m(i) color(ltbluishgray) lwidth(vthick) )  ///
	, name(control_emp, replace) legend(off) scheme(s2mono) graphregion(color(none))
