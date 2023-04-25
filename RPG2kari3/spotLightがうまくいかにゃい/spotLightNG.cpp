#include "ofMain.h"

class ofApp : public ofBaseApp {
public:
    void setup();
    void draw();

    float n;
};

void ofApp::setup() {
    ofSetWindowTitle("OpenFrameworks");

    ofSetSmoothLighting(true);
    ofEnableDepthTest();

    n = 0;
}

void ofApp::draw() {
    // 原点を画面中央に移動しておく
    ofVec3f origin(ofGetWidth() * 0.5f, ofGetHeight() * 0.5f, 0.0f);
    ofTranslate(origin);

    ofBackground(0);

    // スポットライトを置く
    ofLight spotLight;
    // （⇒この行をsetPointLight()（点光源）に変えるか
    //     コメントアウトすると（デフォルトが点光源っぽい）
    //     板が紫色になる）
    spotLight.setSpotlight();
    // spotLight.setPointLight();

    // 光の色は紫色にする
    ofColor lightColor(255, 0, 255);
    spotLight.setDiffuseColor(lightColor);
    spotLight.setSpecularColor(lightColor);

    // ライトの位置は原点から画面手前（z座標）500.0fにする
    // （⇒最初は setPosition(0.0f, 0.0f, 500.0f); にしていたが
    // 　　ライトの位置は ofApp::draw() 先頭の ofTranslate(origin);
    //     では移動しなかった（別座標らしい。そういうものなのか？））
    spotLight.setPosition(origin.x, origin.y, 500.0f);

    // ライトの向きを横にぐるぐる回す
    float x = sin(n);
    float y = 0;
    float z = cos(n);
    ofVec3f direction(x, y, z);
    spotLight.setOrientation(direction);

    // コーンの広がりを60度、よくわかりゃん値を20.0fにする
    float angle = ofRadToDeg(PI / 3);
    float concentration = 20.0f;
    spotLight.setSpotlightCutOff(angle);
    spotLight.setSpotConcentration(concentration);

    // スポットライトが効くようにする
    // （⇒この行をコメントアウトすると白い板が表示される）
    spotLight.enable();

    // 白い板にスポットライトを当てる
    ofSetLineWidth(0);
    ofSetColor(255);
    ofFill();
    ofDrawBox(0, 0, 0, 600, 500, 10);

    n += 0.02;
}

int main() {
    ofSetupOpenGL(800, 600, OF_WINDOW);
    ofRunApp(new ofApp());
}
