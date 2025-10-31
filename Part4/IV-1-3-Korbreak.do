// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***************************************
* *** 한국의 금리, 인플레이션과 구조변화 ***
* ***************************************
import excel "D:\statapgm\Part4\IV-1-3-Korbreak.xlsx", sheet("break") firstrow
save IV-1-3-Korbreak, replace

use IV-1-3-Korbreak, clear
drop qtr
gen qtr =tq(1976q1)+_n-1

tsset qtr, format(%tq)
order qtr interest inflation grgdp

* HP filter
tsfilter hp grgdphp = grgdp, smooth(1600) trend(tgrgdp)
tsline grgdp grgdphp tgrgdp 
gen gap= grgdp-tgrgdp
twoway (line grgdp tgrgdp qtr) (bar gap qtr)
twoway rarea grgdp tgrgdp qtr

* 그래프(구조변화 관찰)
tsline interest inflation grgdp

* 구조변화 여부의 테스트
regress  interest  L.interest inflation

* 구조변화의 시점을 알고 있을 때
estat sbknown, break(tq(1979q3))
estat sbknown, break(tq(1998q1))
estat sbknown, break(tq(2008q4))

* 구조변화의 시점을 모를 때
estat sbsingle

* 파라미터 추정치의 안정성을 통한 구조변화 검정
estat sbcusum

* 문턱효과 분석

* 자신의 시차변수
threshold interest, regionvars(L.interest) threshvar(L.interest)
threshold interest, regionvars(L.interest  inflation grgdp) threshvar(L.interest)

* GDP의 시차변수
threshold interest, regionvars(L.interest inflation grgdp) threshvar(L.grgdp)
threshold interest, regionvars(L.interest inflation grgdp) threshvar(L.grgdp) optthresh(2)

* output gap의 시차변수
threshold interest, regionvars(L.interest inflation grgdp) threshvar(L.gap)
threshold interest, regionvars(L.interest inflation grgdp) threshvar(L.gap) optthresh(2)









