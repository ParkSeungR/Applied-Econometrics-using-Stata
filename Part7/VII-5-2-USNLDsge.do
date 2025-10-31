// 박승록(2019), 『Stata 를 이용한 응용계량경제학』, 박영사
// 웹사이트: https://sites.google.com/view/parksr-stata/

import excel "D:\statapgm\Part7\VII-5-2-USNLDsge.xlsx", sheet("data") firstrow
gen yearq=tq(1955q1)+_n-1
format yearq %tq
tsset yearq, quarterly
save VII-5-2-USNLDsge, replace

* **************************************
* *** 선형 동적확률일반균형 모형의 추정 ***
* **************************************
use VII-5-2-USNLDsge, clear

dsge (c = F.c - (1-{beta}+{beta}*{delta})*F.r, unobserved) ///
        ({eta}*h = w - c, unobserved)                                    ///
        ({phi1}*x = y - {phi2}*c - g, unobserved)                   ///
        (y = (1-{alpha})*(z+h) + {alpha}*k)                            ///
        (w = y - h, unobserved)                                             ///
        (r = y - k, unobserved)                                              ///
        (F.k = {delta}*x+ (1-{delta})*k, state noshock)          ///
        (F.z = {rhoz}*z, state)                                             ///
        (F.g = {rhog}*g, state)                                             ///
      , from(beta=0.96 eta=1 alpha=0.3 delta=0.025 phi1=0.2 phi2=0.6 rhoz=0.8 rhog=0.3) ///
        solve noidencheck

estat transition
irf set rbcirf
irf create persistent, replace
irf graph irf, irf(persistent) impulse(z) response(y c x h w z) noci byopts(yrescale)

* ***********************************************
* *** 비선형 동적확률일반균형 모형의 추정 ****
* ***********************************************
use VII-5-2-USNLDsge, clear

constraint 1 _b[alpha] = 0.33
constraint 2 _b[beta] = 0.99
constraint 3 _b[delta] = 0.025
constraint 4 _b[chi] = 2

dsgenl (1/c = {beta}*(1/F.c)*(1+r-{delta}))   ///
          ({chi}*h = w/c)                                 ///
          (y = c + i)                                         ///
          (y = z*k^{alpha}*h^(1-{alpha}))        ///
          (r = {alpha}*y/k)                               ///
          (w = (1-{alpha})*y/h)                        ///
          (F.k = i + (1-{delta})*k)                     ///
          (ln(F.z) = {rho}*ln(z))                       ///
        , observed(y) unobserved(c i r w h)     ///
	      exostate(z) endostate(k) constraint(1/4)

estat steady
estat covariance
estat policy
estat stable
estat transition
