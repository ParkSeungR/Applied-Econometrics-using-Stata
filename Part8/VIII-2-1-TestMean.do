// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ****************************
* *** 모집단 평균의 신뢰구간 ***
* ****************************
sysuse auto, clear

* 평균, 비율, 분산의 신뢰구간 계산
ci mean price
return list

ci prop foreign
ci var price

* 오차한계: mean command 활용사례
mean price rep78 mpg trunk turn displacement

* 평균의 검정
ttest mpg=20

* 평균의 차이검정
ttest mpg, by(foreign)

* 평균의 차이검증(두 집단의 표본수, 평균, 표준편차를 알때)
ttesti 80 104 8.4 70 106 7.6