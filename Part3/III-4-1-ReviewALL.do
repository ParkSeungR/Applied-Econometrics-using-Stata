// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *******************************************
* *** 계량분석의 전과정 설명을 위한 템플리트 ***
* *******************************************
﻿import excel "D:\statapgm\Part3\III-4-1-ReviewALL.xlsx", sheet("data") firstrow 
save III-4-1-ReviewALL, replace

use III-4-1-ReviewALL, clear
tsset year

* 변수 로그변환, 보관
generate lconsum=ln(consumption)
generate lincome=ln(income)
generate lwealth=ln(wealth)
save reviewall, replace

* ********************
* *** 1) 자료검토  ***
* ********************
use reviewall, clear

* 단순기술통계량(데이터 검토)
summarize consumption income wealth interest

* 상관계수 행렬(다중공선성 개연성 및 자료특성 파악)
correlate consumption income wealth interest

* 그래프플 통한 자료의 오류, 특성, 상관관계, 정규성변환 가능성
graph matrix consumption income wealth interest
twoway (scatter consumption income)  (lfit consumption income) 
twoway (scatter consumption wealth)    (lfit  consumption wealth)  
twoway (scatter consumption interest)  (lfit consumption interest)
line consumption year
gladder consumption
gladder income
gladder wealth
gladder interest

* ***************************************
* *** 2)정규성 검정(Normalty Test) ****
* ***************************************
use reviewall, clear

* 고전적 최소자승법(OLS) 잔차항 계산
regress lconsum lincome lwealth interest
predict error, r

* 잔차 플롯
scatter error year, yline(0)

* 잔차의 막대그래프
histogram error, bin(10)

* 정규확률산포도(Normal probability plot)
pnorm error

* 자크- 베라 테스트(Jarque Bera test)
jb error


* *******************************************************
* *** 3) 모형설정오류 검정(Specification error test)  ***
* *******************************************************
use reviewall, clear
* 고전적 최소자승법 
regress lconsum lincome lwealth interest
* Ramsey의 RESET 테스트
estat ovtest
reset lconsum lincome lwealth interest


* ********************************************
*  *** 4) 다중공선성 문제의 탐지와 해결  ***
* ********************************************
use reviewall, clear
* 고전적 최소자승법
regress  lconsum lincome lwealth interest
* 분산팽창계수 계산 (VIF)
estat vif
* Farrar-Glauber Multicollinearity Tests
lmcol lconsum lincome lwealth interest, coll
	   
* 능형회귀(Ridge Regression)
ridgereg  lconsum lincome lwealth interest, model(grr1) mfx(lin)

* 주요인분석(Principal component analysis)과 회귀분석
pca lincome lwealth interest
predict p1-p3
regress  lconsum p1


* **************************************
* *** 5) 이분산 문제의 탐지와 해결 ***
* **************************************
use reviewall, clear
* 고전적 최소자승법
regress lconsum lincome lwealth interest
* 잔차계산
predict error, r
* 적합된 값(fitted value)
predict fitcon, xb
* 잔차의 제곱
generate error2=error^2
* 잔차자승합의 히스토그램
histogram error2, bin(10)
* 잔차자승과 적합된 값의 그래프
scatter error2 fitcon

* 브로슈-페이건 $ 화이트 테스트
quietly regress lconsum lincome lwealth interest
estat hettest
estat imtest, white

* White corrected(robust) standard error
regress lconsum lincome lwealth interest, vce(robust)


* ****************************************
* *** 6) 자기상관 문제의 탐지와 해결 ***
* ****************************************
use reviewall, clear
* 다양한 자기상관탐지 테스트
regress lconsum lincome lwealth interest
estat dwatson
estat durbinalt, small
estat durbinalt, small lags(1/2)
estat bgodfrey, small lags(1/2)
estat archlm, lags(1 2 3)

* 자기상관의 처치법
*Prais-Winsten AR(1) regression
prais lconsum lincome lwealth interest

*Cochrane-Orcutt AR(1) regression
prais lconsum lincome lwealth interest, corc

* Robust standard errors
prais lconsum lincome lwealth interest, corc vce(robust)

* Newey-West standard errors 
newey lconsum lincome lwealth interest, lag(2)

* ******************************
* *** 7) 추정결과의 리포트  ***
********************************
use reviewall, clear

* 원하는 모형의 추정과  파라미터 보관
quietly regress lconsum lincome lwealth interest
estimates store model1

quietly reg lconsum lincome lwealth interest, vce(robust)
estimates store model2

quietly prais lconsum lincome lwealth interest
estimates store model3

quietly prais lconsum lincome lwealth interest, corc
estimates store model4

quietly newey lconsum lincome lwealth interest, lag(3)
estimates store model5

* 보관한 추정결과의 정리 (Stata 명령어 활용)
* Result Window에서 Table형식으로 복사하여 엑셀로 복사
estimates table model1 model2 model3 model4 model5  ///
                     , stats(r2) b(%5.4f) star(0.10 0.05 0.01) 
					 
estimates table model1 model2 model3 model4 model5  ///
                     , stats(r2) b(%5.4f) se(%5.4f) t(%4.1f) 

* 보관한 추정결과의 정리 (사용자 작성 프로그램 esttab 활용)
* Result Window에서 Table형식으로 복사하여 엑셀로 복사
esttab model1 model2 model3 model4 model5   ///
        , star(* 0.10 ** 0.05 *** 0.01) r2 b(%5.4f) t(%4.1f) fixed
		
esttab model1 model2 model3 model4 model5   ///
        , star(* 0.10 ** 0.05 *** 0.01) r2 b(%5.4f) se(%5.4f) fixed

* 추정결과 MS Word 파일 생성(1)
* Current Working Directory에서 Word로 읽어들임
esttab model1 model2 model3 model4 model5 using review1       ///
       ,  replace star(* 0.10 ** 0.05 *** 0.01)  rtf r2 aic                   ///
	      mtitle( "Model 1" "Model 2" "Model 3" "Model 4" "Model 5") ///
		  label title("Table: Estimation Results")
		  
* 추정결과 MS Word 파일 생성(2)
reg2docx model1 model2 model3  model4 model5 using review2.docx  ///
            , replace scalars(r2(%9.3f) r2_a(%9.2f)) t(%7.2f)  ///
			  title(Table: Estimation Results)          ///
			  mtitles("model 1" "model 2" "model 3" "model 4" "model 5")	
