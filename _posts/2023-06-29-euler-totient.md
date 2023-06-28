---
title: "オイラーのφ関数"
permalink: /posts/totient
writer: 0214sh7
layout: library
---

$$\varphi$$はトーシェントと読むらしい

$$\varphi(n)$$とは、$$1$$から$$n$$までの整数で、$$n$$と互いに素であるものの個数

これは、$$n$$が相違な素因数$$p_1,p_2,...,p_d$$を含むとして

$$\varphi(n) = n\prod_{k=1}^d (1-\frac{1}{p_k})$$

と計算することができる

[github](https://github.com/0214sh7/procon-library/blob/master/math/Euler's%20totient%20function.cpp)


単体
- 整数$$N$$を与えると、$$\varphi(N)$$を計算し整数で返す
- 計算量は$$O(\sqrt{N})$$

```cpp
int totient(int N){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    if(N<0){
        return 0;
    }
    int R = N;
    for(int i=2;i*i<=N;i++){
        if(N%i==0){
            R -= R/i;
            while(N%i==0){
                N/=i;
            }
        }
    }
    if(N>1){
        R -= R/N;
    }
    return R;
}
```


列挙
- 整数$$N$$を与えると、$$0$$から$$N$$までの$$\varphi(i)$$を計算し,要素数が$$N+1$$のvectorで返す
- ここで、$$\varphi(0)=0$$としている
- 計算量は$$O(NloglogN)$$

```cpp
std::vector<int> totient_array(int N){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    std::vector<int> R(N+1);
    for(int i=0;i<=N;i++){
        R[i]=i;
    }
    for(int i=2;i<=N;i++){
        if(R[i]!=i)continue;
        for(int j=i;j<=N;j+=i){
            R[j]-=(R[j]/i);
        }
    }
    return R;
}
```


## 使用例
***

### 実行コード
```cpp
#include <bits/stdc++.h>

int totient(int N){/*省略*/}
std::vector<int> totient_array(int N){/*省略*/}

int main(void){
    
    for(int i=0;i<=10;i++){
        std::cout << totient(i) << " ";
    }
    std::cout << std::endl;
    
    std::vector<int> T = totient_array(10);
    for(int i=0;i<=10;i++){
        std::cout << T[i] << " ";
    }
    std::cout << std::endl;
    
    return 0;
}
```

### 出力
```
0 1 1 2 2 4 2 6 4 6 4 
0 1 1 2 2 4 2 6 4 6 4 
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2021/03/25 | 使用例を追加 |
| 2020/04/16 | オイラーのφ関数を追加 |