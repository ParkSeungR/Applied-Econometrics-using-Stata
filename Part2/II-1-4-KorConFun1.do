// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***************************************
* *** 한국의 케인지안 소비함수 추정 사례 ***
* ***************************************
* 민간소비(실질), 가처분소득(실질)
* 자료: 한국은행
import excel "G:\1. Stata 저술 본문\STATA PGM\Part2\II-1-4-KorConFun1.xlsx", sheet("data") firstrow
save II-1-4-KorConFun, replace

use II-1-4-KorConFun, clear
tsset year, yearly

* 민간소비와 가처분소득 산포도 및  요약통계
scatter con gdp
summarize con  gdp

* 변수 로그 변환
generate lcon=ln(con)
generate lgdp=ln(gdp)

* 시간변수 생성
generate t=year-1969

* 케인지안 소비함수의 추정
* 선형함수 
twoway (scatter con gdp) (lfit con gdp)
regress con gdp

*  로그-로그(log-log function)함수
twoway (scatter lcon lgdp) (lfit lcon lgdp)
regress lcon lgdp

* 로그-선형함수(log-linear function)
twoway (scatter lgdp t) (lfit lgdp t)
regress  lgdp t

* 선형함수의 탄력성  계산
quietly regress con gdp
generate elast=_b[gdp]*gdp/con
list year elast



