---
title: "ポテンシャル付きUnionFind"
permalink: /posts/pot-unionfind
writer: 0214sh7
layout: library
---


init
- 整数 $$N$$ と演算(群)を与えると、頂点を$$N$$個生成し全て独立にする
- 計算量は $$Ο(N)$$

potentialized_unionfind
- コンストラクタ。initを呼ぶ

leader
- 頂点 $$k$$ が所属する連結集合の代表元を返す
- と同時に経路圧縮する
- 計算量は $$Ο(\alpha (N))$$

same
- 頂点 $$p$$ と頂点 $$q$$ がその時点で同じ連結成分に属しているかを調べ、同じならtrue、違うならfalseを返す
- 計算量は $$Ο(\alpha (N))$$
- 
size
- 頂点 $$k$$ が所属する連結集合のサイズを返す
- 計算量は $$Ο(1)$$

merge
- 頂点 $$p$$ と頂点 $$q$$ の間にコスト $d$ の辺を張る(集合を合併する)
- 「$$p$$ と $$q$$ が異なる連結成分に属している」「$$p$$ と $$q$$ が同じ連結成分に属し、そのポテンシャルの差が $$d$$ である」場合は true 、「$$p$$ と $$q$$ が同じ連結成分に属し、そのポテンシャルの差が $$d$$ ではない」場合は　false を返す
- 計算量は $$Ο(\alpha (N))$$

potential
- 頂点 $$k$$ のポテンシャルを返す
- 計算量は $$Ο(\alpha (N))$$

diff
- (頂点 $$q$$ のポテンシャル) $$-$$ (頂点 $$p$$ のポテンシャル) を返す
- 計算量は $$Ο(\alpha (N))$$

```cpp
template<typename T>
class potentialized_unionfind{
    // Copyright (c) 2024 0214sh7
    // https://github.com/0214sh7/library/
    private:
    std::vector<int> par,rank,size_;
    std::vector<T> pot;

    std::function<T(T,T)> op_;
    std::function<T(T)> inv_;
    T id_;

    public:

    void init(int N, std::function<T(T,T)> op, std::function<T(T)> inv, T id){
        op_ = op;
        inv_ = inv;
        id_ = id;
        par.assign(N,0);
        rank.assign(N,0);
        size_.assign(N,1);
        pot.assign(N,id);
        for(int i=0;i<N;i++){
            par[i] = i;
        }
    }

    potentialized_unionfind(int N, std::function<T(T,T)> op, std::function<T(T)> inv, T id){
        init(N,op,inv,id);
    }

    int leader(int k){
        if(par[k]==k){
            return k;
        }
        int r = leader(par[k]);
        pot[k] = op_(pot[par[k]],pot[k]);
        par[k] = r;
        return par[k];
    }

    bool same(int p,int q){
        return leader(p)==leader(q);
    }

    int size(int k){
        return size_[leader(k)];
    }

    bool merge(int p, int q, T d){
        //pot(Q)-pot(P)=dを満たす
        d = op_(potential(p),d);
        d = op_(d,inv_(potential(q)));
        p = leader(p);
        q = leader(q);
        if(p==q){
            T X = diff(p,q);
            return (d == X);
        }
        if(rank[p]<rank[q]){
            std::swap(p,q);
            d = inv_(d);
        }
        par[q]=p;
        if(rank[p]==rank[q])rank[p]++;
        size_[p] += size_[q];
        size_[q] = 0;
        pot[q]=d;
        return true;
    }

    T potential(int k){
        leader(k);
        return pot[k];
    }

    T diff(int p, int q){
        return op_(inv_(potential(p)),potential(q));
    }

};
```


## 使用例
***

### 実行コード
```cpp
#include <bits/stdc++.h>

template<typename T>
class potentialized_unionfind{/*省略*/};

int main(void){

    std::function<long long(long long,long long)> op = [&](long long A, long long B){
        return A+B;
    };

    std::function<long long(long long)> inv = [&](long long A){
        return -A;
    };

    const long long id = 0;

    potentialized_unionfind<long long> potUF(6,op,inv,id);

    potUF.merge(0,1,1);
    potUF.merge(1,2,2);
    potUF.merge(2,3,4);
    potUF.merge(2,4,8);
    
    std::cout << "頂点 3 と頂点 4 の結合はできているか" << std::endl;
    bool c = potUF.same(3,4);
    std::cout << (c?"Yes":"No") << std::endl;
    std::cout << std::endl;

    std::cout << "頂点 3 と頂点 5 の結合はできているか" << std::endl;
    bool d = potUF.same(3,5);
    std::cout << (d?"Yes":"No") << std::endl;
    std::cout << std::endl;
    
    std::cout << "頂点 0 とのポテンシャルの差" << std::endl;
    for(int i=0;i<5;i++){
        std::cout << potUF.diff(0,i) << " ";
    }
    std::cout << std::endl << std::endl;
    
    std::cout << "頂点 2 とのポテンシャルの差" << std::endl;
    for(int i=0;i<5;i++){
        std::cout << potUF.diff(2,i) << " ";
    }
    std::cout << std::endl;
    
    return 0;
}
```

### 出力
```
頂点 3 と頂点 4 の結合はできているか
Yes

頂点 3 と頂点 5 の結合はできているか
No

頂点 0 とのポテンシャルの差
0 1 3 7 11 

頂点 2 とのポテンシャルの差
-3 -2 0 4 8 

```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2024/09/22 | 任意型に対応 |
| 2024/09/22 | 実装と一部機能の関数名を変更 |
| 2023/11/11 | long longに対応 |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2021/03/26 | 使用例、コンストラクタを追加 |
| 2020/04/06 | ポテンシャル付きUnionFindを追加 |

## 確認した問題

| 問題 | 提出 |
| :---: | :--- |
| [Library Checker(行列積)](https://judge.yosupo.jp/problem/unionfind_with_potential_non_commutative_group) | [提出](https://judge.yosupo.jp/submission/237096) |
| [Library Checker(整数)](https://judge.yosupo.jp/problem/unionfind_with_potential) | [提出](https://judge.yosupo.jp/submission/237097) |