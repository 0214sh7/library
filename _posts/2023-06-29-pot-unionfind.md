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
- P,Qが同じ集合にある場合にfalseを返す

diff
- $$(Qのポテンシャル)-(Pのポテンシャル)$$を返す
- 計算量は$$Ο(\alpha (N))$$

[github](https://github.com/0214sh7/procon-library/blob/master/data%20structure/potentialized%20unionfind.cpp)

```
class potentialized_unionfind{
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
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

    potentialized_unionfind(int N){
        init(N);
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
```


## 使用例
***

### 実行コード
```
#include <bits/stdc++.h>

class potentialized_unionfind{/*省略*/};

int main(void){
    
    potentialized_unionfind potUF(5);
    
    potUF.unite(0,1,1);
    potUF.unite(1,2,2);
    potUF.unite(2,3,4);
    potUF.unite(2,4,8);
    
    std::cout << "頂点3と頂点4の結合はできているか" << std::endl;
    bool c = potUF.unite(3,4,4);
    if(c==true){
        std::cout << "true" << std::endl;
    }else{
        std::cout << "false" << std::endl;
    }
    std::cout << std::endl;
    
    std::cout << "頂点0とのポテンシャルの差は何か" << std::endl;
    for(int i=0;i<5;i++){
        std::cout << potUF.diff(0,i) << " ";
    }
    std::cout << std::endl << std::endl;
    
    std::cout << "頂点2とのポテンシャルの差は何か" << std::endl;
    for(int i=0;i<5;i++){
        std::cout << potUF.diff(2,i) << " ";
    }
    std::cout << std::endl;
    
    return 0;
}
```

### 出力
```
頂点3と頂点4の結合はできているか
false

頂点0とのポテンシャルの差は何か
0 1 3 7 11 

頂点2とのポテンシャルの差は何か
-3 -2 0 4 8 
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2021/03/26 | 使用例、コンストラクタを追加 |
| 2020/04/06 | ポテンシャル付きUnionFindを追加 |