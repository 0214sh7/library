---
title: "ベルマンフォード法"
permalink: /posts/bellmanford
writer: 0214sh7
layout: post
---

init
- 無向グラフを、辺の始点と終点とコストを表現したpair<pair<int,int>,long long>のvectorとして与える。
- すると、グラフをsolve()が扱えるようになる
- 多始点などで何回も回す場合、initの実行は1回でよい
- 計算量はΟ(max(E,V))

solve
- initでできたグラフに対し、与えられたsを始点としてベルマンフォード法を実行する
- 得られた最小コストを要素数がVのvectorとして返す
- vectorの要素はpair<long long,bool>である　firstは最小コストを表しており、secondがtrueの場合最小コストが存在せずfirstの値は適当
- 計算量はΟ(VE)

[github](https://github.com/0214sh7/procon-library/blob/master/algorithm/BellmanFord.cpp)

~~~

class BellmanFord{
    /*
    Copyright (c) 2020 0214sh7
    https://github.com/0214sh7/library/
    */
    private:
    typedef std::pair<std::pair<int,int>,long long> P;
    int V,E;
    long long INF = (1LL<<61);
    std::vector<std::pair<std::pair<int,int>,long long>> es;
    
    public:
    void init(std::vector<std::pair<std::pair<int,int>,long long>> edge){
        //辺数をもとめる　
        E=edge.size();
        //頂点数を決定する
        V=0;
        for(int i=0;i<edge.size();i++){
            V=std::max(V,edge[i].first.first+1);
            V=std::max(V,edge[i].first.second+1);
        }
        es=edge;
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
    
    //init:{ {int,int},longlong}のvectorを渡すことで有向グラフを構築する
    //solve:始点を渡すとinitで構築したグラフでベルマンフォードをし、コストのvectorを返す
};
~~~
