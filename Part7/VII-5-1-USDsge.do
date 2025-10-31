// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

 * **************************************************
* ***  동태확률일반균형(DSGE)모형의 일반적 분석절차  ****
* ***************************************************

webuse usmacro2

* DSGE모형의 설정과 추정
dsge (x = E(F.x) - (r - E(F.p) - z), unobserved) ///
        (p = {beta}*E(F.p) + {kappa}*x)               ///
        (r = 1/{beta}*p + u)                                  ///
        (F.z = {rhoz}*z, state)                             ///
        (F.u = {rhou}*u, state)

* 모형의 안정성, 추정결과를 이용한 정책효과, 전이과정 분석
estat stable
estat policy
estat transition

* 추정결과를 이용한 충격반응함수 계산과 그래프 그리기
irf set USdsge_irf
irf create model
irf graph irf, impulse(u) response(x p r u) byopts(yrescale) yline(0) 

* 예측치 계산과 그래프 그리기
* 추정구간 밖 예측(out of sample forecasting)
estimates store dsge_est
tsappend, add(12)
forecast create dsgemodel, replace
forecast estimates dsge_est
forecast solve, prefix(d1_) begin(tq(2016q1))
tsline d1_p if tin(2010q1, 2021q1), tline(2016q1)

* 추정구간내밖 예측(within sample forecasting)
forecast solve, prefix(d2_) begin(tq(2013q1))
tsline p d2_p if tin(2010q1, 2021q1), tline(2013q1)


constraint 1 _b[alpha] = 0.33
constraint 2 _b[beta] = 0.99
constraint 3 _b[delta] = 0.025
constraint 4 _b[chi] = 2

dsgenl (1/c = {beta}*(1/F.c)*(1+r-{delta}))  ///
          ({chi}*h = w/c)                             ///
          (y = c + i)                                     ///
          (y = z*k^{alpha}*h^(1-{alpha}))      /// 
          (r = {alpha}*y/k)                            ///
          (w = (1-{alpha})*y/h)                     ///
          (F.k = i + (1-{delta})*k)                    ///
          (ln(F.z) = {rho}*ln(z))                       ///
        , observed(y) unobserved(c i r w h)     ///
          exostate(z) endostate(k) constraint(1/4) 
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  