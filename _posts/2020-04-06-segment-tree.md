---
title: "セグメント木"
permalink: /posts/segmenttree
writer: 0214sh7
layout: library
---

単にセグ木と言えばこれを指す、最も単純なセグ木

init
- 整数$$N$$を与えると、要素が$$N$$個入る最小サイズの完全二分木を構成し、すべての要素を単位元で初期化する
- 計算量は$$Ο(N)$$

calc
- セグ木に乗せる演算を書く
- 場合によって使いたい演算を書き換える
- 演算はモノイドである必要がある
- long long×long long→long longにしか対応してない　は？

update
- $$k$$番目(0-indexed)の要素を$$a$$で更新し、それが影響するノードを全て更新する
- 計算量はinitの$$N$$を用いて、$$Ο(logN)$$

query
- $$[a,b)$$の範囲内にある要素をcalcで計算した結果をlong longで返す
- 計算量は$$Ο(log(b-a))$$

[github](https://github.com/0214sh7/procon-library/blob/master/data%20structure/segment%20tree.cpp)

~~~
class segmenttree{
    /*
    Copyright (c) 2020 0214sh7
    https://github.com/0214sh7/library/
    */
    private:
    int n;
    long long identity = 0;//単位元
    std::vector<long long> dat;
    public:
    
    void init(int N){
        n=1;
        while(n<N)n*=2;
        dat.clear();
        for(int i=0;i<2*n-1;++i){
            dat.push_back(identity);
        }
    }
    
    long long calc();
    
    void update(int k,long long a){
        k+=n-1;
        dat[k]=a;
        while(k>0){
            k=(k-1)/2;
            dat[k]=calc(dat[2*k+1],dat[2*k+2]);
        }
    }
    
    long long query(long long a,long long b){
        a+=n;
        b+=n;
        long long R=0;
        while(a < b){
            if(a % 2 == 1){
                R = calc(R, dat[a - 1]);
                a += 1;
            }
            a /= 2;
            if(b % 2 == 1){
                b -= 1;
                R = calc(R, dat[b - 1]);
            }
            b /= 2;
        }
        return R;
    }
    
    long long calc(long long a,long long b){
        //your monoid here
        return a+b;
    }
    
};
~~~