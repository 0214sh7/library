---
title: "二項係数"
permalink: /posts/binomial-coefficient
writer: 0214sh7
layout: library
---

整数$$N$$を与えると、sizeが$$N+1$$のvectorが返ってくる。

vectorの$$i$$番目(0-indexed)の要素は、$$\frac{n!}{i!(n-i)!}$$を$$MOD$$の値で割った余りを表している。

$$MOD$$が素数でないときの動作は未確認

計算量は$$Ο(Nlog(MOD))$$


[github](https://github.com/0214sh7/procon-library/blob/master/math/binomial%20coefficient.cpp)

~~~
std::vector<long long> binomial_coefficient(long long N){
    /*
    Copyright (c) 2020 0214sh7
    https://github.com/0214sh7/library/
    */
    const long long MOD = 998244353;
    std::vector<long long> fac;
    std::vector<long long> facIE;
    std::vector<long long> comb;
    for(int i=0;i<=N;i++){
        if(i==0){
            fac.push_back(1);
        }else{
            fac.push_back(i*fac[i-1]%MOD);
        }
    }
    for(int i=0;i<=N;i++){
        long long r=1,b=fac[i],e=MOD-2;
        while(e){
            if(e&1){
                r=(r*b)%MOD;
            }
            b=(b*b)%MOD;
            e >>=1;
        }
        facIE.push_back(r);
    }
    for(int i=0;i<=N;i++){
        long long r=fac[N];
        r = (r*facIE[i])%MOD;
        r = (r*facIE[N-i])%MOD;
        comb.push_back(r);
    }
    return comb;
}
~~~