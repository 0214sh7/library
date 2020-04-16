---
title: "オイラーのφ関数"
permalink: /posts/totient
writer: 0214sh7
layout: post
---

φはトーシェントと読むらしい

φ(n)とは、1からnまでの整数で、nと互いに素であるものの個数
これは、pをnの相違な素因数の集合として
n*Π(1-1/p_k)
と計算することができる

[github](https://github.com/0214sh7/procon-library/blob/master/math/Euler's%20totient%20function.cpp)


単体
- 整数Nを与えると、φ(N)を計算し整数で返す
- 計算量はΟ(sqrt(N))

~~~
int totient(int N){
    /*
    Copyright (c) 2020 0214sh7
    https://github.com/0214sh7/library/
    */
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
~~~


列挙
- 整数Nを与えると、0~Nまでのφ(i)を計算し,要素数がN+1のvectorで返す
- ここで、φ(0)=0としている
- 計算量はΟ(NloglogN)

~~~
std::vector<int> totient_array(int N){
    /*
    Copyright (c) 2020 0214sh7
    https://github.com/0214sh7/library/
    */
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
~~~