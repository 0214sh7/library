---
title: "凸包"
permalink: /posts/convexhull
writer: 0214sh7
layout: library
---

アルゴリズムはAndrewのmonotone chainという名前らしい

二次元上の点集合をvector<pair<long long,long long>>で与える

するとその点集合の凸包を求め、x座標が最も小さい点のうちy座標が最も小さい点から始めて反時計回りに並べてvector<pair<long long,long long>>で返す

計算量は$$O(\vert P \vert log \vert P \vert)$$(ソートがネックになっており、ソートがなければ$$O(\vert P \vert)$$)

[github](https://github.com/0214sh7/procon-library/blob/master/math/convex%20hull.cpp)

~~~
std::vector<std::pair<long long,long long>> convex_hull(std::vector<std::pair<long long,long long>> P){
    /*
    Copyright (c) 2020 0214sh7
    https://github.com/0214sh7/library/
    */
    if(P.size()<=2){
        return P;
    }
    std::vector<std::pair<long long,long long>> H,L,R;
    sort(P.begin(),P.end());
    
    //下半分
    for(int i=0;i<P.size();i++){
        int j=L.size();
        while(j>=2 && (L[j-1].first-L[j-2].first)*(P[i].second-L[j-2].second)<=(L[j-1].second-L[j-2].second)*(P[i].first-L[j-2].first)){
            L.pop_back();
            j--;
        }
        L.push_back(P[i]);
    }
    
    //上半分
    for(int i=P.size()-1;i>=0;i--){
        int j=H.size();
        while(j>=2 && (H[j-1].first-H[j-2].first)*(P[i].second-H[j-2].second)<=(H[j-1].second-H[j-2].second)*(P[i].first-H[j-2].first)){
            H.pop_back();
            j--;
        }
        H.push_back(P[i]);
    }
    
    
    R=L;
    for(int i=1;i<H.size()-1;i++){
        R.push_back(H[i]);
    }
    
    return R;
}
~~~
