// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

﻿* **************************
* *** 서열 로짓모형 추정법  ***
* **************************
import excel "D:\statpgm\Part6\VI-1-4-Warm.xlsx", sheet("warm") firstrow
save VI-1-4-Warm, replace

use VI-1-4-Warm, clear
* 단순기술통계량
desc _all
summ _all

* 서열로짓모형의 추정
ologit warm yr89 male white age ed prst	
ologit warm yr89 male white age ed prst, or

*예측치 계산
predict SD D A SA
summarize SD D A SA

* 한계효과 계산
margins, dydx(*) 

* 카테고리별 기울기 동일여부 검정 
ssc install http://fmwww.bc.edu/RePEc/bocode/o/omodel.pkg
omodel logit warm yr89 male white age ed prst	
