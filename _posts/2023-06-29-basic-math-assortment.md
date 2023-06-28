---
title: "数学詰め合わせパック"
permalink: /posts/basic-math
writer: 0214sh7
layout: library
---

優柔不断なあなたに

というのは建前で、それぞれ独立して扱うほどではないが重要なものを一箇所に集めた

[github](https://github.com/0214sh7/procon-library/blob/master/math/basic%20math%20assortment.cpp)



# もくじ
- [小数点以下切り上げ(天井関数)]( #小数点以下切り上げ天井関数 )
- [階乗]( #階乗 )
- [最大公約数]( #最大公約数 )
- [最小公倍数]( #最小公倍数 )
- [約数列挙]( #約数列挙 )
- [素数判定]( #素数判定 )
- [素数列挙]( #素数列挙 )
- [素因数分解]( #素因数分解 )
- [累乗(繰り返し二乗法)]( #累乗繰り返し二乗法 )
- [逆元(素数MOD)]( #逆元素数mod )


---

## 小数点以下切り上げ(天井関数)

- よくある天井関数
- 計算量は$$Ο(1)$$

```cpp
long long roundup(long long a,long long b){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    return (a+b-1)/b;
}
```

### 使用例

#### 実行コード
```cpp
#include <bits/stdc++.h>

long long roundup(long long a,long long b){/*省略*/}

int main(void){
    
    for(int i=0;i<=10;i++){
        std::cout << i << " ";
    }
    std::cout << std::endl;
    for(int i=0;i<=10;i++){
        std::cout << roundup(i,4) << " ";
    }
    
    return 0;
}
```

#### 出力
```
0 1 2 3 4 5 6 7 8 9 10 
0 1 1 1 1 2 2 2 2 3 3 
```

[もくじに戻る](#もくじ)

---

## 階乗

- 与えられた$$x$$に対し$$x!$$を計算する
- $$MOD$$も与えるとそれで割った余りをとる
- 計算量は$$Ο(x)$$

```cpp
long long fact(long long x,long long MOD=LLONG_MAX){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    long long k=1;
    for(int i=1;i<=x;i++){
        k=(k*i)%MOD;
    }
    return k;
}
```

### 使用例

#### 実行コード
```cpp
#include <bits/stdc++.h>

long long fact(long long x,long long MOD=LLONG_MAX){/*省略*/}

int main(void){
    
    for(int i=0;i<=6;i++){
        std::cout << fact(i) << " ";
    }
    
    return 0;
}
```

#### 出力
```
1 1 2 6 24 120 720 
```

[もくじに戻る](#もくじ)

---

## 最大公約数

- ２つの引数のGCDを求める
- 計算量は$$O(log(max(a,b)))$$

```cpp
long long gcd(long long a,long long b){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
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
```

### 使用例

#### 実行コード
```cpp
#include <bits/stdc++.h>

long long gcd(long long a,long long b){/*省略*/}

int main(void){
    
    std::cout << gcd(4,6) << std::endl;
    std::cout << gcd(3,5) << std::endl;
    std::cout << gcd(12,18) << std::endl;
    std::cout << gcd(8,13) << std::endl;
    
    return 0;
}
```

#### 出力
```
2
1
6
1
```

[もくじに戻る](#もくじ)

---

## 最小公倍数

- ２つの引数のLCMを求める
- 計算量は$$O(log(max(a,b)))$$

```cpp
long long lcm(long long a,long long b){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
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
```

### 使用例

#### 実行コード
```cpp
#include <bits/stdc++.h>

long long lcm(long long a,long long b){/*省略*/}

int main(void){
    
    std::cout << lcm(4,6) << std::endl;
    std::cout << lcm(3,5) << std::endl;
    std::cout << lcm(12,18) << std::endl;
    std::cout << lcm(8,13) << std::endl;
    
    return 0;
}
```

#### 出力
```
12
15
36
104
```

[もくじに戻る](#もくじ)

---

## 約数列挙

- 自然数$$N$$を与えると、$$N$$の正の約数を小さい順に並べたvectorを返す
- 正でない数を与えると空のvectorを返す
- 計算量は$$O(\sqrt{N})$$

```cpp
std::vector<long long> divisor_enum(long long N){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    std::vector<long long> R;
    if(N<=0)return R;
    long long s=0;
    for(long long i=1;i*i<=N;i++){
        if(N%i==0){
            R.push_back(i);
            if(i*i!=N)s++;
        }
    }
    for(long long i = s-1;i>=0;i--){
        R.push_back(N/R[i]);
    }
    return R;
}
```

### 使用例

#### 実行コード
```cpp
#include <bits/stdc++.h>

std::vector<long long> divisor_enum(long long N){/*省略*/}

signed main() {
    
    for(long long i=1;i<=10;i++){
        std::cout << i << "  ";
        std::vector<long long> K = divisor_enum(i);
        for(long long j=0;j<K.size();j++){
            std::cout << K[j] << " ";
        }
        std::cout << std::endl;
    }
    
    return 0;
}
```

#### 出力
```
1  1 
2  1 2 
3  1 3 
4  1 2 4 
5  1 5 
6  1 2 3 6 
7  1 7 
8  1 2 4 8 
9  1 3 9 
10  1 2 5 10 
```

[もくじに戻る](#もくじ)

---

## 素数判定

- 与えられた$$x$$に対し、$$x$$が素数ならtrueを、そうでないならfalseを返す
- 計算量は$$O(\sqrt{x})$$

```cpp
bool prime(long long X){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    if(X<2)return false;
    for(long long i=2;i*i<=X;i++){
        if(X%i==0){
            return false;
        }
    }
    return true;
}
```

### 使用例

#### 実行コード
```cpp
#include <bits/stdc++.h>

bool prime(long long X){/*省略*/}

int main(void){
    
    for(int i=0;i<=10;i++){
        std::cout << i << " ";
    }
    std::cout << std::endl;
    
    for(int i=0;i<=10;i++){
        std::cout << prime(i) << " ";
    }
    
    return 0;
}
```

#### 出力
```
0 1 2 3 4 5 6 7 8 9 10 
0 0 1 1 0 1 0 1 0 0 0 
```

[もくじに戻る](#もくじ)

---

## 素数列挙

- 与えられた$$N$$に対し、$$N$$以下の素数を列挙し、小さい順にvectorとして返す
- 計算量は$$O(NloglogN)$$

```cpp
std::vector<long long> primearray(long long N){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
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
```

### 使用例

#### 実行コード
```cpp
#include <bits/stdc++.h>

std::vector<long long> primearray(long long N){/*省略*/}

int main(void){
    
    std::vector<long long> P = primearray(100);
    for(int i=0;i<P.size();i++){
        std::cout << P[i] << " ";
    }
    std::cout << std::endl;
    
    return 0;
}
```

#### 出力
```
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 
```

[もくじに戻る](#もくじ)

---

## 素因数分解

- 与えられた$$N$$に対し、$$N$$を素因数分解し、小さい順にvectorとして返す
- 計算量は$$Ο(\sqrt{N})$$

```cpp
std::vector<long long> prime_factorization(long long N){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
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
```

### 使用例

#### 実行コード
```cpp
#include <bits/stdc++.h>

std::vector<long long> prime_factorization(long long N){/*省略*/}

int main(void){
    
    std::vector<long long> number={4,12,57,97,210};
    for(int j=0;j<5;j++){
        std::cout << number[j] << "  ";
        std::vector<long long> F = prime_factorization(number[j]);
        for(int i=0;i<F.size();i++){
            std::cout << F[i] << " ";
        }std::cout << std::endl;
    }
    std::cout << std::endl;
    
    return 0;
}
```

#### 出力
```
4  2 2 
12  2 2 3 
57  3 19 
97  97 
210  2 3 5 7 
```

[もくじに戻る](#もくじ)

---

## 累乗(繰り返し二乗法)

- 与えられた$$b,e$$に対し、$$b^e$$を返す
- $$MOD$$も与えるとそれで割った余りをとる
- 計算量は$$Ο(log(e))$$

```cpp
long long power(long long b,long long e,long long MOD=LLONG_MAX){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
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
```

### 使用例

#### 実行コード
```cpp
#include <bits/stdc++.h>

long long power(long long b,long long e,long long MOD=LLONG_MAX){/*省略*/}

int main(void){
    
    std::cout << "2のi乗"<< std::endl;
    for(int i=0;i<=10;i++){
        std::cout << power(2,i) << " ";
    }
    std::cout << std::endl;
    
    std::cout << "2のi乗を100で割ったあまり"<< std::endl;
    for(int i=0;i<=10;i++){
        std::cout << power(2,i,100) << " ";
    }
    
    return 0;
}
```

#### 出力
```
2のi乗
1 2 4 8 16 32 64 128 256 512 1024 
2のi乗を100で割ったあまり
1 2 4 8 16 32 64 28 56 12 24
```

[もくじに戻る](#もくじ)

---

## 逆元(素数MOD)

- 与えられた$$b,MOD$$に対し、$$MOD$$を法とした整数環上での逆元($$bx=1$$を満たす$$x$$)を返す
- MODが素数でない場合の動作は未確認
- 計算量は$$Ο(log(MOD))$$

```cpp
long long inverse(long long b,long long MOD){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
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
```

### 使用例

#### 実行コード
```cpp
#include <bits/stdc++.h>

long long inverse(long long b,long long MOD){/*省略*/}

int main(void){
    
    std::cout << "mod 7でのiの逆元"<< std::endl;
    for(int i=1;i<7;i++){
        std::cout << i << " " << inverse(i,7) << " " << (i*inverse(i,7))%7 << std::endl;
    }
    
    return 0;
}
```

#### 出力
```
mod 7でのiの逆元
1 1 1
2 4 1
3 5 1
4 2 1
5 3 1
6 6 1
```

[もくじに戻る](#もくじ)

---

## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2021/04/05 | 約数列挙を追加 |
| 2021/03/27 | 使用例を追加 |
| 2021/03/26 | 軽微なバグを修正 |
| 2021/03/26 | アンカーリンクを追加 |
| 2021/06/01 | 素因数分解のバグを修正 |
| 2020/04/03 | 数学詰め合わせパックを追加 |