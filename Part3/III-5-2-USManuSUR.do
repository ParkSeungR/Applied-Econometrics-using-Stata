// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

﻿* *********************************
* *** 미국 제조업의 비용함수 추정  ***
* *** 비용함수의 연립추정법(SUR)   ***
* *********************************
import excel "D:\statapgm\Part3\III-5-2-USManuSUR.xlsx", sheet("data") firstrow
save III-5-2-USManuSUR, replace

use III-5-2-USManuSUR, clear

* 비용몫(cost share)계산
generate sk=pk*k/cost
generate sl=pl*l/cost
generate se=pe*e/cost
generate sm=pm*m/cost

* 중간재와의 상대가격의 log값
generate rpk=ln(pk/pm)
generate rpl=ln(pl/pm)
generate rpe=ln(pe/pm)

* SUR 추정법(제약조건이 없을 경우)
sureg (sk rpk rpl rpe) (sl rpk rpl rpe) (se rpk rpl rpe)

* SUR 추정법(제약조건이 있을 경우)
constraint 1 [sk]rpl=[sl]rpk
constraint 2 [sk]rpe=[se]rpk
constraint 3 [sl]rpe=[se]rpl
sureg (sk rpk rpl rpe) (sl rpk rpl rpe) (se rpk rpl rpe), const(1 2 3)
