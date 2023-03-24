---
title: "ローリングハッシュ"
permalink: /posts/rollinghash
writer: 0214sh7
layout: library
---

MOD $$2^{61}-1$$と$$2$$基底を採用しています　[例の記事](https://trap.jp/post/900/)はいったい･･･<br>
基底はコード中のBaseを直にいじれば変更できます ここサポートした方がいいのかな？


init
- ~~文字列~~ long longのvector $$S$$ を与えると、前計算として$$S$$をハッシュする他、getの計算で使用する数値を計算する
- 計算量は基底の数を$$b$$として、$$Ο(b\vert S \vert)$$

rollinghash
- コンストラクタ。initを呼ぶ

get
- 半開区間$$[l,r)$$を与えると、$$S$$の$$[l,r)$$文字目のハッシュ値を返す
- 計算量は基底の数を$$b$$として、$$Ο(b)$$

instant
- ~~文字列~~ long longのvector $$P$$を与えると、initに与えた$$S$$とは関係なく$$P$$のハッシュ値を計算し返す
- ただ返すだけで、initで揃えた情報を変更することはない
- 計算量は基底の数を$$b$$として、$$Ο(b\vert P \vert)$$

connect
- ~~文字列~~ long longのvector $$P,Q$$ のハッシュ結果と列の長さを与えると、initに与えた$$S$$とは関係なく$$P,Q$$の結合vector$$P+Q$$のハッシュ値を計算し返す
- ただ返すだけで、initで揃えた情報を変更することはない
- 計算量は基底の数を$$b$$、$$P$$の長さを$$p$$として、$$Ο(b \log{p})$$


[github](https://github.com/0214sh7/procon-library/blob/master/algorithm/rollinghash.cpp)

```
class rollinghash{
    /*
    Copyright (c) 2023 0214sh7
    https://github.com/0214sh7/library/
    */
    private:
    static constexpr long long mod = (1LL << 61)-1;
    std::vector<long long> Base = {12345,10000000};
    std::vector<long long> BaseInv;
    std::vector<std::vector<long long>> BaseInvExp;
    static constexpr long long h = 100;
    
    long long product(long long a,long long b){
        static constexpr long long m = 1LL << 31;
        long long a1 = a/m,a2 = a%m;
        long long b1 = b/m,b2 = b%m;
        
        long long r = 0 , s;
        r = (r + 2*a1*b1) % mod;
        s = (a1*b2 + b1*a2) % mod;
        long long s1 = s/m,s2 = s%m;
        s = (2*s1+m*s2) % mod;
        r = (r + s) % mod;
        r = (r + a2*b2) % mod;
        
        return r;
    }
    
    long long power(long long b,long long e){
        long long r=1;
        while(e){
            if(e&1){
                r=product(r,b)%mod;
            }
                b=product(b,b)%mod;
                e >>=1;
        }
        return r;
    }
    
    public:
    std::vector<long long> S;
    std::vector<std::vector<long long>> H,Hsum;
    
    void init(std::vector<long long> cs){
        S=cs;
        int n=S.size();
        
        BaseInv.resize(Base.size());
        BaseInvExp.resize(Base.size());
        H.resize(Base.size());
        Hsum.resize(Base.size());
        for(int i=0;i<(int)Base.size();i++){
            BaseInvExp[i].assign(n+1,1);
            H[i].assign(n+1,0);
            Hsum[i].assign(n+1,0);
        }
        
        //逆元
        for(int i=0;i<(int)Base.size();i++){
            BaseInv[i]=power(Base[i],mod-2);
        }
        for(int i=0;i<(int)Base.size();i++){
            for(int j=0;j<n;j++){
                BaseInvExp[i][j+1] = product(BaseInvExp[i][j],BaseInv[i]);
            }
        }
        
        //本体
        for(int i=0;i<(int)Base.size();i++){
            long long b=1;
            for(int j=0;j<n;j++){
                H[i][j]=product(b,S[j]+h);
                b=product(b,Base[i]);
            }
        }
        
        //累積和
        for(int i=0;i<(int)Base.size();i++){
            for(int j=0;j<n;j++){
                Hsum[i][j+1]=(Hsum[i][j]+H[i][j])%mod;
            }
        }
    }
    
    rollinghash(std::vector<long long> C){
        init(C);
    }
    
    std::vector<long long> get(int l,int r){
        std::vector<long long> R(Base.size());
        for(int i=0;i<(int)Base.size();i++){
            long long g = (Hsum[i][r]-Hsum[i][l]+mod)%mod;
            g=product(g,BaseInvExp[i][l]);
            R[i] = g;
        }
        return R;
    }
    
    std::vector<long long> instant(std::vector<long long> P){
        std::vector<long long> R;
        for(int i=0;i<(int)Base.size();i++){
            long long r = 0, b = 1;
            for(int j=0;j<(int)P.size();j++){
                r = (r+product(b,P[j]+h))%mod;
                b = product(b,Base[i]);
            }
            R.push_back(r);
        }
        return R;
    }
    
    std::vector<long long> connect(std::vector<long long> P,long long ps,std::vector<long long> Q,long long qs){
        std::vector<long long> R;
        for(int i=0;i<(int)Base.size();i++){
            long long r = (product(Q[i],power(Base[i],ps))+P[i])%mod;
            R.push_back(r);
        }
        return R;
        assert(qs==qs);
    }
    
};
```

## 使用例
***

### 実行コード
```
#include <bits/stdc++.h>

class rollinghash{/*省略*/};

int main() {
    
    rollinghash rolihash({'a','b','c','a','b'});
    
    std::cout << "\"abcab\"の[0,2)文字目、つまり\"ab\"のハッシュ値" << std::endl;
    std::vector<long long> a = rolihash.get(0,2);
    for(int i=0;i<a.size();i++){
        std::cout << a[i] << " ";
    }
    std::cout << std::endl << std::endl;
    
    std::cout << "\"abcab\"の[1,4)文字目、つまり\"bca\"のハッシュ値" << std::endl;
    std::vector<long long> b = rolihash.get(1,4);
    for(int i=0;i<b.size();i++){
        std::cout << b[i] << " ";
    }
    std::cout << std::endl << std::endl;
    
    std::cout << "\"abcab\"の[3,5)文字目、つまり\"ab\"のハッシュ値" << std::endl;
    std::vector<long long> c = rolihash.get(3,5);
    for(int i=0;i<c.size();i++){
        std::cout << c[i] << " ";
    }
    std::cout << std::endl << std::endl;
    
    std::cout << "\"bc\"のハッシュ値" << std::endl;
    std::vector<long long> d = rolihash.instant({'b','c'});
    for(int i=0;i<d.size();i++){
        std::cout << d[i] << " ";
    }
    std::cout << std::endl << std::endl;
    
    std::cout << "\"a\"のハッシュ値" << std::endl;
    std::vector<long long> e = rolihash.instant({'a'});
    for(int i=0;i<e.size();i++){
        std::cout << e[i] << " ";
    }
    std::cout << std::endl << std::endl;

    std::cout << "\"bc\"と\"a\"の結合、つまり\"bca\"のハッシュ値" << std::endl;
    std::vector<long long> f = rolihash.connect(d,2,e,1);
    for(int i=0;i<f.size();i++){
        std::cout << f[i] << " ";
    }
    std::cout << std::endl << std::endl;
    
    return 0;
}
```

### 出力
```
"abcab"の[0,2)文字目、つまり"ab"のハッシュ値
2444507 1980000197 

"abcab"の[1,4)文字目、つまり"bca"のハッシュ値
30025064778 19700001990000198 

"abcab"の[3,5)文字目、つまり"ab"のハッシュ値
2444507 1980000197 

"bc"のハッシュ値
2456853 1990000198 

"a"のハッシュ値
197 197 

"bc"と"a"の結合、つまり"bca"のハッシュ値
30025064778 19700001990000198 
```

## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/03/25 | connectを追加 |
| 2023/03/25 | ハッシュ対象をstringからvector<long long>に変更 |
| 2022/06/26 | constexprによる最適化を実行 |
| 2021/08/31 | instantを追加 |
| 2021/04/01 | ローリングハッシュを追加 |

## 確認した問題

| 問題 | 提出 |
| :---: | :--- |
| [ABC141-E](https://atcoder.jp/contests/abc141/tasks/abc141_e) | [提出](https://atcoder.jp/contests/abc141/submissions/39997036) |