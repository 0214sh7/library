---
title: "ローリングハッシュ"
permalink: /posts/rollinghash
writer: 0214sh7
layout: library
---

MOD $$2^{61}-1$$と$$2$$基底を採用しています　[例の記事](https://trap.jp/post/900/)はいったい･･･<br>
基底はコード中のBaseを直にいじれば変更できます ここサポートした方がいいのかな？


init
- 文字列$$S$$を与えると、前計算として$$S$$をハッシュする他、getの計算で使用する数値を計算する
- 計算量は基底の数を$$b$$として、$$Ο(b\vert S \vert)$$

rollinghash
- コンストラクタ。initを呼ぶ

get
- 半開区間$$[l,r)$$を与えると、$$S$$の$$[l,r)$$文字目のハッシュ値を返す
- 計算量は基底の数を$$b$$として、$$Ο(b)$$


[github](https://github.com/0214sh7/procon-library/blob/master/algorithm/rollinghash.cpp)

```
class rollinghash{
    /*
    Copyright (c) 2021 0214sh7
    https://github.com/0214sh7/library/
    */
    private:
    const long long mod = (1LL << 61)-1;
    std::vector<long long> Base = {12345,10000000};
    std::vector<long long> BaseInv;
    std::vector<std::vector<long long>> BaseInvExp;
    const long long h = 100;
    
    long long product(long long a,long long b){
        const long long m = 1LL << 31;
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
    std::string S;
    std::vector<std::vector<long long>> H,Hsum;
    
    void init(std::string cs){
        S=cs;
        int n=S.size();
        
        BaseInv.resize(Base.size());
        BaseInvExp.resize(Base.size());
        H.resize(Base.size());
        Hsum.resize(Base.size());
        for(int i=0;i<Base.size();i++){
            BaseInvExp[i].assign(n+1,1);
            H[i].assign(n+1,0);
            Hsum[i].assign(n+1,0);
        }
        
        //逆元
        for(int i=0;i<Base.size();i++){
            BaseInv[i]=power(Base[i],mod-2);
        }
        for(int i=0;i<Base.size();i++){
            for(int j=0;j<n;j++){
                BaseInvExp[i][j+1] = product(BaseInvExp[i][j],BaseInv[i]);
            }
        }
        
        //本体
        for(int i=0;i<Base.size();i++){
            long long b=1;
            for(int j=0;j<n;j++){
                H[i][j]=product(b,S[j]+h);
                b=product(b,Base[i]);
            }
        }
        
        //累積和
        for(int i=0;i<Base.size();i++){
            for(int j=0;j<n;j++){
                Hsum[i][j+1]=(Hsum[i][j]+H[i][j])%mod;
            }
        }
    }
    
    rollinghash(std::string S){
        init(S);
    }
    
    std::vector<long long> get(int l,int r){
        std::vector<long long> R;
        for(int i=0;i<Base.size();i++){
            long long g = (Hsum[i][r]-Hsum[i][l]+mod)%mod;
            g=product(g,BaseInvExp[i][l]);
            R.push_back(g);
        }
        return R;
    }
    
};
```

## 使用例
***

### 実行コード
```
#include <bits/stdc++.h>

class rollinghash{/*省略*/};

signed main() {
    
    rollinghash rolihash("abcab");
    
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
```

## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2021/04/01 | ローリングハッシュを追加 |