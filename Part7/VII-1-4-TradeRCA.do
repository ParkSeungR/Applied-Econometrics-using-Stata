// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *****************************************
* *** 세계무역통계를 이용한 RCA 지수 계산  ***
* *****************************************
import excel "D:\statapgm\Part7\VII-1-4-TradeRCA.xlsx", sheet("eximtowor") firstrow
save VII-1-4-TradeRCA, replace

ssc install http://fmwww.bc.edu/RePEc/bocode/r/rca.pkg

use VII-1-4-TradeRCA, clear
* *** 1) 수출, 수입만을 wide form으로 만듬
drop tradeflow partcode partner
reshape wide value, i(year commcode commdesc reportcode reporter) j(tradeflowd) str

* *** 2) 수출액, 수입액 기준 RCA지수계산
* 수출액 기준 RCA (RCAX)
rca valueExport, j(reporter) m(commcode) index(BRCA) by(year)

* 수입액 기준 RCA (RCAM)
rca valueImport, j(reporter) m(commcode) index(BRCA) by(year)


* *** 3) Long form 자료를 Wide form으로 변경
drop reporter
reshape wide valueExport valueImport valueExport_brca valueImport_brca ///
           , i(year commcode commdesc) j(reportcode) 
		   
* *** 4) 수출, 수입,  RCAX, RCAM을 별도의 Sheet로 엑셀파일에 저장
* 변수명 간단하게 변경
rename valueExport_brca* RCAX*
rename valueImport_brca* RCAM*
rename valueExport* export*
rename valueImport* import*

* 엑셀파일로 저장		   
export excel year commcode commdesc export* using traderca ///
           , firstrow(variable) sheet(export) sheetmodify
		   
export excel year commcode commdesc import* using traderca ///
           , firstrow(variable) sheet(import) sheetmodify
		   
export excel year commcode commdesc RCAX* using traderca ///
           , firstrow(variable) sheet(RCAX) sheetmodify
		   
export excel year commcode commdesc RCAM* using traderca ///
           , firstrow(variable) sheet(RCAM) sheetmodify 
		   
		   
		   
* ***********************************************************
* ***** 세계무역통계를 이용한 산업내 무역지수 계산  ******
* ***********************************************************

use VII-1-4-TradeRCA, clear
* *** 1) 수출, 수입만을 wide form으로 만듬
drop tradeflow partcode partner
reshape wide value, i(year commcode commdesc reportcode reporter) j(tradeflowd) str

* *** 2) 산업내 무역지수계산
* 수출, 수입중 하나가 0이면 I=0로서 일방무역
* 수출, 수입이 같다면 I=1로서 산업내 무역 활발
egen min=rowmin(valueExport valueImport)
egen mean=rowmean(valueExport valueImport)
generate intraindex=min/mean

* *** 3) Long form 자료를 Wide form으로 변경
drop reporter min mean
reshape wide valueExport valueImport intraindex ///
           , i(year commcode commdesc) j(reportcode) 
		   
* *** 4) 수출, 수입,  산업내무역지수를 별도의 Sheet로 엑셀파일에 저장
* 변수명 간단하게 변경
rename intraindex* I*
rename valueExport* export*
rename valueImport* import*

* 엑셀파일로 저장		   
export excel year commcode commdesc export* using intra ///
           , firstrow(variable) sheet(export) sheetmodify
		   
export excel year commcode commdesc import* using intra ///
           , firstrow(variable) sheet(import) sheetmodify
		   
export excel year commcode commdesc I* using intra ///
           , firstrow(variable) sheet(intraindex) sheetmodify
		   