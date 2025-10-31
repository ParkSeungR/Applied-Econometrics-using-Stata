// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *****************************
* *** 이분산, 자기상관 그래프 ***
* *****************************

clear
set scheme s1mono

* 이분산
set seed 12345678
range x 0 99 250
gen yhat = 20+0.5*x 
gen y1= 20+0.5*x +5*rnormal()
gen y2= 20+0.5*x +(1+0.1*x)*rnormal()
gen y3= 20+0.5*x +(10-0.1*x)*rnormal()

twoway  (scatter y1 x, msymbol(o)) ///
            (line yhat x,  ylabel(0 (20)100)  lwidth(thick) lcolor(black) ) ///
 	      , legend(off)
		   
 twoway (scatter y2 x, msymbol(o)) ///
            (line yhat x,  ylabel(0 (20)100)  lwidth(thick)  lcolor(black) ) ///
		  , legend(off)
		  	  		  
 twoway  (scatter y3 x, msymbol(o)) ///
             (line yhat x,  ylabel(0 (20)100)  lwidth(thick)  lcolor(black)  ) ///
		  , legend(off)

* 자기상관
set seed 12345678
range x 0 99 250
* tsset x, daily
gen yhat = 20+0.5*x 

gen e1=0.01
replace e1=1.3*e1[_n-1] if _n>=2

gen e2=0.01
replace e2=-1.3*e2[_n-1] if _n>=2

gen y1= 20+0.5*x +5*rnormal()
gen y2= 20+0.5*x +5*e1
gen y3= 20+0.5*x +5*e2

twoway  (scatter y1 x, msymbol(o)) ///
            (line yhat x,  ylabel(0 (20)100)  lwidth(thick) lcolor(black) ) ///
 	      , legend(off)

twoway (scatter y2 x, msymbol(o)) ///
            (line yhat x,  ylabel(0 (20)100)  lwidth(thick)  lcolor(black) ) ///
		  , legend(off)
		  	  		  
 twoway  (scatter y3 x, msymbol(o)) ///
             (line yhat x,  ylabel(0 (20)100)  lwidth(thick)  lcolor(black)  ) ///
		  , legend(off)
