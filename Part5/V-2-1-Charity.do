// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***********************************
* *** 자선기부의 결정요인 분석 사례  ***
* ***********************************
import excel "D:\statapgm\Part5\V-2-1-Charity.xlsx", sheet("data") firstrow
save V-2-1-Charity, replace

use V-2-1-Charity, clear
xtset id time

* 패널자료의 단순기술통계량
xtsum id time charity income price age ms deps

* 종속변수 charity의 개체별 시계열 그림
xtline charity, overlay legend(off)

* 통합회귀분석(Pooled OLS), 군집강건 표준오차
regress charity income price age ms deps
regress charity income price age ms deps, vce(cluster id)

* 고정효과모형과 확률효과모형의 추정 및 하우스만 검정
xtreg charity income price age ms deps, fe 
estimates store fix

xtreg charity income price age ms deps, re 
estimates store ran

hausman fix ran, sigmamore
