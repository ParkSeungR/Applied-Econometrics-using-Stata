// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

* ************************ 
* ***  중심극한정리 이해 ***
* ************************ 
set scheme s1mono
graph set window fontface "굴림체"

set obs 10000
set seed 12345

* 균일확률분포에 대한 중심극한정리 적용
generate u1=runiform()
histogram u1, normal bin(30) saving(u1, replace) title(균일분포) 

forvalues repeat=2/20 {
     generate u`repeat'=runiform()
                                }
       
foreach n in  5 10 20 {
     egen umean`n'=rowmean(u1-u`n')
     generate uz`n'=(umean`n'-1/2)/(sqrt((1/12)/`n'))
     histogram uz`n', bin(30) normal saving(uz`n', replace)
                               }

graph combine u1.gph uz5.gph uz10.gph uz20.gph, col(1) ysize(12) xsize(4)  ///
         saving(uniform, replace)


* 삼각분포에 대한 중심극한정리 적용
generate t1=sqrt(runiform())
histogram t1, normal bin(30) saving(t1, replace) title(삼각분포)

forvalues repeat=2/20 {
       generate t`repeat'=sqrt(runiform())
                                 }
       
foreach n in  5 10 20 {
     egen tmean`n'=rowmean(t1-t`n')
     generate tz`n'=(tmean`n'-2/3)/(sqrt((1/18)/`n'))
     histogram tz`n', bin(30) normal saving(tz`n', replace)
                               }

graph combine t1.gph tz5.gph tz10.gph tz20.gph, col(1) ysize(12) xsize(4) ///
         saving(triangle, replace)
 

* 베타분포에 대한 중심극한정리 적용
generate b1=rbeta(0.7,0.7)
histogram b1, normal bin(30) saving(b1, replace) title(베타분포(0.5, 0.5))

forvalues repeat=2/20 {
         generate b`repeat'=rbeta(0.7,0.7)
                                 }
       
foreach n in  5 10 20 {
    egen bmean`n'=rowmean(b1-b`n')
    generate bz`n'=(bmean`n'-0.5)/(sqrt(0.103/`n'))
    histogram bz`n', bin(30) normal saving(bz`n', replace)
                              }
 
graph combine b1.gph bz5.gph bz10.gph bz20.gph, col(1) ysize(12) xsize(4) ///
         saving(beta, replace)
  
graph combine uniform.gph triangle.gph beta.gph, col(3) ysize(12) xsize(10)

/*
베타분포의 평균: a/(a+b)
베타분포의 분산: a*b/[(a+b)^2 * (a+b+1) ]
generate b25=rbeta(2,5)  // 좌측으로 왜곡
generate b51=rbeta(5,1)  // 우측 삼각
generate b13=rbeta(1,3)  // 좌측 삼각
generate b07=rbeta(0.7,0.7)  // 좌우측 빈도많음

a b 평균 분산
2 5 0.286 0.026
5 1 0.833 0.020
1 3 0.250 0.038
0.7 0.7 0.500 0.104
*/
