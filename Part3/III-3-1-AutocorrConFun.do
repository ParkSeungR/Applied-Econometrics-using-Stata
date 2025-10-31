// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ********************************************
* *** 한국의 케인지안 소비함수 추정과 자기상관 ***
* ********************************************
use III-3-1-AutocorrConFun, clear
tsset year

* 소비함수의 추정과 잔차항 검토
regress con gdp
predict error, r
generate lagerror=error[_n-1]
scatter error year, yline(0)
scatter error lagerror, yline(0) xline(0) 

* 다양한 자기상관의 탐지법
estat dwatson
estat durbinalt, small
estat durbinalt, small lags(1/2)
estat bgodfrey, small lags(1/2)

* 자기상관의 처치법
*Prais-Winsten AR(1) regression
prais con gdp

*Cochrane-Orcutt AR(1) regression
prais con gdp, corc

* robust standard errors
prais con gdp, corc vce(robust)

* Newey-West standard errors
newey con gdp, lag(3)
