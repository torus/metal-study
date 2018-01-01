# Drawing Filled Bézier Curve with Metal Shader

![](https://github.com/torus/metal-study/raw/master/metal-bezier.png)

ベジェ曲線で囲まれた領域を塗りつぶすフラグメントシェーダ。

uv 空間上の全ての点について、その点から曲線上の全ての点までの距離を計算し、その最小値が負の値ならばその点に色をつける。

ある点から曲線の全ての点までの距離を求めると書いたけど、実際には曲線上の全ての点における接線との距離をベジェ曲線の方程式におけるパラメタ t の多項式として表し、この多項式が実根を持つかどうかを判定して色を決める。

図がないと説明しずらいけど。

4 次方程式の解き方についてはこのページが分かりやすかったです：[４次方程式解の公式 | Fukusukeの数学めも](http://mathsuke.mods.jp/ferrari_formula/)

色をつける判定のための計算ではこちらを参考にしました：[ax^4+bx^3+cx^2+dx+e=0(a≠0)というxの4次方程式が相異なる4つの実数解をもつ... - Yahoo!知恵袋](https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q12120530007)


