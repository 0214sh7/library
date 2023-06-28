---
title: "最小共通祖先"
permalink: /posts/lowest-common-ancestor
writer: 0214sh7
layout: library
---

init
- 整数$$r$$と頂点数$$N$$の木を0-indexedのvector<pair<int,int>>で与えると前計算をし、$$r$$を根とする木のLCAが計算できるようになる
- 計算量は$$Ο(N \log N)$$

lowest_common_ancestor
- コンストラクタ。initを呼ぶ

climb
- $$u$$と$$k$$を与えると、頂点$$u$$から$$k$$個遡った頂点の番号を返す
- もし根を超えてしまった場合は$$-1$$を返す
- 計算量は$$Ο(\log k)$$

lca
- $$u$$と$$v$$を与えると頂点$$u$$と$$v$$のLCA(最小共通祖先)を返す
- 計算量は木の頂点数$$N$$を用いて、$$Ο(\log N)$$

[github](https://github.com/0214sh7/procon-library/blob/master/algorithm/lowest%20common%20ancestor.cpp)

```
class lowest_common_ancestor{
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    private:
    int V,LOG;
    std::vector<std::vector<long long>> G,table;
    std::vector<long long> depth;
    
    void dfs(long long v,long long p,long long d){
        depth[v] = d;
        table[v][0] = p;
        for(long long e:G[v]){
            if(e!=p){
                dfs(e,v,d+1);
            }
        }
    }
    
    public:
    void init(long long root,std::vector<std::pair<long long,long long>> edge){
        V = 1+edge.size();
        LOG = 1;
        while((1<<LOG)<V)LOG++;

        G.clear();
        G.resize(V);
        for(int i=0;i<edge.size();i++){
            G[edge[i].first].push_back(edge[i].second);
            G[edge[i].second].push_back(edge[i].first);
        }
        
        table.resize(V);
        for(int i=0;i<V;i++){
            table[i].resize(LOG);
        }
        depth.resize(V);
        dfs(root,-1,0);
        
        for(int j=0;j<LOG-1;j++){
            for(int i=0;i<V;i++){
                if(table[i][j]==-1){
                    table[i][j+1] = -1;
                }else{
                    table[i][j+1] = table[table[i][j]][j];
                }
                
            }
        }
        
    }
    
    lowest_common_ancestor(long long root,std::vector<std::pair<long long,long long>> edge){
        init(root,edge);
    }
    
    
    long long climb(long long u,long long k = 1){
        for(int i=0;k>0;k>>=1,i++){
            if(u==-1)return -1;
            if(k&1)u = table[u][i];
        }
        return u;
    }
    
    long long lca(long long u,long long v){
        if(depth[u]>depth[v])std::swap(u,v);
        v = climb(v,depth[v]-depth[u]);
        if(u==v)return u;
        
        for(int i=LOG-1;i>=0;i--){
            if(table[u][i]!=table[v][i]){
                u = table[u][i];
                v = table[v][i];
            }
        }
        return table[u][0];
    }
    
};
```

## 使用例
***

### 実行コード
```
#include <bits/stdc++.h>

class lowest_common_ancestor{/*省略*/};

int main(void){
    
    int N = 8;
    
    std::vector<std::pair<long long,long long>> edge;
    
    edge.push_back({0,1});
    edge.push_back({0,2});
    edge.push_back({0,3});
    edge.push_back({1,4});
    edge.push_back({1,5});
    edge.push_back({5,6});
    edge.push_back({5,7});
    
    //0を根として前計算する
    lowest_common_ancestor LCA(0,edge);
    
    //頂点6から一つずつ遡ったら6→5→1→0になり、それを超えると-1
    for(int i=0;i<5;i++){
        std::cout << LCA.climb(6,i) << " ";
    }
    std::cout << std::endl;
    
    //頂点6と頂点7のLCAは5
    std::cout << LCA.lca(6,7) << std::endl;
    
    //頂点6と頂点1のLCAは1
    std::cout << LCA.lca(6,1) << std::endl;
    
    //頂点6と頂点3のLCAは0
    std::cout << LCA.lca(6,3) << std::endl;
    
    return 0;
}
```

### 出力
```
6 5 1 0 -1 
5
1
0
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2020/10/10 | 最小共通祖先を追加 |