---
title: "二次元配列の回転"
permalink: /posts/vector2d-rotate
writer: 0214sh7
layout: library
---

二次元配列$$A$$を与えると、$$A$$を反時計回りに回転させ返す

第二変数を$$true$$にすると時計回りに回転させる

もし$$A[i]$$の長さが揃っていない場合は最も長いものに合わせ、足りない部分は第三変数の値(デフォルトは$$0$$)で埋める

計算量は配列を$$N$$行$$M$$列として$$Ο(NM)$$

[github]()

```
std::vector<std::vector<char>> vector2D_rotate(std::vector<std::vector<char>> A,bool clockwise=false,char leading = 0){
    /*
    Copyright (c) 2021 0214sh7
    https://github.com/0214sh7/library/
    */
    int N = A.size();
    if(N==0)return A;
    
    int M = 0;
    for(int i=0;i<N;i++){
        M = std::max(M,(int)A[i].size());
    }
    
    std::vector<std::vector<char>> B(M,std::vector<char>(N,leading));
    
    for(int i=0;i<N;i++){
        for(int j=0;j<A[i].size();j++){
            if(clockwise){
                B[j][N-1-i]=A[i][j];
            }else{
                B[M-1-j][i]=A[i][j];
            }
        }
    }
    
    return B;
}
```

## 使用例
***

### 実行コード
```
#include <bits/stdc++.h>

std::vector<std::vector<char>> vector2D_rotate(std::vector<std::vector<char>> A,bool clockwise=false,char leading = 0){/*省略*/}

int main(){
    
    std::vector<std::vector<char>> A ={
        {'a','b','c'},
        {'d','e','f'},
        {'g','h','i'}
    };
    
    std::cout << "回転なし" << std::endl;
    for(int i=0;i<A.size();i++){
        for(int j=0;j<A[i].size();j++){
            std::cout << A[i][j] << " ";
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
    
    std::vector<std::vector<char>> counter = vector2D_rotate(A);
    
    std::cout << "反時計回り" << std::endl;
    for(int i=0;i<counter.size();i++){
        for(int j=0;j<counter[i].size();j++){
            std::cout << counter[i][j] << " ";
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
    
    std::vector<std::vector<char>> clockwise = vector2D_rotate(A,true);
    
    std::cout << "時計回り" << std::endl;
    for(int i=0;i<clockwise.size();i++){
        for(int j=0;j<clockwise[i].size();j++){
            std::cout << clockwise[i][j] << " ";
        }
        std::cout << std::endl;
    }
    
    return 0;
}
```

### 出力
```
回転なし
a b c 
d e f 
g h i 

反時計回り
c f i 
b e h 
a d g 

時計回り
g d a 
h e b 
i f c
```


## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2021/09/12 | 二次元配列の回転を追加 |