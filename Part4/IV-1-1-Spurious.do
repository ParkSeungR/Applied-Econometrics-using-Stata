// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***********************************
* *** 시계열 자료의 추세와 가성회귀  ***
* ***********************************
clear

* 10000개 가상적 시계열자료 생성
set seed 1234
set obs 10000
generate t = _n

tsset t

generate ey = rnormal()
generate ex = rnormal()

* 시차변수의 계수값이 1로 불안정시계열 생성
generate y = 0 in 1
replace y =L.y + ey in 2/L
tsline y

generate x = 0 in 1
replace x =L.x + ex in 2/L
tsline x

* 회귀분석
regress y x
regress y x t
regress D.y D.x
