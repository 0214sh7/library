---
title: "数学詰め合わせパック"
permalink: /posts/basic-math
writer: 0214sh7
layout: library
---

優柔不断なあなたに

というのは建前で、それぞれ独立して扱うほどではないが重要なものを一箇所に集めた

[github](https://github.com/0214sh7/procon-library/blob/master/math/basic%20math%20assortment.cpp)


注記:ページ内のコードを使用する際は、以下の表記を同時に添付してください。
~~~
/*
Copyright (c) 2020 0214sh7
https://github.com/0214sh7/library/
*/
~~~


小数点以下切り上げ(天井関数)

<details>
<summary>クリックで開く</summary><div>

---
<br>
小数点以下切り上げ
- よくある天井関数
- 計算量は$$Ο(1)$$

```
//小数点以下切り上げ
long long roundup(long long a,long long b){
    /*
    Copyright (c) 2021 0214sh7
    https://github.com/0214sh7/library/
    */
    return (a+b-1)/b;
}
```
---
</div></details>



階乗
- 与えられた$$x$$に対し$$x!$$を計算する
- $$MOD$$も与えるとそれで割った余りをとる
- 計算量は$$Ο(x)$$
~~~
//階乗
long long fact(long long x,long long MOD=INT_MAX){
    long long k=1;
    for(int i=1;i<=x;i++){
        k=(k*i)%MOD;
    }
    return k;
}
~~~

最大公約数
- ２つの引数のGCDを求める
- 計算量は$$O(log(max(a,b)))$$
~~~
//最大公約数
long long gcd(long long a,long long b){
    a=std::abs(a);
    b=std::abs(b);
    if(a>b)std::swap(a,b);
    if(a==0){
        return b;
    }
    
    long long r=a%b;
    while(r){
        a=b;
        b=r;
        r=a%b;
    }
    return b;
}
~~~

最小公倍数
- ２つの引数のLCMを求める
- 計算量は$$O(log(max(a,b)))$$
~~~
//最小公倍数
long long lcm(long long a,long long b){
    if(std::abs(a)>std::abs(b))std::swap(a,b);
    if(a==0){
        return b;
    }
    
    long long s=a,t=b;
    a=std::abs(a);
    b=std::abs(b);
    if(a>b)std::swap(a,b);
    
    long long r=a%b;
    while(r){
        a=b;
        b=r;
        r=a%b;
    }
    
    return s / b * t;
}
~~~

素数判定
- 与えられた$$x$$に対し、$$x$$が素数ならtrueを、そうでないならfalseを返す
- 計算量は$$O(\sqrt{x})$$
~~~
//素数判定
bool prime(long long X){
    if(X<2)return false;
    for(long long i=2;i*i<=X;i++){
        if(X%i==0){
            return false;
        }
    }
    return true;
}
~~~

素数列挙
- 与えられた$$N$$に対し、$$N$$以下の素数を列挙し、小さい順にvectorとして返す
- 計算量は$$O(NloglogN)$$
~~~
//素数列挙
std::vector<long long> primearray(long long N){
    std::vector<long long> R;
    std::vector<bool> prime;
    for(int i=0;i<=N;i++){
        prime.push_back(true);
    }
    if(N<2){
        return R;
    }
    prime[0]=false;
    prime[1]=false;
    for(long long i=2;i*i<=N;i++){
        if(!prime[i])continue;
        for(int j=2*i;j<=N;j+=i){
            prime[j]=false;
        }
    }
    for(long long i=0;i<prime.size();i++){
        if(prime[i]){
            R.push_back(i);
        }
    }
    return R;
}
~~~

素因数分解
- 与えられた$$N$$に対し、$$N$$を素因数分解し、小さい順にvectorとして返す
- 計算量は$$Ο(\sqrt{N})$$
~~~
//素因数分解
std::vector<long long> prime_factorization(long long N){
    std::vector<long long> R;
    if(N<2)return R;
    for(long long i=2;i*i<=N;i++){
        while(N%i==0){
            R.push_back(i);
            N/=i;
        }
    }
    if(N!=1){
          R.push_back(N);
    }
    return R;
}
~~~

累乗(繰り返し二乗法)
- 与えられた$$b,e$$に対し、$$b^e$$を返す
- $$MOD$$も与えるとそれで割った余りをとる
- 計算量は$$Ο(log(e))$$
~~~
//累乗(繰り返し二乗法)
long long power(long long b,long long e,long long MOD=INT_MAX){
    long long r=1;
    while(e){
        if(e&1){
            r=(r*b)%MOD;
        }
        b=(b*b)%MOD;
        e >>=1;
    }
    return r;
}
~~~

逆元(素数MOD)
- 与えられた$$b,MOD$$に対し、$$MOD$$を法とした整数環上での逆元($$bx=1$$を満たす$$x$$)を返す
- MODが素数でない場合の動作は未確認
- 計算量は$$Ο(log(MOD))$$
~~~
//逆元(素数MOD)
long long inverse(long long b,long long MOD){
    long long r=1,e=MOD-2;
    while(e){
        if(e&1){
            r=(r*b)%MOD;
        }
        b=(b*b)%MOD;
        e >>=1;
    }
    return r;
}
~~~

