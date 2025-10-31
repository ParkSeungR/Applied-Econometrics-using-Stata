// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***********************************
* *** 한국에서 오쿤의 법칙 검정 사례 ***
* ***********************************
* 자료원: 한국은행 
﻿import excel "D:statapgm\Part2\Part2\II-1-3-KorOkunsLaw.xlsx", sheet("data") firstrow
save II-1-3-KorOkunsLaw, replace

use II-1-3-KorOkunsLaw, clear
tsset year, yearly

* 실업률 변화
generate grun=un-L.un

* 실업률변화와 GNP
scatter grun grgnp
regress grun grgnp

* 1998년 특이치 제거
drop if year==1998
scatter grun grgnp
regress grun grgnp

