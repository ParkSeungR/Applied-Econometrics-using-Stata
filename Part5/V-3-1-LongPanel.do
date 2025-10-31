// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***********************************************
* *************장기패널자료 분석법 ************
* ***********************************************
import excel "G:\1. Stata 저술 본문\STATA PGM\Part5\V-3-1-LongPanel.xlsx", sheet("invest") firstrow
xtset company time
save V-3-1-LongPanel, replace

* ******* 패널자료의 단순기술통계량  *****************
use V-3-1-LongPanel, clear
summarize company time invest market stock 
xtsum company time invest market stock 
xttab company
xttrans company 

* ******* 패널자료의 특성파악을 위한 그래프  ********
xtline invest, overlay legend(off)
xtline market, overlay legend(off)
xtline stock, overlay legend(off)

twoway (scatter invest market) (lfit invest market) 
twoway (scatter invest stock) (lfit invest stock) 

preserve
xtdata, be
twoway (scatter  invest market) (lfit  invest market) 
restore

preserve
xtdata, fe
twoway (scatter  invest stock) (lfit  invest stock) 
restore


* ========= 1)  regress, xtregar 사용법 =========
* 개체별 회귀분석(OLS)
preserve 
statsby, by(company) clear: regress invest market stock
format _b* %12.4f 
list
restore

* 오차항 자기상관(AR1)가정시 추정법
xtregar invest market stock, fe
xtregar invest market stock, re

* ==========  2) xtpcse 사용법 ==================
* 개체전체, 개체내 자기상관은 옵션 correlation()
* 개체간 이분산은 옵선 hetonly나  independent
use V-3-1-LongPanel, clear

* 통합 OLS(Pooled OLS)
xtpcse invest market stock, correlation(independent)

* 개체간 상관관계, 개체별 자기상관
xtpcse invest market stock, correlation(psar1)

* 개체간 상관관계, 전체개체평균  자기상관
xtpcse invest market stock, correlation(ar1)

* 개체간 전체 개체 상관관계, 개체간 이분산 혹은 독립
xtpcse invest market stock, correlation(psar1) hetonly
xtpcse invest market stock, correlation(psar1) independent

xtpcse invest market stock, correlation(ar1) hetonly
xtpcse invest market stock, correlation(ar1) independent


* ========== 3) xtgls 사용법 ==================
* 개체간 이분산 자기상관은 옵선 panels()를
* 개체내 자기상관은 corr()로 통제함

* uit가 iid일경우 Pooled OLS
xtgls invest market stock, panels(iid)

* 다른 개체간에 이분산
xtgls invest market stock, panels(heteroskedastic)

* 다른 개체간에 이분산, 상관관계
xtgls invest market stock, panels(correlated)

* 다른 개체간 이분산, 모든 개체내 자기상관
xtgls invest market stock, panels(hetero) corr(ar1)

* 다른 개체간에 이분산, 상관관계, 모든 개체내 자기상관
xtgls invest market stock, panels(correlated) corr(ar1)

* 다른 개체간에 이분산, 상관관계, 개체별로 개체내 자기상관
xtgls invest market stock, panels(correlated) corr(psar1)


* ==========  4) xtscc 사용법 ================
* xtpcse의 AR(1) 처리기능을 AR(p)까지 일반화 
ssc install http://www.stata-journal.com/software/sj7-3/st0128.pkg

xtscc invest market stock, lag(4)


* ==========  5) 패널자료의 단위근, 공적분: xtunitroot, xtpmg ======
use V-3-1-LongPanel, clear

* 패널자료의 단위근 검증
xtunitroot ips invest, lags(aic 5)
xtunitroot ips market, lags(aic 5)
xtunitroot ips stock, lags(aic 5)

* 패널자료의 공적분 검증
xtcointtest kao invest market stock
xtcointtest pedroni invest market stock
xtcointtest westerlund invest market stock

* 패널자료의 공적분 문제 해결을 위한 추정법
ssc install  http://fmwww.bc.edu/RePEc/bocode/x/xtpmg.pkg
xtpmg d.invest d.market d.stock, lr(l.invest market stock) ec(ec1) full pmg
xtpmg d.invest d.market d.stock, lr(l.invest market stock) ec(ec2)  pmg

