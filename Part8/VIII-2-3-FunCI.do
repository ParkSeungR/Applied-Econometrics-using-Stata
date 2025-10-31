// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ************************
* *** 확률함수 이용 사례 ***
* ************************
sysuse auto
quietly summarize price, detail
return list

scalar xbar=r(mean)
scalar nobs=r(N)
scalar df=nobs-1
scalar t=invttail(df, 0.025)
scalar sighat=r(sd)
scalar se=sighat/sqrt(nobs)

scalar lower=xbar-t*se
scalar upper=xbar+t*se

display "lower bound of 95% CI = " lower
display "upper bound of 95% CI  = " upper

* ci명령어 
ci mean price
