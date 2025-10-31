// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***************************************************
* *** 한국의 총요소생산성 추계 (Tonqvist TFP Index 방법) ***
* ***************************************************
import excel "D:\statapgm\Part7\VII-1-2-KorTFP.xlsx", sheet("kortfp") firstrow
save VII-1-2-KorTFP, replace

use VII-1-2-KorTFP, clear

* 성장률 계산
gen gr_y=ln(y)-ln(y[_n-1])
gen gr_l=ln(l)-ln(l[_n-1])
gen gr_k=ln(k)-ln(k[_n-1])

* 노동과 자본의 기여도
gen con_l=(sl+sl[_n-1])/2 * gr_l 
gen con_k=(sk+sk[_n-1])/2 * gr_k 

* 총요소생산성 증가율 계산
gen tfp=gr_y-con_l-con_k

* 총요소생산성 지수계산(1969=1)
gen tfpindex=1 if year==1969
replace tfpindex=tfpindex[_n-1]*(1+tfp) if year>=1970

format con* tfp* %10.4f
list year y l k sl sk con_l con_k tfp tfpindex, sep(0)

* 연도별 기여도
list year gr_y con_l con_k tfp

* 연도별 기여율
gen deg_y=gr_y/gr_y*100
gen deg_l=con_l/gr_y*100
gen deg_k=con_k/gr_y*100
gen deg_tfp=tfp/gr_y*100

format deg* %10.2f
list year deg_y deg_l deg_k deg_tfp

* 총요소생산성 지수와 증가율의 그래프
twoway (line tfpindex year) (bar tfp year)
