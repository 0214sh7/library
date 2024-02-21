---
title: "遅延セグ木"
permalink: /posts/lazysegmenttree
writer: 0214sh7
layout: library
---

収録が遅すぎる、書いたのいつだよ

init
- 以下の $6$ つの引数を与えるとそれに対応した遅延セグ木を構築する
  - 要素数
  - セグ木に乗る演算
  - その単位元
  - セグ木の要素への作用の関数
  - 作用どうしの合成
  - 作用の単位元
- 第 2 引数がモノイドでない・第 4 引数が作用でない場合の動作は保証しない
- 計算量は $$Ο(N)$$

lazysegmenttree
- コンストラクタ。initを呼ぶ

set
- 今までの結果を消去し、与えられた vector $$A$$ で初期化する
- 計算量は $$O(N \times (乗せた演算の計算量) )$$

update
- $$[l,r)$$ (0-indexed)の要素すべてに $$f$$ を作用させる
- 計算量は $$O(\log N \times ((演算の計算量) + (作用の計算量) + (合成の計算量)) )$$

query
- $$[a,b)$$の範囲内にある要素の演算結果をで返す
- 計算量は $$O(\log N \times ((演算の計算量) + (作用の計算量) + (合成の計算量)) )$$

[github]()

```cpp
template<typename T,typename F>
class lazysegmenttree{
    /*
    Copyright (c) 2024 0214sh7
    https://github.com/0214sh7/library/
    */
    //private:
    public:
    int n,height;
    
    std::vector<T> dat;
    std::vector<F> lazy;
    std::vector<bool> lazy_flag;
    std::function<T(T,T)> calc;
    T identity;
    std::function<T(F,T)> action;
    std::function<F(F,F)> composition;
    F action_identity;
    
    void eval(int k){
        if(!lazy_flag[k])return;
        if(k<n-1){
            lazy[2*k+1] = composition(lazy[k],lazy[2*k+1]);
            lazy[2*k+2] = composition(lazy[k],lazy[2*k+2]);
            lazy_flag[2*k+1] = true;
            lazy_flag[2*k+2] = true;
        }
        dat[k] = action(lazy[k],dat[k]);
        lazy[k] = action_identity;
        lazy_flag[k] = false;
    }
    
    public:
    
    void init(int N,std::function<T(T,T)> func,T Identity,
    std::function<T(F,T)> Action,std::function<F(F,F)> Composition, F Action_identity){
        n=1;height=1;
        while(n<N){n*=2;height++;};
        dat.resize(2*n-1);
        lazy.resize(2*n-1);
        lazy_flag.resize(2*n-1);
        for(int i=0;i<2*n-1;++i){
            dat[i]=Identity;
            lazy[i]=Action_identity;
            lazy_flag[i]=false;
        }
        calc = func;
        identity = Identity;
        action = Action;
        composition = Composition;
        action_identity = Action_identity;
    }
    
    lazysegmenttree(int N,std::function<T(T,T)> func,T Identity,
    std::function<T(F,T)> Action,std::function<F(F,F)> Composition,F Action_identity){
        init(N,func,Identity,Action,Composition,Action_identity);
    }
    
    void set(std::vector<T> A){
        if(n<(int)A.size()){
            n=1;height=1;
            while(n<(int)A.size()){n*=2;height++;};
            dat.resize(2*n-1);
            lazy.resize(2*n-1);
            lazy_flag.resize(2*n-1);
        }
        for(int i=0;i<2*n-1;++i){
            dat[i]=identity;
            lazy[i]=action_identity;
            lazy_flag[i]=false;
        }
        for(unsigned i=0;i<A.size();i++){
            dat[n-1+i] = A[i];
        }
        for(int i=n-2;i>=0;i--){
            dat[i] = calc(dat[2*i+1],dat[2*i+2]);
        }
    }
    
    void update(int a,int b,F f){
        a+=n-1;
        b+=n-1;
        for(int i=height-1;i>=0;i--){
            if(((a+1)>>i)>0){
                eval(((a+1)>>i)-1);
            }
            if((b>>i)>0){
                eval((b>>i)-1);
            }
        }
        
        int l = a,r = b-1;
        while(a < b){
            if(a % 2 == 0){
                lazy[a] = composition(f,lazy[a]);
                lazy_flag[a] = true;
                a++;
            }
            a = (a-1)/2;
            
            if(b % 2 == 0){
                b--;
                lazy[b] = composition(f,lazy[b]);
                lazy_flag[b] = true;
            }
            b = (b-1)/2;
        }
        
        while(l>0){
            l = (l-1)/2;
            eval(2*l+1);eval(2*l+2);
            dat[l] = calc(dat[2*l+1],dat[2*l+2]);
        }
        while(r>0){
            r = (r-1)/2;
            eval(2*r+1);eval(2*r+2);
            dat[r] = calc(dat[2*r+1],dat[2*r+2]);
        }
        
    }
    
    T query(int a,int b){
        a+=n-1;
        b+=n-1;
        for(int i=height-1;i>=0;i--){
            if(((a+1)>>i)>0){
                eval(((a+1)>>i)-1);
            }
            if((b>>i)>0){
                eval((b>>i)-1);
            }
        }
        
        T L= identity,R = identity;
        while(a < b){
            if(a % 2 == 0){
                eval(a);
                L = calc(L,dat[a]);
                a++;
            }
            a = (a-1)/2;
            if(b % 2 == 0){
                b--;
                eval(b);
                R = calc(dat[b],R);
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


### 区間加算･区間和

セグ木の都合上作用の計算に区間の幅をもたせる必要があり、(和,区間幅)というペアを乗せることになる

#### 実行コード
```cpp
#include <bits/stdc++.h>

template<typename T,typename F>
class lazysegmenttree{/*省略*/};

int main(void){
    
    typedef std::pair<long long,long long> P;
    std::function<P(P,P)> func = [](P a,P b){
        return P{a.first+b.first,a.second+b.second};
    };
    
    std::function<P(long long,P)> action = [](long long f,P x){
        return P{x.first+f*x.second,x.second};
    };
    
    std::function<long long(long long,long long)> composition = [](long long f,long long g){
        return f+g;
    };
    
    int N = 10;
    lazysegmenttree<P,long long> lazyseg(N,func,{0,0},action,composition,0);
    lazyseg.set(std::vector<P>(N,{0,1}));
    

    lazyseg.update(0,7,3);
    lazyseg.update(3,10,5);

    std::cout << "[0,7) に 3 を、 [3,10) に 5 を足した結果" << std::endl;
    for(int i=0;i<N;i++){
        std::cout << lazyseg.query(i,i+1).first << " ";
    }
    
    return 0;
}
```

#### 出力
```
[0,7) に 3 を、 [3,10) に 5 を足した結果
3 3 3 8 8 8 8 5 5 5 
```

### 区間変更･区間min

こちらの場合は幅をもたせなくてもいいが、作用の単位元として「変更をしない」を実装する必要があり、作用側がペアになっている

#### 実行コード
```cpp
#include <bits/stdc++.h>

template<typename T,typename F>
class lazysegmenttree{/*省略*/};

int main(void){
    
    std::function<long long(long long,long long)> func = [](long long a,long long b){
        return std::min(a,b);
    };
    
    std::function<long long(std::pair<long long,bool>,long long)> action = [](std::pair<long long,bool> f,long long x){
        if(!f.second)return x;
        return f.first;
    };
    
    std::function<std::pair<long long,bool>(std::pair<long long,bool>,std::pair<long long,bool>)>
    composition = [](std::pair<long long,bool> f,std::pair<long long,bool> g){
        if(!f.second)return g;
        return f;
    };

    const long long INF = 100'000'000;
    
    int N = 10;
    lazysegmenttree<long long,std::pair<long long,bool>> lazyseg(N,func,INF,action,composition,{0,false});
    lazyseg.set({0,1,2,3,4,5,6,7,8,9});
    

    lazyseg.update(3,7,{100,true});

    std::cout << "[3,7) を 100 に変更した結果" << std::endl;
    for(int i=0;i<N;i++){
        std::cout << lazyseg.query(i,i+1) << " ";
    }
    std::cout << std::endl << std::endl;

    std::cout << "変更後の [5,10) の最小値" << std::endl;
    std::cout << lazyseg.query(5,10);
    
    return 0;
}
```

#### 出力
```
[3,7) を 100 に変更した結果
0 1 2 100 100 100 100 7 8 9 

変更後の [5,10) の最小値
7
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2024/02/21 | 遅延セグ木を追加 |