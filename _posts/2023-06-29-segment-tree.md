---
title: "セグメント木"
permalink: /posts/segmenttree
writer: 0214sh7
layout: library
---

単にセグ木と言えばこれを指す、最も単純なセグ木

init
- 第一引数で整数$$N$$を与えると、要素が$$N$$個入る最小サイズの完全二分木を構成し、すべての要素を単位元で初期化する
- また第二･第三引数でセグ木に乗せる演算とその単位元を与えるとその演算を乗せる
- 演算がモノイドでない場合の動作は保証しない
- 計算量は$$Ο(N)$$

segmenttree
- コンストラクタ。initを呼ぶ

update
- $$k$$番目(0-indexed)の要素を$$a$$で更新し、それが影響するノードを全て更新する
- 計算量はinitの$$N$$を用いて、$$Ο(logN)$$

query
- $$[a,b)$$の範囲内にある要素をcalcで計算した結果をlong longで返す
- 計算量は$$Ο(log(b-a))$$

[github](https://github.com/0214sh7/procon-library/blob/master/data%20structure/segment%20tree.cpp)

```cpp
template<typename T>
class segmenttree{
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    private:
    int n;
    
    std::vector<T> dat;
    std::function<T(T,T)> calc;
    T identity;
    public:
    
    void init(int N,std::function<T(T,T)> func,T Identity){
        n=1;
        while(n<N)n*=2;
        dat.resize(2*n-1);
        for(int i=0;i<2*n-1;++i){
            dat[i]=Identity;
        }
        calc = func;
        identity = Identity;
    }
    
    segmenttree(int N,std::function<T(T,T)> func,T Identity){
        init(N,func,Identity);
    }
    
    void update(int k,T a){
        k+=n-1;
        dat[k]=a;
        while(k>0){
            k=(k-1)/2;
            dat[k]=calc(dat[2*k+1],dat[2*k+2]);
        }
    }
    
    T query(int a,int b){
        a+=n-1;
        b+=n-1;
        T L= identity,R = identity;
        while(a < b){
            if(a % 2 == 0){
                L = calc(L,dat[a]);
                a++;
            }
            a = (a-1)/2;
            if(b % 2 == 0){
                R = calc(dat[b-1],R);
                b--;
            }
            b = (b-1)/2;
        }
        R = calc(L,R);
        return R;
    }
    
};
```

## 使用例
***

### 実行コード
```cpp
#include <bits/stdc++.h>

template<typename T>
class segmenttree{/*省略*/};

int main(void){
    
    long long N = 6;
    std::vector<long long> A = {100000,20000,3000,400,50,6};
    std::function<long long(long long,long long)> func = [](long long a,long long b){
        return a+b;
    };
    
    segmenttree<long long> segtree(N,func,0);
    for(int i=0;i<N;i++){
        segtree.update(i,A[i]);
    }
    
    std::cout << segtree.query(0,3) << std::endl;
    std::cout << segtree.query(0,6) << std::endl;
    std::cout << segtree.query(2,6) << std::endl;
    std::cout << segtree.query(3,5) << std::endl;
    std::cout << segtree.query(5,6) << std::endl;
    
    return 0;
}
```

### 出力
```
123000
123456
3456
450
6
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2022/01/30 | バグを修正 |
| 2022/01/30 | 任意の型に対応 |
| 2021/10/10 | バグを修正 |
| 2021/03/26 | 使用例、コンストラクタを追加 |
| 2020/04/06 | セグメント木を追加 |