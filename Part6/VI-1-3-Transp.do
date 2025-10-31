// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

﻿* *****************************
* *** 조건부 로짓모형 추정법  ***
* *****************************
import excel "D:\statpgm\Part6\VI-1-3-Transp.xlsx", sheet("transp") firstrow
save VI-1-3-Transp, replace

use VI-1-3-Transp, clear

* 단순기술통계량
desc _all
summ _all
table mode
tabulate mode choice

* 그래프
graph matrix choice termtime invehiclecost traveltime travelcost income partysize

* 다항로짓모형(Multinomial logit model)
* 설명변수는 선택자 특징적 자료이어야 함
mlogit mode travelcost income partysize if choice==1, rr baseoutcome(4) 

* 조건부 로짓모형(Conditional logit model)
* 설명변수는 선택대안 특징적 자료이어야 함
clogit choice termtime invehiclecost traveltime travelcost, group(id)
clogit choice termtime invehiclecost traveltime travelcost air train bus, group(id)
clogit choice termtime invehiclecost traveltime travelcost air train bus, or group(id)
margins, dydx(*)
predict pc

* 정확도
gsort id -pc
gen actual = mode*choice 
collapse (first) mode choice pc (max) actual, by(id)
rename mode pred
tabulate actual pred


* 혼합 로짓모형(mixed logit model)
* 설명변수는  선택자 & 선택대안 특징적 자료가 혼합
generate incair=income*air
generate inctra=income*train
generate incbus=income*bus
generate parair=partysize*air
generate partra=partysize*train
generate parbus=partysize*bus

clogit choice termtime invehiclecost traveltime travelcost air train bus ///
         incair inctra incbus parair partra parbus, group(id)

clogit choice termtime invehiclecost traveltime travelcost air train bus ///
         incair inctra incbus parair partra parbus, or group(id)
		 
margins, dydx(*)
predict pc

* 정확도
gsort id -pc
collapse (first) mode choice pc, by(id)
tabulate mode choice
