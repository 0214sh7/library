---
title: "UnionFind"
permalink: /posts/unionfind
writer: 0214sh7
layout: library
---

init
- 整数$$N$$を与えると、頂点を$$N$$個生成し全てを独立にした上で全てのランクを$$0$$にする
- 計算量は$$Ο(N)$$

unionfind
- コンストラクタ。initを呼ぶ

root
- 頂点$$k$$のその時点での根を求める
- と同時に経路圧縮する
- 計算量は$$Ο(\alpha (N))$$

$$α(x)$$はアッカーマン関数$$Ack(x,x)$$の逆関数

$$Ack(4,4)=2^{2^{2^{65536}}}-3$$から伺えるように、$$\alpha (x)$$は実用上定数($$4$$)倍と見なせるほどに収束が遅い

same
- 頂点pと頂点qがその時点で同じ集合に属しているか(=根が同一か)を調べ、同じならtrue、違うならfalseを返す
- 計算量は$$Ο(\alpha (N))$$

unite
- 頂点pと頂点qが属してる集合を合併する
- すでに同じ集合に属している場合は無視する
- pの属する集合のランクがqのものと同じか大きいときp側が根に、そうでないときq側が根になる
- 計算量は$$Ο(\alpha (N))$$

[github](https://github.com/0214sh7/procon-library/blob/master/data%20structure/union%20find.cpp)

```
class unionfind{
    /*
    Copyright (c) 2021 0214sh7
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
    
    unionfind(int N){
        init(N);
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
```


## 使用例
***

### 実行コード
```
#include <bits/stdc++.h>

class unionfind{/*省略*/};

int main(void){
    
    unionfind UF(12);
    UF.unite(1,3);
    UF.unite(1,5);
    UF.unite(1,7);
    UF.unite(1,8);
    UF.unite(1,10);
    UF.unite(1,12);
    UF.unite(4,6);
    UF.unite(4,9);
    UF.unite(4,11);
    
    for(int i=1;i<=12;i++){
        std::cout << UF.root(i) << " ";
    }
    std::cout << std::endl;
    
    for(int i=1;i<=12;i++){
        std::cout << UF.same(1,i) << " ";
    }
    std::cout << std::endl;
    
    return 0;
}
```

### 出力
```
1 2 1 4 1 4 1 1 4 1 4 1 
1 0 1 0 1 0 1 1 0 1 0 1 
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2021/03/26 | 使用例、コンストラクタを追加 |
| 2020/04/06 | UnionFindを追加 |