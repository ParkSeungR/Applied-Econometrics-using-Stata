// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *********************************
* *** ARCH 모형의 일반적 분석절차  ***
* *********************************
import excel "D:\statapgm\Part4\IV-5-1-KospiARCH.xlsx", sheet("KOSPI") firstrow
save IV-5-1-KospiARCH, replace

set scheme s1mono
* ***************************************************
* ****** 1) 시계열자료의 군집성, 변동성 파악 ******
* ***************************************************
use  IV-5-1-KospiARCH, clear
gen time = _n
tsset time

* 수익률 시계열 및 히스토그램
gen r=(ln(kospi)-ln(L.kospi))*100
tsline kospi, xlabel(400 800 1200) 
tsline r, xlabel(400 800 1200) name(g1, replace)
histogram r, normal name(g2, replace)
graph combine g1 g2, cols(1) 

* ********************************************
* ****** 2) ARCH효과의 존재여부 검정 ******
* ********************************************
* Engle's Lagrange multiplier test
regress r
estat archlm, lags(1)
estat archlm, lags(1/9)

* *****************************************************
* ****** 3) ARCH 모형의 추정, 변동성 예측 그래프 ***
* *****************************************************
arch r, arch(1)
predict htarch1, variance
tsline htarch, xlabel(400 800 1200) name(g3, replace)

* *******************************************************
* ****** 4) GARCH 모형의 추정, 변동성 예측 그래프 ***
* *******************************************************
* GARCH(1,1)모형
arch r, arch(1) garch(1)
predict htgarch, variance
tsline htgarch, xlabel(400 800 1200) name(g4, replace)

* *********************************************************
* ****** 5) GARCH-M모형의 추정, 변동성 예측 그래프 ***
* *********************************************************
* GARCH in mean
arch r, archm arch(1) garch(1) tarch(1)
predict htmgarch, variance
tsline htmgarch, xlabel(400 800 1200) name(g5, replace)

* *******************************************************
* ****** 6) TGARCH 모형의 추정, 변동성 예측 그래프 ***
* *******************************************************
* Threshold GARCH(1,1)
arch r, arch(1) garch(1) tarch(1)
predict httgarch, variance
tsline httgarch, xlabel(400 800 1200) name(g6, replace)

* *******************************************************
* ****** 7) EGARCH 모형의 추정, 변동성 예측 그래프 ***
* *******************************************************
* Exponential EGARCH(1,1,1)
arch r, arch(1) garch(1) earch(1)
predict htegarch, variance
tsline htegarch, xlabel(400 800 1200) name(g7, replace)



