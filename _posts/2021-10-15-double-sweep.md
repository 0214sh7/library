---
title: "木の直径"
permalink: /posts/double-sweep
writer: 0214sh7
layout: library
---

木ではない一般的なグラフでも近似解が出るらしいけどチェックしてません(え？)

init
- 整数$$N$$と頂点数$$N$$の重み付き木を0-indexedのvector<pair<pair<int,int>,long long>>で与えると前計算をし、木の直径が計算できるようになる
- 計算量は$$Ο(N)$$

double_sweep
- コンストラクタ。initを呼ぶ

vertex
- 最も距離が大きくなるような頂点対$$(u,v)$$を一つ返す
- 計算量は$$Ο(1)$$

pass
- $$u$$と$$v$$の間のパスを返す
- このときvectorの先頭が$$u$$、最後尾が$$v$$になる
- 計算量はパスの長さを$$P$$として、$$Ο(P)$$

diameter
- $$u$$と$$v$$の間のパスの重さを出力する
- 計算量はパスの長さを$$P$$として、$$Ο(P)$$

[github](https://github.com/0214sh7/procon-library/blob/master/algorithm/double%20sweep.cpp)

```
class double_sweep{
    /*
    Copyright (c) 2021 0214sh7
    https://github.com/0214sh7/library/
    */
    private:
    const long long INF = (1LL<<61);
    int V,V1,V2;
    std::vector<std::vector<std::pair<int,long long>>> G;
    std::vector<int> parent;
    std::vector<long long> parent_cost;
    long long diam;
    long long temp;
    
    void dfs(int phase,int v,int p,long long d){
        if(phase==1){
            if(d>temp){
                V1 = v;
                temp = d;
            }
        }
        if(phase==2){
            parent[v] = p;
            if(d>temp){
                V2 = v;
                temp = d;
            }
        }
        for(std::pair<int,long long> E:G[v]){
            int e = E.first;
            long long f = E.second;
            if(e!=p){
                dfs(phase,e,v,d+f);
                if(phase==2){
                    parent_cost[e] = f;
                }
            }
        }
    }
    
    public:
    
    void init(int N,std::vector<std::pair<std::pair<int,int>,long long>> edge){
        V = N;
        V1 = 0,V2 = 0;
        
        G.clear();
        G.resize(V);
        for(int i=0;i<edge.size();i++){
            int from=edge[i].first.first,to=edge[i].first.second;
            long long cost=edge[i].second;
            G[from].push_back({to,cost});
            G[to].push_back({from,cost});
        }
        
        parent.resize(V);
        for(int i=0;i<V;i++){
            parent[i] = -1;
        }
        parent_cost.resize(V);
        for(int i=0;i<V;i++){
            parent_cost[i] = -1;
        }
        
        temp = -INF;
        dfs(1,0,-1,0);
        temp = -INF;
        dfs(2,V1,-1,0);
        diam = -1;
    }
    
    double_sweep(int N,std::vector<std::pair<std::pair<int,int>,long long>> edge){
        init(N,edge);
    }
    
    std::pair<int,int> vertex(void){
        return std::make_pair(V2,V1);
    }
    
    std::vector<int> pass(void){
        std::vector<int> R;
        diam = 0;
        int r = V2;
        while(r!=V1){
            R.push_back(r);
            diam += parent_cost[r];
            r = parent[r];
        }
        R.push_back(r);
        return R;
    }
    
    long long diameter(void){
        if(diam==-1){
            pass();
        }
        return diam;
    }
};
```

## 使用例
***

### 実行コード
```
#include <bits/stdc++.h>

class double_sweep{/*省略*/};

int main(void){
    
    int N = 8;
    std::vector<std::pair<std::pair<int,int>,long long>> edge;
    
    edge.push_back({ {0,1},1});
    edge.push_back({ {0,2},2});
    edge.push_back({ {0,3},4});
    edge.push_back({ {1,4},8});
    edge.push_back({ {1,5},16});
    edge.push_back({ {5,6},32});
    edge.push_back({ {5,7},64});
    
    double_sweep DS(N,edge);
    
    
    //直径の端の頂点は6と7
    std::pair<int,int> V = DS.vertex();
    std::cout << V.first << " " << V.second << std::endl;
    
    //そのパスは6-5-7
    std::vector<int> P = DS.pass();
    for(int i=0;i<P.size();i++){
        std::cout << P[i] << " ";
    }
    std::cout << std::endl;
    
    //重さの和は96
    long long D = DS.diameter();
    std::cout << D << std::endl;
    
    
    return 0;
}
```

### 出力
```
6 7
6 5 7 
96
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2020/10/15 | 木の直径を追加 |