// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ********************************
* *** 패널 VAR모형의 일반적 절차  ***
* ********************************
* 사용자 작성프로그램 pvar 설치
ssc install http://www.stata-journal.com/software/sj16-3/st0455.pkg

* pvargranger -- Perform pairwise Granger causality tests after pvar
webuse nlswork2
xtset idcode year
generate wage = exp(ln_wage)
keep idcode year wage hours

* 패널모형추정과 그랜저 인과검정(Pairwise Granger causality tests)
pvar wage hours, lags(3)
pvargranger  

* 차수결정(Lag-order selection statistics)
pvarsoc wage hours
pvarsoc wage hours, pvaro(instl(3/7))
pvarsoc wage hours, pinstl(1/5)

* 패널모형의 다양한 추정법 
pvar wage hours, lags(3) 
egen indocc = group(ind_code occ_code)
pvar wage hours, lags(3) vce(cluster indocc)
pvar wage hours, lags(3) instlags(1/3)
pvar wage hours, lags(3) instlags(1/3) gmmstyle
pvar wage hours, lags(3) instlags(1/3) gmmstyle overid
pvar wage hours, lags(3) gmmopts(winitial(identity) wmatrix(robust) twostep vce(unadjusted))

* 안정성 검정(Check the stability condition of panel VAR)
pvar wage hours, lags(3) 
pvarstable
pvarstable, graph
pvarstable, graph nogrid

* 충격반응함수(IRFs and dynamic multipliers)
pvarirf , oirf step(20)
pvarirf , cumulative step(20)
pvarirf , table  step(20)

* 예측오차분산(Calculate FEVDs)
pvarfevd


use V-3-1-LongPanel, clear
xtset company time
* 패널모형추정과 그랜저 인과검정(Pairwise Granger causality tests)
pvar invest market stock, lags(3)
pvargranger  

* 차수결정(Lag-order selection statistics)
pvarsoc invest market,  maxlag(8)
pvarsoc invest market, maxlag(8) pvaro(instl(1/8))
pvarsoc invest market, maxlag(6) pinstl(1/8)

* 패널모형의 다양한 추정법 
pvar wage hours, lags(3) 
egen indocc = group(ind_code occ_code)
pvar wage hours, lags(3) vce(cluster indocc)
pvar wage hours, lags(3) instlags(1/3)
pvar wage hours, lags(3) instlags(1/3) gmmstyle
pvar wage hours, lags(3) instlags(1/3) gmmstyle overid
pvar wage hours, lags(3) gmmopts(winitial(identity) wmatrix(robust) twostep vce(unadjusted))

* 안정성 검정(Check the stability condition of panel VAR)
pvar wage hours, lags(3) 
pvarstable
pvarstable, graph
pvarstable, graph nogrid

* 충격반응함수(IRFs and dynamic multipliers)
pvarirf , oirf step(20)
pvarirf , cumulative step(20)
pvarirf , table  step(20)

* 예측오차분산(Calculate FEVDs)
pvarfevd





webuse psidextract
generate lwks = ln(wks)
pvar lwks lwage if fem == 0, lags(3) 
pvargranger
pvarstable
pvarstable, graph
graph export pvar1.eps, replace
pvarirf, oirf mc(200) byoption(yrescale) porder(lwage lwks)
graph export pvar2.eps, replace
capture erase fevd_ci.dta
pvarfevd, mc(200) porder(lwage lwks) save("fevd_ci.dta")
pvarsoc lwks lwage if fem == 0, pvaropts(instlags(1/4))
pvar lwks lwage if fem == 0, lags(1) instlags(1/4) 
pvargranger
xtunitroot ht lwks if fem == 0
xtunitroot ht lwage if fem == 0
generate gwage = (exp(lwage)-exp(l.lwage))/exp(l.lwage)
generate gwks = (wks - l.wks)/l.wks
xtunitroot ht gwks if fem == 0
xtunitroot ht gwage if fem == 0
pvarsoc gwks gwage if fem == 0, pvaropts(instlags(1/4)) 
pvar gwks gwage if fem == 0, lags(1) instlags(1/4)
pvargranger
// Example 2: NLS
webuse nlswork2, clear
xtdescribe
generate ln_wks = ln(wks_work)
pvar ln_wks ln_wage, fd
estimates store fd_2 
pvar ln_wks ln_wage, fd instlags(2/3) 
estimates store fd_2t3
pvar ln_wks ln_wage, fod 
estimates store fod_1
pvar ln_wks ln_wage, fod instlags(1/2) 
estimates store fod_1t2
estimates table fd_2 fd_2t3 fod_1 fod_1t2 , b(%3.2f) se(%3.2f) stats(N J J_pval) modelwidth(8)
pvar ln_wks ln_wage, fd instlags(2/3) gmmstyle
estimates store fd_2t3g
pvar ln_wks ln_wage, fod instlags(1/2) gmmstyle
estimates store fod_1t2g
estimates table fd_2t3g fod_1t2g, b(%4.2f) se(%4.2f) stats(N J J_pval) modelwidth(8)
pvarsoc ln_wks ln_wage, maxl(3) pvaropts(instlags(1/3) fod gmmstyle)
pvarsoc ln_wks ln_wage, maxl(3) pvaropts(instlags(2/4) fod gmmstyle)
