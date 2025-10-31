// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *******************************************
* *** 고전적 최소자승 추정량의 몬테칼로 실험 ***
* *******************************************

* 추정치의 초기값 부여
scalar sumb1=0
scalar sumb2=0

* 반복실험 횟수 지정
forvalues i = 1(1)10000 {

* 관측치수 지정
quietly set obs 50

*  독립변수 x값의 발생
generate x=runiform(100, 1000)

* 오차항 생성
generate u`i'=rnormal(0, 400)
generate u=u`i'

* 종속변수 y값의 계산
generate y=40+0.6*x+u

* 회귀분석
quietly regress y x

* 추정결과 파라미터 추정치 보관
scalar b1=_b[_cons]
scalar b2=_b[x]

* 반복하면서 파라미터 추정치의 누적합  
scalar sumb1=sumb1+b1
scalar sumb2=sumb2+b2

drop y x u*
                              }

* 반복실험후 파라미터의 평균계산
scalar  meanb1=sumb1/10000
scalar  meanb2=sumb2/10000
scalar list meanb1 meanb2 

