// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *************************************
* *** 한국의 통신비 소비함수 추정 사례  ***
* *************************************
* 자료원: 통계청
* 통신비 지출 함수 추정
import excel "D:statapgm\Part2\II-1-1-DemandFunction.xlsx", sheet("data") firstrow
save II-1-1-DemandFunction, replace

use II-1-1-DemandFunction, clear
tsset year, yearly

scatter con p
scatter con gdp
line con gdp year
line p pc pe year

* 단순기술통계량
summarize con p  pc pe gdp
corr con p  pc pe gdp

* 통신비 지출과 가격의 함수
regress con p

* 통신비 지출과 가격 및 소득의 함수
regress con p  gdp
regress con p  gdp, beta

* 통신비 지출과 가격, 보완재, 경쟁재의 가격의 함수
regress con p pc pe gdp
regress con p pc pe gdp, beta

