// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ****************************************
* *** 초월대수 비용함수 단일방정식 추정법 ***
* ****************************************
import excel "D:\statpgm\Part7\VII-3-1-COST.xlsx", sheet("data") firstrow
save VII-3-1-COST, replace

use VII-3-1-COST, clear
xtset  fmercode year

desc 
summarize 

gen t = yeardum
gen c=areap*area + laborp*labor + npkp*npk 
sort fmercode year

* 각변수를 자신의 평균에 대해 표준화
local rice "c prod area labor npk other price areap laborp npkp otherp age edyrs hhsize nadult banrat"
foreach x of local rice {
by  fmercode: egen m`x' =mean(`x')
by  fmercode: gen  i`x'= `x'/ m`x'
                                 }							   
drop m*

* 비용함수 추정관련 자료작성
gen tc=areap*area + laborp*labor + npkp*npk 
gen s1=(areap*area)/tc
gen s2=(laborp*labor)/tc
gen s3=(npkp*npk)/tc

gen lq=ln(iprod)
gen ltc=ln(ic)
gen lw1=ln(iareap)
gen lw2=ln(ilaborp)
gen lw3=ln(inpkp)

gen lw11 = 0.5*lw1*lw1
gen lw12 = lw1*lw2
gen lw13 = lw1*lw3

gen lw22 = 0.5*lw2*lw2
gen lw23 = lw2*lw3
gen lw33 = 0.5*lw3*lw3

gen lqw1 = lw1*lq
gen lqw2 = lw2*lq
gen lqw3 = lw3*lq
gen lqq = lq*lq

gen lw1t = lw1*t
gen lw2t = lw2*t
gen lw3t = lw3*t
gen lqt = lq*t
gen t2 = t^2

drop i*
sort fmercode year 

drop yeardum prod area labor npk other price areap laborp npkp otherp
order fmercode year fmercode year lq tc s* lw* lqt lqw* lqq t t2

* 제약조건 부여하지 않은 형태의 추정
reg  ltc lw1 lw2 lw3 lw11 lw12 lw13 lw22 lw23 lw33 lq lqq lqw1 lqw2 lqw3

* 제약조건 부여하고 필요한 변수 생성	
gen ltclm=ltc-lw3
gen lw1lw3=lw1-lw3
gen lw2lw3=lw2-lw3
gen lw1lw32=0.5*(lw1-lw3)^2
gen lw2lw32=0.5*(lw2-lw3)^2
gen lw1lw2lw3=(lw1-lw3)*(lw2-lw3)	
gen lw1lw3q= lw1lw3*lq
gen lw2lw3q= lw2lw3*lq

* 제약조건 부여한 형태의 추정	
reg  ltclm lw1lw3 lw2lw3 lw1lw32 lw2lw32 lw1lw2lw3  lw1lw3q lw2lw3q lq lqq
		
* **************************************************
* *** 초월대수 비용함수의 연립방정식 추정법 ****
* **************************************************
constraint  1 [ltc]lw1+[ltc]lw2+[ltc]lw3=1 
constraint  2 [ltc]lw11+[ltc]lw12+[ltc]lw13=0
constraint  3 [ltc]lw12+[ltc]lw22+[ltc]lw23=0
constraint  4 [ltc]lw13+[ltc]lw23+[ltc]lw33=0
constraint  5 [ltc]lqw1+[ltc]lqw2+[ltc]lqw3=0
constraint  6 [ltc]lw1  =[s1]_cons
constraint  7 [ltc]lw11=[s1]lw1
constraint  8 [ltc]lw12=[s1]lw2
constraint  9 [ltc]lw13=[s1]lw3
constraint 10 [ltc]lqw1=[s1]lq
constraint 11 [s1]lw2=[s2]lw1

* 원래의 비용함수와 비용몫(요소수요)함수를 이용하여 연립추정
sureg (ltc lw1 lw2 lw3 lw11 lw12 lw13 lw22 lw23 lw33 lq lqq lqw1 lqw2 lqw3) ///
         (s1 lw1 lw2 lw3 lq)                                                                    ///
         (s2 lw1 lw2 lw3 lq)                                                                    ///
        , constraints(1 2 3 5 6 7 8 9 10 11)			

*  비용몫(요소수요)함수만을 이용한 연립추정
sureg (s1 lw1 lw2 lw3 lq)  ///
         (s2 lw1 lw2 lw3 lq)  ///		
        , constraints(16)
	    