// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *******************************
* *** 시계열자료의 안정성의 이해 ***
* *******************************
clear

* 관측치 500개 시계열 생성
set seed 1234
set obs 500
generate t=_n
tsset t

* 상수항 없는 안정적 시계열
generate u1=rnormal()
generate y1=u1              in 1
replace   y1=0.7*L.y1+u1 in 2/L
tsline y1, name(y1, replace)

* 상수항 있는 안정적 시계열
generate u2=rnormal()
generate y2=u2                 in 1
replace   y2=1+0.7*L.y2+u2 in 2/L
tsline y2, name(y2, replace)

* 상수항, 추세 있는 안정적 시계열
generate u3=rnormal()
generate y3=u3                         in 1
replace   y3=1+0.1*t+0.7*L.y3+u3 in 2/L
tsline y3, name(y3, replace)

* 상수항 없는 임의보행 시계열
generate u4=rnormal()
generate y4=u4           in 1
replace   y4=L.y4+u4 in 2/L
tsline y4, name(y4, replace)

* 상수항 있는 임의보행 시계열
generate u5=rnormal()
generate y5=u5                 in 1
replace   y5=0.2+L.y5+u5 in 2/L
tsline y5, name(y5, replace)

* 상수항, 추세 있는 임의보행 시계열
generate u6=rnormal()
generate y6=u6                            in 1
replace   y6=0.5+0.1*t+L.y6+u6 in 2/L
tsline y6, name(y6, replace)

graph combine y1 y2 y3 y4 y5 y6, cols(2)
