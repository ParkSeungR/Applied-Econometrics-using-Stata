// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

﻿* ***********************************
* *** 로짓모형 프로빗 모형의  추정법  ***
* ***********************************
import excel "VI-1-1-Smoker.xlsx", sheet("smoker") firstrow
save VI-1-1-Smoker, replace

use VI-1-1-Smoker, clear
* 단순기술통계량
summarize smoker age educ income pcigs79
correlate smoker age educ income pcigs79
graph matrix smoker age educ income pcigs79

* ==== 1) 선형확률모형(Linear Probability Model)  ====
regress smoker age educ income pcigs79
* 오차항의 분포 확인
rvfplot
avplots

* ==== 2) 프로빗 모형(Probit Model)   ====
probit smoker age educ income pcigs79
* 한계효과
margins , dydx(*) atmeans

* ==== 3) 로짓 모형(logit model)   ====
logit smoker age educ income pcigs79
* 한계효과
margins , dydx(*) atmeans


# 로짓, Odds ratio, 한계효과의 의미

* ==== 3) 로짓 모형(logit model)   ====
logit smoker age educ income pcigs79
logistic smoker age educ income pcigs79
margins , dydx(*) atmeans

predict phat if e(sample)
gen smokerhat=0
replace smokerhat=1 if phat>=0.5 
tabulate smoker smokerhat