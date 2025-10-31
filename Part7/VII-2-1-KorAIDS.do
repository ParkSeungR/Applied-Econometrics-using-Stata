// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

﻿* *************************************************************
* ***   한국의 목적별 소비지출 자료를 이용한 AIDS모형의 추정사례  ***
* *************************************************************
import excel "D:\statpgm\Part7\VII-2-1-KorAIDS.xlsx", sheet("data2") firstrow
save VII-2-1-KorAIDS, replace

* ****** LA-AIDS모형 ********
use VII-2-1-KorAIDS, clear

forvalues i=1(1)5 {
    generate lp`i'=ln(p`i') 
                      }
					  
quaids w1-w5, anot(10) lnprices(lp1-lp5) expenditure(expen) noquadratic
predict what*
estat expenditure mu*
estat compensated ce*
estat uncompensated ue*

estat expenditure, atmeans stderrs
matrix list r(expelas)
matrix list r(sd)
estat uncompensated, atmeans stderrs
matrix list r(uncompelas)
matrix list r(sd)
estat compensated, atmeans stderrs
matrix list r(compelas)
matrix list r(sd)

* ****** QUAIDS모형 ********
use VII-2-1-KorAIDS, clear
forvalues i=1(1)5 {
    generate lp`i'=ln(p`i') 
                      }
					  
quaids w1-w5, anot(10) lnprices(lp1-lp5) expenditure(expen)
predict what*
estat expenditure mu*
estat compensated ce*
estat uncompensated ue*

estat expenditure, atmeans stderrs
matrix list r(expelas)
matrix list r(sd)
estat uncompensated, atmeans stderrs
matrix list r(uncompelas)
matrix list r(sd)
estat compensated, atmeans stderrs
matrix list r(compelas)
matrix list r(sd)

