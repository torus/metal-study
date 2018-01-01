# Drawing Filled Bézier Curve with Metal Shader

![](https://github.com/torus/metal-study/raw/master/metal-bezier.png)

ベジェ曲線で囲まれた領域を塗りつぶすフラグメントシェーダ。

![](https://upload.wikimedia.org/wikipedia/commons/8/89/Bézier_3_big.svg)
- [Bézier curve - Wikipedia](https://en.wikipedia.org/wiki/B%C3%A9zier_curve)

ベジェ曲線は全ての t について、図の点 B で線分 R0R1 と接する事実を利用する。

R0 と R1 を通る直線の方程式を ax + by + c = 0 とする。ある点 (x0, y0) がこの直線のどちら側にあるかは、ax0 + by0 + c の符号を調べれば分かる。（このプログラムでは間違えて外側を塗ってしまった。）この方程式の a、b および c の値を 4 個の制御点の座標と t の値から

uv 空間上の全ての点について、その点から曲線上の全ての点までの距離を計算し、その最小値が負の値ならばその点に色をつける。

ある点から曲線の全ての点までの距離を求めると書いたけど、実際には曲線上の全ての点における接線との距離をベジェ曲線の方程式におけるパラメタ t の多項式として表し、この多項式が実根を持つかどうかを判定して色を決める。

図がないと説明しずらいけど。

4 次方程式の解き方についてはこのページが分かりやすかったです：[４次方程式解の公式 | Fukusukeの数学めも](http://mathsuke.mods.jp/ferrari_formula/)

色をつける判定のための計算ではこちらを参考にしました：[ax^4+bx^3+cx^2+dx+e=0(a≠0)というxの4次方程式が相異なる4つの実数解をもつ... - Yahoo!知恵袋](https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q12120530007)


