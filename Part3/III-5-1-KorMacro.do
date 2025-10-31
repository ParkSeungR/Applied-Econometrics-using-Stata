// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

﻿* ****************************
* *** 한국의 간단한 거시모형 ***
* ****************************
import excel "D:\statapgm\Part3\III-5-1-KorMacro.xlsx", sheet("Sheet1") firstrow
drop date
gen date=tq(1992q1)+_n-1
format date %tq
tsset date 
save III-5-1-KorMacro, replace

* ===  연립방정식 모형의 단일방정식, 연립방정식 추정법 ===
use  III-5-1-KorMacro, clear

* ****** 모형의 OLS추정법 ********
regress con gdp l.con
regress inv d.gdp l.rat
regress rat gdp d.gdp d.m1 l.rat

* ****** 모형의 2SLS 추정법 ********
ivregress 2sls con l.con (gdp = l.con d.gdp l.rat d.m1), small
ivregress 2sls inv d.gdp l.rat
ivregress 2sls rat d.gdp d.m1 l.rat  (gdp = l.con d.gdp l.rat d.m1), small

* ****** 모형의 LIML 추정법 ********
ivregress liml con l.con (gdp = l.con d.gdp l.rat d.m1)
ivregress liml inv d.gdp l.rat
ivregress liml rat d.gdp d.m1 l.rat  (gdp = l.con d.gdp l.rat d.m1)

* ****** 모형의 GMM 추정법 ********
ivregress gmm con l.con (gdp = l.con d.gdp l.rat d.m1)
ivregress gmm inv d.gdp l.rat
ivregress gmm rat d.gdp d.m1 l.rat  (gdp = l.con d.gdp l.rat d.m1)


* ****** 연립방정식 추정법(3SLS) ******
* reg3를 이용하여 ols, 2sls, sur추정가능
reg3 (con gdp l.con) (inv d.gdp l.rat) (rat gdp d.gdp d.m1 l.rat),  ///
       endog(con inv rat gdp) exog(gov)
	   
* ****** 연립방정식 추정법(FIML) ******
* sem 또는 gsem에 추정방법  method=(ml)을 부여
gsem (con <- gdp l.con) (inv <- d.gdp l.rat) (rat <- gdp d.gdp d.m1 l.rat),  ///
         method(ml)	   

		 
* === 연립방정식 모형의 시뮬레이션 분석 ===
use  III-5-1-KorMacro, clear

* 모형의 추정
reg3 (con gdp l.con) (inv d.gdp l.rat) (rat gdp d.gdp d.m1 l.rat),  ///
       endog(con inv rat gdp) exog(gov)
	   
* 추정결과 보관
estimates store kormacroeqs

* 시뮬레이션 분석의 시작
forecast create kormacromodel, replace

* 추정모형, 항등식, 내생변수, 외생변수 지정
forecast estimates kormacroeqs
forecast identity gdp = con + inv + gov
forecast exogenous gov
forecast exogenous m1

* 연립방정식 모형의 내생변수의 정적 해를 구함
forecast solve, prefix(s_) begin(tq(1992q2)) static
*  - 실적치와 해의 도해
tsline con s_con
tsline inv s_inv
tsline rat s_rat
tsline gdp s_gdp
*  - 실적치와 해의 정확도
ssc install http://fmwww.bc.edu/RePEc/bocode/f/fcstats.pkg
fcstats con s_con
fcstats inv s_inv
fcstats rat s_rat
fcstats gdp s_gdp

* 연립방정식 모형의 내생변수의 동적 해를 구함
forecast solve, prefix(d_) begin(tq(1992q2)) 
*  - 실적치와 해의 도해
tsline con d_con, name(con, replace)
tsline inv d_inv, name(inv, replace)
tsline rat d_rat, name(rat, replace)
tsline gdp d_gdp, name(gdp, replace)
graph combine con inv rat gdp, col(2)
*  - 실적치와 해의 정확도
fcstats con d_con
fcstats inv d_inv
fcstats rat d_rat
fcstats gdp d_gdp

* **** 모형의 반복추정과 예측구간 설정 *******
set scheme s1color
set seed 12345
forecast solve, prefix(sm_) begin(tq(1992q2)) simulate(residuals, statistic(stddev, prefix(sd_)) reps(100))
generate sm_con_up = sm_con + invnormal(0.975)*sd_con
generate sm_con_dn = sm_con + invnormal(0.025)*sd_con
generate sm_inv_up = sm_inv + invnormal(0.975)*sd_inv
generate sm_inv_dn = sm_inv + invnormal(0.025)*sd_inv
generate sm_rat_up = sm_rat + invnormal(0.975)*sd_rat
generate sm_rat_dn = sm_rat + invnormal(0.025)*sd_rat
generate sm_gdp_up = sm_gdp + invnormal(0.975)*sd_gdp
generate sm_gdp_dn = sm_gdp + invnormal(0.025)*sd_gdp

tsline con sm_con sm_con_up sm_con_dn
tsline inv sm_inv sm_inv_up sm_inv_dn
tsline rat sm_rat sm_rat_up sm_rat_dn
tsline gdp sm_gdp sm_gdp_up sm_gdp_dn

* ***** 충격반응실험(정책효과분석) *******
* - 외생변수에 대한 충격(정부재정지출 10%증가)
forecast adjust gdp = gdp + gov*0.1 if date == tq(2010q1)
forecast solve, prefix(g_) begin(tq(2010q1))
tsline con g_con
tsline inv g_inv
tsline rat g_rat
tsline gdp g_gdp
* - 내생변수에 대한 충격(투자 10%증가)
forecast adjust inv = inv*1.1 if date == tq(2010q1)
forecast solve, prefix(i_) begin(tq(2010q1))
tsline con i_con
tsline inv i_inv
tsline rat i_rat
tsline gdp i_gdp

* ***** 모형의 예측 *******
tsappend, add(8)
replace gov=gov[_n-4]*(1+ln(gov[_n-4]/gov[_n-8])) if date > tq(2018q2)
replace m1=m1[_n-4]*(1+ln(m1[_n-4]/m1[_n-8])) if date > tq(2018q2)
forecast solve, prefix(f_) begin(tq(2018q3)) end(tq(2020q2))
tsline con f_con
tsline inv f_inv
tsline rat f_rat
tsline gdp f_gdp

forecast describe endogenous
forecast describe estimates, detail
forecast describe solve

forecast clear
