---
title: "線分当たり判定"
permalink: /posts/segment-intersection
writer: 0214sh7
layout: library
---

$$2$$ 次元上の線分 $$[a,b]$$ と $$[c,d]$$ を与えると、 $$2$$ つの線分が共通部分を持つか判定する

共通部分を持てば true を、持たないなら false を返す

計算量は $$Ο(1)$$

[github]()

```cpp
bool intersect(std::pair<long long,long long> a,std::pair<long long,long long> b,std::pair<long long,long long> c,std::pair<long long,long long> d){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    std::function<std::pair<long long,long long>(std::pair<long long,long long>)> fraction = [](std::pair<long long,long long> x){
        long long g = std::gcd(x.first,x.second);
        x.first /= g, x.second /= g;
        if(x.second<0){x.first*=-1;x.second*=-1;}
        return x;
    };
 
    //p1*s+q1*t=r1, p2*s+q2*t=r2
    long long p1 = b.first -a.first , q1 = c.first -d.first , r1 = c.first -a.first ;
    long long p2 = b.second-a.second, q2 = c.second-d.second, r2 = c.second-a.second;
 
    //平行
    if(p1*q2==q1*p2){
 
        if(p1*r2 != p2*r1){
            return false;
        }
 
        //x軸に平行
        if(a.second == b.second){
            long long a1 = std::min(a.first,b.first), a2 = std::max(a.first,b.first);
            long long b1 = std::min(c.first,d.first), b2 = std::max(c.first,d.first);
 
            if(!(a2 < b1 || b2 < a1)){
                return true;
            }
        }else{
            //y軸に平行か斜め
            long long a1 = std::min(a.second,b.second), a2 = std::max(a.second,b.second);
            long long b1 = std::min(c.second,d.second), b2 = std::max(c.second,d.second);
 
            if(!(a2 < b1 || b2 < a1)){
                return true;
            }
        }
 
    //平行でない
    }else{
        std::pair<long long,long long> s = fraction({ q2*r1-q1*r2, p1*q2-q1*p2});
        std::pair<long long,long long> t = fraction({-p2*r1+p1*r2, p1*q2-q1*p2});
 
        if(0 <= s.first && s.first <= s.second && 0 <= t.first && t.first <= t.second){
            return true;
        }
    }
 
    return false;
}
```

## 使用例
***

### 実行コード
```cpp
#include <bits/stdc++.h>

bool intersect(std::pair<long long,long long> a,std::pair<long long,long long> b,std::pair<long long,long long> c,std::pair<long long,long long> d){/*省略*/}

int main(){
    
    bool cross = intersect({1,1},{2,2},{1,2},{2,1});
    std::cout << "cross " << (cross?"Yes":"No") << std::endl;
    
    bool far = intersect({2,1},{1,2},{3,1},{4,2});
    std::cout << "far " << (far?"Yes":"No") << std::endl;
    
    bool parallel = intersect({1,1},{1,2},{2,1},{2,2});
    std::cout << "parallel " << (parallel?"Yes":"No") << std::endl;
    
    bool overlapped = intersect({1,0},{3,0},{2,0},{4,0});
    std::cout << "overlapped " << (overlapped?"Yes":"No") << std::endl;
    
    bool touched = intersect({1,0},{2,0},{2,0},{3,0});
    std::cout << "touched " << (touched?"Yes":"No") << std::endl;
    
    bool seperated = intersect({1,0},{2,0},{3,0},{4,0});
    std::cout << "seperated " << (seperated?"Yes":"No") << std::endl;

    return 0;
}
```

### 出力
```
cross Yes
far No
parallel No
overlapped Yes
touched Yes
seperated No
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/07/06 | 線分当たり判定を追加 |