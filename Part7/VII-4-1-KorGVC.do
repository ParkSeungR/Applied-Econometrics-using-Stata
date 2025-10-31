// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ****************************************
* *** 글로벌밸류체인에 대한 3가지 접근법  ***
* ****************************************
* 먼저 icio 설치후 c:\ado\plus\i내에 icio*와 데이터 다운로드 확인
* GVC관련 자료의 이해 필수 

* **************************************
* ****** 1) 초기 GVC분석법  **********
* **************************************

* 한국의 전세계 부가가치 수출 및 수입
forvalue i=2000(1)2014 {
 icio_load, iciot(wiod) year(`i')
 icio, origin(kor) destination(all) vby(foreign)
 icio, origin(all) destination(kor) vby(foreign)
                                 }
								 
* 한국과 미국간 부가가치 수출, 수입								 
forvalue i=2000(1)2014 {
 icio_load, iciot(wiod) year(`i')
 icio, origin(kor) destination(usa) vby(foreign)	
 icio, origin(usa) destination(kor) vby(foreign)	
                                 }

* 한국과 중국간 부가가치 수출, 수입								 
forvalue i=2000(1)2014 {
 icio_load, iciot(wiod) year(`i')
 icio, origin(kor) destination(chn) vby(foreign)	
 icio, origin(chn) destination(kor) vby(foreign)
                                 }	

* 한국과 일본간 부가가치 수출, 수입
forvalue i=2000(1)2014 {
 icio_load, iciot(wiod) year(`i')
 icio, origin(kor) destination(jpn) vby(foreign)	
 icio, origin(jpn) destination(kor) vby(foreign
                                 }

* ********************************************************							 
* *** 2) KWW방법에 의한 총수출의 부가가치 분해  *****
* ********************************************************

* 한국 총수출의 부가가치 분해( 9개 부분)
forvalue i=2000(1)2014 {
icio_load, iciot(wiod) year(`i')
icio, exporter(kor) kww
	                             }
								 
* 한국 총수출의 부가가치 분해( 1-5 부분합)
forvalue i=2000(1)2014 {
icio_load, iciot(wiod) year(`i')
icio, exporter(kor) kww output(dva)
	                             }								 
* 한국 총수출의 부가가치 분해( 1-6 부분합)
forvalue i=2000(1)2014 {
icio_load, iciot(wiod) year(`i')
icio, exporter(kor) kww output(dc)
	                             }

* *********************************************************
* *** 3) BM방법에 의한 총수출의 부가가치 분해  ********
* **********************************************************
* 3-1) 한국 총수출의 부가가치 분해(Sink방식 19개 부분)
forvalue i=2000(1)2014 {
icio_load, iciot(wiod) year(`i')
icio, exporter(kor) importer(usa)
	                             }

* 한국 총수출의 부가가치 분해(Source방식 19개 부분)
forvalue i=2000(1)2014 {
icio_load, iciot(wiod) year(`i')
icio, exporter(kor) importer(usa) bilateral(source_fvae)
	                             }

* 3-2) BM방법에 의한 다자간 무역 분해  *****

* 한미간 GVC관련 무역(적어도 2개국경 경유)
forvalue i=2000(1)2014 {
icio, exporter(kor) importer(usa) output(gvc) bilateral(source)
	                             }

* 3자간 무역에서 부가가치 원천
forvalue i=2000(1)2014 {
* 일본의 한국수출후 전세계 각국에서 소비된 것 중 일본의 비중  
icio, export(jpn) import(kor) destination(all) output(dc)
* 한국의 중국수출후 전세계 각국에서 소비된 것 중 한국의 비중  
icio, export(kor) import(chn) destination(all) output(dc)
* 한국의 중국수출후 전세계 각국에서 소비된 것 중 일본의 비중
icio, origin(jpn) export(kor) import(chn) destination(all) output(fc)
	                             }











						 