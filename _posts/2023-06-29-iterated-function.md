---
title: "反復写像"
permalink: /posts/iterated-function
writer: 0214sh7
layout: library
---

init
- 数列$$F$$を与えると、すべての整数 $$x (0 \leq x < \vert F \vert)$$ について $$f(x) = F[x]$$ となるように関数 $$f$$ を設定する 
- 計算量は$$N=\vert F \vert$$とし、$$Ο(N)$$

iterated_function
- コンストラクタ。initを呼ぶ

solve
- 整数 $$x$$ であって$$0 \leq x < N$$ を満たすようなものと非負整数 $$ k $$ を与えると、$$\overbrace{f(f(\cdots f}^{k}(x)))$$ を求め、返す
- もし$$k = 0$$なら$$x$$そのものを返す
- 範囲外なら$$-1$$を返す
- 計算量は$$Ο(N \log k)$$

[github](https://github.com/0214sh7/procon-library/blob/master/algorithm/iterated%20function.cpp)

```cpp
class iterated_function{
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    private:
    std::vector<int> T[64];
    int N;
    
    public:
    void init(std::vector<int> F){
        N = F.size();
        T[0] = F;
        for(int j=1;j<64;j++){
            T[j].resize(N);
            for(int i=0;i<N;i++){
                T[j][i] = T[j-1][T[j-1][i]];
            }
        }
        
    }

    iterated_function(std::vector<int> F){
        init(F);
    }

    int solve(int x,long long k){
        if(!(0<=x && x<N) || k<0){
            return -1;
        }

        int y = x;
        for(int i=0;(k>>i)>0;i++){
            if((k>>i)%2==1){
                y = T[i][y];
            }
        }

        return y;
    }
    
};
```


## 使用例
***

### 実行コード
```cpp
#include <bits/stdc++.h>

class iterated_function{/*省略*/};

int main() {
    
    std::vector<int> F = {1,2,3,4,5,2};
    iterated_function func(F);

    std::cout << "0からk回辿ったときの頂点" << std::endl;
    for(int k=0;k<=15;k++){
        std::cout << func.solve(0,k) << " ";
    }
    std::cout << std::endl << std::endl;

    std::cout << "各頂点から3回辿ったときの頂点" << std::endl;
    for(int i=0;i<6;i++){
        std::cout << func.solve(i,3) << " ";
    }
    std::cout << std::endl;
    
}
```

### 出力
```
0からk回辿ったときの頂点
0 1 2 3 4 5 2 3 4 5 2 3 4 5 2 3 

各頂点から3回辿ったときの頂点
3 4 5 2 3 4 
```

## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2022/07/03 | 反復写像を追加 |

## 確認した問題

| 問題 | 提出 |
| :---: | :--- |
| [ABC167-D](https://atcoder.jp/contests/abc167/tasks/abc167_d) | [提出](https://atcoder.jp/contests/abc167/submissions/32945330) |