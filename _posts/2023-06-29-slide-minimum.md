---
title: "スライド最小値"
permalink: /posts/slideminimum
writer: 0214sh7
layout: library
---

数列$$A$$と整数$$K$$を与えると、以下の数式を満たす要素数が$$\vert A \vert -K+1$$の数列$$R$$を構成し、返す

$$R_i = min(A_i , A_{i+1} , ... , A_{i+K-1})$$


計算量は$$O(\vert A \vert)$$

[github](https://github.com/0214sh7/procon-library/blob/master/algorithm/slide%20minimum.cpp)

```
std::vector<long long> slide_minimum(std::vector<long long> A,int K){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    std::vector<long long> R;
    int N = A.size();
    std::deque<int> D;
    for(int i=0;i<N;i++){
        while(!D.empty() && A[D.back()]>=A[i]){D.pop_back();}
        D.push_back(i);
        if(i-K+1>=0){
            R.push_back(A[D.front()]);
            if(D.front()==i-K+1){
                D.pop_front();
            }
        }
    }
    return R;
}
```


## 使用例
***

### 実行コード
```
#include <bits/stdc++.h>

std::vector<long long> slide_minimum(std::vector<long long> A,int K){/*省略*/}

int main(void){
    
    std::vector<long long> A = {3,1,4,1,5,9,2,6,5,3,5,8,9,7,9,3,2,3},B;
    long long K = 3;
    
    B = slide_minimum(A,K);
    for(int i=0;i<B.size();i++){
        std::cout << B[i] << " ";
    }
    std::cout << std::endl;
    
    return 0;
}
```

### 出力
```
1 1 1 1 2 2 2 3 3 3 5 7 7 3 2 2 
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2021/03/26 | 使用例を追加 |
| 2020/04/23 | スライド最小値を追加 |
