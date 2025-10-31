// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

﻿* ********************************
* *** 구조방정식 모형의 분석절차 ***
* ********************************
import excel "D:\statapgm\Part7\VII-6-2-SEMGSS.xlsx", sheet("data") firstrow
save VII-6-2-SEMGSS, replace 

use VII-6-2-SEMGSS, clear

* 글로벌 매크로 만들기
global peduc "paeduc padeg maeduc madeg"
global reduc "educ speduc degree"
global relige "relpersn attend god pray"
global libera "polviews conlabor confed"
global totlist "$peduc $reduc $relige  $libera"
macro list

* 필요자료만 선택, 재정렬
keep id $totlist
order  $totlist

* ***********************************
* *** 단순기술통계량 및 상관계수행렬 ***
* ***********************************
* 단순기술통계량
desc $totlist
summ  $totlist
* 상관계수행렬
corr $totlist

* ************************************************
* *** 다변량 정규성 검정(Doornik-Hansen omnibus test) ***
* ************************************************
mvtest  normality $totlist, stat(all)

* ****************************************************
* *** 신뢰도 검정을 위한 크론바흐 알파(Cronbach's alpha) ***
* ****************************************************
alpha $peduc, item label asis
alpha $reduc, item label asis
alpha $relige, item label asis
alpha $libera, item label asis

* ******************************************************
* *** Principal component factor analysis와 관찰변수의 그룹화  ***
* ******************************************************
* Principal component factor analysis
factor  $totlist, pcf

* *************************************************
* *** 확인적 요인분석(Confirmatory Factor Analysis: CFA) ***
* *************************************************
sem (Peduc -> $peduc)          ///
       (Reduc -> $reduc)           ///
       (Liberalism   -> $relige)    ///
       (Religiousity ->  $libera) 
* 모형의 신뢰성 및 판별분석
relicoef
condisc	
* 모형의 적합도  
estat gof, stats(all) 

* *****************************************
* *** 구조방정식 모형(SEM) 추정과 수정지수 ***
* *****************************************
sem (Peduc -> $peduc)            ///
       (Reduc -> $reduc)             ///
       (Liberalism  -> $relige)       ///
       (Religiousity -> $libera)      ///
       (Peduc -> Reduc)              ///
       (Peduc -> Religiousity)       ///
       (Religiousity -> Liberalism)  ///
     , latent(Peduc Reduc Liberalism Religiousity )
estat mindices

* ***********************************************
* *** 수정지수를 이용한 구조방정식 모형(SEM) 개선 ***
* *********************************************** 
sem (Peduc -> $peduc)          ///
       (Reduc ->  $reduc)          ///
       (Liberalism -> $relige)      ///
       (Religiousity ->  $libera)   ///
       (Peduc -> Reduc)                                     ///
       (Peduc -> Religiousity)                              ///
       (Religiousity -> Liberalism)                         ///
     , latent(Peduc Reduc Liberalism Religiousity ) ///
	   cov( e.maeduc*e.padeg e.conlabor*e.confed) 
* 모형의 신뢰성 및 판별성 분석
relicoef
condisc	
* 수정지수 계산
estat mindices
* 모형의 적합도
estat eqgof
estat gof, stats(all) 
* 직접효과, 간접효과 및 총효과의 계산
estat teffects


* *****************************
* ***  SEM모형의 2단계 추정법 ***
* *****************************  
* 1단계: 확인적 요인분석과 잠재변수값 계산
sem (Peduc -> $peduc)          ///
       (Reduc -> $reduc)           ///
       (Liberalism   -> $relige)    ///
       (Religiousity ->  $libera) 
* 잠재변수값 계산 및 잠재변수들간 상관관계
predict q1 q2 q3 q4,  latent(Peduc Reduc Liberalism Religiousity)
* 2단계: 구조모형의 추정(3SLS사용)
reg3 (q2 q1) (q3 q1) (q4 q3)

