// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***************************************
* *** 다중공선성 문제의 탐지와 해결방법   ***
* ***************************************
* Longley Dataset 
import excel "D:\statapgm\Part3\III-1-1-MultiLongley.xlsx", sheet("data") firstrow
save III-1-1-MultiLongley, replace

use III-1-1-MultiLongley, clear

* 자료의 단순기술통계량
summarize y x1 x2  x3  x4 x5
correlate  y x1 x2  x3  x4 x5 t

* 변수간 상관관계 도표
graph matrix y x1 x2  x3  x4 x5

* 회귀분석
reg y x1 x2  x3  x4 x5 t

* 다중공선성의 존재 검정 : VIF계산
estat vif

* Farrar-Glauber Multicollinearity Tests
ssc install http://fmwww.bc.edu/RePEc/bocode/f/fgtest.pkg
fgtest y x1 x2 x3 x4 x5 t

* Theil R2 Multicollinearity Effect
ssc install http://fmwww.bc.edu/RePEc/bocode/t/theilr2.pkg
theilr2 y x1 x2 x3 x4 x5 t

* 능형회귀(ridge regression)
ridgereg y x1 x2 x3 x4 x5, model(orr) lmcol



* 고유값과 conditional number
corr y x1 x2 x3 x4 x5 t, cov
matrix A=r(C) 
mat list A
matrix symeigen X lambda = A
mat list lambda
mat list X
matrix AX = A*X
mat list AX
matrix Xlambda = X*diag(lambda)
mat list Xlambda

* VIF의 직접계산
reg x1 x2  x3  x4 x5 t 
scalar vif1=1/(1-e(r2))
reg x2   x1  x3  x4 x5 t 
scalar vif2=1/(1-e(r2))
reg x3   x1  x2  x4 x5 t 
scalar vif3=1/(1-e(r2))
reg x4   x1  x2  x3 x5 t 
scalar vif4=1/(1-e(r2))
reg x5   x1  x2  x3 x4 t 
scalar vif5=1/(1-e(r2))
scalar list vif1 vif2 vif3 vif4 vif5
