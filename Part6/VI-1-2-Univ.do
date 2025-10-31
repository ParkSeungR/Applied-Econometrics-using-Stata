// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

﻿* **************************
* *** 다항 로짓모형 추정법  ***
* **************************
import excel "D\statpgm\Part6\VI-1-2-Univ.xlsx", sheet("univ") firstrow
save VI-1-2-Univ, replace

use VI-1-2-Univ, clear
* 단순기술통계량
desc _all
summ _all

* 그래프
graph matrix psechoice hscath grades faminc famsiz parcoll female black

* 다항로짓모형(Multinomial logit model)
* 모형추정
mlogit psechoice hscath grades faminc famsiz parcoll female black 
mlogit psechoice hscath grades faminc famsiz parcoll female black, rr
mlogit psechoice hscath grades faminc famsiz parcoll female black, baseoutcome(1) 

* 확율예측
predict p1 if e(sample), outcome(1)
predict p2 if e(sample), outcome(2)
predict p3 if e(sample), outcome(3)
summarize p1 p2 p3 

* 한계효과의 측정
margins, atmeans
margins, dydx(*) predict(outcome(1)) predict(outcome(2)) predict(outcome(3))

# 정확도
generate  prid_psechoice = 0
replace    prid_psechoice = 1 if p1>p2 & p1>p3
replace    prid_psechoice = 2 if p2>p1 & p2>p3
replace    prid_psechoice = 3 if p3>p1 & p3>p2

tabulate psechoice prid_psechoice 