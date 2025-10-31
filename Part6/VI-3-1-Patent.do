// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

﻿* ***********************************
* *** 포아송, 음이항분포 모형 추정법  ***
* ***********************************
import excel "D:\statpgm\Part6\VI-3-1-Patent.xlsx", sheet("patent") firstrow
save VI-3-1-Patent, replace

* ===== 자료정리(패널자료의 작성) =====
use VI-3-1-Patent, clear
reshape long patent lrnd lspill, i(firm industry area) j(year)
xtset firm year 

* 산업더미변수
generate  inddum=0
replace    inddum=1 if industry==1  //우주항공
replace    inddum=2 if industry==2  //화학
replace    inddum=3 if industry==3  //컴퓨터
replace    inddum=4 if industry==4  //기계
replace    inddum=5 if industry==5  //자동차

* 지역더미변수
generate  areadum=0
replace    areadum=1 if area==2  //일본
replace    areadum=2 if area==3  //미국

* ====== 1990년 자료만 이용한 분석 =====
keep if year==90
summ patent lrnd lspill inddum areadum

* 특허출원건수의 분포
histogram patent, bin(40) freq

* 고전적 최소자승법
regress patent  lrnd i.inddum i.areadum

* 포아송 회귀모형
poisson patent  lrnd i.inddum i.areadum

* 음이항회귀모형
nbreg patent  lrnd i.inddum i.areadum


* ===== 가산자료의 패널 분석 =====
* 단순기술통계량
xtsum firm industry area patent lrnd lspill

* 통합최소자승법(Pooled OLS)
regress patent lrnd lspill i.inddum i.areadum 
regress patent lrnd lspill i.inddum i.areadum, vce(robust)
regress patent lrnd lspill i.inddum i.areadum, vce(cluster firm)

* 패널포아송 회귀모형
xtpoisson patent lrnd lspill i.inddum i.areadum 

* 패널음이항회귀모형
xtnbreg patent lrnd lspill i.inddum i.areadum 




