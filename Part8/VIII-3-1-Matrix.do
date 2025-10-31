// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***************************************
* *** 제약모형과 비제약모형의 차이 검정  ***
* ***************************************
sysuse auto, clear
* 제약조건이 없는 모형
regress price mpg rep78 headroom foreign
scalar rssu = e(rss)
scalar dfu = e(df_r)

* 제약조건이 있는 모형(foreign 제외)
regress price mpg rep78 headroom
scalar rssr = e(rss)
scalar dfr = e(df_r)
scalar J = dfr - dfu

* F-통계량과  p-값
scalar F = ((rssr -rssu)/J) / (rssu/dfu)
scalar pval = Ftail(J, dfu, F)

scalar list rssu dfu rssr dfr J F pval

* *******************************************
* *** 회귀분석결과로 부터 AIC BIC 통계량 계산  ***
* *******************************************
regress price mpg rep78 headroom foreign
scalar aicu = ln(e(rss) / e(N)) + 2*e(rank) /e(N) 
scalar bicu = ln(e(rss) / e(N)) + e(rank)*ln(e(N)) / e(N)

regress price mpg rep78 headroom 
scalar aicr = ln(e(rss) / e(N)) + 2*e(rank) /e(N) 
scalar bicr = ln(e(rss) / e(N)) + e(rank)*ln(e(N)) / e(N)
scalar list aicu bicu aicr aicu 

* *********************************************
* *** Stata 행렬명령어를 이용한 최소자승법 사례  ***
* *********************************************

sysuse auto, clear
* 행렬 y, X 만들기
generate con=1
mkmat price, matrix(y)
mkmat con mpg headroom foreign, matrix(X)
mkmat con, matrix(C)
* 계수추정 (b=inv(X'X)X'y)
matrix b=invsym(X'*X)*X'*y
matrix list b
* 자유도
scalar N= rowsof(y)
scalar K= colsof(X)
scalar DF = N-K
scalar list N K DF
* TSS, ESS, RSS 및 R-square 계산
matrix TSS = y'*y-(C'*y)*(C'*y) / N
matrix ESS = b'*X'*y-(C'*y)*(C'*y) / N
matrix RSS = y'*y-b'*X'*y
matrix  R2 = ESS * inv(TSS) 
matrix list R2
* 파라미터의 분산계산
matrix VCOV = (RSS/DF)*invsym(X'*X)
matrix VAR = vecdiag(VCOV)
matrix  VAR = VAR'
matrix list VAR
* 행렬을 변수로 변환
svmat R2, names(Rsquare)
svmat b, names(coef)
svmat VAR, names(var)
*파라미터의 표준오차, t-값, p-value계산
generate se=sqrt(var)
generate t=coef/se
generate pval=2*ttail(DF,abs(t))
list coef se t pval Rsquare if _n<=4
* 행렬을 이용한 OLS와 regress 결과비교
regress  price mpg  headroom foreign

* ************************************
* *** MATA 를 이용한 최소자승법 사례  ***
* ************************************
sysuse auto, clear
generate con=1
keep price con mpg  headroom foreign
summarize price con mpg  headroom foreign
* regress를 이용한 회귀분석
regress  price mpg  headroom foreig

* MATA 행렬언어를 이용한 회귀분석
mata 
* 행렬정의
 st_view(y=., ., "price")
 st_view(X=., ., ("con", "mpg", " headroom", "foreign"))
 *파리미터 추정
 beta = luinv(X'X)*X'y
 *  TSS, RSS, ESS 및 R-square 계산
 tss = y'y-rows(y)*mean(y)^2
 ess = beta'X'y-rows(y)*mean(y)^2
 rss = y'y-beta'X'y
 r2 = ess/tss
 * 추정계수의 표준오차 계산
 varcov = (rss/(rows(y)-cols(X)))*luinv(X'X)
 variance = diagonal(diag(varcov))
 se = sqrt(variance)
 * 추정결과를 하나의 행렬로 만듬
 result = (beta, se, beta:/se, 2*ttail(rows(y)-cols(X), abs(beta:/se)))
 *   Stata로 행렬을 이전
 st_matrix("result",result)
end

clear
* MATA에서 보낸 행렬을 변수로 바꾸어 출력
svmat result
rename (result1-result4) (coef se t_value p_value) 
list coef se t_value p_value





