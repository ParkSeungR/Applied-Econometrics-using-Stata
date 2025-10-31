// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* **************************************
* *** 구조변화의 탐지 및 문턱효과 회귀   ***
* **************************************
webuse usmacro

* 구조변화의 검정
tsline  fedfunds inflation
regress fedfunds L.fedfunds inflation
estat sbknown, break(tq(1980q1))
estat sbsingle
estat sbcusum

* 문턱효과 분석
threshold inflation, regionvars(L.inflation) threshvar(L.inflation)
threshold fedfunds, regionvars(L.fedfunds inflation ogap) threshvar(L.ogap)
threshold fedfunds, regionvars(L.fedfunds inflation ogap) threshvar(L.ogap) optthresh(3)