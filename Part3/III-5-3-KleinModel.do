// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

﻿* ********************************
* *** 미국의 거시모형 (Kleim Model) ***
* ********************************
import excel "D:\statapgm\Part3\III-5-3-KleinModel.xlsx", sheet("klein") firstrow
generate w=wp+wg
generate yr=year-1931
tsset year
save III-5-3-KleinModel, replace 

* ******** 모형의 추정(3SLS) **********
use III-5-3-KleinModel, clear
reg3 (c p L.p w) (i p L.p L.k) (wp y L.y yr), endog(w p y) exog(t wg g)
estimates store kleineqs

* 시뮬레이션 분석의 시작
forecast create kleinmodel, replace

* 추정모형, 항등식, 내생변수, 외생변수 지정
forecast estimates kleineqs
forecast identity y = c + i + g
forecast identity p = y - t - wp
forecast identity k = L.k + i
forecast identity w = wg + wp
forecast exogenous wg
forecast exogenous g
forecast exogenous t
forecast exogenous yr

* 연립방정식 모형의 내생변수의 정적 해를 구함
forecast solve, prefix(s_) begin(1921) end(1941) static
*  - 실적치와 해의 도해
tsline c s_c
tsline i s_i
tsline wp s_wp
tsline y s_y
tsline p s_p
tsline k s_k
tsline w s_w
*  - 실적치와 해의 정확도
ssc install http://fmwww.bc.edu/RePEc/bocode/f/fcstats.pkg
fcstats  c s_c
fcstats  i s_i
fcstats  wp s_wp
fcstats  y s_y
fcstats  p s_p
fcstats  k s_k
fcstats  w s_w

* 연립방정식 모형의 내생변수의 동적 해를 구함
forecast solve, prefix(d_) begin(1921) end(1941)
*  - 실적치와 해의 도해
tsline c d_c, name(gc, replace)
tsline i d_i, name(gi, replace)
tsline wp d_wp, name(gwp, replace)
tsline y d_y, name(gy, replace)
tsline p d_p, name(gp, replace)
tsline k d_k, name(gk, replace)
tsline w d_w, name(gw, replace)
graph combine gc gi gwp gy gp gw, col(2)
*  - 실적치와 해의 정확도
fcstats c d_c
fcstats i d_i
fcstats wp d_wp
fcstats y d_y
fcstats p d_p
fcstats k d_k
fcstats w d_w

* **** 모형의 반복추정과 예측구간 설정 *******
set scheme s1color
set seed 12345
forecast solve, prefix(sm_) begin(1931) end(1941) simulate(betas, statistic(stddev, prefix(sd_)) reps(100))
gen sm_c_up = sm_c + invnormal(0.975)*sd_c
gen sm_c_dn = sm_c + invnormal(0.025)*sd_c
gen sm_i_up = sm_i + invnormal(0.975)*sd_i
gen sm_i_dn = sm_i + invnormal(0.025)*sd_i
gen sm_wp_up = sm_wp + invnormal(0.975)*sd_wp
gen sm_wp_dn = sm_wp + invnormal(0.025)*sd_wp
gen sm_y_up = sm_y + invnormal(0.975)*sd_y
gen sm_y_dn = sm_y + invnormal(0.025)*sd_y
gen sm_p_up = sm_p + invnormal(0.975)*sd_p
gen sm_p_dn = sm_p + invnormal(0.025)*sd_p
gen sm_k_up = sm_k + invnormal(0.975)*sd_k
gen sm_k_dn = sm_k + invnormal(0.025)*sd_k
gen sm_w_up = sm_w + invnormal(0.975)*sd_w
gen sm_w_dn = sm_w + invnormal(0.025)*sd_w

tsline c   d_c   sm_c   sm_c_dn sm_c_up 
tsline i    d_i    sm_i    sm_i_dn   sm_i_up 
tsline wp d_wp sm_wp sm_wp    sm_wp_up
tsline y   d_y   sm_y   sm_y_dn sm_y_up
tsline p   d_p   sm_p  sm_p_dn sm_p_up
tsline k   d_k   sm_k   sm_k_dn sm_k_up
tsline w   d_w   sm_w  sm_w_dn sm_w_up

* ***** 충격반응실험(정책효과분석) *******
* - 외생변수에 대한 충격(정부재정지출 10%증가)
forecast adjust y = y + g*0.1 if year==1931
forecast solve, prefix(g_) begin(1931) end(1941)
tsline c   g_c  
tsline i    g_i    
tsline wp g_wp
tsline y   g_y   
tsline p   g_p  
tsline k   g_k   
tsline w   g_w  

* - 내생변수에 대한 충격(투자 10%증가)
forecast adjust i = i*1.1 if year == 1931
forecast solve, prefix(i_) begin(1931) end(1941)
tsline c   i_c  
tsline i    i_i    
tsline wp i_wp
tsline y   i_y   
tsline p   i_p  
tsline k   i_k   
tsline w   i_w  

* ***** 모형의 예측 *******
* 외생변수 wg g t의 값을 1946년까지 1941년과 동일
forecast solve, prefix(f_) begin(1931) end(1946)
tsline c   f_c  
tsline i    f_i    
tsline wp f_wp
tsline y   f_y   
tsline p   f_p  
tsline k   f_k   
tsline w   f_w  

forecast describe endogenous
forecast describe estimates, detail
forecast describe solve

forecast clear
