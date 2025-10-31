// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***************************************
* *** 가상적 패널데이터세트(단기) 만들기  ***
* ***************************************
clear
set seed 123
set obs 1000

* 개인별 자료(n=1000)만들기
generate id = _n
generate year = 2015
generate x1 = runiform( ) > .5
generate x2 = rbeta(2, 3)
generate nu = rnormal( )
generate alpha1 = rnormal( )
generate alpha2 = x1+ x2 + nu

* 패널자료(T=5)
expand 5
bysort id: replace year = year + _n

generate x3 = rbeta(2, 3) + nu
generate x4 = runiform( ) + nu
generate u   = rnormal( )

* 확률효과모형, 고정효과모형의 종속변수 생성
generate yre = (1) + (2)*x1 + (3)*x2 + (4)*x3 + (5)*x4 + alpha1 + u
generate yfe = (1) + (2)*x1 + (3)*x2 + (4)*x3 + (5)*x4 + alpha2 + u

* 패널자료의 개인, 시간 식별
xtset id year, yearly
save V-2-2-Montecarlo, replace 


* ============= 1) 패널자료의 특성 파악  =========== 
use  V-2-2-Montecarlo, clear

* ******************************************************
* ******* 패널자료의 단순기술통계량  *****************
* ******************************************************
summarize yre yfe x1 x2 x3 x4 
xtsum yre yfe x1 x2 x3 x4 
corr yre yfe x1 x2 x3 x4 alpha1 alpha2
xttab x1
xttrans x1

* ******************************************************
* ******* 패널자료의 특성파악을 위한 그래프  ********
* ******************************************************
xtline yre if id<=20, overlay legend(off)
xtline x3  if id<=20, overlay legend(off) 

twoway (scatter yre x3) (lfit yre x3) 
twoway (scatter yre x4) (lfit yre x4) 

preserve
xtdata, be
twoway (scatter yre x4) (lfit yre x4) 
restore

preserve
xtdata, fe
twoway (scatter yre x4) (lfit yre x4) 
restore


* ========= 2) 통합데이터를 이용한 추정방법 ========= 
use V-2-2-Montecarlo, clear

* ******************************************************
* ******* 통합데이터(pooled data)의 OLS 추정량  ****
* ******************************************************
* 오차항이 iid이고, 독립변수와 상관관계 없을 때 OLS는 일치추정량
regress yre x1 x2 x3 x4
regress yfe x1 x2 x3 x4

* 오차항이 개체내 상이한 시점간 자기상관, 개인간iid일 때 강건표준오차 
regress yre x1 x2 x3 x4, vce(robust)
regress yfe x1 x2 x3 x4, vce(robust)

* 오차항이 개체내 상이한 시점간 자기상관, 개인간iid일 때 군집-강건표준오차
regress yre x1 x2 x3 x4, vce(cluster id)
regress yfe x1 x2 x3 x4, vce(cluster id)

* ********************************************************
* ***** 통합데이터(pooled data)의 FGLS  추정량 *******
* ***** -모집단 평균 추정량(population Averaged)- ****
* ********************************************************
xtreg yre x1 x2 x3 x4, pa
xtreg yre x1 x2 x3 x4, vce(robust) pa 
xtreg yre x1 x2 x3 x4, vce(robust) corr(ar 2) pa 

xtreg yfe x1 x2 x3 x4, pa
xtreg yfe x1 x2 x3 x4, vce(robust) pa
xtreg yfe x1 x2 x3 x4, vce(robust) corr(ar 2) pa 


* ====== 3) 패널 데이터를 이용한 추정방법 ====== 
* **************************************************
* ******* 고정효과 모형 (Fixed Effect Model) *****
* *******  -개체내 추정량(Within Estimator) - *****
* **************************************************
xtreg yre x1 x2 x3 x4, fe
xtreg yre x1 x2 x3 x4, fe vce(cluster id)

xtreg yfe x1 x2 x3 x4, fe
xtreg yfe x1 x2 x3 x4, fe vce(cluster id)

* *************************************************************
* ************** 최소자승더미변수모형 Model) ***************
* ******* (Least-Squares Dummy Variable Model:LSDV) *****
* *************************************************************
areg yre x1 x2 x3 x4, absorb(id) vce(cluster id)
areg yre x1 x2 x3 x4, absorb(id) vce(cluster id)

* ****************************************************
* ***** 일계차분모형(First Differenced estimator ****
* ****************************************************
regress D.(yre x3 x4), noconstant vce(cluster id)
regress D.(yfe x3 x4), noconstant vce(cluster id)

* ****************************************************
* *******  개체간 추정량(Between Estimator) - *****
* ****************************************************
xtreg yre x1 x2 x3 x4, be
xtreg yre x1 x2 x3 x4, be vce(bootstrap)

xtreg yfe x1 x2 x3 x4, be
xtreg yfe x1 x2 x3 x4, be vce(bootstrap)

* **************************************************
* ******* 확률모형효과(Random Effect Model) ****
* **************************************************
xtreg yre x1 x2 x3 x4, re
xtreg yre x1 x2 x3 x4, re vce(cluster id)
xtreg yre x1 x2 x3 x4, re vce(cluster id) theta

xtreg yfe x1 x2 x3 x4, re
xtreg yfe x1 x2 x3 x4, re vce(cluster id)
xtreg yfe x1 x2 x3 x4, re vce(cluster id) theta


* ==== 4) 고정효과모형과 확률효과모형의 선택  === 
use V-2-2-Montecarlo, clear

* *********************************************
* *****  하우스만 테스트(Hausman Test) ****
* *********************************************
xtreg yre x1 x2 x3 x4, fe 
estimates store refe 

xtreg yre x1 x2 x3 x4, re 
estimates store rere

xtreg yfe x1 x2 x3 x4, fe 
estimates store fefe

xtreg yfe x1 x2 x3 x4, re
estimates store fere

estimates table refe rere fefe fere, se

hausman fefe fere, sigmamore
hausman refe rere, sigmamore

* **********************************************************
* *****  강건 하우스만 테스트(Robust Hausman Test) ****
* **********************************************************
ssc install http://fmwww.bc.edu/RePEc/bocode/r/rhausman.pkg
rhausman fefe fere, reps(200) cluster
rhausman refe rere, reps(200) cluster

* **************************************
* *****  먼드랙 검정(Mundlak test) ****
* **************************************
bysort id: egen meanx3=mean(x3)
bysort id: egen meanx4=mean(x4)

quietly xtreg yfe x1 x2 x3 x4 meanx3 meanx4, vce(robust)
test meanx3 meanx4

quietly xtreg yre x1 x2 x3 x4 meanx3 meanx4, vce(robust)
test meanx3 meanx4




