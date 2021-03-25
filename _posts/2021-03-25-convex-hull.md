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

```
std::vector<std::pair<long long,long long>> convex_hull(std::vector<std::pair<long long,long long>> P){
    /*
    Copyright (c) 2021 0214sh7
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
```

## 使用例
***

### 実行コード
```
#include <bits/stdc++.h>

std::vector<std::pair<long long,long long>> convex_hull(std::vector<std::pair<long long,long long>> P){/*省略*/}

int main(void){
    
    std::vector<std::pair<long long,long long>> P,Q;
    P.push_back({0,0});
    P.push_back({2,0});
    P.push_back({1,1});
    P.push_back({0,2});
    P.push_back({2,2});
    
    Q = convex_hull(P);
    for(int i=0;i<Q.size();i++){
        std::cout << Q[i].first << " " << Q[i].second << std::endl;
    }
    return 0;
}
```

### 出力
```
0 0
2 0
2 2
0 2
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2021/03/25 | 使用例を追加 |
| 2020/04/22 | 凸包を追加 |