#include "ofApp.h"

const int SAMPLE_COUNT = 48;
//const int SAMPLE_COUNT = 64;
//const int SAMPLE_COUNT = 32;

// アウトライン1文字分の型を作ろう
struct ofOutline {
	vector<glm::vec3> vertices;
};

// 1文字に対応するアウトラインのデータを作ろう
class OutlineChar {
	uint32_t c;
	vector<ofOutline> oo;
	string strHex;
	string strCode;
	string strCoord;
public:
	OutlineChar(uint32_t c, ofTrueTypeFont font) {
		this->c = c;
		stringstream ss;
		ss << std::hex << c;
		this->strHex = ss.str();
		this->strCode = "k" + strHex + "Code";
		this->strCoord = "k" + strHex + "Coord";
		ofPath chara_path = font.getCharacterAsPoints(c, true, false);
		vector<ofPolyline> outline = chara_path.getOutline();
		for (int i = 0; i < outline.size(); i++) {
			if (i != 0) { ofNextContour(true); }
			auto vertices = outline[i].getResampledByCount(SAMPLE_COUNT).getVertices();
			ofOutline ol;
			for (auto& v : vertices) {
				glm::vec3 vv(v.x, v.y, v.z);
				ol.vertices.push_back(vv);
			}
			oo.push_back(ol);
		}
	}
	void printInitialData() {
		cout << "static final char " << strCode << " = '" << (char)c << "';" << endl;
		cout << "static final float[][] " << strCoord << " = {" << endl;
		for (ofOutline& o : oo) {
			cout << std::fixed;
			cout << "  {";
			for (glm::vec3& v : o.vertices) {
				cout << std::setprecision(2) << " " << v.x;
				cout << std::setprecision(2) << ", " << v.y;
				cout << ", ";
			}
			cout << std::defaultfloat;
			cout << "}," << endl;
		}
		cout << "};" << endl;
	}
	void printSetupLogic() {
		cout << " outline = new ofOutline("
			<< strCode << ", " << strCoord << ");" << endl;
		cout << " outlineWords.add(outline);" << endl;
	}
};

//--------------------------------------------------------------
void ofApp::setup() {

	ofSetFrameRate(60);
	ofSetWindowTitle("openframeworks");

	ofBackground(0);
	ofSetColor(255);
	ofSetLineWidth(1.5);
	ofEnableDepthTest();

	this->font_size = 80;
	this->font.loadFont("fonts/Kazesawa-Bold.ttf", this->font_size, true, true, true);

	this->word = " 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

	// Processing java用ソースコードを吐き出したい
	// 初期値のテーブルを定義してデータ構造をセットアップしよう
	cout << "static class ofOutlineCoord {" << endl;
	cout << " ArrayList<PVector> vertices = new ArrayList();" << endl;
	cout << " ofOutlineCoord(float[] c) {" << endl;
	cout << "  for (int i = 0; i < c.length; i+=2) {" << endl;
	cout << "   PVector v = new PVector(c[i+0], c[i+1]);" << endl;
	cout << "   vertices.add(v);" << endl;
	cout << "  }" << endl;
	cout << " }" << endl;
	cout << "}" << endl;
	cout << "static class ofOutline {" << endl;
	cout << " char code;" << endl;
	cout << " ArrayList<ofOutlineCoord> coord;" << endl;
	cout << " ofOutline(char code, float[][] coord) {" << endl;
	cout << "  this.code = code;" << endl;
	cout << "  this.coord = new ArrayList();" << endl;
	cout << "  for (float[] c : coord) {" << endl;
	cout << "   ofOutlineCoord vertices = new ofOutlineCoord(c);" << endl;
	cout << "   this.coord.add(vertices);" << endl;
	cout << "  }" << endl;
	cout << " }" << endl;
	cout << "}" << endl;
	cout << endl;
	cout << "static class openFrameworksOutline {" << endl;
	for (int i = 0; i < word.size(); i++) {
		OutlineChar oc(word[i], font);
		oc.printInitialData();
		cout << endl;
	}
	cout << "static ArrayList<ofOutline> ofOutline() {" << endl;
	cout << " ArrayList<ofOutline> outlineWords = new ArrayList();" << endl;
	cout << " ofOutline outline;" << endl;
	for (int i = 0; i < word.size(); i++) {
		OutlineChar oc(word[i], font);
		cout << endl;
		oc.printSetupLogic();
	}
	cout << " return outlineWords;" << endl;
	cout << "}" << endl;
	cout << "}" << endl;
}

//--------------------------------------------------------------
void ofApp::update() {

	ofSeedRandom(39);
}

//--------------------------------------------------------------
void ofApp::draw() {
	this->cam.begin();
	ofRotateX(180);
	//ofRotateY(ofGetFrameNum() * 0.66666666666);

	//cout << word.size() << endl;
	for (int i = 0; i < word.size(); i++) {

		ofPath chara_path = this->font.getCharacterAsPoints(word[i], true, false);
		vector<ofPolyline> outline = chara_path.getOutline();
		//cout << outline.size() << endl;

		ofFill();
		ofBeginShape();
		for (int outline_index = 0; outline_index < outline.size(); outline_index++) {

			if (outline_index != 0) { ofNextContour(true); }

			auto vertices = outline[outline_index].getResampledByCount(SAMPLE_COUNT).getVertices();
			for (auto& vertex : vertices) {
				//cout << vertex << endl;

				auto location = vertex - glm::vec3(this->font_size * 0.5, this->font_size * -0.5, 320);
				auto rotation_y = glm::rotate(glm::mat4(), (i * 13.5f) * (float)DEG_TO_RAD, glm::vec3(0, 1, 0));
				location = glm::vec4(location, 0) * rotation_y;

				ofVertex(location);
			}
		}
		ofEndShape();
	}

	this->cam.end();
}

//--------------------------------------------------------------
int main() {

	ofSetupOpenGL(720, 720, OF_WINDOW);
	ofRunApp(new ofApp());
}