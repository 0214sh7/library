---
title: "二項係数"
permalink: /posts/binomial-coefficient
writer: 0214sh7
layout: library
---


init
- 整数$$N$$を与えると、combを実行するのに必要な数値(階乗とその逆元)を前計算する
- 計算量は$$Ο(N)$$

extension
- initで用意した範囲で足りない場合、整数$$N$$を与えると不足分を追加で前計算する
- 計算量は実行前のサイズを$$s$$として、$$Ο(N-s+log(MOD))$$

comb
- 整数$$n,r$$を与えると、$$\frac{n!}{r!(n-r)!}$$を$$MOD$$で割った余りを返す
- もしこれを計算するための前計算が不足している場合、ちょうど補完するようにextensionが実行される
- このため、計算量を気にしなければinitは呼ばなくても良い
- また最初にinitに十分な値を与えていればextensionは呼ばれない
- 計算量はextensionのもの+$$Ο(1)$$

[github](https://github.com/0214sh7/procon-library/blob/master/math/binomial%20coefficient.cpp)

~~~
class binomial_coefficient{
    /*
    Copyright (c) 2021 0214sh7
    https://github.com/0214sh7/library/
    */
    private:
    const long long MOD = 998244353;
    int sze = 0;
    std::vector<long long> fact;
    std::vector<long long> factinv;
    
    long long Gfinv(long long b){
        long long r=1;
        long long e=MOD-2;
        while(e){
            if(e&1){
                r=(r*b)%MOD;
            }
                b=(b*b)%MOD;
                e >>=1;
        }
        return r;
    }
    
    public:
    
    void init(int N){
        if(N<0){
            return ;
        }
        sze = N+1;
        fact.resize(N+1);
        factinv.resize(N+1);
        
        fact[0]=1;
        for(long long i=1;i<=N;i++){
            fact[i]=(fact[i-1]*i)%MOD;
        }
        factinv[N] = Gfinv(fact[N]);
        for(long long i=N-1;i>=0;i--){
            factinv[i]=(factinv[i+1]*(i+1))%MOD;
        }
    }
    
    void extension(int N){
        if(sze>N && sze!=0){
            return ;
        }
        
        fact.resize(N+1);
        factinv.resize(N+1);
        
        fact[sze]=(sze==0)?1:(fact[sze-1]*sze)%MOD;
        
        for(long long i=sze+1;i<=N;i++){
            fact[i]=(fact[i-1]*i)%MOD;
        }
        factinv[N] = Gfinv(fact[N]);
        for(long long i=N-1;i>=sze;i--){
            factinv[i]=(factinv[i+1]*(i+1))%MOD;
        }
        sze = N+1;
    }
    
    long long comb(long long n,long long r){
        if(n<0 || r<0 || n<r){
            return 0;
        }
        
        if(n>=sze){
            extension(n);
        }
        
        long long R = fact[n];
        R = (R*factinv[r])%MOD;
        R = (R*factinv[n-r])%MOD;
        return R;
    }
};
~~~