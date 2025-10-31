// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *********************************************
* *** ARIMA모형의 차수결정을 위한 몬테칼로 실험 ***
* *********************************************

* ARMA 시계열 생성을 위한 사용자 프로그램 sim_arma 설치
ssc install http://www.stata.com/users/jpitblado/sim_arma.pkg

*  다양한 차수의 ARMA 시계열 생성후 ac, pac함수 확인
* ====== MA(q)와  ac, pac함수의 형태 =======
*  MA(1)에서는 ac함수의 1기만 유의미
clear
set seed 1234
sim_arma y, ma(0.7) sigma(1) nobs(1000)
ac y, name(ma1ac, replace)
pac y, name(ma1pac, replace)
graph combine ma1ac ma1pac, cols(1)

*MA(3)에서는 ac함수의 3기까지 유의미
clear
set seed 1234
sim_arma y, ma(0.6, 0.2, 0.1) sigma(1) nobs(1000)
ac y, name(ma3ac, replace)
pac y, name(ma3pac, replace)
graph combine ma3ac ma3pac, cols(1)

* ====== AR(p)와  ac, pac함수의 형태 =======
*AR(1)에서 계수값이 클때 ac함수는 서서히 감소, pac는 1기만 유의미
clear
set seed 1234
sim_arma y, ar(0.95) sigma(1) spin(5000) time(t) nobs(1000)
ac y, name(ar1ac, replace)
pac y, name(ar1pac, replace)
graph combine ar1ac ar1pac, cols(1)

*AR(1)에서 계수값이 작을 때 ac함수는 급히 감소, pac는 1기만 유의미
clear
set seed 1234
sim_arma y, ar(0.6) sigma(1) spin(5000) time(t) nobs(1000)
ac y, name(ar1ac, replace)
pac y, name(ar1pac, replace)
graph combine ar1ac ar1pac, cols(1)

* AR(1)에서 계수값이 마이너스(-)값을 가질 때
* ac함수는  +, -를 반복하며 감소, pac는 1기만 유의미
clear
set seed 1234
sim_arma y, ar(-0.75) sigma(1) spin(5000) time(t) nobs(1000)
ac y, name(ar1ac, replace)
pac y, name(ar1pac, replace)
graph combine ar1ac ar1pac, cols(1)

*AR(3)에서는 ac함수는 서서히 감소, pac는 3기까지 유의미
clear
set seed 1234
sim_arma y, ar(0.7 0.4 -0.3) spin(5000) nobs(1000)
ac y, name(ar3ac, replace)
pac y, name(ar3pac, replace)
graph combine ar3ac ar3pac, cols(1)

* ====== ARMA(p, q)와  ac, pac함수의 형태 =======
*ARMA(1,1)에서는 계수값이 작으면 ac, pac 함수는 급히  감소
clear
set seed 1
sim_arma y, ar(0.5) ma(0.5) spin(2000) nobs(1000)
ac y, name(arma11ac, replace)
pac y, name(arma11pac, replace)
graph combine arma11ac arma11pac, cols(1)

*ARMA(1,1)에서 계수값이 크면 ac, pac 함수는  서서히  감소
clear
set seed 1
sim_arma y, ar(0.95) ma(0.95) spin(2000) nobs(1000)
ac y, name(arma11ac, replace)
pac y, name(arma11pac, replace)
graph combine arma11ac arma11pac, cols(1)
