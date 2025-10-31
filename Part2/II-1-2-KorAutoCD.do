// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *******************************************
* *** 한국의 자동차 산업의 생산함수 추정 사례 ***
* *******************************************
* 한국의 자동차 산업 부가가치, 노동투입, 자본스톡
import excel "D:statapgm\Part2\Part2\II-1-2-KorAutoCD.xlsx", sheet("data") firstrow
save II-1-2-KorAutoCD, replace

use II-1-2-KorAutoCD, clear

* 로그 변환
generate ly=ln(y)
generate ll=ln(l)
generate lk=ln(k)
generate lyl=ly-ll
generate lkl=lk-ll

*  NCRTS가정하 추정
regress ly ll lk
*  CRTS여부 검정
test _b[ll]+_b[lk]=1

*  NCRTS가정하 추정
regress lyl lkl
