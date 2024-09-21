---
title: "セグメント木"
permalink: /posts/segmenttree
writer: 0214sh7
layout: library
---

単にセグ木と言えばこれを指す、最も単純なセグ木

init
- 第一引数で整数 $$N$$ を与えると、要素が $$N$$ 個入る最小サイズの完全二分木を構成し、すべての要素を単位元で初期化する
- また第二･第三引数でセグ木に乗せる演算とその単位元を与えるとその演算を乗せる
- 演算がモノイドでない場合の動作は保証しない
- 計算量は $$Ο(N)$$
- また第一変数を変数の代わりに vector として要素を与えることで vector で初期化することもできる　この場合の計算量は $$ O(N \times \text{演算の計算量}) $$

segmenttree
- コンストラクタ。initを呼ぶ

set
- $$k$$ 番目( $$0$$ -indexed)の要素を $$a$$ で更新し、それが影響するノードを全て更新する
- 計算量は init の $$N$$ を用いて、 $$Ο(\log N)$$
- また vector を与えることでセグメント木全体をその vector で上書きする
- 計算量は $$ O(N \times \text{演算の計算量}) $$

size
- 計算に使われている vector のサイズ( init で与えたもの)を返す
- 計算量は $$Ο(1)$$

get
- $$k$$ 番目( $$0$$ -indexed)の要素を返す
- 計算量は $$Ο(1)$$

prod
- $$[a,b)$$の範囲内にある要素をcalcで計算した結果を返す
- 計算量は $$Ο(log(b-a))$$

max_right
- $$l$$ と単調な関数 $$f : \text{型} \to \text{bool} $$ を与えると、
 $$ f(calc( \  [l,r) \ )) $$ が true になる最大の $$r$$ を返す
- すなわち、 $$ f(A_{l} \otimes \cdots \otimes A_{r-1}) $$ が true になる最大の $$r$$ を返す
- 計算量は $$Ο(\log N)$$

min_left
- $$r$$ と単調な関数 $$f : \text{型} \to \text{bool} $$ を与えると、
 $$ f(calc( \  [l,r) \ )) $$ が true になる最小の $$l$$ を返す
- すなわち、 $$ f(A_{l} \otimes \cdots \otimes A_{r-1}) $$ が true になる最小の $$l$$ を返す
- 計算量は $$Ο(\log N)$$


```cpp
template<typename T>
class segmenttree{
    // Copyright (c) 2024 0214sh7
    // https://github.com/0214sh7/library/
    private:
    int n;
    int size_;
    std::vector<T> dat;
    std::function<T(T,T)> calc;
    T id;

    public:

    void init(int N, std::function<T(T,T)> func, T e){
        size_ = N;
        n = 1;
        while(n<N)n<<=1;
        calc = func;
        id = e;
        dat.assign(2*n-1,e);
    }

    void init(std::vector<T> a, std::function<T(T,T)> func, T e){
        init(a.size(),func,e);
        set(a);
    }

    segmenttree(int N, std::function<T(T,T)> func, T e){
        init(N,func,e);
    }

    segmenttree(std::vector<T> a, std::function<T(T,T)> func, T e){
        init(a,func,e);
    }

    void set(int k, T a){
        assert(0<=k && k<size_);
        k += n-1;
        dat[k] = a;
        while(k>0){
            k = (k-1)/2;
            dat[k] = calc(dat[2*k+1],dat[2*k+2]);
        }
    }

    void set(std::vector<T> a){
        assert((int)a.size()==size_);
        dat.assign(2*n-1,id);
        for(int k=0;k<size_;k++){
            dat[n+k-1] = a[k];
        }
        for(int k=n-2;k>=0;k--){
            dat[k] = calc(dat[2*k+1],dat[2*k+2]);
        }
    }

    int size(void){
        return size_;
    }

    T get(int k){
        assert(0<=k && k<size_);
        return dat[n+k-1];
    }

    T prod(int a,int b){
        assert(0<=a && a<=b && b<=size_);
        a += n-1;
        b += n-1;
        T L = id, R = id;
        while(a<b){
            if(a%2==0){
                L = calc(L,dat[a]);
                a++;
            }
            a = (a-1)/2;
            if(b%2==0){
                b--;
                R = calc(dat[b],R);
            }
            b = (b-1)/2;
        }
        return calc(L,R);
    }

    int max_right(int l, std::function<bool(T)> f){
        assert(0<=l && l<=size_);
        assert(f(id));

        l += n-1;
        int k = l;
        int sum = id;
        
        while(1){
            while(k%2==1)k=(k-1)/2;
            T newsum = calc(sum,dat[k]);
            if(f(newsum)){
                sum = newsum;
                if(((k+2) & -(k+2)) == (k+2)){
                    return size_;
                }
                k++;
            }else{
                break;
            }
        }

        while(k < n-1){
            T newsum = calc(sum,dat[2*k+1]);
            if(f(newsum)){
                sum = newsum;
                k = 2*k+2;
            }else{
                k = 2*k+1;
            }
        }

        return k-n+1;
    }
    
    int min_left(int r, std::function<bool(T)> f){
        assert(0<=r && r<=size_);
        assert(f(id));
        if(r==0)return 0;

        r += n-1;r--;
        int k = r;
        int sum = id;
        
        while(1){
            while(k%2==0)k=(k-1)/2;
            T newsum = calc(dat[k],sum);
            if(f(newsum)){
                sum = newsum;
                if(((k+1) & -(k+1)) == (k+1)){
                    return 0;
                }
                k--;
            }else{
                break;
            }
        }

        while(k < n-1){
            T newsum = calc(dat[2*k+2],sum);
            if(f(newsum)){
                sum = newsum;
                k = 2*k+1;
            }else{
                k = 2*k+2;
            }
        }

        return k-n+2;
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
    
    std::vector<long long> A = {100000,20000,3000,400,50,6};
    std::function<long long(long long,long long)> func = [](long long a,long long b){
        return a+b;
    };
    
    segmenttree<long long> segtree(A,func,0);
    
    std::cout << segtree.prod(0,3) << std::endl;
    std::cout << segtree.prod(0,6) << std::endl;
    std::cout << segtree.prod(2,6) << std::endl;
    std::cout << segtree.prod(3,5) << std::endl;
    std::cout << segtree.prod(5,6) << std::endl;
    
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
| 2024/09/20 | 実装と一部機能の関数名を変更 |
| 2024/09/20 | max_right, min_left を追加 |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2022/01/30 | バグを修正 |
| 2022/01/30 | 任意の型に対応 |
| 2021/10/10 | バグを修正 |
| 2021/03/26 | 使用例、コンストラクタを追加 |
| 2020/04/06 | セグメント木を追加 |

## 確認した問題

| 問題 | 提出 |
| :---: | :--- |
| [DSL_2_B](https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_2_B) | [提出](https://judge.u-aizu.ac.jp/onlinejudge/review.jsp?rid=9659716) |
| [ALPC-J](https://atcoder.jp/contests/practice2/tasks/practice2_j) | [提出(max_right)](https://atcoder.jp/contests/practice2/submissions/57917910) |
| [ALPC-J](https://atcoder.jp/contests/practice2/tasks/practice2_j) | [提出(min_left)](https://atcoder.jp/contests/practice2/submissions/57917919) |