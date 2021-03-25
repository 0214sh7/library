---
title: "ベルマンフォード法"
permalink: /posts/bellmanford
writer: 0214sh7
layout: library
---

init
- 無向グラフを、辺の始点と終点とコストを表現したpair<pair<int,int>,long long>のvectorとして与える。
- すると、グラフをsolve()が扱えるようになる
- 多始点などで何回も回す場合、initの実行は$$1$$回でよい
- 計算量は$$Ο(max(E,V))$$

BellmanFord
- コンストラクタ。initを呼ぶ

solve
- initでできたグラフに対し、与えられた$$s$$を始点としてベルマンフォード法を実行する
- 得られた最小コストを要素数が$$V$$のvectorとして返す
- vectorの要素はpair<long long,bool>である　firstは最小コストを表しており、secondがtrueの場合最小コストが存在せずfirstの値は適当
- 計算量は$$Ο(VE)$$

[github](https://github.com/0214sh7/procon-library/blob/master/algorithm/BellmanFord.cpp)

```
class BellmanFord{
    /*
    Copyright (c) 2021 0214sh7
    https://github.com/0214sh7/library/
    */
    private:
    typedef std::pair<std::pair<int,int>,long long> P;
    int V,E;
    long long INF = (1LL<<61);
    std::vector<std::pair<std::pair<int,int>,long long>> es;
    
    public:
    void init(int N,std::vector<std::pair<std::pair<int,int>,long long>> edge){
        //辺数をもとめる　
        E=edge.size();
        //頂点数を決定する
        V=N;
        es=edge;
    }
    
    BellmanFord(int N,std::vector<std::pair<std::pair<int,int>,long long>> edge){
        init(N,edge);
    }

    std::vector<std::pair<long long,bool>> solve(int s){
        std::vector<std::pair<long long,bool>> d;
        //INFで初期化する
        for(int i=0;i<V;i++){
            d.push_back({INF,false});
        }
        d[s].first=0;
        for(int j=0;j<2*V;j++){
             bool update=false;
            for(int i=0;i<E;i++){
                P k=es[i];
                if(d[k.first.first].first!=INF && d[k.first.second].first>d[k.first.first].first+k.second){
                    d[k.first.second].first=d[k.first.first].first+k.second;
                    if(j>=V){
                        d[k.first.second].second=true;
                    }
                    update=true;
                }
            }
            if(!update)break;
        }
        return d;
    }
    
};
```


## 使用例
***

### 実行コード
```
#include <bits/stdc++.h>

class BellmanFord{/*省略*/};

int main(void){
    
    std::vector<std::pair<std::pair<int,int>,long long>> E;
    int N = 5;
    E.push_back({ {0,1},1});
    E.push_back({ {1,2},2});
    E.push_back({ {2,3},4});
    E.push_back({ {2,4},8});
    E.push_back({ {3,4},10000});
    
    BellmanFord bellmanford(N,E);
    std::vector<std::pair<long long,bool>> B = bellmanford.solve(0);
    
    for(int i=0;i<N;i++){
        if(B[i].second==true){
            std::cout << "-INF" << " ";
        }else{
            std::cout << B[i].first << " ";
        }
    }
    std::cout << std::endl;
    
    std::vector<std::pair<long long,bool>> C = bellmanford.solve(1);
    
    for(int i=0;i<N;i++){
        if(C[i].second==true){
            std::cout << "-INF" << " ";
        }else{
            std::cout << C[i].first << " ";
        }
    }
    std::cout << std::endl;
    
    return 0;
}
```

### 出力
```
0 1 3 7 11 
2305843009213693952 0 2 6 10 
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2021/03/25 | 使用例、コンストラクタを追加 |
| 2021/03/25 | バグを修正/コメントを削除 |
| 2020/04/04 | ベルマンフォード法を追加 |