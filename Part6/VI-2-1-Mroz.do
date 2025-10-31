// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

﻿* ******************************
* *** 제한종속변수모형 추정법  ***
* ******************************
import excel "D:\statpgm\Part6\VI-2-1-Mroz.xlsx", sheet("mroz") firstrow
save VI-2-1-Mroz, replace

use VI-2-1-Mroz, clear

* 단순기술통계량 및 그래프
summ inlf hours kidslt6 kidsge6 age educ wage repwage hushrs   ///
          husage huseduc huswage faminc mtr motheduc fatheduc ///
		  unem city exper nwifeinc lwage expersq 
keep inlf hours age educ exper expersq faminc kidslt6 huswage lwage
table inlf 
correlate hours age educ exper expersq faminc kidslt6 huswage 
graph matrix hours age educ exper expersq faminc kidslt6 huswage 

* ***** 고전적 최소자승법(OLS) ******
* 전체 표본 대상(1-753)
regress  hours age educ exper expersq faminc kidslt6 huswage 
twoway (scatter hours faminc) (lfit hours faminc), name(g1)

* 근로참여자 표본(1-428)
regress hours age educ exper expersq faminc kidslt6 huswage in 1/428
twoway (scatter hours faminc  in 1/428) (lfit hours faminc  in 1/428), name(g2)

* 표본에 따른 회귀선의 기울기 비교 그림
graph combine g1 g2

* *********** 토빗 모형  **************
* 모형추정(0이하 절단, 표준 & 강건표준오차)
tobit hours age educ exper expersq faminc kidslt6 huswage, ll(0)
tobit hours age educ exper expersq faminc kidslt6 huswage, ll(0) vce(robust)

* ********* 절단된 회귀모형 **********
truncreg hours age educ exper expersq faminc kidslt6 huswage, ll(0)

* ****** 헥크만의 표본선택 모형 *******
heckman  lwage age educ exper, select(age educ exper) 
heckman  lwage age educ exper, select(age educ exper) vce(robust)
heckman  lwage age educ exper, select(age educ exper) twostep




