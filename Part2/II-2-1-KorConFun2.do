// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *****************************************************
* *** 한국의 케인지안 소비함수 추정과 잔차의 정규성 검정 ***
* *****************************************************
use II-1-4-KorConFun, clear
tsset year, yearly

* 민간소비와 가처분소득 산포도
scatter con gdp

* 케인지안 소비함수 추정
regress con gdp

* 추정결과로부터 잔차계산
predict error, r

* **********************************
* *** 정규성 검정(Normalty Test) ****
* **********************************
* 잔차 플롯
scatter error year, yline(0)

* 잔차의 히스토그램
histogram error, bin(10)

*정규확률산포도(Normal probability plot)
pnorm error

* 기타 그래프를 이용한 정규성 테스트방법
kdensity error
qnorm error
symplot error 

*  자크 베라 테스트(Jarque Bera test)
ssc install http://fmwww.bc.edu/RePEc/bocode/j/jb.pkg
jb error

* Shapiro–Wilk test 
swilk error

* Shapiro–Francia test 
sfrancia error

* skewness and kurtosis test 
sktest error

*  예측오차
twoway lfitci con gdp, stdf || scatter con gdp

