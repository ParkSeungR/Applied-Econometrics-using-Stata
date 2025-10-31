// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* **********************************************
* *** 패널분석을 위한 IV 추정법, 동적모형 추정법  ***
* **********************************************
import excel "D:\statapgm\Part5\V-3-2-IVEstimation.xlsx", sheet("wage") firstrow
save V-3-2-IVEstimation, replace

* 패널자료의 단순기술통계량
use V-3-2-IVEstimation, clear
xtset id t
xtsum lwage wks south smsa ms exp occ ind union fem blk ed

* ==== 도구변수(IV) 추정법 ====
* 2단최소자승법(2SLS)를 위한 xtivreg
xtivreg lwage south smsa exp occ ind union  (wks = ms), fe first
xtivreg lwage south smsa exp occ ind union  (wks = ms), fe 
xtivreg lwage south smsa exp occ ind union  (wks = ms), fe vce(bootstrap)

* 하우스만-테일러(Hausman-Taylor) 추정법
* Hausman-Taylor estimates
xthtaylor lwage wks south smsa ms exp occ ind union fem blk ed, ///
             endog(exp occ ind union ed) constant(fem blk ed)

* Amemiya-MaCurdy estimates
xthtaylor lwage wks south smsa ms exp occ ind union fem blk ed, ///
             endog(exp occ ind union ed) constant(fem blk ed) amacurdy

* ==== 시차종속변수가 독립변수로 사용된 모형 ====
* 아렐라노-본드 추정법(Arellano-Bond Estimator) 
xtabond lwage wks south smsa ms exp occ ind union, lag(2) twostep artests(3)
* 자기상관 검정
estat abond
* 과대식별 제약  검정
estat sargan
