// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ****************************************
* *** Stata Output을 문서화하는 방법 사례   ***
* ****************************************

*  1) Stata 명령어 estimates store, estimates table 이용하기
sysuse auto, clear
regress price mpg weight  
estimates store model1
regress price mpg weight length 
estimates store model2
regress price mpg weight length rep78 
estimates store model3
regress price mpg weight length rep78 foreign 
estimates store model4

estimates table model1 model2 model3 model4
estimates table model1 model2 model3 model4      ///
              , b(%7.2f) se(%5.4f)
estimates table model1 model2 model3 model4      ///     
              , b(%7.2f) se(%5.4f) stats(N r2_a)
estimates table model1 model2 model3 model4      ///
              , b(%7.2f) star(0.10 0.05 0.01) stats(N r2_a) 
estimates table model1 model2 model3 model4      ///
              , b(%7.2f) se(%5.4f) t(%4.1f) stats(N r2_a) 

* 2) 사용자 프로그램  esttab 사용하기
* 사용자  프로그램의  설치 
ssc install http://www.stata-journal.com/software/sj7-2/st0085_1.pkg

esttab model1 model2 model3 model4    ///
        , star(* 0.10 ** 0.05 *** 0.01) r2 b(%10.1f) t(%10.1f) fixed
	 
esttab model1 model2 model3 model4    ///
        , star(* 0.10 ** 0.05 *** 0.01) r2 b(%10.1f) se(%10.1f) fixed

* 추정결과의 MS Word 파일 생성
esttab model1 model2 model3 model4 using review                     ///
        , replace star(* 0.10 ** 0.05 *** 0.01)                          ///
          rtf r2 aic mtitle( "Model 1" "Model 2" "Model 3"  "Model 4" )  ///
          label title("Estimation Results")
		 
* 3) 사용자 프로그램  sum2docx,  corr2docx, rreg2docx 사용하기
* 단순기술통계, 상관계수행렬, 회귀분석결과를 MS  Word 파일로 저장
* 사용자  프로그램의  설치 
ssc install http://fmwww.bc.edu/RePEc/bocode/c/corr2docx.pkg
ssc install http://fmwww.bc.edu/RePEc/bocode/s/sum2docx.pkg
ssc install http://fmwww.bc.edu/RePEc/bocode/r/reg2docx.pkg

* 단순기술통계량을 워드문서로 보관
sum2docx price mpg weight length rep78 foreign using temp1.docx            ///
       , replace obs mean(%9.2f) sd min(%9.0g) median(%9.0g) max(%9.0g)

sum2docx price mpg weight length rep78 foreign using temp2.docx           ///
       , replace obs mean sd min median max title("단순기술통계량")

sum2docx price mpg weight length rep78 foreign using temp3.docx            ///
       , replace obs mean(%9.2f) sd min(%9.0g) median(%9.0g) max(%9.0g) ///
         title("<표 1> 단순기술통계량")

putdocx append temp1.docx temp2.docx temp3.docx  ///
       , saving(mytable.docx,replace)

* 상관계수행렬을  워드문서로 보관
corr2docx mpg weight length rep78 foreign using temp1.docx, replace

corr2docx mpg weight length rep78 foreign   ///
          if foreign == 1 using temp1.docx     ///
        , replace note("foreign car")

corr2docx mpg weight length rep78 foreign using temp1.docx, replace star

corr2docx mpg weight length rep78 foreign using temp1.docx  ///
        , append star(** 0.01 * 0.05)

corr2docx mpg weight length rep78 foreign using temp1.docx ///
        , replace star note(피어슨의 상관계수)

corr2docx mpg weight length rep78 foreign using temp1.docx ///
        , replace star note(주: 피어슨의 상관계수)              ///
          title("상관계수행렬")

corr2docx mpg weight length rep78 foreign using temp1.docx  ///
        , replace star addone

* 회귀분석결과 MS Word 파일로 보관
reg2docx model1 model2 model3  model4 using result.docx  ///
       , replace r2(%9.3f) ar2(%9.2f) t(%7.2f)                    ///
	     title(Table: OLS regression results)                        ///
	     mtitles("model 1" "model 2" "model 3" "model 4")
	  
	  
	  
	  
	  