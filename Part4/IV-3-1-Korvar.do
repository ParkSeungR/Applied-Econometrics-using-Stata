// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

﻿* ******************************************
* *** 한국의 VAR모형: GDP, CON, INV 3개변수  ***
* ******************************************
import excel "D:\statapgm\Part4\IV-3-1-Korvar.xlsx", sheet("korvar") firstrow
save IV-3-1-Korvar, replace

set scheme s1mono
* ***********************************
* ******** 1) 그래프 그리기   *******
* ***********************************
use IV-3-1-Korvar, clear
* 기간변수 생성, 시간식별
gen date=tq(1960q1)+_n-1
tsset date, format(%tq)  

* 변수의 전년동기대비 증가율 계산
generate grgdp=ln(gdp)-ln(L4.gdp)
generate grcon=ln(con)-ln(L4.con)
generate grinv=ln(inv)-ln(L4.inv)
generate grgov=ln(gov)-ln(L4.gov)

* 단순기술통계량
summ gdp con inv grgdp grcon grinv  
corr gdp con inv grgdp grcon grinv  

* 원계열
graph matrix gdp con inv
tsline gdp, name(gdp, replace) 
tsline con, name(con, replace) 
tsline inv,  name(inv, replace) 
graph combine gdp con inv, cols(1)

* 증가율 계열
graph matrix grgdp grcon grinv
tsline grgdp, name(grgdp, replace) 
tsline grcon, name(grcon, replace) 
tsline grinv, name(grinv, replace) 
graph combine grgdp grcon grinv, cols(1)

* ***********************************
* ******** 2) 단위근 검정   *********
* ***********************************
use IV-3-1-Korvar, clear
* 증가율 자료 이용 
* lag(p)옵션없으면 DF 검정
dfuller grgdp, noconstant
dfuller grgdp, drift
dfuller grgdp, trend

dfuller grcon, noconstant
dfuller grcon, drift
dfuller grcon, trend

dfuller grinv, noconstant
dfuller grinv, drift
dfuller grinv, trend

* lag(p)옵션있으면 ADF 검정
dfuller grgdp, noconstant lag(4)
dfuller grgdp, drift  lag(4)
dfuller grgdp, trend  lag(4)

dfuller grcon, noconstant  lag(4)
dfuller grcon, drift  lag(4)
dfuller grcon, trend  lag(4)

dfuller grinv, noconstant  lag(4)
dfuller grinv, drift  lag(4)
dfuller grinv, trend  lag(4)

* ***********************************
* ******** 3) 예비추정  *************
* ***********************************
use IV-3-1-Korvar, clear

varbasic grgdp grcon grinv, lag(1/5) 
varbasic grgdp grcon grinv, lag(1/5) irf step(20) 
varbasic grgdp grcon grinv, lag(1/5) fevd step(20)

* *******************************************
* ******** 4) 시차(lag order) 선정  *********
* *******************************************
varsoc grgdp grcon grinv, maxlag(10) 

* ***************************************************
* ******** 5) 추정결과의 진단(Diagnostics) ********
* ***************************************************
* 잔차의 자기상관 여부 검정
varlmar, mlag(9)
* 잔차의 정규성 여부 검정
varnorm, jbera
* Granger의  인과성 검정
vargranger
* VAR의 안정성 검정
varstable, graph
* 사후적 시차의 유의성 검정
varwle

* ***************************************************
* ******** 6) 변수의 오더링(ordering) 결정  ********
* ***************************************************
* 변수의 오더링(ordering) 결정 
xcorr grgdp grcon 
xcorr grcon grinv 
xcorr grgdp grinv 
vargranger

* ***************************************************
* ******** 7) 변수의 오더링(ordering) 결정  ********
* ***************************************************
* IRF, FEVD 계산
var grgdp grcon grinv, lags(1/3)
irf create try1, set(korvarirf) step(20)
* 생성된 irf, fevd 데이터 확인
describe using korvarirf.irf

* 생성된 irf 출력
irf table oirf
irf table oirf, noci impulse(grgdp)
irf table oirf, noci impulse(grcon)
irf table oirf, noci impulse(grinv)

* 생성된 irf 그래프 
irf graph oirf, yline(0)

* 생성된 cirf 출력(누적효과)
irf table coirf
irf table coirf, noci impulse(grgdp)
irf table coirf, noci impulse(grcon)
irf table coirf, noci impulse(grinv)

* 생성된 cirf 그래프 
irf graph coirf, yline(0)

* 생성된 fevd 출력
irf table fevd
irf table fevd, noci  impulse(grgdp)
irf table fevd, noci  impulse(grcon)
irf table fevd, noci  impulse(grinv)

* 생성된 fevd 그래프 
irf graph fevd, yline(0)

* ********************************************************
* **** 8) 촐레스키 분해(Cholesky decomposition)  *****
* ********************************************************
* 변수의 순서: grgdp grcon grinv
quietly var grgdp grcon grinv, lags(1/3)
matrix Sigma = e(Sigma)
matrix list Sigma
matrix C = corr(Sigma)
matrix list C
matrix Schol = cholesky(Sigma)
matrix list Schol

* 변수의 순서: grinv grcon grgdp 
quietly var grinv grcon grgdp, lags(1/3)
matrix Sigma = e(Sigma)
matrix list Sigma
matrix C = corr(Sigma)
matrix list C
matrix Schol = cholesky(Sigma)
matrix list Schol

* ***************************************
* ******** 9) 예측(forecasting)  ********
* ***************************************
* 사후예측
var grgdp grcon grinv, lags(1/3)
predict p_grgdp, equation(grgdp)
predict p_grcon, equation(grcon)
predict p_grinv, equation(grinv)
tsline p_grgdp grgdp
tsline p_grcon grcon 
tsline p_grinv   grinv  

* 사전예측
tsappend, add(12)
fcast compute f_, step(12)
fcast graph f_grgdp f_grinv f_grcon
list qtr grgdp f_grgdp grcon f_grcon grinv f_grinv

* 동적예측(구간내 예측)
var grgdp grcon grinv if tin( , 2015q3), lags(1/3) 
fcast compute d_, step(12)
fcast graph d_grgdp d_grinv d_grcon, ci observed
list qtr grgdp d_grgdp grcon d_grcon grinv d_grinv

* 동적예측(구간외 예측)
var grgdp grcon grinv, lags(1/3)
fcast compute D_, step(12) dynamic(tq(2018q2))
fcast graph D_grgdp D_grcon D_grinv, observed
list time grgdp D_grgdp grcon D_grcon grinv D_grinv


* ********************************
* ******** 10) VARX모형  ********
* ********************************
use IV-3-1-Korvar, clear

var grgdp grcon grinv, lags(1/3) exog(grgov)

irf create try2, set(korvarxirf, replace) step(20)
describe using korvarxirf.irf

irf table oirf
irf table oirf, noci impulse(grgdp)
irf table oirf, noci impulse(grcon)
irf table oirf, noci impulse(grinv)
irf table dm, noci impulse(grgov)

irf graph oirf, yline(0)
irf graph dm,  impulse(grgov)


* *******************************************************
* ******** 11) 공적분 검정(Cointegration Test)  ********
* *******************************************************
use IV-3-1-Korvar, clear

* Engle-Granger Cointegration Test
* 사용자 프로그램 설치
ssc install http://fmwww.bc.edu/RePEc/bocode/e/egranger.pkg
* EG 테스트
egranger consum gdp, lags(2)
egranger consum gdp, lags(2) regress
egranger consum gdp, lags(2) regress trend

* ECM모형 추정
egranger consum gdp, ecm lags(4) regress


* ************************************************
* ******** 12) 벡터오차수정모형(VECM)  ********
* ************************************************
use IV-3-1-Korvar, clear

* 공적분 검정(Co-integration test)
vecrank consum gdp invest, lags(4)
vec consum gdp invest, lags(4)
veclmar
vecnorm
vecstable
irf create tryvec, step(20) set(vecresult, replace)

describe using vecresult.irf
irf graph oirf, yline(0)
irf graph fevd, yline(0)
irf table oirf
irf table fevd 


* **********************************************
* ******** 13) 구조적 VAR모형(SVAR)  ********
* **********************************************
use IV-3-1-Korvar, clear

matrix A1 = (1,0,0 \ .,1,0 \ .,.,1)
matrix B1 = (.,0,0 \ 0,.,0 \ 0,0,.)
svar grgdp grcon grinv, lags(1/3) aeq(A1) beq(B1)
matlist e(A)
matlist e(B)
irf create order1, set(var1.irf) replace step(20)
irf graph sirf, xlabel(0(4)20) irf(order1) yline(0,lcolor(black))  byopts(yrescale)

matrix A2 = (1,.,. \ 0,1,. \ 0,0,1)
matrix B2 = (.,0,0 \ 0,.,0 \ 0,0,.)
svar grgdp grcon grinv, lags(1/6) aeq(A2) beq(B2)
matlist e(A)
matlist e(B)
irf create order2, set(var2.irf) replace step(20)
irf graph sirf, xlabel(0(4)20) irf(order2) yline(0,lcolor(black)) byopts(yrescale)

