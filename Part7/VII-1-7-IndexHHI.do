// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *****************************************
* *** 집중도 (Herfindahl-Hirschman index (HHI))  ****
* *****************************************
import excel "D:\statpgm\Part7\VII-1-7-IndexHHI.xlsx", sheet("hhi") firstrow
save VII-1-7-IndexHHI, replace

use VII-1-7-IndexHHI, clear

* 변수의 그룹 파악
table age  
table race
table married 
table grade 
table industry 
table occupation 
table union

* 1개변수 1개 기준
hhi5 wage, by(industry)  prefix(hhi1)

* 1개변수 2개 기준
hhi5 wage hours, by(industry race) prefix(hhi2)

* 2 변수 1개 기준
hhi5 wage hours, by(industry) prefix(hhi3)

* 2 변수 2개 기준
hhi5 wage hours, by(industry race) prefix(hhi4)

* 상위 n개 지정, 최소 관측치수 지정
hhi5 wage, by(industry) prefix(hhi5) top(5) minobs(10)

* 엑셀파일로 저장		   
export excel industry race hhi* using hhiindex ///
           , firstrow(variable) sheet(hhi) 
		   
