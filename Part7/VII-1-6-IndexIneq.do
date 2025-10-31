// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *******************************************
* *** 불평등(Inequality), 양극화(Polarization) 사례  ***
* *******************************************
* DASP설치 필요(http://dasp.ecn.ulaval.ca/index.html)

import excel "D:\statapgm\Part7\VII-1-6-IndexIneq.xls", sheet("data") firstrow
save VII-1-6-IndexIneq, replace 

use VII-1-6-IndexIneq, clear

* 매출액의 불균등 지수
* 불균등(inequality)
igini s2010-s2014

* 엔트로피 지수(entropy index)
ientropy s2010-s2014, theta(1)

* 로렌츠 곡선(Lorentz curve)
clorenz s2010-s2014, legend(off)

* 매출액의 양극화 지수 (polarization index)
* Duclos, Esteban and Ray (2004) (DER) polarization index
ipolder s2010-s2014, alpha(0.5) fast(0)
* Foster and Wolfson (1992) polarization index
ipolfw s2010-s2014 

 * 로렌즈 곡선 & Gini 계수
 ssc install http://www.stata-journal.com/software/sj16-4/st0457.pkg

 * 보다 전문적으로 소득분배, 불평등, 양극화 등을 연구할 때 매우 편리

