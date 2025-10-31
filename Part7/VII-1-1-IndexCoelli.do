// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ***************************
* *** 다양한 지수 분석사례  ****
* ***************************

* 2개 산출물, 3개 투입물로 부터 다양한 지수 계산
* Battese & Coelli(2005) 사례

clear
input year y1 y2 x1 x2 x3  p1  p2  w1 w2 w3
2008 471	293	145	67	39	27	18	39	100	100
2009 472	290	166	75	39	28	17	41	110	 97
2010 477	278	162	78	43	34	17	42	114	103
2011 533	277	178	89	42	32	20	46	121	119
2012 567	289	177	93	51	34	23	46	142	122
end

* index명령어 설치
ssc install http://fmwww.bc.edu/RePEc/bocode/i/index.pkg

* 산출물의 물량지수와 가격지수
index p1 p2 = y1 y2, chain simple base(1) year(2008) list
generate qindex=_TT_Qc
generate pq=_TT_Pc

* 투입물의 물량지수와 가격지수
index w1 w2 w3 = x1 x2 x3, chain simple base(1) year(2008) list
generate iindex=_TT_Qc
generate pi=_TT_Pc
list qindex pq iindex pi

* 총요소생산성 증가율 계산 
gen gr_q=ln(qindex)-ln(qindex[_n-1])
gen gr_i=ln(iindex)-ln(iindex[_n-1])
gen tfp=gr_q-gr_i

* 총요소생산성 지수 계산
gen tfpindex=1 
replace tfpindex=tfpindex[_n-1]*exp(tfp) if year>=2009
list tfp tfpindex
