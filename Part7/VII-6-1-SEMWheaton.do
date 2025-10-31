// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

use https://www.stata-press.com/data/r16/sem_sm2
ssd describe
webgetsem sem_sm2

* ************************************
* *** 기본모형의 추정과 수정지수 검토  ***
* ************************************
sem (anomia67 pwless67 <- Alien67)   ///
        (anomia71 pwless71 <- Alien71)  ///
        (educ66 occstat66 <- SES )        ///
        (Alien67 <- SES)                        ///
        (Alien71 <- Alien67 SES) 
estat mindices

* **************************
* *** 오차항의 공분산 반영  ***
* **************************
sem (anomia67 pwless67 <- Alien67)   ///
       (anomia71 pwless71 <- Alien71)   ///
       (educ66 occstat66 <- SES )        ///
       (Alien67 <- SES)                        ///
       (Alien71 <- Alien67 SES)             ///
     , cov(e.anomia67*e.anomia71)     ///
       cov(e.pwless67*e.pwless71)
relicoef
condisc	
estat mindices
estat eqgof
estat gof 
estat teffects
		
. ssd init x1 x2 x3
. ssd set obs 74
. ssd set cor 1 \ -.8072 1 \ .3934 -.5928 1
. ssd set sd 5.6855 .7774 .4602
. ssd set means 21.2973 3.0195 .2973

* 만약 직접공분산행렬을 직접 입력할 경우 ssd명령어를 사용함
ssd init educ66 occstat66 anomia67 pwless67 anomia71 pwless71
ssd set obs      932
ssd set means 10.90 37.49 13.61 14.67 14.13 14.90 
ssd set sd         3.10 21.22  3.44   3.06   3.54  3.16 
ssd set cor                                 ///
    1.00 \                                        ///
    0.54 1.00 \                                 ///
   -0.36 -0.30 1.00 \                       ///
   -0.41 -0.29 0.66 1.00 \                ///
   -0.35 -0.29 0.56 0.47 1.00 \         ///
   -0.37 -0.28 0.44 0.52 0.67 1.00
ssd describe 
