// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***********************
* *** 더미변수 활용법   ***
* ***********************
sysuse auto

* 요약통계
summarize price weight length foreign rep78

* 상관계수
corr price weight length foreign rep78

* 더미변수(절편)
regress price weight length foreign 

* 더미변수(기울기)
generate  wf=weight*foreign
regress price weight length wf 

* 더미변수(절편, 기울기)
regress price weight length foreign wf 

* 요소변수를 이용한 더미(절편)
regress price weight length i.foreign

* 다수의 더미변수
areg price weight length, absorb(rep78)