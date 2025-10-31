# 정규분포 pdf, cdf
clear
set obs 100 

gen z = (_n-50)/10
gen normdist = normalden(z)
gen cumnorm = normal(z)

twoway (line normdist z) (line cumnorm z)

# 로지스틱 분포 pdf, cdf
gen logdist = logisticden(z)
gen cumlog = logistic(z)

twoway (line logdist z) (line cumlog z)

# 정규분포와 로지스틱 분포
twoway (line normdist z)  (line logdist z) 
twoway (line cumnorm z) (line cumlog z)



# 사례 
clear
input income	golf
120	0
130	0
140	0
150	0
250	1
260	1
270	1
280	1
160	0
170	0
180	0
210	1
220	1
230	0
240	0
250	0
190	0
200	0
210	0
220	0
230	1
240	1
290	1
300	1
310	1
320	1
330	1
end

scatter(golf income) 

regress golf income
predict lpm_golf
gen error = golf-lpm_golf
twoway (scatter golf income) (line lpm_golf income)
scatter error income
scatter error lpm_golf



logit golf income
predict lgt_golf
gsort lgt_golf
twoway (scatter golf income) (line lgt_golf income)
gen lgterror = golf-lgt_golf
scatter lgterror income
scatter lgterror lgt_golf



probit golf income
predict prb_golf
gsort prb_golf
twoway (scatter golf income) (line prb_golf income)


twoway (scatter golf income) (line lgt_golf income) (line lpm_golf income) (line prb_golf incom)




