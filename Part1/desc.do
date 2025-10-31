* **********************
* *** 기술통계학 기초 ***
* **********************
sysuse auto
describe 
list 

* table command 활용사례 
* mean 대신 다음 옵션을 사용하면 다양한 척도 계산 가능  
* 옵션의 종류: freq sd sum count min max p50 iqr 
table rep78
table rep78, contents(n mpg)
table rep78, c(n mpg mean mpg sd mpg median mpg)
table rep78, c(n mpg mean mpg sd mpg median mpg) format(%9.2f)
table rep78 foreign
table rep78 foreign, c(mean mpg)
table rep78 foreign, c(mean mpg) format(%9.2f) center
table foreign rep78, c(mean mpg) format(%9.2f) center
table foreign rep78, c(mean mpg) format(%9.2f) center row col

* tabulate command 활용사례 
tabulate rep78
tabulate foreign
tabulate rep78 foreign
tabulate rep78 foreign, row
tabulate foreign rep78, row
tabulate foreign rep78, row col
tabulate foreign rep78, row col cell

* 줄기-잎그림 그리기
stem mpg
stem price
stem price, lines(1) digits(3)

* 수치 기술통계의 계산
summarize price 
summarize price mpg rep78 headroom trunk weight

summarize price, detail
return list, all

* 공분산, 상관계수의 계산 
correlate price mpg rep78 headroom trunk, covariance
correlate price mpg rep78 headroom trunk

* 스페이만의 순위상관계수의 계산
spearman mpg rep78
spearman mpg rep78, matrix
spearman mpg price rep78, pw star(.05)

* 켄달의 순위상관계수의 계산
ktau mpg price rep78, stats(taua taub score se p) bonferroni

* bar 그래프 그리기
* mean median p1 p2 ... p99 sum count min max
graph bar (count) rep78 foreign
graph bar (count) rep78 foreign, percentage
graph bar (mean) trunk
graph bar (mean) mpg trunk turn displacement
graph bar (mean) mpg trunk turn displacement, over(foreign)

graph hbar (count) rep78 foreign
graph hbar (count) rep78 foreign, percentage
graph hbar (mean) trunk
graph hbar (mean) mpg trunk turn displacement
graph hbar (mean) mpg trunk turn displacement, over(foreign)

* 파이차트 그리기
* rep78의 숫자별로 mpg의 합이나 구성비를 파이차트로 그림
graph pie mpg, over(rep78)
graph pie mpg, over(rep78) plabel(_all sum)
graph pie mpg, over(rep78) plabel(_all percent)

* 같은 측정단위를 가진 변수들의 합이나 구성비를 파이차트로 그림
graph pie length headroom
graph pie length headroom, plabel(_all sum)
graph pie length headroom, plabel(_all percent)

* 히스토그램 그리기
histogram mpg                                  //면적의 합이 1
histogram mpg, fraction               //높이의 합이 1
histogram mpg, percent               //높이의 합이 100
histogram mpg, frequency          //높이의 합이 관측치 수

histogram mpg, frequency bin(5)         //막대의 수가 5개
histogram mpg, frequency discrete     //전체 카테고리 이용

histogram mpg, frequency horizontal    //수평 그래프
histogram mpg, frequency by(foreign)  //카테고리별로 별도 그래프

twoway (histogram mpg) (kdensity mpg)  //두 그래프를 겹쳐서 그림

* 산포도 그리기
scatter mpg weight
scatter mpg weight, by(foreign)
twoway (scatter mpg weight) (lfit mpg weight)
twoway (scatter mpg weight) (qfit mpg weight)
twoway (scatter mpg weight) (lfit mpg weight) (qfit mpg weight)
twoway (scatter mpg weight) (lfit mpg weight) (qfit mpg weight), by(foreign)
* 오자이브 그리기
cumul mpg, gen(cmpg)
sort cmpg
line cmpg mpg 
* 상자그림 그리기
graph box mpg
graph hbox mpg
graph box mpg trunk turn
graph hbox mpg trunk turn
* z-값 계산
egen zmpg=std(mpg)
summarize zmpg


