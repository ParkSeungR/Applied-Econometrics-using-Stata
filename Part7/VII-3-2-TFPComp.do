// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

********************************************************
* *** 1)초월대수 생산함수를 이용한 총요소생산성 계산 절차  ***
********************************************************
import excel "D:\statapgm\Part7\VII-3-2-TFPComp.xlsx", sheet("data") firstrow
save VII-3-2-TFPComp, replace

use VII-3-2-TFPComp, clear
xtset id year

* 각 변수의 평균으로 표준화
sort id 
foreach x in  y l k f m {
by id: egen m_`x'  = mean(`x')
by id: gen  nm_`x' = `x'/ m_`x'
                               }	

* 표준화된 변수의 로그 변환
gen ln_Y = ln(nm_y)
gen ln_L = ln(nm_l)
gen ln_K = ln(nm_k)
gen ln_F = ln(nm_f)
gen ln_M = ln(nm_m)
gen t = year

* 총비용과 비용 몫 계산
gen TC = pl*l + pk*k + pf*f + pm*m
gen sl = (pl*l)/TC
gen sk = (pk*k)/TC
gen sf = (pf*f)/TC
gen sm = (pm*m)/TC

drop nm_* m_*

* 초월대수 생산함수 추정에 필요한 변수 계산
gen ln_L2 = 0.5 * ln_L^2
gen ln_K2 = 0.5 * ln_K^2
gen ln_F2 = 0.5 * ln_F^2
gen ln_M2 = 0.5 * ln_M^2
gen t2 = 0.5 * t^2

gen ln_LK = ln_L * ln_K
gen ln_LF = ln_L * ln_F
gen ln_LM = ln_L * ln_M
gen ln_KF = ln_K * ln_F
gen ln_KM = ln_K * ln_M
gen ln_FM = ln_F * ln_M

gen ln_Lt = ln_L * t
gen ln_Kt = ln_K * t
gen ln_Mt = ln_M * t
gen ln_Ft = ln_F * t


* 변경생산함수 추정
global dependent  ln_L ln_K  ln_F  ln_M  ln_L2 ln_K2  ln_F2  ln_M2 ln_LK  ///
                  ln_LF ln_LM ln_KF ln_KM ln_FM t t2 ln_Lt ln_Kt ln_Mt ln_Ft

* OLS를 이용한 초기치 계산
regress  ln_Y $dependent
matrix b1 = e(b)

* 변경생산함수 추정
sfmodel ln_Y, prod dist(h) frontier($dependent) usigmas(t) vsigmas() 
sf_init, frontier(b1) usigmas(0 0) vsigmas(0)
ml max, difficult gtol(1e-5) nrtol(1e-5)

* 기술적 효율성 추정
sf_predict, bc(eff) jlms(jlms2_h) marginal

* 기술적 효율성 변화의 추정
gen TEFF= t_M

* 산출탄력성 계산
sort id
by id: gen eta_L =_b[ln_L]+_b[ln_L2]* ln_L +_b[ln_LK]* ln_K+_b[ln_LF]* ln_F+_b[ln_LM]* ln_M+_b[ln_Lt]* t
by id: gen eta_K =_b[ln_K]+_b[ln_K2]* ln_K +_b[ln_LK]* ln_L+_b[ln_KF]* ln_F+_b[ln_KM]* ln_M+_b[ln_Kt]* t
by id: gen eta_F =_b[ln_F]+_b[ln_F2]* ln_F +_b[ln_LF]* ln_L+_b[ln_KF]* ln_K+_b[ln_FM]* ln_M+_b[ln_Ft]* t
by id: gen eta_M =_b[ln_M]+_b[ln_M2]* ln_M +_b[ln_LM]* ln_L+_b[ln_KM]* ln_K+_b[ln_FM]* ln_F+_b[ln_Mt]* t

* 기술변화의 계산
by id: gen TECH =_b[t]+_b[t2]* t +_b[ln_Lt]* ln_L+_b[ln_Kt]* ln_K+_b[ln_Ft]* ln_F+_b[ln_Mt]* ln_M

* 각 요소의 산출탄력성을 합해서 규모의 경제 계산
gen RTS=eta_L+eta_K+eta_F+eta_M

* 규모의 경제에서 각 산출탄력성의 비중 계산
gen lamda_L=eta_L/RTS
gen lamda_K=eta_K/RTS
gen lamda_F=eta_F/RTS
gen lamda_M=eta_M/RTS

* 생산요소투입 증가율 계산
by id: gen gr_L=ln_L-ln_L[_n-1]
by id: gen gr_K=ln_K-ln_K[_n-1]
by id: gen gr_F=ln_F-ln_F[_n-1]
by id: gen gr_M=ln_M-ln_M[_n-1]

* 규모의 경제 변화지표 계산
gen SCALE=(RTS-1)*(lamda_L*gr_L+lamda_K*gr_K+lamda_F*gr_F+lamda_M*gr_M)

* 배분적 비효율성 계산
gen ALL=(lamda_L-sl)*gr_L+(lamda_K-sk)*gr_K+(lamda_F-sf)*gr_F+(lamda_M-sm)*gr_M

* 총요소생산성 계산
gen TFP=SCALE+TECH+ALL+TEFF

* 총요소생산성 구성요인의 기술 통계량
summarize TFP SCALE TECH ALL TEFF
by id: summarize TFP SCALE TECH ALL TEFF

******************************************************************
* *** 2) 초월대수 비용함수를 이용한 총요소생산성 계산 절차  ***
******************************************************************
use VII-3-2-TFPComp, clear
xtset id year

* 총비용 계산
gen TC=pl*l + pk*k + pf*f + pm*m

* 각변수를 자신의 평균에 대해 표준화
sort id
foreach x in TC y pl pk pf pm {
by id: egen m_`x' =mean(`x')
by id: gen  nm_`x'= `x'/ m_`x'
                                         }	

* 로그 변환
gen lcost=ln(nm_TC)
gen ly=ln(nm_y)
gen lpl=ln(nm_pl)
gen lpf=ln(nm_pf)
gen lpk=ln(nm_pk)
gen lpm=ln(nm_pm)
gen t=year

* 각 요소의 비용몫 계산
gen sl=(pl*l)/TC
gen sk=(pk*k)/TC
gen sf=(pf*f)/TC
gen sm=(pm*m)/TC

* 비용함수에 동차성 및 동조성 부여한후 추정
gen ltc=lcost-lpk
gen lwl=lpl-lpk
gen lwf=lpf-lpk
gen lwm=lpm-lpk

gen lwl2=0.5*lwl^2
gen lwf2=0.5*lwf^2
gen lwm2=0.5*lwm^2
gen ly2=0.5*ly^2
gen t2=0.5*t^2

gen lwlf=lwl*lwf
gen lwlm=lwl*lwm
gen lwfm=lwf*lwm

gen lwly=lwl*ly
gen lwfy=lwf*ly
gen lwmy=lwm*ly

gen lyt=ly*t
gen lwlt=lwl*t
gen lwft=lwf*t
gen lwmt=lwm*t

drop nm_* m_*

global depend lwl lwf lwm lwl2 lwf2 lwm2 lwlf lwlm lwfm ly ly2 lwly lwfy lwmy t t2 lwlt lwft lwmt lyt

*
regress ltc $depend
matrix coef = e(b)

* 변경비용함수의 추정
sfmodel ltc, cost dist(h) frontier($depend) usigmas(t) vsigmas() 
sf_init, frontier(coef) usigmas(0 0) vsigmas(0)
ml max, difficult 

* 총요소생산성 변화와 그 구성요인

* 기술적 효율성 및 변화
sf_predict, bc(eff) marginal
gen TEFF= -t_M

* 생산증가율 계산
sort id
by id: gen gr_y=ly-ly[_n-1]

*  생산의 비용탄력성 역수(규모의 경제,1/RTS) 
gen IRTS = _b[ly] + _b[ly2]*ly + _b[lwly]*lwl + _b[lwfy]*lwf + _b[lwmy]*lwm +_b[lyt]*t  

* 규모의 경제변화
gen SCALE = (1-IRTS)*gr_y 

* 기술변화
gen TECH = - _b[t] - _b[t2]*t - _b[lyt]*ly - _b[lwlt]*lwl - _b[lwft]*lwf - _b[lwmt]*lwm 

* 총요소생산성 변화(TFP)
gen TFP = SCALE + TECH + TEFF

* 총요소생산성 구성요인의 기술 통계량
summarize TFP SCALE TECH TEFF

* 이윤의 변화와 그 구성요인

* 생산요소가격 증가율 계산
sort id
by id: gen gr_pl=lpl-lpl[_n-1]
by id: gen gr_pk=lpk-lpk[_n-1]
by id: gen gr_pf=lpf-lpf[_n-1]
by id: gen gr_pm=lpm-lpm[_n-1]

* 가격 증가율
by id: gen gr_p=ln(p)-ln(p[_n-1])

* 전체 생산요소가격  증가율
by id: gen gr_w = sl*gr_pl + sk*gr_pk + sk*gr_pf + sm*gr_pm

* 총수입
generate revenue = p * y

* 총이윤
generate profit = revenue - TC

* 이윤증가율의 구성요인
*   1) 산출물 가격변화 효과
generate PRICE = revenue / TC * gr_p 
*   2) 산출물 증가 효과
generate OUTPUT = (revenue / TC - 1) * gr_y 
*   3) 투입물 가격 변화 효과
generate INPRICE = gr_w
*   4) 산출물 가격변화
generate PROFIT = PRICE + OUTPUT - INPRICE + TFP

summarize PROFIT PRICE OUTPUT INPRICE TFP SCALE TECH TEFF

* 각지표의 평균 그래프 그리기
sort year id
collapse (mean) TFP SCALE TECH TEFF  PROFIT PRICE OUTPUT INPRICE, by(year)
line  TFP SCALE TECH TEFF year
line  PROFIT PRICE OUTPUT INPRICE TFP year

