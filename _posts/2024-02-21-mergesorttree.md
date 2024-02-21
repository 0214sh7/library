---
title: "マージソート木"
permalink: /posts/mergesorttree
writer: 0214sh7
layout: library
---

init
- long longのvector $$A$$ を与えると、マージソートの過程となる完全二分木を構成する
- 計算量は $$Ο(N \log N)$$

mergesorttree
- コンストラクタ。initを呼ぶ

quantity
- $$A$$ の $$[l,r)$$ の範囲にある $$X$$ 以下の要素の個数を返す
- 計算量は $$A$$ のサイズ $$N$$ を用いて、 $$Ο((\log N)^2)$$

sum
- $$A$$ の $$[l,r)$$ の範囲にある $$X$$ 以下の要素の和を返す
- 計算量は $$A$$ のサイズ $$N$$ を用いて、 $$Ο((\log N)^2)$$

[github]()

```cpp
class mergesorttree{
    
    // Copyright (c) 2024 0214sh7
    // https://github.com/0214sh7/library/

    private:
    int n;
    std::vector<std::vector<long long>> dat,cum;
    
    public:
    
    void init(std::vector<long long> A){
        int N = A.size();
        n=1;
        while(n<N)n*=2;
        dat.assign(2*n-1,{0});
        cum.assign(2*n-1,{0});
        
        for(int i=0;i<N;i++){
            dat[n-1+i][0] = A[i];
            cum[n-1+i][0] = A[i];
        }
        for(int i=n-2;i>=0;i--){
            dat[i].resize(dat[2*i+1].size()+dat[2*i+2].size());
            unsigned a=0,b=0;
            while(a!=dat[2*i+1].size() && b!=dat[2*i+2].size()){
                if(dat[2*i+1][a]<=dat[2*i+2][b]){
                    dat[i][a+b] = dat[2*i+1][a];
                    a++;
                }else{
                    dat[i][a+b] = dat[2*i+2][b];
                    b++;
                }
            }
            while(a!=dat[2*i+1].size()){
                dat[i][a+b] = dat[2*i+1][a];
                a++;
            }
            while(b!=dat[2*i+2].size()){
                dat[i][a+b] = dat[2*i+2][b];
                b++;
            }

            cum[i] = dat[i];
            for(unsigned j=1;j<dat[i].size();j++){
                cum[i][j] += cum[i][j-1];
            }
        }
    }
    
    mergesorttree(std::vector<long long> A){
        init(A);
    }

    long long quantity(int l, int r, long long X){
        long long ret = 0;
        l += n-1;
        r += n-1;
        while(l < r){
            if(l % 2 == 0){
                auto it = std::upper_bound(dat[l].begin(), dat[l].end(), X);
                ret += std::distance(dat[l].begin(),it);
                l++;
            }
            l = (l-1)/2;
            if(r % 2 == 0){
                auto it = std::upper_bound(dat[r-1].begin(), dat[r-1].end(), X);
                ret += std::distance(dat[r-1].begin(),it);
                r--;
            }
            r = (r-1)/2;
        }
        
        return ret;
    }

    long long sum(int l, int r, long long X){
        long long ret = 0;
        l += n-1;
        r += n-1;
        while(l < r){
            if(l % 2 == 0){
                auto it = std::upper_bound(dat[l].begin(), dat[l].end(), X);
                int dis = std::distance(dat[l].begin(),it);
                if(dis>0)ret += cum[l][dis-1];
                l++;
            }
            l = (l-1)/2;
            if(r % 2 == 0){
                auto it = std::upper_bound(dat[r-1].begin(), dat[r-1].end(), X);
                int dis = std::distance(dat[r-1].begin(),it);
                if(dis>0)ret += cum[r-1][dis-1];
                r--;
            }
            r = (r-1)/2;
        }
        
        return ret;
    }
    
    
};
```

## 使用例
***

### 実行コード
```cpp
#include <bits/stdc++.h>

class mergesorttree{/*省略*/};

int main() {
    
    std::vector<long long> A = {3,1,4,1,5,9,2};
    mergesorttree mstree(A);
    long long c;
    
    std::cout << "Aの [0,4) 、すなわち {3,1,4,1} にある3以下の要素数" << std::endl;
    c = mstree.quantity(0,4,3);
    std::cout << c << std::endl << std::endl;

    std::cout << "Aの [0,4) 、すなわち {3,1,4,1} にある2以下の要素数" << std::endl;
    c = mstree.quantity(0,4,2);
    std::cout << c << std::endl << std::endl;

    std::cout << "Aの [2,6) 、すなわち {4,1,5,9} にある7以下の要素数" << std::endl;
    c = mstree.quantity(2,6,7);
    std::cout << c << std::endl << std::endl;

    std::cout << "Aの [2,6) 、すなわち {4,1,5,9} にある7以下の要素の和" << std::endl;
    c = mstree.sum(2,6,7);
    std::cout << c;
    
    return 0;
}
```

### 出力
```
Aの [0,4) 、すなわち {3,1,4,1} にある3以下の要素数
3

Aの [0,4) 、すなわち {3,1,4,1} にある2以下の要素数
2

Aの [2,6) 、すなわち {4,1,5,9} にある7以下の要素数
3

Aの [2,6) 、すなわち {4,1,5,9} にある7以下の要素の和
10
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2024/02/21 | マージソート木を追加 |