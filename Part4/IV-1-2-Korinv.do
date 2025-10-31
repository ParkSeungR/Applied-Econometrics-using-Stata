// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***********************************
* *** 한국의 투자 시리즈와 이동평균  ***
* ***********************************
import excel "D:\statapgm\Part4\IV-1-2-Korinv.xlsx", sheet("inv") firstrow
save IV-1-2-Korinv, replace

use IV-1-2-Korinv, clear
* 날짜변수 정의
drop qtr
gen qtr=tq(1960q1)+_n-1
tsset qtr, quarterly

* 원시계열 그래프와 추세, 경기, 계절, 오차요인
tsline inv

* 단순 후방이동평균(trailing moving average)
tssmooth ma sm4inv = inv, window(3 1)
tsline inv sm4inv if tin(1978q1, ), legend(off)

* 단순 대칭 이동평균(symmetric moving average)
tssmooth ma sm4cinv = inv, window(2 1 2)
tsline inv sm4cinv if tin(1978q1, ), legend(off)
tsline inv sm4inv sm4cinv if tin(1978q1, ), legend(off)

* 가중 이동평균(Weighted moving averages)
tssmooth ma sm5inv=inv, weights(1 2 <3> 2 1)
tsline inv sm5inv if tin(1978q1, ), legend(off)

* 지수적 이동평균(exponential smoothing)
tssmooth exp smeinv = inv
tsline inv smeinv if tin(1978q1, ), legend(off)

* 예측
tssmooth exp forinv = inv, forecast(4)
tsline inv forinv if tin(1978q1, ), legend(off)

* 홀트-윈터스 예측(Holt–Winters forecasting)
tssmooth hwinters hwinv = inv, forecast(4)
tsline inv hwinv if tin(1978q1, ), legend(off)


