// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ********************************
* *** CB- SEM과 PLS-SEM의 비교 ***
* ********************************
import excel "D:\statapgm\Part7\VII-6-3-PLSSEM.xlsx", sheet("data") firstrow
save VII-6-3-PLSSEM, replace

use VII-6-3-PLSSEM, clear

*  PLS-SEM 사용자작성 프로그램 설치
ssc install http://fmwww.bc.edu/RePEc/bocode/p/plssem.pkg

* CB-SEM모형의 추정, 평가
sem (Attractive -> face sexy) (Appearance -> body appear attract)              ///
       (Muscle -> muscle strength endur) (Weight -> lweight calories cweight)  ///
	   (Appearance <- Attractive) (Muscle <- Appearance) (Weight <- Appearance)  ///
     , latent(Attractive Appearance Muscle Weight)
sem, standardize
relicoef
condisc	
estat gof, stats(all)

* PLS-SEM모형의 추정, 평가(반영 관측변수로 모형화)
plssem (Attractive > face sexy) (Appearance > body appear attract)             ///
           (Muscle > muscle strength endur) (Weight > lweight calories cweight) ///
          , structural(Appearance Attractive, Muscle Appearance, Weight Appearance)
* 내부모형, 외부모형, 요인부하량의 도표
plssemplot, innermodel
plssemplot, outerweights
plssemplot, loadings	
* 직접효과, 간접효과, 총효과의 측정 	  
estat total, plot
estat indirect, effects(Muscle Appearance Attractive, Weight Appearance Attractive)
* 다중공선성 존재여부 검정  
estat vif
* 잠재변수, 잔차의 계산
predict, xb residuals
summ *_hat *_res 
* 이분산 존재 검정 
estat unobshet, test reps(200) plot

* PLS-SEM모형의 추정, 평가(형성 관측변수로 모형화)		  
plssem (Attractive < face sexy) (Appearance < body appear attract) ///
           (Muscle < muscle strength endur) (Weight < lweight calories cweight) ///
          , structural(Appearance Attractive, Muscle Appearance, Weight Appearance)
* 내부모형, 외부모형, 요인부하량의 도표
plssemplot, innermodel
plssemplot, outerweights
plssemplot, loadings	
* 직접효과, 간접효과, 총효과의 측정 	  
estat total, plot
estat indirect, effects(Muscle Appearance Attractive, Weight Appearance Attractive)
* 다중공선성 존재여부 검정  
estat vif
