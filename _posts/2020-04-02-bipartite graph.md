---
title: "二部グラフ判定"
permalink: /posts/bipartite
writer: 0214sh7
layout: library
---

無向グラフを、辺の始点と終点を表現したpair<int,int>のvectorとして与える。<br>
すると、sizeが$$max(点の番号)+1$$のvectorが返ってくる。すべての要素は$$0$$または$$1$$である。<br>
これは、与えられたグラフを二部グラフとして表現するとき$$i$$番目の要素は$$0$$と$$1$$どちらに属するかを表している。<br>
また二部グラフでないとき全ての要素は$$0$$である。<br>
計算量は$$Ο(V)$$

[github](https://github.com/0214sh7/procon-library/blob/master/algorithm/bipartite%20graph.cpp)

~~~
std::vector<int> bipartite(std::vector<std::pair<int,int>> edge){
    /*
    Copyright (c) 2020 0214sh7
    https://github.com/0214sh7/library/
    */
    int E = edge.size();
    if(E==0)return {};
    int V = 0;
    for(int i=0;i<E;i++){
        V=std::max(V,edge[i].first+1);
        V=std::max(V,edge[i].second+1);
    }
    std::vector<int> R(V,-1);
    std::vector<int> S(0);
    std::vector<std::vector<int>> es(V,std::vector<int>(0));
    for(int i=0;i<E;i++){
        es[edge[i].first].push_back(edge[i].second);
        es[edge[i].second].push_back(edge[i].first);
    }
    std::queue<int> Q;
    std::vector<bool> visited(V,false);
    for(int j=0;j<V;j++){
        if(visited[j])continue;
        Q.push(j);
        R[j]=0;
        visited[j]=true;
        while(!Q.empty()){
            int q=Q.front();
            Q.pop();
            visited[q]=true;
            for(int i=0;i<es[q].size();i++){
                if(R[es[q][i]]==R[q]){
                    return S;
                }
                if(visited[es[q][i]])continue;
                Q.push(es[q][i]);
                R[es[q][i]]=1-R[q];
            }
        }
    }
    return R;
}

~~~