---
title: "UnionFind"
permalink: /posts/unionfind
writer: 0214sh7
layout: post
---

init
- 整数Nを与えると、頂点をN個生成し全てを独立にした上で全てのランクを0にする
- 計算量はΟ(N)

root
- 頂点kのその時点での根を求める
- と同時に経路圧縮する
- 計算量はΟ(α(N))

α(x)はアッカーマン関数A(x,x)の逆関数

same
- 頂点pと頂点qがその時点で同じ集合に属しているか(=根が同一か)を調べ、同じならtrue、違うならfalseを返す
- 計算量はΟ(α(N))

unite
- 頂点pと頂点qが属してる集合を合併する
- すでに同じ集合に属している場合は無視する
- pの属する集合のランクがqのものと同じか大きいときp側が根に、そうでないときq側が根になる
- 計算量はΟ(α(N))

[github](https://github.com/0214sh7/procon-library/blob/master/data%20structure/union%20find.cpp)

~~~
class unionfind{
    /*
    Copyright (c) 2020 0214sh7
    https://github.com/0214sh7/library/
    */
    private:
    std::vector<int> UF,rank;
    public:
    
    void init(int N){
        UF.clear();
        rank.clear();
        for(int i=0;i<N;i++){
            UF.push_back(i);
            rank.push_back(0);
        }
    }
    
    int root(int k){
        if(UF[k]==k){
            return k;
        }else{
            UF[k]=root(UF[k]);
            return UF[k];
        }
    }
    
    bool same(int p,int q){
        return root(p)==root(q);
    }
    
    void unite(int P,int Q){
        int p=root(P);
        int q=root(Q);
        if(p==q)return;
        if(rank[p]<rank[q])std::swap(p,q);
        UF[q]=p;
        if(rank[p]==rank[q])rank[p]++;
    }
    
};
~~~