// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ********************
* *** 분산분석 사례 ***
* ********************
clear 
input strat sale
1 	40
1 	36
1 	30
1 	32
1 	34
1 	38
1 	46
1 	34
2 	24
2 	20
2 	14
2 	16
2 	36
2 	32
2 	30
2 	28
3 	34
3 	28
3 	26
3 	20
3 	22
3 	18
3 	16
3 	12
end 

anova sale strat  