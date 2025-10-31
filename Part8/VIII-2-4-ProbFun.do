// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ****************************
* *** 확률분포 그래프 그리기 ***
* ****************************
set scheme s1mono
graph set window fontface "굴림체"

* ***************************
* *** 정규분포 이해하기 ***
* ***************************
twoway function y = normalden(x), range(-5 5) lpattern(solid) lwidth(thick)  /// 
           title("표준정규분포 확률밀도함수") 

twoway function y = normal(x), range(-5 5)  lpattern(solid) lwidth(thick)  ///
           title("누적 표준정규분포 함수") 

twoway function y = normalden(x, 0.8), range(-5 5) lpattern(solid) lwidth(thick)  ///
           title("표준정규분포 확률밀도함수(표준편차=0.8)")    

twoway function y = normalden(x, 1, 0.8), range(-5 5) lpattern(solid) lwidth(thick)  ///
           title("표준정규분포 확률밀도함수(평균=1, 표준편차=0.8)")     
     
* 다양한 평균과 분산을 가진 정규분포 확률밀도 함수
* 명령어가 길어질 경우 #delimit ; -- #delimit cr을 사용
#delimit ;
twoway function y = normalden(x), range(-5 5) lpattern(solid) lwidth(thick)                  
      ||  function y = normalden(x, 0.8), range(-5 5) lpattern(dash) lwidth(thick)           
      ||  function y = normalden(x, 1, 0.8), range(-5 5) lpattern(dash_dot) lwidth(thick) 
      ||, title("다양한 정규분포 확률밀도함수")  ytitle("f(x)")                                         
           legend(label(1 "N(0, 1)") label(2 "N(0, 0.8)") label(3 "N(1, 0.8)")                        
           position(11) cols(1) ring(0) region(lp(blank))) ;
#delimit cr


* 정규분포와 범위별 확률 근사치(체비쉐프의 법칙)   
#delimit ;
twoway function y = normalden(x), range(-5 -3) color(gs5) recast(area)   
      ||  function y = normalden(x), range(-3 -2) color(gs7) recast(area)   
      ||  function y = normalden(x), range(-2 -1) color(gs10) recast(area)  
      ||  function y = normalden(x), range(-1 1) color(gs13) recast(area)   
      ||  function y = normalden(x), range(1 2) color(gs10) recast(area)    
      ||  function y = normalden(x), range(2 3) color(gs7) recast(area)     
      ||  function y = normalden(x), range(3 5) color(gs5) recast(area)     
      ||  function y = normalden(x), range(-5 5) color(black) lpattern(solid) lwidth(thick)  
      ||, title("정규분포 범위별 확률근사치(체비쉐프 법칙)" )  
           ytitle("f(X)")                                              
           xtitle("X")                                                 
           legend(off)                                              
           plotregion(margin(zero))                          
           text(0 -3 "-3", place(s))                          
           text(0 -2 "-2", place(s))                    
           text(0 -1 "-1", place(s))                          
           text(0 1 "1", place(s))                                  
           text(0 2 "2", place(s))                               
           text(0 3 "3", place(s))  ;             
#delimit cr  

* *********************
* *** t-분포 이해하기 ***
* *********************
* 정규분포와 t분포 비교
#delimit ; 
twoway function y = normalden(x), range(-5 5)  lpattern(solid) lwidth(thick)  
      ||  function y = tden(5, x), range(-5 5)  lpattern(dash) lwidth(thick)       
      ||, title("정규분포와 t(5)분포의 확률밀도함수")       
           ytitle("f(X)")                                                    
           legend(label(1 "N(0, 1)") label(2 "t(3)")               
           position(11) cols(1) ring(0) region(lp(blank)))  ;
#delimit cr
   
* 자유도와 t분포의 형태
#delimit ;
twoway function y = tden(3, x), range(-5 5) lpattern(solid) lwidth(thick)  
     ||  function y = tden(7, x), range(-5 5) lpattern(dash) lwidth(thick)   
     ||  function y = tden(30, x), range(-5 5)  lpattern(dash_dot) lwidth(thick) 
     ||, title("자유도와 t분포의 형태")               
          ytitle("f(X)")                                        
          legend(label(1 "t(3)") label(2 "t(7)") label(3 "t(30)")        
          position(11) cols(1) ring(0) region(lp(blank))) ;
#delimit cr

* t분포와 기각역
display invttail(30, .05)
#delimit ;
twoway function y = tden(30, x), range(1.697 5)  color(black) recast(area)  
      ||  function y = tden(30, x), range(-5 5) color(black) lpattern(solid) lwidth(thick) 
      ||, title("t 분포와 기각역")  ytitle("f(t)")  xtitle("t")  legend(off)               
           plotregion(margin(zero))                    
           text(0 1.69 "1.697", place(s)) ;
#delimit cr
     
* t분포와 양쪽 기각역
#delimit ;
twoway function y = tden(30, x), range(1.697 5) color(gs10) recast(area)     
      ||  function y = tden(30, x), range(-5 -1.697)  color(gs10) recast(area) 
      ||  function y = tden(30, x), range(-5 5)  color(black) lpattern(solid) lwidth(thick) 
      ||, title("t 분포와 양쪽 기각역")          
           ytitle("f(t)") xtitle("t") legend(off)   
           plotregion(margin(zero))             
           text(0 1.697 "1.697", place(s))    
           text(0 -1.697 "-1.697", place(s))  ; 
#delimit cr
  
* **********************
* *** F-분포 이해하기 ***
* ********************** 
* F-분포와 확률밀도함수 
#delimit ;
twoway  function y = Fden(2,2,x), range(0 6)  lpattern(solid) lwidth(thick)    
       ||  function y = Fden(10,2, x), range(0 6) lpattern(dash) lwidth(thick)  
       ||  function y = Fden(50,50, x), range(0 6)  lpattern(dash_dot) lwidth(thick)   
       ||, ytitle("F-density") xtitle("x")   title("F-분포와 확률밀도함수")     
            legend(label(1 "F(2, 2)") label(2 "F(10, 2)") label(3 "F(50, 50)")        
            position(1) cols(1) ring(0)region(lp(blank))) ;
#delimit cr

* ****************************   
* *** 카이자승 분포 이해하기 ***
* ****************************

* Chi square 확률밀도함수
#delimit ;
twoway  function y = chi2den(2,x), range(0 20) lpattern(solid) lwidth(thick)    
       ||  function y = chi2den(5,x), range(0 20)   lpattern(dash) lwidth(thick)  
       ||  function y = chi2den(10,x), range(0 20) lpattern(dash_dot) lwidth(thick)    
       ||, title("카이자승 확률밀도함수") ytitle("Chi Square cum. density") xtitle("x")  
            legend(label(1 "Chi2(2)") label(2 "Chi2(5)") label(3 "Chi2(10)")        
            position(1) cols(1) ring(0) region(lp(blank))) ;
#delimit cr
			
* Chi Square 누적분포함수 
#delimit ;
twoway  function y = chi2(2,x), range(0 20) lpattern(solid) lwidth(thick)     
       ||  function y = chi2(5,x), range(0 20)   lpattern(dash) lwidth(thick)  
       ||  function y = chi2(10,x), range(0 20) lpattern(dash_dot) lwidth(thick)  
       ||, title("Chi Square 누적분포함수") ytitle("Chi Square cum. density") xtitle("x")  
            legend(label(1 "Chi2(2)") label(2 "Chi2(5)") label(3 "Chi2(10)")            
            position(1) cols(1) ring(0) region(lp(blank))) ;
#delimit cr     

* Chi square 확률밀도함수식를 이용한 그래프 그리기
clear
set obs 101
gen x = _n/5
scalar df2  = 2
scalar df5  = 5
scalar df10 = 10
generate chi2pdf2   =(1/(2^(df2/2)))*(1/exp(lngamma(df2/2)))*x^(df2/2-1)*exp(-x/2)
generate chi2pdf5   =(1/(2^(df5/2)))*(1/exp(lngamma(df5/2)))*x^(df5/2-1)*exp(-x/2)
generate chi2pdf10 =(1/(2^(df10/2)))*(1/exp(lngamma(df10/2)))*x^(df10/2-1)*exp(-x/2)

#delimit ;   
twoway line chi2pdf2 chi2pdf5 chi2pdf10 x               
         , ytitle("Chi Square density") xtitle("x")           
           title("Chi Square 확률밀도함수")                   
           legend(label(1 "Chi2(2)") label(2 "Chi2(5)") label(3 "Chi2(10)")      
           position(1) cols(1) ring(0)region(lp(blank))) ;
#delimit cr  

#delimit ;
twoway line chi2pdf2 x, lpattern(solid) lwidth(thick)          
      ||  line chi2pdf5 x, lpattern(dash) lwidth(thick)          
      ||  line chi2pdf10 x, lpattern(dash_dot) lwidth(thick)   
      ||, ytitle("Chi Square Density") xtitle("x")  
           legend(label(1 "Chi2(2)") label(2 "Chi2(5)") label(3 "Chi2(10)")      
           position(1) cols(1) ring(0)region(lp(blank)))  
           title("Chi Square 확률밀도함수")                  
           subtitle("Probability Density와 Cumulative Density 구별")    
           note("자료: STATA를 이용한 계량경제학") ;
#delimit cr
