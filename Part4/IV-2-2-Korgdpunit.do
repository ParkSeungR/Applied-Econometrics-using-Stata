// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ********************************************
* *** 한국의 GDP, 소비 시계열의 안정성과 ARIMA ***
* ********************************************
import excel "D:\statapgm\Part4\IV-2-2-Korgdpunit.xlsx", sheet("unit") firstrow
save IV-2-2-Korgdpunit, replace 

use  IV-2-2-Korgdpunit, clear
* 날짜변수 생성
gen year=tq(1960q1)+_n-1
tsset year, format(%tq)
* 변수 로그변환
gen lgdp=ln(gdp)
gen lcon=ln(con)

* ======= 그림 그리기(흑백) =====
set scheme s1mono
qui tsline lgdp, name(gdp, replace)
qui tsline D4.lgdp, name(dgdp, replace)
qui tsline lcon, name(con, replace)
qui tsline D4.lcon, name(dcon, replace)
graph combine gdp dgdp con dcon, cols(2)

* ======= 단위근 검정 =====
* lags()옵션이이 부여되면 ADF검정
* 원계열 단위근 검정
dfuller lgdp, noconstant lags(3) regress
dfuller lgdp, drift lags(3) regress
dfuller lgdp, trend lags(3) regress

* 차분된 계열 단위근 검정
dfuller D.lgdp, noconstant  lags(3) regress
dfuller D.lgdp, drift  lags(3) regress
dfuller D.lgdp, trend  lags(3) regress

* 필립-페론 단위근 검정(Phillips–Perron unit-root test)
pperron lgdp, lags(4)
pperron D.lgdp, lags(4)

* Dickey–Fuller generalized least squares unit-root test
dfgls lgdp
dfgls D.lgdp

* =======  ARIMA 모형 =====
* 식별(상관도, 자기상관 함수, 편상관 함수)
* 원계열
corrgram lgdp, lag(40)
ac lgdp, lag(40) name(aclgdp, replace)
pac lgdp, lag(40) name(paclgdp, replace)
graph combine aclgdp paclgdp, cols(1)

* 차분계열
corrgram D.lgdp, lag(40)
ac D.lgdp, lag(40)  name(acdlgdp, replace)
pac D.lgdp, lag(40) name(pacdlgdp, replace)
graph combine acdlgdp pacdlgdp, cols(1)

* 개연성있는 모형 여러개를 추정후 비교평가
arima lgdp, arima(1, 1, 3)
* 모형적합도(AIC, BIC) 평가
estat ic

* 사후예측(expost forecasting)
predict fity, y
tsline lgdp fity 

* 예측구간설정
predict mser, mse
gen upper=fity+1.96*sqrt(mser)
gen lower=fity-1.96*sqrt(mser)
tsrline lower upper || tsline fity

* 사전예측(ex ante forecasting, 4분기 추가)
tsappend, add(4)
predict flgdp, y dynamic(q(2016q4))
tsline lgdp fity flgdp

* =======  Seasonal ARIMA 모형 =====




* =======  ARIMAX 모형 =====
arima lgdp lcon, arima(1, 1, 3) sarima(1, 1, 1, 4)





























