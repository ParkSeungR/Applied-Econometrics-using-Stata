// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *************************
* *** RCA 지수 계산 연습  ***
* *************************
ssc install http://fmwww.bc.edu/RePEc/bocode/r/rca.pkg

* 입력자료가 long form일 경우
clear
input str2 country	item	export
A	1	33
A	2	40
A	3	40
A	4	49
A	5	36
A	6	19
B	1	27
B	2	38
B	3	31
B	4	12
B	5	11
B	6	40
C	1	38
C	2	39
C	3	27
C	4	10
C	5	21
C	6	48
D	1	39
D	2	46
D	3	22
D	4	22
D	5	38
D	6	25
end

rca export, j(country) m(item) index(BRCA)
reshape wide export export_brca, i(item) j(country) str
export excel item export_brca* using rcadata1, replace firstrow(variable)


* 입력자료가 wide form일 경우
clear	
input item exportA	exportB	exportC exportD
1	33	27	38	39
2	40	38	39	46
3	40	31	27	22
4	49	12	10	22
5	36	11	21	38
6	19	40	48	25
end

reshape long export, i(item) j(country) str
rca export, j(country) m(item) index(BRCA)
reshape wide export export_brca, i(item) j(country) str
export excel item export_brca* using rcadata2, replace firstrow(variable)
