---
title: "ランレングス圧縮"
permalink: /posts/run-length-encode
writer: 0214sh7
layout: library
---

文字列$$S$$を与えると、$$S$$をランレングス圧縮(連長圧縮)して返す

ランレングス圧縮とは、文字列を「文字と、それがいくつ続くか」の組に変換するものである
ちなみに可逆変換

計算量は$$Ο(\vert S \vert)$$

[github](https://github.com/0214sh7/procon-library/blob/master/algorithm/runlength%20encode.cpp)

```cpp
std::vector<std::pair<char,int>> runlength_encode(std::string S){
    // Copyright (c) 2023 0214sh7
    // https://github.com/0214sh7/library/
    std::vector<std::pair<char,int>> R;
    for(int i=0;i<(int)S.size();i++){
        if(i==0 || S[i]!=S[i-1]){
            R.push_back({S[i],1});
        }else{
            R.back().second++;
        }
    }
    return R;
}
```


## 使用例
***

### 実行コード
```cpp
#include <bits/stdc++.h>

std::vector<std::pair<char,int>> runlength_encode(std::string S){/*省略*/}

int main(void){
    
    std::string S = "abbcccddeeeacddd";
    std::vector<std::pair<char,int>> R = runlength_encode(S);
    for(int i=0;i<(int)R.size();i++){
        std::cout << R[i].first << " " << R[i].second << std::endl;
    }
    
    return 0;
}
```

### 出力
```
a 1
b 2
c 3
d 2
e 3
a 1
c 1
d 3
```

## 更新履歴
***

| 日時 | 内容 |
| :---: | :--- |
| 2023/06/29 | ライセンスのコメントアウトを変更 |
| 2022/07/10 | ランレングス圧縮を追加 |

## 確認した問題

| 問題 | 提出 |
| :---: | :--- |
| [ABC259-C](https://atcoder.jp/contests/abc259/tasks/abc259_c) | [提出](https://atcoder.jp/contests/abc259/submissions/33129519) |