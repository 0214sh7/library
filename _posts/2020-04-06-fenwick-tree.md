---
title: "フェニック木"
permalink: /posts/fenwicktree
writer: 0214sh7
layout: post
---

BIT(Binary Indexed Tree)とも

init
- 整数Nを与えると、要素がN個のフェニック木を構成し、すべての要素を0で初期化する
- 計算量はΟ(N)

add
- a番目(0-indexed)の要素にwを加算する
- 計算量はinitのNを用いて、Ο(log(N))


sum
- [0,a)の範囲内にある要素の和をlong longで返す
- 計算量はΟ(log(a))

inversion
- 転　倒　数って知ってる？
- 数列Vを与えるとVの転倒数を計算し、long longで返す
- 計算量はN=V.sizeとし、Ο(Nlog(N))

[github](https://github.com/0214sh7/procon-library/blob/master/data%20structure/Fenwick%20tree.cpp)

~~~
class Fenwick_tree{
    /*
    Copyright (c) 2020 0214sh7
    https://github.com/0214sh7/library/
    */
    private:
    std::vector<long long> BIT;
    
    public:
    
    void add(int a,long long w){
        for(int x=a;x<BIT.size();x|=(x+1)){
            BIT[x]+=w;
        }
    }
    
    void init(int n){
        BIT.clear();
        for(int i=0;i<n;i++){
            BIT.push_back(0);
        }
    }
    
    long long sum(int a){
        long long r=0;
        for(int x=a-1;x>=0;x=(x&(x+1))-1){
            r+=BIT[x];
        }
        return r;
    }
    
    long long inversion(std::vector<long long> V){
        long long r=0;
        init(V.size());
        for(int i=0;i<V.size();i++){
            add(V[i],1);
            r+=i-sum(V[i]);
        }
        return r;
    }
};

~~~