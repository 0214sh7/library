---
title: "拡張ユークリッドの互除法"
permalink: /posts/bezout-coef
writer: 0214sh7
layout: library
---

拡張ユークリッドの互除法、extended Euclidean algorithmの対訳感がそんなにないね　どうでもいいね

整数$$a,b$$を与えると、$$g=gcd(a,b)$$とそれを用いて表される等式

$$ax+by=g$$

を満たす$$(x,y)$$(ベズー係数)を一つ求め、$$g$$とともに返す

計算量は$$O(log(max(a,b)))$$

ここで返り値はpair<ll,pair<ll,ll>>となっているが、それぞれ$$ \{g,\{x,y\}\} $$を表している

[github](https://github.com/0214sh7/procon-library/blob/master/math/extended%20Euclidean%20algorithm.cpp)

```
std::pair<long long,std::pair<long long,long long>> extgcd(long long a,long long b){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    std::vector<long long> q;
    while(b!=0){
        long long r = a%b;
        r+=b;
        r%=b;
        long long q_ = (a-r)/b;
        q.push_back(q_);
        a = b;
        b = r;
    }
    
    long long g=a,x=1,y=0;
    if(g<0){
        g*=-1;
        x*=-1;
    }
    for(int i=-1+(int)q.size();i>=0;i--){
        long long tmp = y;
        y = x-q[i]*y;
        x = tmp;
    }
    
    return {g,{x,y}};
}
```

## 使用例
***

### 実行コード
```
#include <bits/stdc++.h>

std::pair<long long,std::pair<long long,long long>> extgcd(long long a,long long b){/*省略*/}

signed main() {
    
    std::pair<long long,std::pair<long long,long long>> R;
    R = extgcd(111,30);
    long long g = R.first, x = R.second.first, y = R.second.second;
    
    std::cout << "111と30の最大公約数" << std::endl;
    std::cout << g << std::endl;
    std::cout << std::endl;
    
    
    std::cout << "111x+30y=3を満たすような(x,y)の一例" << std::endl;
    std::cout << "(" << x << "," << y << ")" << std::endl;
    std::cout << std::endl;
    
    
    std::cout << "111x+30y" << std::endl;
    std::cout << 111*x+30*y << std::endl;
    
    return 0;
}
```

### 出力
```
111と30の最大公約数
3

111x+30y=3を満たすような(x,y)の一例
(3,-11)

111x+30y
3
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2021/04/08 | 欠落していた計算量を追加 |
| 2021/04/08 | 拡張ユークリッドの互除法を追加 |