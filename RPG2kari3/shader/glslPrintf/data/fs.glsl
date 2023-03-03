// https://stackoverflow.com/questions/44793883/convert-floating-point-numbers-to-decimal-digits-in-glsl
// GLSL内部で値を表示する
// （PC-8001さんに教えていただきました）
//
// デフォルトはビュー行列とモデル行列（合わせてビューモデル行列）は使っていないと思われる
// （uViewMatrix(camera)⇒単位行列扱い（そもそもない）
// modelview⇒単位行列
// projection⇒transformと中身が同じ
// 
// hint(DISABLE_OPTIMIZED_STROKE)を設定した場合
// 。。。シェーダーをp5.jsから移植する場合はこれを設定して前提を合わせることをオススメ
uniform mat4 transform;		// p5.jsの(projectionMatrix * uModelViewMatrix)
uniform mat4 modelview;		// p5.jsのuModelViewMatrixに対応する
uniform mat4 projection;	// p5.jsのuProjectionMatrixに対応する
// p5.jsのuViewMatrixに対応する行列が見当たらない
//
// （p5.jsのシェーダーを書くとは「WebGL1.0」と戦うということ）


//---------------------------------------------------------------------------
// Fragment
//---------------------------------------------------------------------------
varying vec2 pos;                   // screen position <-1,+1>
uniform sampler2D txr_font;     // ASCII 32x8 characters font texture unit
uniform float fxs,fys;          // font/screen resolution ratio
//---------------------------------------------------------------------------
const int _txtsiz=32;           // text buffer size
int txt[_txtsiz],txtsiz;        // text buffer and its actual size
vec4 col;                       // color interface for txt_print()
//---------------------------------------------------------------------------
void txt_decimal(float x)       // print float x into txt
    {
    int i,j,c;          // l is size of string
    float y,a;
    const float base=10.0;
    txtsiz=0;
    // handle sign
#if 0
    if (x<0.0) { txt[txtsiz]='-'; txtsiz++; x=-x; }
     else      { txt[txtsiz]='+'; txtsiz++; }
#else
    if (x<0.0) { txt[txtsiz]=0x2d; txtsiz++; x=-x; }
     else      { txt[txtsiz]=0x2b; txtsiz++; }
#endif
    // divide to int(x).fract(y) parts of number
    y=x; x=floor(x); y-=x;
    // handle integer part
    i=txtsiz;                   // start of integer part
    for (;txtsiz<_txtsiz;)
        {
        a=x;
        x=floor(x/base);
        a-=base*x;
#if 0
        txt[txtsiz]=int(a)+'0'; txtsiz++;
#else
        txt[txtsiz]=int(a)+0x30; txtsiz++;
#endif
        if (x<=0.0) break;
        }
    j=txtsiz-1;                 // end of integer part
    for (;i<j;i++,j--)      // reverse integer digits
        {
        c=txt[i]; txt[i]=txt[j]; txt[j]=c;
        }
    // handle fractional part
#if 0
    for (txt[txtsiz]='.',txtsiz++;txtsiz<_txtsiz;)
#else
    int point = 0;
    for (txt[txtsiz]=0x2e,txtsiz++;txtsiz<_txtsiz;)
#endif
        {
        y*=base;
        a=floor(y);
        y-=a;
#if 0
        txt[txtsiz]=int(a)+'0'; txtsiz++;
#else
        txt[txtsiz]=int(a)+0x30; txtsiz++;
        point++;
        if (3 <= point) {
        	break;
        }
#endif
        if (y<=0.0) break;
        }
    txt[txtsiz]=0;  // string terminator
    }
//---------------------------------------------------------------------------
void txt_print(float x0,float y0)   // print txt at x0,y0 [chars]
    {
    int i;
    float x,y;
    // fragment position [chars] relative to x0,y0
    x=0.5*(1.0+pos.x)/fxs; x-=x0;
    y=0.5*(1.0-pos.y)/fys; y-=y0;
    // inside bbox?
    if ((x<0.0)||(x>float(txtsiz))||(y<0.0)||(y>1.0)) return;
    // get font texture position for target ASCII
    i=int(x);               // char index in txt
    x-=float(i);
    i=txt[i];
    x+=float(int(i-((i/32)*32)));
    y+=float(int(i/32));
    x/=32.0; y/=8.0;    // offset in char texture
    col=texture2D(txr_font,vec2(x,y));
    }
//---------------------------------------------------------------------------

void show(float x, float y, float value) {
    txt_decimal(value);
    txt_print(x, y);
}
void show(float x, float y, vec4 v) {
	const int TAB = 12;
	show(x + TAB * 0, y, v.x);
	show(x + TAB * 1, y, v.y);
	show(x + TAB * 2, y, v.z);
	show(x + TAB * 3, y, v.w);
}
void show(float x, float y, mat4 m) {
	show(x, y + 0, m[0]);
	show(x, y + 1, m[1]);
	show(x, y + 2, m[2]);
	show(x, y + 3, m[3]);
}

void main()
    {
    col=vec4(0.0,0.0,1.0,1.0);  // background color
    
   show(-20.0,-20.0, transform);
   show(-20.0,-10.0, modelview);
   show(-20.0,0.0, projection);
   mat4 m = projection * modelview;
   show(-20.0,+10.0, m);
   
    gl_FragColor=col;
    }
//---------------------------------------------------------------------------
