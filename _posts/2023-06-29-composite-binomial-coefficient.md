---
title: "任意mod二項係数"
permalink: /posts/composite-binomial-coefficient
writer: 0214sh7
layout: library
---

計算量の異なる $$2$$ つのコードがある

[github](https://github.com/0214sh7/procon-library/blob/master/math/composite%20binomial%20coefficient.cpp)


- [その１]( #その１ )
  - $$n,r \leq 10^{18}, mod \leq 10^6$$ 程度の場合に計算できる
- [その２]( #その２ )
  - $$n,r \leq 10^6, mod \leq 10^9$$ 程度の場合に計算できる 

***

## その１

init
- mod $$M$$を与えると、combを実行するのに必要な数値を前計算する
- 計算量は $$M$$ の素因数分解を $$ \prod_{i=1}^{\omega(M)}{ {p_i}^{e_i}} $$ とすると $$Ο( \sum_{i=1}^{\omega(M)}{ {p_i}^{e_i}} + \sqrt{M})$$
  - $$\omega(m)$$ は $$m$$ の素因数の個数、$$m \leq 10^9$$ のとき $$\omega(m) \leq 10$$

composite_binomial_coefficient_1
- コンストラクタ。initを呼ぶ

comb
- 整数$$n,r$$を与えると、$$\frac{n!}{r!(n-r)!}$$を$$M$$で割った余りを返す
- extensionはないため、$$n$$ にinitで与えた $$N$$ より大きい値を与えた場合の挙動は保証しない
- 計算量は$$Ο( (\log n + \log M) \omega(M) )$$


```
class composite_binomial_coefficient_1{
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    private:
    long long Mod;    
    std::vector<std::array<long long,3>> P;
    std::vector<std::vector<long long>> fact,factinv;

    std::pair<long long,long long> bezout(long long a,long long b){
        if(b==0){
            return {1,0};
        }
        long long r = a%b, q = (a-r)/b;
        std::pair<long long,long long> D = bezout(b,r);
        return {D.second,D.first-q*D.second};
    }

    public:

    void init(long long M){

        if(M<1){
            return;
        }

        Mod = M;

        //Mを素因数分解する
        //Pは{素数,個数,素数^個数}
        P.clear();
        long long m = M;
        for(int i=2;i*i<=m;i++){
            int v = 1;
            int e = 0;
            while(m%i==0){
                e++;
                m /= i;
                v *= i;
            }
            if(e>0){
                P.push_back({i,e,v});
            }
        }
        if(m!=1){
            P.push_back({m,1,m});
        }

        //用いる素数pについて、(x!)_p := (1~xでpと互いに素なものの積)を求める
        fact.clear();
        fact.resize(P.size());
        factinv.clear();
        factinv.resize(P.size());

        for(int i=0;i<(int)P.size();i++){
            fact[i].resize(P[i][2]);
            fact[i][0] = 1;
            for(int j=1;j<P[i][2];j++){
                if(j%P[i][0]==0){
                    fact[i][j] = fact[i][j-1];
                }else{
                    fact[i][j] = (fact[i][j-1]*j)%P[i][2];
                }
            }

            factinv[i].resize(P[i][2]);
            factinv[i][P[i][2]-1] = bezout(fact[i][P[i][2]-1],P[i][2]).first;
            if(factinv[i][P[i][2]-1]<0)factinv[i][P[i][2]-1] += P[i][2];
            
            for(int j=P[i][2]-2;j>=0;j--){
                if((j+1)%P[i][0]==0){
                    factinv[i][j] = factinv[i][j+1];
                }else{
                    factinv[i][j] = (factinv[i][j+1]*(j+1))%P[i][2];
                }
            }
        }
    }

    composite_binomial_coefficient_1(long long mod){
        init(mod);
    }

    long long comb(long long n,long long r){
        
        if(n<0 || r<0 || n<r || Mod==1){
            return 0;
        }
        long long k = n-r;

        //各p^qについてnCr mod p^qを求めてLにまとめる
        std::vector<std::pair<long long,long long>> L(P.size());

        for(int i=0;i<(int)P.size();i++){
            long long p = P[i][0], q = P[i][1], pq = P[i][2];

            std::vector<long long> N,K,R;
            long long nown = n, nowk = k, nowr = r;
            while(nown>0){
                N.push_back(nown%pq);
                K.push_back(nowk%pq);
                R.push_back(nowr%pq);
                nown /= p;
                nowk /= p;
                nowr /= p;
            }

            long long e0 = 0, e1 = 0;
            nown = n/p, nowk = k/p, nowr = r/p;
            while(nown > 0){
                e0 += nown;
                e0 -= nowk;
                e0 -= nowr;
                nown /= p;
                nowk /= p;
                nowr /= p;
            }
            nown = n/pq, nowk = k/pq, nowr = r/pq;
            while(nown > 0){
                e1 += nown;
                e1 -= nowk;
                e1 -= nowr;
                nown /= p;
                nowk /= p;
                nowr /= p;
            }
            
            long long T = 1;
            if((p!=2 || q<3) && e1%2 == 1){
                T = pq-1;
            }

            for(int j=0;j<(int)N.size();j++){
                T = (T*fact[i][N[j]])%pq;
                T = (T*factinv[i][K[j]])%pq;
                T = (T*factinv[i][R[j]])%pq;
            }

            for(int j=0;j<std::min(q,e0);j++){
                T = (T*p)%pq;
            }

            L[i] = {T,pq};
        }

        //中国剰余定理を用いて復元する
        std::pair<long long,long long> C = L[0];
        for(int i=1;i<(int)P.size();i++){
            long long q = C.second*L[i].second;
            std::pair<long long,long long> u = bezout(C.second,L[i].second);
            long long c = (((C.first*L[i].second)%q)*u.second)%q;
            long long d = (((L[i].first*C.second)%q)*u.first)%q;
            C.first = (c+d+q)%q;
            C.second = q;
        }

        return C.first;
    }
};
```


### 使用例
***

#### 実行コード
```
#include <bits/stdc++.h>

class composite_binomial_coefficient_1{/*省略*/};

int main(void){
    
    std::cout << "10で割ったあまり" << std::endl; 
    composite_binomial_coefficient_1 CBC(10);
    for(int i=0;i<=8;i++){
        for(int j=0;j<=i;j++){
            std::cout << CBC.comb(i,j) << " ";
        }std::cout << std::endl;
    }
    std::cout << std::endl;

    std::cout << "もとの値" << std::endl;
    composite_binomial_coefficient_1 CBC_origin(1000);
    for(int i=0;i<=8;i++){
        for(int j=0;j<=i;j++){
            std::cout << CBC_origin.comb(i,j) << " ";
        }std::cout << std::endl;
    }
    
    return 0;
}
```

#### 出力
```
10で割ったあまり
1 
1 1 
1 2 1 
1 3 3 1 
1 4 6 4 1 
1 5 0 0 5 1 
1 6 5 0 5 6 1 
1 7 1 5 5 1 7 1 
1 8 8 6 0 6 8 8 1 

もとの値
1 
1 1 
1 2 1 
1 3 3 1 
1 4 6 4 1 
1 5 10 10 5 1 
1 6 15 20 15 6 1 
1 7 21 35 35 21 7 1 
1 8 28 56 70 56 28 8 1 

```

### 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2023/03/18 | 任意mod二項係数を追加 |

## 確認した問題

| 問題 | 提出 |
| :---: | :--- |
| [Library Checker](https://judge.yosupo.jp/problem/binomial_coefficient) | [提出](https://judge.yosupo.jp/submission/130133) |

***


## その２

init
- 整数$$N$$とmod $$M$$を与えると、combを実行するのに必要な数値を前計算する
- 計算量は $$Ο(N \log N + N \omega(M) + \sqrt{M})$$
  - $$\omega(m)$$ は $$m$$ の素因数の個数、$$m \leq 10^9$$ のとき $$\omega(m) \leq 10$$
<!-- √M + Nω(M) + Ω(N!) , もっとタイトな評価ができそう -->

composite_binomial_coefficient_2
- コンストラクタ。initを呼ぶ

comb
- 整数$$n,r$$を与えると、$$\frac{n!}{r!(n-r)!}$$を$$M$$で割った余りを返す
- extensionはないため、$$n$$ にinitで与えた $$N$$ より大きい値を与えた場合の挙動は保証しない
- 計算量は$$Ο(\log M + \omega(M) )$$
  - 特に、 $$n,r$$ に依存しない


```
class composite_binomial_coefficient_2{
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    private:
    int sze = 0;
    long long Mod;
    std::vector<long long> P;
    std::vector<long long> d,prime;
    std::vector<int> index;
    std::vector<long long> factPri;
    std::vector<std::vector<long long>> factRel;
    std::vector<std::vector<long long>> power;

    std::pair<long long,long long> bezout(long long a,long long b){
        if(b==0){
            return {1,0};
        }
        long long r = a%b, q = (a-r)/b;
        std::pair<long long,long long> D = bezout(b,r);
        return {D.second,D.first-q*D.second};
    }

    public:

    void init(int N,long long M){

        if(N<0 || M<1){
            return;
        }

        if(M==1){
            Mod = M;
            return;
        }

        sze = N+1;
        Mod = M;
        
        //1~Nの非自明な約数を求める
        d.resize(N+1);
        std::fill(d.begin(),d.end(),0);
        prime.clear();
        index.resize(N+1);
        std::fill(index.begin(),index.end(),-1);

        if(N>0){
            d[1] = 1;
        }
        for(long long i=2;i<=N;i++){
            if(d[i]==0){
                d[i]=i;
                prime.push_back(i);
            }
            for(int j=0;j<(int)prime.size() && prime[j]<=d[i] && i*prime[j]<=N ;j++){
                d[prime[j]*i]=prime[j];
            }
        }
        
        //法が含む素数のリストを求める
        P.clear();
        for(int i=2;i*i<=M;i++){
            int e = 0;
            while(M%i==0){
                e++;
                M /= i;
            }
            if(e>0){
                if(i<=N)index[i] = P.size();
                P.push_back(i);
            }
        }
        if(M!=1){
            if(M<=N)index[M] = P.size();
            P.push_back(M);
        }

        //k!について、Mと互いに素である部分とそうでない部分に分けてそれぞれ求める
        factPri.resize(N+1);
        std::fill(factPri.begin(),factPri.end(),1);
        factRel.resize(N+1);
        for(int i=0;i<=N;i++){
            factRel[i].resize(P.size());
            std::fill(factRel[i].begin(),factRel[i].end(),0);
        }

        for(int i=2;i<=N;i++){

            factPri[i] = factPri[i-1];
            factRel[i] = factRel[i-1];

            long long now = i;
            while(now>1){
                long long p = d[now];
                if(index[p]==-1){
                    factPri[i] = (factPri[i]*p)%Mod;
                }else{
                    factRel[i][index[p]]++;
                }
                now /= p;
            }
        }

        //p^0,p^1,...,p^(N/p)を前計算する
        power.resize(P.size());
        for(int i=0;i<(int)P.size();i++){
            power[i].resize(1+N/P[i]);
            power[i][0] = 1;
            for(int j=1;j<1+N/P[i];j++){
                power[i][j] = (power[i][j-1]*P[i])%Mod;
            }
        }

    }

    composite_binomial_coefficient_2(int N,long long M){
        init(N,M);
    }

    long long comb(long long n,long long r){
        if(Mod==1){
            return 0;
        }
        if(n<0 || r<0 || n<r){
            return 0;
        }

        long long R = factPri[n];
        long long m = bezout(factPri[r],Mod).first;
        if(m<0)m+=Mod;
        R = (R*m)%Mod;
        m = bezout(factPri[n-r],Mod).first;
        if(m<0)m+=Mod;
        R = (R*m)%Mod;

        for(int i=0;i<(int)P.size();i++){
            int e = factRel[n][i] - factRel[r][i] - factRel[n-r][i];
            assert(e>=0);
            R = (R*power[i][e])%Mod;
        }

        return R;
    }

};
```


### 使用例
***

#### 実行コード
```
#include <bits/stdc++.h>

class composite_binomial_coefficient_2{/*省略*/};

int main(void){
    
    std::cout << "10で割ったあまり" << std::endl; 
    composite_binomial_coefficient_2 CBC(8,10);
    for(int i=0;i<=8;i++){
        for(int j=0;j<=i;j++){
            std::cout << CBC.comb(i,j) << " ";
        }std::cout << std::endl;
    }
    std::cout << std::endl;

    std::cout << "もとの値" << std::endl;
    composite_binomial_coefficient_2 CBC_origin(8,1000);
    for(int i=0;i<=8;i++){
        for(int j=0;j<=i;j++){
            std::cout << CBC_origin.comb(i,j) << " ";
        }std::cout << std::endl;
    }
    
    return 0;
}
```

#### 出力
```
10で割ったあまり
1 
1 1 
1 2 1 
1 3 3 1 
1 4 6 4 1 
1 5 0 0 5 1 
1 6 5 0 5 6 1 
1 7 1 5 5 1 7 1 
1 8 8 6 0 6 8 8 1 

もとの値
1 
1 1 
1 2 1 
1 3 3 1 
1 4 6 4 1 
1 5 10 10 5 1 
1 6 15 20 15 6 1 
1 7 21 35 35 21 7 1 
1 8 28 56 70 56 28 8 1 

```

### 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2023/03/18 | 任意mod二項係数を追加 |

## 確認した問題

| 問題 | 提出 |
| :---: | :--- |
| [ARC012-D](https://atcoder.jp/contests/arc012/tasks/arc012_4) | [提出](https://atcoder.jp/contests/arc012/submissions/39798965) |