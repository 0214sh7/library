﻿---
title: "UnionFind"
permalink: /posts/unionfind
writer: 0214sh7
layout: library
---

DSU(disjoint set union)とも

init
- 整数 $$N$$ を与えると、頂点を$$N$$個生成し全て独立にする
- 計算量は $$Ο(N)$$

unionfind
- コンストラクタ。initを呼ぶ

leader
- 頂点 $$k$$ が所属する連結集合の代表元を返す
- と同時に経路圧縮する
- 計算量は $$Ο(\alpha (N))$$

$$α(x)$$ はアッカーマン関数 $$Ack(x,x)$$ の逆関数

$$Ack(4,4) = 2^{2^{2^{65536}}}-3$$ から伺えるように、 $$\alpha (x)$$ は実用上定数( $$4$$ )倍と見なせるほどに収束が遅い

same
- 頂点 $$p$$ と頂点 $$q$$ がその時点で同じ連結成分に属しているかを調べ、同じならtrue、違うならfalseを返す
- 計算量は $$Ο(\alpha (N))$$

size
- 頂点 $$k$$ が所属する連結集合のサイズを返す
- 計算量は $$Ο(1)$$

merge
- 頂点 $$p$$ と頂点 $$q$$ の間に辺を張る(集合を合併する)
- すでに同じ連結成分に属している場合は無視する
- 計算量は $$Ο(\alpha (N))$$


```cpp
class unionfind{
    // Copyright (c) 2024 0214sh7
    // https://github.com/0214sh7/library/
    private:
    std::vector<int> par,rank,size_;

    public:

    void init(int N){
        par.assign(N,0);
        rank.assign(N,0);
        size_.assign(N,1);
        for(int i=0;i<N;i++){
            par[i] = i;
        }
    }

    unionfind(int N){
        init(N);
    }

    int leader(int k){
        if(par[k]==k){
            return k;
        }
        par[k] = leader(par[k]);
        return par[k];
    }

    bool same(int p,int q){
        return leader(p)==leader(q);
    }

    int size(int k){
        return size_[leader(k)];
    }

    void merge(int p, int q){
        p = leader(p);
        q = leader(q);
        if(p==q)return;
        if(rank[p]<rank[q])std::swap(p,q);
        par[q]=p;
        if(rank[p]==rank[q])rank[p]++;
        size_[p] += size_[q];
        size_[q] = 0;
    }

};
```


## 使用例
***

### 実行コード
```cpp
#include <bits/stdc++.h>

class unionfind{/*省略*/};

int main(void){
    
    unionfind UF(13);
    UF.merge(1,3);
    UF.merge(1,5);
    UF.merge(1,7);
    UF.merge(1,8);
    UF.merge(1,10);
    UF.merge(1,12);
    UF.merge(4,6);
    UF.merge(4,9);
    UF.merge(4,11);
    
    std::cout << "それぞれが所属する連結成分の代表頂点\n";
    for(int i=1;i<=12;i++){
        std::cout << UF.leader(i) << " ";
    }
    std::cout << "\n\n";
    
    std::cout << "1と同じ連結成分に属しているならo、そうでないならx\n";
    for(int i=1;i<=12;i++){
        std::cout << (UF.same(1,i)?"o":"x") << " ";
    }
    std::cout << "\n\n";
    
    std::cout << "同じ連結成分に入っている頂点がいくつあるか\n";
    for(int i=1;i<=12;i++){
        std::cout << UF.size(i) << " ";
    }
    std::cout << std::endl;
    
    return 0;
}
```

### 出力
```
それぞれが所属する連結成分の代表頂点
1 2 1 4 1 4 1 1 4 1 4 1 

1と同じ連結成分に属しているならo、そうでないならx
o x o x o x o o x o x o 

同じ連結成分に入っている頂点がいくつあるか
7 1 7 4 7 4 7 7 4 7 4 7 

```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2024/09/22 | 微細な変更 |
| 2024/09/18 | 実装と一部機能の関数名を変更 |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2021/08/31 | sizeを追加 |
| 2021/03/26 | 使用例、コンストラクタを追加 |
| 2020/04/06 | UnionFindを追加 |

## 確認した問題

| 問題 | 提出 |
| :---: | :--- |
| [ABC157-D](https://atcoder.jp/contests/abc157/tasks/abc157_d) | [提出](https://atcoder.jp/contests/abc157/submissions/58005509) |
| [Library Checker](https://judge.yosupo.jp/problem/unionfind) | [提出](https://judge.yosupo.jp/submission/237109) |