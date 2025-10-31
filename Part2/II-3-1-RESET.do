// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***************************
* *** 모형설정오류 검정  ***
* ***************************
import excel "statapgm\Part2\II-3-1-RESET.xlsx", sheet("data") firstrow
save II-3-1-RESET, replace

use II-3-1-RESET, clear

* 단순기술 통계량
summarize risk age pressure weight smoker

* 회귀분석
regress risk age pressure smoker

* Ramsey의 회귀설정오류검정법(RESET)
estat  ovtest

* 좀더 자세한 RESET
ssc install http://fmwww.bc.edu/RePEc/bocode/r/reset.pkg
reset risk age pressure smoker

