// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* **************************
* *** Stata 그래프 템플리트 ***
* **************************
import excel "G:\statpgm\Part1\I-4-1-GraphTEM.xlsx", sheet("data") firstrow clear
save I-4-1-GraphTEM, replace

use I-4-1-GraphTEM, clear

#delimit ;
twoway line Korea yea
       || line USA year
       || line Japan year
       || line China year
       ||,
           title("한미일중 일인당 GDP추이")
           subtitle("1953-2017년")
           ytitle("일인당 GDP(ppp)")
           ylabel(10000(20000)60000)
		   xtitle("연도")
		   xlabel(1950(20)2020)
           note( "자료: Penn World Table v. 9.1")
           legend( label(1 "한국") label(2 "미국")  label(3 "일본")  label(4 "중국") )
;
#delimit cr
