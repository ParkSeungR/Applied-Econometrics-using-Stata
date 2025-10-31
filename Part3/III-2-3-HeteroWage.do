// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ******************************************
* *** 임금함수 추정과 이분산 검정 및 처치법  ***
* ******************************************
import excel "D:\statapgm\Part3\III-2-3-HeteroWage.xlsx", sheet("data") firstrow
save III-2-3-HeteroWage, replace

use III-2-3-HeteroWage, clear
set scheme mys1mono

* 단순기술통계량
summarize wage educ exper sex marstat region union 

* 상관계수
correlate wage educ exper sex marstat region union 

* 도표 그리기 및 변수변환의 필요성
graph matrix wage educ exper sex marstat region union 
gladder wage

* 회귀분석과 이분산의 존재 확인
generate lwage=ln(wage)
regress lwage educ exper sex marstat region union 
predict fitlwage, xb
predict error, r
generate error2=error^2
line error2 id

* 이분산 존재 확인 테스트: Breuch Pagan test & White's test
* Breuch Pagan test
regress lwage educ exper sex marstat region union 
estat hettest
* White's test
estat imtest, white

* 이분산 처치법
* 임금변수의 로그변환을 통해 이분산 정도 감소 확인
regress wage educ exper sex marstat region union
estat hettest
estat imtest, white

* 이분산 문제 처치를 위한 White corrected(robust) standard error
regress wage educ exper sex marstat region union, vce(robust)
regress lwage educ exper sex marstat region union, vce(robust)
