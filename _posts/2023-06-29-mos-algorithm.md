---
title: "Moのアルゴリズム"
permalink: /posts/mos-algorithm
writer: 0214sh7
layout: library
---

すもももももももものうち

いくつかの半開区間 $$[l_i,r_i)$$ についての答えを高速に求める
$$[l,r)$$ での答えがわかっているとき、隣接する区間 $$[l-1,r),[l+1,r),[l,r-1),[l,r+1)$$ についての答えが高速にわかる場合に有効

第一引数に区間全体の長さ $$N$$ 、第二引数にクエリの数 $$Q$$ 、第三引数にクエリのリスト、そして第四～第七引数にはそれぞれ
- $$[l,r)$$ の答えから $$[l-1,r)$$ の答えを求める関数
- $$[l,r)$$ の答えから $$[l+1,r)$$ の答えを求める関数
- $$[l,r)$$ の答えから $$[l,r-1)$$ の答えを求める関数
- $$[l,r)$$ の答えから $$[l,r+1)$$ の答えを求める関数

を与えると、各クエリに対しての答えをvectorで返す

計算量は第四～第七引数で与えた関数の計算量を $$f$$ とすると $$Ο(Q \log Q + N \sqrt{Q} f)$$

[github](https://github.com/0214sh7/procon-library/blob/master/algorithm/mos-algorithm.cpp)

```
std::vector<long long> Mo(int N,int Q,std::vector<std::pair<int,int>> X, 
std::function<void(int,long long&)> lm, std::function<void(int,long long&)> lp, 
std::function<void(int,long long&)> rm, std::function<void(int,long long&)> rp){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    int rQ;
    std::map<std::pair<int,int>,std::vector<int>> index;
    std::vector<int> block(N,0);
    std::vector<long long> Ans(Q);

    std::function<bool(std::pair<int,int>, std::pair<int,int>)> comp = [&](std::pair<int,int> A,std::pair<int,int> B){
        if(block[A.first]!=block[B.first]){
            return (block[A.first]<block[B.first]);
        }
        if(A.second != B.second){
            return (A.second < B.second);
        }
        return (A.first < B.first);
    };

    for(int i=0;i<Q;i++){
        index[X[i]].push_back(i+1);
    }
    int q = index.size();

    rQ = 1;
    while((rQ+1)*(rQ+1)<=q)rQ++;

    int now = 0;
    for(int i=0;i<rQ-1;i++){
        now += ((N+rQ-1-i)/rQ);
        block[now]++;
    }
    for(int i=0;i<N-1;i++){
        block[i+1] += block[i];
    }

    std::vector<std::pair<int,int>> Y(q);
    now = 0;
    for(auto e:index){
        Y[now] = e.first;
        now++;
    }

    std::sort(Y.begin(),Y.end(),[&](auto a, auto b){return comp(a, b);});

    int L = 0,R = 0;
    long long Result = 0;

    for(int i=0;i<q;i++){
        
        while(Y[i].first < L){
            lm(L,Result);
            L--;
        }
        while(R < Y[i].second){
            rp(R,Result);
            R++;
        }
        while(L < Y[i].first){
            lp(L,Result);
            L++;
        }
        while(Y[i].second < R){
            rm(R,Result);
            R--;
        }

        for(int k:index[Y[i]]){
            Ans[k-1] = Result;
        }

    }

    return Ans;

    //lm(i): [i,r)を[i-1,r)にする
    //lp(i): [i,r)を[i+1,r)にする
    //rm(i): [i,r)を[i,r-1)にする
    //rp(i): [i,r)を[i,r+1)にする

}
```


## 使用例
***

<br>
$$A = (1,2,3,4,5)$$ の $$[l,r)$$ の和を求める

これは $$[l,r)$$ の和がわかっていれば $$[l-1,r),[l+1,r),[l,r-1),[l,r+1)$$ の和が $$O(1)$$ でわかる\\
例えば $$[1,3)$$ の和が $$A_1 + A_2 = 2 + 3 = 5$$ であることがわかっていれば $$[1,4)$$ の和は $$5 + A_3 = 5 + 4 = 9$$ であることがわかる


### 実行コード
```
#include <bits/stdc++.h>

std::vector<long long> Mo(int N,int Q,std::vector<std::pair<int,int>> X, 
std::function<void(int,long long&)> lm, std::function<void(int,long long&)> lp, 
std::function<void(int,long long&)> rm, std::function<void(int,long long&)> rp){/*省略*/}

int main(void){
    
    int N = 5, Q = 15;
    std::vector<long long> A = {1,2,3,4,5};
    std::vector<std::pair<int,int>> LR = {
        {0,1},
        {0,2},
        {0,3},
        {0,4},
        {0,5},
        {1,2},
        {1,3},
        {1,4},
        {1,5},
        {2,3},
        {2,4},
        {2,5},
        {3,4},
        {3,5},
        {4,5},
    };
    
    std::function<void(int,long long&)> lm = [&](int i,long long& res){
        res += A[i-1];
    };

    std::function<void(int,long long&)> lp = [&](int i,long long& res){
        res -= A[i];
    };

    std::function<void(int,long long&)> rm = [&](int i,long long& res){
        res -= A[i-1];
    };

    std::function<void(int,long long&)> rp = [&](int i,long long& res){
        res += A[i];
    };


    std::vector<long long> Ans = Mo(N,Q,LR,lm,lp,rm,rp);

    for(int i=0;i<(int)Ans.size();i++){
        std::cout << "[" << LR[i].first << "," << LR[i].second << ")  " << Ans[i] << std::endl;
    }

    return 0;
}
```

### 出力
```
[0,1)  1
[0,2)  3
[0,3)  6
[0,4)  10
[0,5)  15
[1,2)  2
[1,3)  5
[1,4)  9
[1,5)  14
[2,3)  3
[2,4)  7
[2,5)  12
[3,4)  4
[3,5)  9
[4,5)  5

```

## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2023/03/13 | Moのアルゴリズムを追加 |

## 確認した問題

| 問題 | 提出 |
| :---: | :--- |
| [ABC293-G](https://atcoder.jp/contests/abc293/tasks/abc293_g) | [提出](https://atcoder.jp/contests/abc293/submissions/39690323) |