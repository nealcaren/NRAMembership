
insheet using nra_monthly.csv, comma clear

/*
set obs 379
replace year=2013 in 379
replace month="January" in 379
replace nra=nra[378]+400000 in 379
*/

*Create and format date variable
gen stata_date=monthly(string(year)+month,"YM")
format stata %tmCCYY

*Hack for shading area
su nra_subscribers
gen min=`r(min)'-50000
gen max=`r(max)'+50000
format max min n* %16.0gc 

*Where should we put our ticks?
su stata_date if month=="January"
local xtick_min=`r(min)'
local xtick_max=`r(max)'

keep if year
*Graph it
twoway area max stata if sta>=`=monthly("December 2008","MY")'  , bcolor(blue*.2) ///
|| area max stata if sta>=`=monthly("December 1992","MY")'  & sta<=`=monthly("December 2000","MY")'  , bcolor(blue*.2) ///
||  scatter nra_sub stata_date , mcolor(gs1) msymbol(circle) ///
||  scatter nra_sub stata_date if year==2013 , mcolor(red) msymbol(circle) ///
text(2100000 `=monthly("October 1992","MY")' "Blue shade during Democratic President", place(e) size(tiny) ) ///
ylabel(2000000(250000)3700000 ,nogrid) ytitle("")  ///
xlabel(270(24)629, tlcolor(white) labsize(vsmall)  ) xtitle("") xticks(`xtick_min'(12) `xtick_max') ///
title( " " " " "NRA membership count" "by month, 1981-2012", size(medium) ring(0) position(10) ) legend(off) ///
note("Source: Based on circulation reports for American Rifleman, American Hunter and America's 1st Freedom", size(vsmall))


graph export monthly.png, width(1600) replace

 
