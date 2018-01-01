# Drawing Filled Bézier Curve with Metal Shader

![](https://github.com/torus/metal-study/raw/master/metal-bezier.png)

### 概要

ベジェ曲線で囲まれた領域を塗りつぶすフラグメントシェーダ。

uv 空間上の全ての点について、その点から曲線上の全ての点までの距離を計算し、その最小値が負の値ならばその点に色をつける。

ある点から曲線の全ての点までの距離を求めると書いたけど、実際には曲線上の全ての点における接線との距離をベジェ曲線の方程式におけるパラメタ t の多項式として表し、この多項式が実根を持つかどうかを判定して色を決める。

### 実装

![](https://upload.wikimedia.org/wikipedia/commons/8/89/Bézier_3_big.svg)\
-- [Bézier curve - Wikipedia](https://en.wikipedia.org/wiki/B%C3%A9zier_curve)

ベジェ曲線は全ての t について、図の点 B で線分 R<sub>0</sub>R<sub>1</sub> と接する事実を利用する。

R<sub>0</sub> と R<sub>1</sub> を通る直線の方程式を lx + my + n = 0 とする。ある点 (x<sub>0</sub>, y<sub>0</sub>) がこの直線のどちら側にあるかは、lx<sub>0</sub> + my<sub>0</sub> + n の符号を調べれば分かる。（このプログラムでは間違えて外側を塗ってしまった。）この方程式の l、m および n の値を 4 個の制御点の座標と t の値から頑張って求める。この時ベクトル (m, -l) がこの直線の法線になることを利用する。

l = l<sub>2</sub>t<sup>2</sup> + l<sub>1</sub>t + l<sub>0</sub>

と書く事にすると、

```c++
    float l2 = - p.y + 3 * q.y - 3 * r.y + s.y;
    float l1 = 2 * p.y - 4 * q.y + 2 * r.y;
    float l0 = - p.y + q.y;
```

となる。m についても同様に

```c++
    float m2 = - (- p.x + 3 * q.x - 3 * r.x + s.x);
    float m1 = - (2 * p.x - 4 * q.x + 2 * r.x);
    float m0 = - (- p.x + q.x);
```

となる。

次に n を求めたい。点 R<sub>0</sub> の座標を (u<sub>0</sub>, u<sub>1</sub>) とすると、

l(x - u<sub>0</sub>) + m(y - u<sub>1</sub>) = 0

が成り立つことから

n = - (lu<sub>0</sub> + mu<sub>1</sub>)

となる。ところで、R<sub>0</sub> の位置を t と制御点の位置ベクトル p、q、r、s を使って書くと

(1 - t)<sup>2</sup>p + 2t(1 - t)q + t<sup>2</sup>r

となるので、上の l、m の値も使うと n は t の 4 次多項式になる。

（つづく）

### 参考ページ

4 次方程式の解き方についてはこのページが分かりやすかったです：[４次方程式解の公式 | Fukusukeの数学めも](http://mathsuke.mods.jp/ferrari_formula/)

色をつける判定のための計算ではこちらを参考にしました：[ax^4+bx^3+cx^2+dx+e=0(a≠0)というxの4次方程式が相異なる4つの実数解をもつ... - Yahoo!知恵袋](https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q12120530007)


