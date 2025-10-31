// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* *********************
* *** 데이터세트 관리 ***
* *********************
cd "E:\work"

* *****************************************
* 데이터세트의 수평합치기(merge): 1:1 매칭 사례
* 두 데이터세트의 key변수가 정확히 일치할 때
clear
input key str1 var1 str1 var2
1	A	B
2	A	B
3	A	B
4	A	B
end
save file1, replace

clear
input key str1 var3
1	C
2	C
3	C
4	C
end
save file2, replace

use file1, clear
merge 1:1 key using file2
list key var1 var2 var3 

* *****************************************
* 데이터세트의 수평합치기(merge): 1:1 매칭 사례
* 두 데이터세트의 key변수가 정확히 일치하지 않을 때
clear
input key str1 var1 str1 var2
1	A	B
2	A	B
3	A	B
4	A	B
5	A	B
7	A	B
8	A	B
end
save file3, replace

clear
input key str1 var3
1	C
2	C
3	C
5	C
6	C
7	C
end
save file4, replace

use file3, clear
merge 1:1 key using file4
sort key
list key var1 var2 var3 

* *****************************************
* 데이터세트의 수평합치기(merge): 1:1 매칭 사례
* 두 데이터세트에서 2개의 key변수가 사용될 때 
clear
input key1 key2 str1 var1 str1 var2
1	2016	A	B
1	2017	A	B
1	2018	A	B
2	2016	A	B
2	2017	A	B
2	2018	A	B
3	2016	A	B
3	2017	A	B
3	2018	A	B
end
save file5, replace

clear
input key1 key2 str1 var3
1	2016	C
1	2017	C
2	2016	C
2	2017	C
3	2016	C
3	2017	C
3	2018	C
end 
save file6, replace

clear
use file5, clear
merge 1:1 key1 key2 using file6 
list key1 key2 var1 var2 var3 

* *****************************************
* 데이터세트의 수평합치기(merge): m:1 매칭 사례
* 두 데이터세트에서 2개의 key변수가 사용될 때 
clear
input key str1 var1 str1 var2
1	A	B
1	A	B
1	A	B
2	A	B
2	A	B
2	A	B
3	A	B
3	A	B
end
save file7, replace

clear
input key str1 var3
key	var3
1	aaa
2	bbb
3	ccc
end
save file8, replace

clear
use file7, clear
merge m:1 key using file8
list key var1 var2 var3

* *********************************
* 데이터세트의 수직 합치기(append)
* 두 데이터세트의 변수명이 동일할 때
clear
input key str1 var1 str1 var2
1	A	B
2	A	B
3	A	B
4	A	B
end
save file9, replace

clear
input key str1 var1 str1 var2
5	C	D
6	E	F
7	G	H
8	I	J
end
save file10, replace

clear
use file9, clear
append using file10
list key var1 var2

* *****************************************
* 데이터세트의 수직 평합치기(append)
* 두 데이터세트의 변수명이 동일하지 않을 때
clear
input key str1 var1 str1 var2
1	A	B
2	A	B
3	A	B
4	A	B
end
save file9, replace

clear
input key str1 var3 str1 var4
5	C	D
6	E	F
7	G	H
8	I	J
end
save file10, replace

clear
use file9, clear
append using file10
list key var1 var2 var3 var4 

* ************************************
* 데이터세트의 Long-form <--> Wide-form

clear
input id sex wage2016 wage2017 wage2018
1 0 100 120 200
2 1 200 250 300
3 0  70 100   50
end 

* Long-form으로
reshape long wage, i(id) j(year)
list id year sex wage 

* 다시 Wide-form으로
reshape wide wage, i(id) j(year)
list id sex wage2016 wage2017 wage2018 

* Present Working Directory에서 데이터세트 제거
forvalues i=1(1)10 {
                        erase file`i'.dta
						}

* **************************
* 데이터세트의 축약 (collapse)

sysuse auto, clear
collapse price mpg rep78 headroom

sysuse auto, clear
collapse (mean) price mpg rep78 headroom, by(foreign)

sysuse auto, clear
collapse (sd) price mpg rep78 headroom

sysuse auto, clear
collapse (sd) price mpg rep78 headroom, by(foreign)
