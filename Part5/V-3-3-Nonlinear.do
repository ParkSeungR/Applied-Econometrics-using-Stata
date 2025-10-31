// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***********************************
* *** 패널분석을 위한 비선형 추정법  ***
* ***********************************
use V-3-2-IVEstimation, clear

* 패널자료의 단순기술통계량
xtsum lwage wks south smsa ms exp occ ind union fem blk ed

* ==== 로짓모형 ====
* 통합로짓모형(Pooled logit model)
logit union south smsa exp occ ind
estimates store po

* 고정효과모형(fe)
xtlogit union south smsa exp occ ind, fe
estimates store fe

* 확률효과모형(re)
xtlogit union south smsa exp occ ind, re
estimates store re

* 모집단 평균모형(pa)
xtlogit union south smsa exp occ ind, pa
estimates store pa

* 하우스만 검정
hausman fe re

* 한계효과의 계산
xtlogit union south smsa exp occ ind, fe
margins, dydx(occ) over(t)
marginsplot

* ==== 토빗모형 ====
* 통합로짓모형(Pooled logit model)
tobit union south smsa exp occ ind
estimates store po

* 확률효과모형(re)
xttobit union south smsa exp occ ind, re
estimates store re

* 한계효과의 계산
xttobit union south smsa exp occ ind, re
margins, dydx(occ) over(t)
marginsplot


