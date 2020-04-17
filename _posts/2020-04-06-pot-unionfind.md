---
title: "ポテンシャル付きUnionFind"
permalink: /posts/pot-unionfind
writer: 0214sh7
layout: library
---

重み付きUnionFindって言ったほうがいいのかな？正直わからない

大体の機能は[UnionFind](./unionfind)と同じで違う点は

potential
- 頂点$$k$$のその時点でのポテンシャルを求める
- 計算量は$$Ο(\alpha (N))$$

unite
- 集合を合併する際に、$$(Qのポテンシャル)-(Pのポテンシャル)=d$$になるように指定する

diff
- $$(Qのポテンシャル)-(Pのポテンシャル)$$を返す
- 計算量は$$Ο(\alpha (N))$$

[github](https://github.com/0214sh7/procon-library/blob/master/data%20structure/potentialized%20unionfind.cpp)

~~~
class potentialized_unionfind{
    /*
    Copyright (c) 2020 0214sh7
    https://github.com/0214sh7/library/
    */
    private:
    std::vector<int> UF,rank,pot;
    public:
    
    void init(int N){
        UF.clear();
        rank.clear();
        for(int i=0;i<N;i++){
            UF.push_back(i);
            rank.push_back(0);
            pot.push_back(0);
        }
    }
    
    int root(int k){
        if(UF[k]==k){
            return k;
        }else{
            int r = root(UF[k]);
            pot[k] += pot[UF[k]];
            UF[k] = r;
            return UF[k];
        }
    }
    
    int potential(int k){
        root(k);
        return pot[k];
    }
    
    bool same(int p,int q){
        return root(p)==root(q);
    }
    
    bool unite(int P,int Q,int d){
        //pot(Q)-pot(P)=dを満たす
        d+=potential(P);
        d-=potential(Q);
        int p=root(P), q=root(Q);
        if(p==q)return false;
        if(rank[p]<rank[q]){
            std::swap(p,q);
            d = -d;
        }
        UF[q]=p;
        if(rank[p]==rank[q])rank[p]++;
        pot[q]=d;
        
        return true;
    }
    
    int diff(int P,int Q){
        return potential(Q)-potential(P);
    }
    
};
~~~