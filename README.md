# SwiftOthello

Swift で作られたオセロゲーム。
オンライン、オフライン対応。
  
### [オンライン]
Swift + Flask(Nginxは使っていません。)  
サーバーサイドがオセロ盤 4x4 にしか対応していない。  
プレイヤー：　Q-leaning や DQN や　NN+GA は面倒なので今回は採用せず　（実装は他のリポジトリにある）  
1. Random　ランダムに置く  
2. CountStone　一番多くの石を取れるところに置く  
3. Naive　左上から置けるところに置く  

### [オフライン]
Swift　で実装  
プレイヤー：  
Random　のみ

<img src="https://user-images.githubusercontent.com/46663023/55683461-1df5ac80-597b-11e9-94fb-799a14d881d2.gif" width="300px">
