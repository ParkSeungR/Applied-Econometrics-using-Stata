// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* **************************************
* *** 환경파괴지수 계산(commoner 가설)  ****
* **************************************
clear
import excel "D:\statapgm\Part7\VII-1-5-IndexEnviron.xlsx", sheet("CO2") firstrow
save co2, replace

clear
import excel "D:\statapgm\Part7\VII-1-5-IndexEnviron.xlsx", sheet("GDP") firstrow
save gdp, replace

clear
import excel "D:\statapgm\Part7\VII-1-5-IndexEnviron.xlsx", sheet("POP") firstrow
save pop, replace

clear
import excel "D:\statapgm\Part7\VII-1-5-IndexEnviron.xlsx", sheet("group") firstrow
save group, replace

merge 1:1 countrycode using co2, nogenerate
merge 1:1 countrycode using gdp, nogenerate
merge 1:1 countrycode using pop, nogenerate
save VII-1-5-IndexEnviron, replace

use VII-1-5-IndexEnviron, clear

* 1970-2012년간 환경파괴지수 및 구성요인의 증가율 계산
forvalues i = 1970(1)2012 {
  generate pergdp_`i'=gdp_`i'/pop_`i'
  generate intensity_`i'=co2_`i'/gdp_`i'
                                     }
drop  if pergdp_1970==.  | pergdp_2012==.
drop  if intensity_1970==. | intensity_2012==.
keep countryname countrycode region Incomegroup ///
        pop_1970 pop_2012 pergdp_1970 pergdp_2012    ///
		intensity_1970 intensity_2012
		
* 증가율 계산(1970-2012년간)
* 인구증가율
generate gr_pop=ln(pop_2012/pop_1970)/42*100
* 일인당 gdp증가율
generate gr_pergdp=ln(pergdp_2012/pergdp_1970)/42*100
* 집약도 증가율
generate gr_intensity=ln(intensity_2012/intensity_1970)/42*100
* 환경파괴지수 증가율
generate environ=gr_pop+gr_pergdp+gr_intensity

* 환경파괴지수 증가율=인구증가율+일인당 소득증가율+집약도 증가율
* 저소득국가 인구증가율, 개도국 일인당 소득증가율, 선진국 집약도 감소율
twoway (scatter environ pergdp_2012) (lfit environ pergdp_2012)
twoway (scatter gr_pop pergdp_2012) (lfit gr_pop pergdp_2012)
twoway (scatter gr_pergdp pergdp_2012) (qfit gr_pergdp pergdp_2012)
twoway (scatter gr_intensity pergdp_2012) (lfit gr_intensity pergdp_2012)

* 엑셀파일로 저장		   
export excel countryname countrycode region Incomegrou environ gr_* ///
           using environment, firstrow(variable) sheet(environ)
