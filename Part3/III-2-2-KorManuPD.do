// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ******************************************
* *** 한국 제조업의 생산함수 추정과 이분산  ***
* ******************************************
import excel "D:\statapgm\Part3\III-2-2-KorManuPD.xlsx", sheet("data") firstrow
save III-2-2-KorManuPD, replace

use III-2-2-KorManuPD, clear

* 변수 로그 변환
generate ly=ln(y)
generate ll=ln(l)
generate lk=ln(k)
generate lm=ln(m)

* 단순기술통계량 계산
summarize ly ll lk lm 

* 상관계수 행렬
correlate  ly ll lk lm 

* 변수의 분포와 변환 필요성
gladder y  
gladder l 
gladder k 
gladder m

*  이분산(Heteroscedasticity)문제의 탐지와 해결
* 고전적 최소자승법과 오차항 분포
regress ly ll lk lm
rvfplot 

* 오차항과 적합치 계산
predict error, r
predict fity, xb

* 잔차의 자승합
generate error2=error^2

* 잔차자승합의 히스토그램
histogram error2, bin(10)

* 잔차자승합과 회귀추정치의 그래프
scatter error2 fity

* 브로슈-페이건 검정(Breusch-Pagan test for heteroskedasticity)
regress ly ll lk lm
estat hettest

* 화이트의 강건한 표준오차(White corrected(robust) standard error)
regress ly ll lk lm, vce(robust)

