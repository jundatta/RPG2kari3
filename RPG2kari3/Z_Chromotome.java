// PC-8001(TN8001)のご厚意でいただいたにゃ＼(^_^)／
// https://gist.github.com/TN8001/e3e2daa2031fc4e48aa65329880ee7d6

// https://github.com/kgolid/chromotome
// https://kgolid.github.io/chromotome-site/

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;


class Palette {
  String name;
  int[] colors;
  int size;
  int stroke;
  int background;

  Palette(String name, int[] colors) {
    this(name, colors, 0, 0);
  }

  Palette(String name, int[] colors, int background) {
    this(name, colors, 0, background);
  }

  Palette(String name, int[] colors, int stroke, int background) {
    this.name = name;
    this.colors = colors;
    this.size = colors.length;
    this.stroke = stroke;
    this.background = background;
  }
}

class Chromotome {
  private static Map<String, Palette> palettes;
  private static String[] keys;

  public static Palette getRandom() {
    return palettes.get(keys[(int) Math.floor(Math.random() * palettes.size())]);
  }

  public static Palette get() {
    return getRandom();
  }

  public static Palette get(String name) {
    return palettes.get(name);
  }

  public static Collection<Palette> getAll() {
    return palettes.values();
  }

  public static Set<String> getNames() {
    return palettes.keySet();
  }

  static {
    palettes = new HashMap<String, Palette>();
    palettes.put("frozen-rose", new Palette("frozen-rose", new int[]{ 0xff29368f, 0xffe9697b, 0xff1b164d, 0xfff7d996 }, 0xfff2e8e4));
    palettes.put("winter-night", new Palette("winter-night", new int[]{ 0xff122438, 0xffdd672e, 0xff87c7ca, 0xffebebeb }, 0xffebebeb));
    palettes.put("saami", new Palette("saami", new int[]{ 0xffeab700, 0xffe64818, 0xff2c6393, 0xffeecfca }, 0xffe7e6e4));
    palettes.put("knotberry1", new Palette("knotberry1", new int[]{ 0xff20342a, 0xfff74713, 0xff686d2c, 0xffe9b4a6 }, 0xffe5ded8));
    palettes.put("knotberry2", new Palette("knotberry2", new int[]{ 0xff1d3b1a, 0xffeb4b11, 0xffe5bc00, 0xfff29881 }, 0xffeae2d0));
    palettes.put("tricolor", new Palette("tricolor", new int[]{ 0xffec643b, 0xff56b7ab, 0xfff8cb57, 0xff1f1e43 }, 0xfff7f2df));
    palettes.put("foxshelter", new Palette("foxshelter", new int[]{ 0xffff3931, 0xff007861, 0xff311f27, 0xffbab9a4 }, 0xffdddddd));
    palettes.put("hermes", new Palette("hermes", new int[]{ 0xff253852, 0xff51222f, 0xffb53435, 0xffecbb51 }, 0xffeeccc2));
    palettes.put("olympia", new Palette("olympia", new int[]{ 0xffff3250, 0xffffb33a, 0xff008c36, 0xff0085c6, 0xff4c4c4c }, 0xff0b0b0b, 0xfffaf2e5));
    palettes.put("byrnes", new Palette("byrnes", new int[]{ 0xffc54514, 0xffdca215, 0xff23507f }, 0xff0b0b0b, 0xffe8e7d4));
    palettes.put("butterfly", new Palette("butterfly", new int[]{ 0xfff40104, 0xfff6c0b3, 0xff99673a, 0xfff0f1f4 }, 0xff191e36, 0xff191e36));
    palettes.put("floratopia", new Palette("floratopia", new int[]{ 0xffbf4a2b, 0xffcd902a, 0xff4e4973, 0xfff5d4bc }, 0xff1e1a43, 0xff1e1a43));
    palettes.put("verena", new Palette("verena", new int[]{ 0xfff1594a, 0xfff5b50e, 0xff14a160, 0xff2969de, 0xff885fa4 }, 0xff1a1a1a, 0xffe2e6e8));
    palettes.put("florida_citrus", new Palette("florida_citrus", new int[]{ 0xffea7251, 0xffebf7f0, 0xff02aca5 }, 0xff050100, 0xff9ae2d3));
    palettes.put("lemon_citrus", new Palette("lemon_citrus", new int[]{ 0xffe2d574, 0xfff1f4f7, 0xff69c5ab }, 0xff463231, 0xfff79eac));
    palettes.put("yuma_punk", new Palette("yuma_punk", new int[]{ 0xfff05e3b, 0xffebdec4, 0xffffdb00 }, 0xffebdec4, 0xff161616));
    palettes.put("yuma_punk2", new Palette("yuma_punk2", new int[]{ 0xfff2d002, 0xfff7f5e1, 0xffec643b }, 0xff19080e, 0xfff7f5e1));
    palettes.put("moir", new Palette("moir", new int[]{ 0xffa49f4f, 0xffd4501e, 0xfff7c558, 0xffebbaa6 }, 0xff161716, 0xfff7f4ef));
    palettes.put("sprague", new Palette("sprague", new int[]{ 0xffec2f28, 0xfff8cd28, 0xff1e95bb, 0xfffbaab3, 0xfffcefdf }, 0xff221e1f, 0xfffcefdf));
    palettes.put("bloomberg", new Palette("bloomberg", new int[]{ 0xffff5500, 0xfff4c145, 0xff144714, 0xff2f04fc, 0xffe276af }, 0xff000000, 0xfffff3dd));
    palettes.put("revolucion", new Palette("revolucion", new int[]{ 0xffed555d, 0xfffffcc9, 0xff41b797, 0xffeda126, 0xff7b5770 }, 0xfffffcc9, 0xff2d1922));
    palettes.put("sneaker", new Palette("sneaker", new int[]{ 0xffe8165b, 0xff401e38, 0xff66c3b4, 0xffee7724, 0xff584098 }, 0xff401e38, 0xffffffff));
    palettes.put("miradors", new Palette("miradors", new int[]{ 0xffff6936, 0xfffddc3f, 0xff0075ca, 0xff00bb70 }, 0xffffffff, 0xff020202));
    palettes.put("kaffeprat", new Palette("kaffeprat", new int[]{ 0xffBCAA8C, 0xffD8CDBE, 0xff484A42, 0xff746B58, 0xff9A8C73 }, 0xff000000, 0xffffffff));
    palettes.put("jrmy", new Palette("jrmy", new int[]{ 0xffdf456c, 0xffea6a82, 0xff270b32, 0xff471e43 }, 0xff270b32, 0xffef9198));
    palettes.put("animo", new Palette("animo", new int[]{ 0xfff6c103, 0xfff6f6f6, 0xffd1cdc7, 0xffe7e6e5 }, 0xff010001, 0xfff5f5f5));
    palettes.put("book", new Palette("book", new int[]{ 0xffbe1c24, 0xffd1a082, 0xff037b68, 0xffd8b1a5, 0xff1c2738, 0xffc95a3f }, 0xff0e0f27, 0xfff5b28a));
    palettes.put("juxtapoz", new Palette("juxtapoz", new int[]{ 0xff20357e, 0xfff44242, 0xffffffff }, 0xff000000, 0xffcfc398));
    palettes.put("hurdles", new Palette("hurdles", new int[]{ 0xffe16503, 0xffdc9a0f, 0xffdfe2b4, 0xff66a7a6 }, 0xff3c1c03, 0xff3c1c03));
    palettes.put("ludo", new Palette("ludo", new int[]{ 0xffdf302f, 0xffe5a320, 0xff0466b3, 0xff0f7963 }, 0xff272621, 0xffdedccd));
    palettes.put("riff", new Palette("riff", new int[]{ 0xffe24724, 0xffc7c7c7, 0xff1f3e7c, 0xffd29294, 0xff010203 }, 0xff010203, 0xfff2f2f2));
    palettes.put("san ramon", new Palette("san ramon", new int[]{ 0xff4f423a, 0xfff6a74b, 0xff589286, 0xfff8e9e2, 0xff2c2825 }, 0xff2c2825, 0xffffffff));
    palettes.put("one-dress", new Palette("one-dress", new int[]{ 0xff1767D2, 0xffFFFFFF, 0xffF9AB00, 0xff212121 }, 0xff212121, 0xffffffff));
    palettes.put("cc239", new Palette("cc239", new int[]{ 0xffe3dd34, 0xff78496b, 0xfff0527f, 0xffa7e0e2 }, 0xffe0eff0));
    palettes.put("cc234", new Palette("cc234", new int[]{ 0xffffce49, 0xffede8dc, 0xffff5736, 0xffff99b4 }, 0xfff7f4ed));
    palettes.put("cc232", new Palette("cc232", new int[]{ 0xff5c5f46, 0xffff7044, 0xffffce39, 0xff66aeaa }, 0xffe9ecde));
    palettes.put("cc238", new Palette("cc238", new int[]{ 0xff553c60, 0xffffb0a0, 0xffff6749, 0xfffbe090 }, 0xfff5e9de));
    palettes.put("cc242", new Palette("cc242", new int[]{ 0xffbbd444, 0xfffcd744, 0xfffa7b53, 0xff423c6f }, 0xfffaf4e4));
    palettes.put("cc245", new Palette("cc245", new int[]{ 0xff0d4a4e, 0xffff947b, 0xffead3a2, 0xff5284ab }, 0xfff6f4ed));
    palettes.put("cc273", new Palette("cc273", new int[]{ 0xff363d4a, 0xff7b8a56, 0xffff9369, 0xfff4c172 }, 0xfff0efe2));
    palettes.put("rag-mysore", new Palette("rag-mysore", new int[]{ 0xffec6c26, 0xff613a53, 0xffe8ac52, 0xff639aa0 }, 0xffd5cda1));
    palettes.put("rag-gol", new Palette("rag-gol", new int[]{ 0xffd3693e, 0xff803528, 0xfff1b156, 0xff90a798 }, 0xfff0e0a4));
    palettes.put("rag-belur", new Palette("rag-belur", new int[]{ 0xfff46e26, 0xff68485f, 0xff3d273a, 0xff535d55 }, 0xffdcd4a6));
    palettes.put("rag-bangalore", new Palette("rag-bangalore", new int[]{ 0xffea720e, 0xffca5130, 0xffe9c25a, 0xff52534f }, 0xfff9ecd3));
    palettes.put("rag-taj", new Palette("rag-taj", new int[]{ 0xffce565e, 0xff8e1752, 0xfff8a100, 0xff3ac1a6 }, 0xffefdea2));
    palettes.put("rag-virupaksha", new Palette("rag-virupaksha", new int[]{ 0xfff5736a, 0xff925951, 0xfffeba4c, 0xff9d9b9d }, 0xffeedfa2));
    palettes.put("retro", new Palette("retro", new int[]{ 0xff69766f, 0xff9ed6cb, 0xfff7e5cc, 0xff9d8f7f, 0xff936454, 0xffbf5c32, 0xffefad57 }));
    palettes.put("retro-washedout", new Palette("retro-washedout", new int[]{ 0xff878a87, 0xffcbdbc8, 0xffe8e0d4, 0xffb29e91, 0xff9f736c, 0xffb76254, 0xffdfa372 }));
    palettes.put("roygbiv-warm", new Palette("roygbiv-warm", new int[]{ 0xff705f84, 0xff687d99, 0xff6c843e, 0xfffc9a1a, 0xffdc383a, 0xffaa3a33, 0xff9c4257 }));
    palettes.put("roygbiv-toned", new Palette("roygbiv-toned", new int[]{ 0xff817c77, 0xff396c68, 0xff89e3b7, 0xfff59647, 0xffd63644, 0xff893f49, 0xff4d3240 }));
    palettes.put("present-correct", new Palette("present-correct", new int[]{ 0xfffd3741, 0xfffe4f11, 0xffff6800, 0xffffa61a, 0xffffc219, 0xffffd114, 0xfffcd82e, 0xfff4d730, 0xffced562, 0xff8ac38f, 0xff79b7a0, 0xff72b5b1, 0xff5b9bae, 0xff6ba1b7, 0xff49619d, 0xff604791, 0xff721e7f, 0xff9b2b77, 0xffab2562, 0xffca2847 }));
    palettes.put("tundra1", new Palette("tundra1", new int[]{ 0xff40708c, 0xff8e998c, 0xff5d3f37, 0xffed6954, 0xfff2e9e2 }));
    palettes.put("tundra2", new Palette("tundra2", new int[]{ 0xff5f9e93, 0xff3d3638, 0xff733632, 0xffb66239, 0xffb0a1a4, 0xffe3dad2 }));
    palettes.put("tundra3", new Palette("tundra3", new int[]{ 0xff87c3ca, 0xff7b7377, 0xffb2475d, 0xff7d3e3e, 0xffeb7f64, 0xffd9c67a, 0xfff3f2f2 }));
    palettes.put("tundra4", new Palette("tundra4", new int[]{ 0xffd53939, 0xffb6754d, 0xffa88d5f, 0xff524643, 0xff3c5a53, 0xff7d8c7c, 0xffdad6cd }));
    palettes.put("rohlfs_1R", new Palette("rohlfs_1R", new int[]{ 0xff004996, 0xff567bae, 0xffff4c48, 0xffffbcb3 }, 0xff004996, 0xfffff8e7));
    palettes.put("rohlfs_1Y", new Palette("rohlfs_1Y", new int[]{ 0xff004996, 0xff567bae, 0xffffc000, 0xffffdca4 }, 0xff004996, 0xfffff8e7));
    palettes.put("rohlfs_1G", new Palette("rohlfs_1G", new int[]{ 0xff004996, 0xff567bae, 0xff60bf3c, 0xffd2deb1 }, 0xff004996, 0xfffff8e7));
    palettes.put("rohlfs_2", new Palette("rohlfs_2", new int[]{ 0xff4d3d9a, 0xfff76975, 0xffffffff, 0xffeff0dd }, 0xff211029, 0xff58bdbc));
    palettes.put("rohlfs_3", new Palette("rohlfs_3", new int[]{ 0xffabdfdf, 0xfffde500, 0xff58bdbc, 0xffeff0dd }, 0xff211029, 0xfff76975));
    palettes.put("rohlfs_4", new Palette("rohlfs_4", new int[]{ 0xfffde500, 0xff2f2043, 0xfff76975, 0xffeff0dd }, 0xff211029, 0xfffbbeca));
    palettes.put("ducci_jb", new Palette("ducci_jb", new int[]{ 0xff395e54, 0xffe77b4d, 0xff050006, 0xffe55486 }, 0xff050006, 0xffefe0bc));
    palettes.put("ducci_a", new Palette("ducci_a", new int[]{ 0xff809498, 0xffd3990e, 0xff000000, 0xffecddc5 }, 0xffecddc5, 0xff863f52));
    palettes.put("ducci_b", new Palette("ducci_b", new int[]{ 0xffecddc5, 0xff79b27b, 0xff000000, 0xffac6548 }, 0xffac6548, 0xffd5c08e));
    palettes.put("ducci_d", new Palette("ducci_d", new int[]{ 0xfff3cb4d, 0xfff2f5e3, 0xff20191b, 0xff67875c }, 0xff67875c, 0xff433d5f));
    palettes.put("ducci_e", new Palette("ducci_e", new int[]{ 0xffc37c2b, 0xfff6ecce, 0xff000000, 0xff386a7a }, 0xff386a7a, 0xffe3cd98));
    palettes.put("ducci_f", new Palette("ducci_f", new int[]{ 0xff596f7e, 0xffeae6c7, 0xff463c21, 0xfff4cb4c }, 0xfff4cb4c, 0xffe67300));
    palettes.put("ducci_g", new Palette("ducci_g", new int[]{ 0xffc75669, 0xff000000, 0xff11706a }, 0xff11706a, 0xffecddc5));
    palettes.put("ducci_h", new Palette("ducci_h", new int[]{ 0xff6b5c6e, 0xff4a2839, 0xffd9574a }, 0xffd9574a, 0xffffc34b));
    palettes.put("ducci_i", new Palette("ducci_i", new int[]{ 0xffe9dcad, 0xff143331, 0xffffc000 }, 0xffffc000, 0xffa74c02));
    palettes.put("ducci_j", new Palette("ducci_j", new int[]{ 0xffc47c2b, 0xff5f5726, 0xff000000, 0xff7e8a84 }, 0xff7e8a84, 0xffecddc5));
    palettes.put("ducci_o", new Palette("ducci_o", new int[]{ 0xffc15e1f, 0xffe4a13a, 0xff000000, 0xff4d545a }, 0xff4d545a, 0xffdfc79b));
    palettes.put("ducci_q", new Palette("ducci_q", new int[]{ 0xff4bae8c, 0xffd0c1a0, 0xff2d3538 }, 0xff2d3538, 0xffd06440));
    palettes.put("ducci_u", new Palette("ducci_u", new int[]{ 0xfff6d700, 0xfff2d692, 0xff000000, 0xff5d3552 }, 0xff5d3552, 0xffff7426));
    palettes.put("ducci_v", new Palette("ducci_v", new int[]{ 0xffc65f75, 0xffd3990e, 0xff000000, 0xff597e7a }, 0xff597e7a, 0xfff6eccb));
    palettes.put("ducci_x", new Palette("ducci_x", new int[]{ 0xffdd614a, 0xfff5cedb, 0xff1a1e4f }, 0xff1a1e4f, 0xfffbb900));
    palettes.put("jud_playground", new Palette("jud_playground", new int[]{ 0xfff04924, 0xfffcce09, 0xff408ac9 }, 0xff2e2925, 0xffffffff));
    palettes.put("jud_horizon", new Palette("jud_horizon", new int[]{ 0xfff8c3df, 0xfff2e420, 0xff28b3d0, 0xff648731, 0xffef6a7d }, 0xff030305, 0xfff2f0e1));
    palettes.put("jud_mural", new Palette("jud_mural", new int[]{ 0xffca3122, 0xffe5af16, 0xff4a93a2, 0xff0e7e39, 0xffe2b9bd }, 0xff1c1616, 0xffe3ded8));
    palettes.put("jud_cabinet", new Palette("jud_cabinet", new int[]{ 0xfff0afb7, 0xfff6bc12, 0xff1477bb, 0xff41bb9b }, 0xff020508, 0xffe3ded8));
    palettes.put("iiso_zeitung", new Palette("iiso_zeitung", new int[]{ 0xffee8067, 0xfff3df76, 0xff00a9c0, 0xfff7ab76 }, 0xff111a17, 0xfff5efcb));
    palettes.put("iiso_curcuit", new Palette("iiso_curcuit", new int[]{ 0xfff0865c, 0xfff2b07b, 0xff6bc4d2, 0xff1a3643 }, 0xff0f1417, 0xfff0f0e8));
    palettes.put("iiso_airlines", new Palette("iiso_airlines", new int[]{ 0xfffe765a, 0xffffb468, 0xff4b588f, 0xfffaf1e0 }, 0xff1c1616, 0xfffae5c8));
    palettes.put("iiso_daily", new Palette("iiso_daily", new int[]{ 0xffe76c4a, 0xfff0d967, 0xff7f8cb6, 0xff1daeb1, 0xffef9640 }, 0xff000100, 0xffe2ded2));
    palettes.put("kov_01", new Palette("kov_01", new int[]{ 0xffd24c23, 0xff7ba6bc, 0xfff0c667, 0xffede2b3, 0xff672b35, 0xff142a36 }, 0xff132a37, 0xff108266));
    palettes.put("kov_02", new Palette("kov_02", new int[]{ 0xffe8dccc, 0xffe94641, 0xffeeaeae }, 0xffe8dccc, 0xff6c96be));
    palettes.put("kov_03", new Palette("kov_03", new int[]{ 0xffe3937b, 0xffd93f1d, 0xff090d15, 0xffe6cca7 }, 0xff090d15, 0xff558947));
    palettes.put("kov_04", new Palette("kov_04", new int[]{ 0xffd03718, 0xff292b36, 0xff33762f, 0xffead7c9, 0xffce7028, 0xff689d8d }, 0xff292b36, 0xffdeb330));
    palettes.put("kov_05", new Palette("kov_05", new int[]{ 0xffde3f1a, 0xffde9232, 0xff007158, 0xffe6cdaf, 0xff869679 }, 0xff010006, 0xff7aa5a6));
    palettes.put("kov_06", new Palette("kov_06", new int[]{ 0xffa87c2a, 0xffbdc9b1, 0xfff14616, 0xffecbfaf, 0xff017724, 0xff0e2733, 0xff2b9ae9 }, 0xff292319, 0xffdfd4c1));
    palettes.put("kov_06b", new Palette("kov_06b", new int[]{ 0xffd57846, 0xffdfe0cc, 0xffde442f, 0xffe7d3c5, 0xff5ec227, 0xff302f35, 0xff63bdb3 }, 0xff292319, 0xffdfd4c1));
    palettes.put("kov_07", new Palette("kov_07", new int[]{ 0xffc91619, 0xfffdecd2, 0xfff4a000, 0xff4c2653 }, 0xff111111, 0xff89c2cd));
    palettes.put("tsu_arcade", new Palette("tsu_arcade", new int[]{ 0xff4aad8b, 0xffe15147, 0xfff3b551, 0xffcec8b8, 0xffd1af84, 0xff544e47 }, 0xff251c12, 0xffcfc7b9));
    palettes.put("tsu_harutan", new Palette("tsu_harutan", new int[]{ 0xff75974a, 0xffc83e3c, 0xfff39140, 0xffe4ded2, 0xfff8c5a4, 0xff434f55 }, 0xff251c12, 0xffcfc7b9));
    palettes.put("tsu_akasaka", new Palette("tsu_akasaka", new int[]{ 0xff687f72, 0xffcc7d6c, 0xffdec36f, 0xffdec7af, 0xffad8470, 0xff424637 }, 0xff251c12, 0xffcfc7b9));
    palettes.put("dt01", new Palette("dt01", new int[]{ 0xff172a89, 0xfff7f7f3 }, 0xff172a89, 0xfff3abb0));
    palettes.put("dt02", new Palette("dt02", new int[]{ 0xff302956, 0xfff3c507 }, 0xff302956, 0xffeee3d3));
    palettes.put("dt03", new Palette("dt03", new int[]{ 0xff000000, 0xffa7a7a7 }, 0xff000000, 0xff0a5e78));
    palettes.put("dt04", new Palette("dt04", new int[]{ 0xff50978e, 0xfff7f0df }, 0xff000000, 0xfff7f0df));
    palettes.put("dt05", new Palette("dt05", new int[]{ 0xffee5d65, 0xfff0e5cb }, 0xff080708, 0xfff0e5cb));
    palettes.put("dt06", new Palette("dt06", new int[]{ 0xff271f47, 0xffe7ceb5 }, 0xff271f47, 0xffcc2b1c));
    palettes.put("dt07", new Palette("dt07", new int[]{ 0xff6a98a5, 0xffd24c18 }, 0xffefebda, 0xffefebda));
    palettes.put("dt08", new Palette("dt08", new int[]{ 0xff5d9d88, 0xffebb43b }, 0xffefebda, 0xffefebda));
    palettes.put("dt09", new Palette("dt09", new int[]{ 0xff052e57, 0xffde8d80 }, 0xffefebda, 0xffefebda));
    palettes.put("dt10", new Palette("dt10", new int[]{ 0xffe5dfcf, 0xff151513 }, 0xff151513, 0xffe9b500));
    palettes.put("hilda01", new Palette("hilda01", new int[]{ 0xffec5526, 0xfff4ac12, 0xff9ebbc1, 0xfff7f4e2 }, 0xff1e1b1e, 0xffe7e8d4));
    palettes.put("hilda02", new Palette("hilda02", new int[]{ 0xffeb5627, 0xffeebb20, 0xff4e9eb8, 0xfff7f5d0 }, 0xff201d13, 0xff77c1c0));
    palettes.put("hilda03", new Palette("hilda03", new int[]{ 0xffe95145, 0xfff8b917, 0xffb8bdc1, 0xffffb2a2 }, 0xff010101, 0xff6b7752));
    palettes.put("hilda04", new Palette("hilda04", new int[]{ 0xffe95145, 0xfff6bf7a, 0xff589da1, 0xfff5d9bc }, 0xff000001, 0xfff5ede1));
    palettes.put("hilda05", new Palette("hilda05", new int[]{ 0xffff6555, 0xffffb58f, 0xffd8eecf, 0xff8c4b47, 0xffbf7f93 }, 0xff2b0404, 0xffffda82));
    palettes.put("hilda06", new Palette("hilda06", new int[]{ 0xfff75952, 0xffffce84, 0xff74b7b2, 0xfff6f6f6, 0xffb17d71 }, 0xff0e0603, 0xfff6ecd4));
    palettes.put("spatial01", new Palette("spatial01", new int[]{ 0xffff5937, 0xfff6f6f4, 0xff4169ff }, 0xffff5937, 0xfff6f6f4));
    palettes.put("spatial02", new Palette("spatial02", new int[]{ 0xffff5937, 0xfff6f6f4, 0xfff6f6f4 }, 0xffff5937, 0xfff6f6f4));
    palettes.put("spatial02i", new Palette("spatial02i", new int[]{ 0xfff6f6f4, 0xffff5937, 0xffff5937 }, 0xfff6f6f4, 0xffff5937));
    palettes.put("spatial03", new Palette("spatial03", new int[]{ 0xff4169ff, 0xfff6f6f4, 0xfff6f6f4 }, 0xff4169ff, 0xfff6f6f4));
    palettes.put("spatial03i", new Palette("spatial03i", new int[]{ 0xfff6f6f4, 0xff4169ff, 0xff4169ff }, 0xfff6f6f4, 0xff4169ff));
    palettes.put("jung_bird", new Palette("jung_bird", new int[]{ 0xfffc3032, 0xfffed530, 0xff33c3fb, 0xffff7bac, 0xfffda929 }, 0xff000000, 0xffffffff));
    palettes.put("jung_horse", new Palette("jung_horse", new int[]{ 0xffe72e81, 0xfff0bf36, 0xff3056a2 }, 0xff000000, 0xffffffff));
    palettes.put("jung_croc", new Palette("jung_croc", new int[]{ 0xfff13274, 0xffeed03e, 0xff405e7f, 0xff19a198 }, 0xff000000, 0xffffffff));
    palettes.put("jung_hippo", new Palette("jung_hippo", new int[]{ 0xffff7bac, 0xffff921e, 0xff3ea8f5, 0xff7ac943 }, 0xff000000, 0xffffffff));
    palettes.put("jung_wolf", new Palette("jung_wolf", new int[]{ 0xffe51c39, 0xfff1b844, 0xff36c4b7, 0xff666666 }, 0xff000000, 0xffffffff));
    palettes.put("system.#01", new Palette("system.#01", new int[]{ 0xffff4242, 0xfffec101, 0xff1841fe, 0xfffcbdcc, 0xff82e9b5 }, 0xff000000, 0xffffffff));
    palettes.put("system.#02", new Palette("system.#02", new int[]{ 0xffff4242, 0xffffd480, 0xff1e365d, 0xffedb14c, 0xff418dcd }, 0xff000000, 0xffffffff));
    palettes.put("system.#03", new Palette("system.#03", new int[]{ 0xfff73f4a, 0xffd3e5eb, 0xff002c3e, 0xff1aa1b1, 0xffec6675 }, 0xff110b09, 0xffffffff));
    palettes.put("system.#04", new Palette("system.#04", new int[]{ 0xffe31f4f, 0xfff0ac3f, 0xff18acab, 0xff26265a, 0xffea7d81, 0xffdcd9d0 }, 0xff26265a, 0xffdcd9d0));
    palettes.put("system.#05", new Palette("system.#05", new int[]{ 0xffdb4549, 0xffd1e1e1, 0xff3e6a90, 0xff2e3853, 0xffa3c9d3 }, 0xff000000, 0xffffffff));
    palettes.put("system.#06", new Palette("system.#06", new int[]{ 0xffe5475c, 0xff95b394, 0xff28343b, 0xfff7c6a3, 0xffeb8078 }, 0xff000000, 0xffffffff));
    palettes.put("system.#07", new Palette("system.#07", new int[]{ 0xffd75c49, 0xfff0efea, 0xff509da4 }, 0xff000000, 0xffffffff));
    palettes.put("system.#08", new Palette("system.#08", new int[]{ 0xfff6625a, 0xff92b29f, 0xff272c3f }, 0xff000000, 0xffffffff));
    palettes.put("empusa", new Palette("empusa", new int[]{ 0xffc92a28, 0xffe69301, 0xff1f8793, 0xff13652b, 0xffe7d8b0, 0xff48233b, 0xffe3b3ac }, 0xff1a1a1a, 0xfff0f0f2));
    palettes.put("delphi", new Palette("delphi", new int[]{ 0xff475b62, 0xff7a999c, 0xff2a1f1d, 0xfffbaf3c, 0xffdf4a33, 0xfff0e0c6, 0xffaf592c }, 0xff2a1f1d, 0xfff0e0c6));
    palettes.put("mably", new Palette("mably", new int[]{ 0xff13477b, 0xff2f1b10, 0xffd18529, 0xffd72a25, 0xffe42184, 0xff138898, 0xff9d2787, 0xff7f311b, }, 0xff2a1f1d, 0xffdfc792));
    palettes.put("nowak", new Palette("nowak", new int[]{ 0xffe85b30, 0xffef9e28, 0xffc6ac71, 0xffe0c191, 0xff3f6279, 0xffee854e, 0xff180305 }, 0xff180305, 0xffede4cb));
    palettes.put("jupiter", new Palette("jupiter", new int[]{ 0xffc03a53, 0xffedd09e, 0xffaab5af, 0xff023629, 0xffeba735, 0xff8e9380, 0xff6c4127 }, 0xff12110f, 0xffe6e2d6));
    palettes.put("hersche", new Palette("hersche", new int[]{ 0xffdf9f00, 0xff1f6f50, 0xff8e6d7f, 0xffda0607, 0xffa4a5a7, 0xffd3d1c3, 0xff42064f, 0xff25393a, }, 0xff0a0a0a, 0xfff0f5f6));
    palettes.put("cherfi", new Palette("cherfi", new int[]{ 0xff99cb9f, 0xffcfb610, 0xffd00701, 0xffdba78d, 0xff2e2c1d, 0xffbfbea2, 0xffd2cfaf }, 0xff332e22, 0xffe3e2c5));
    palettes.put("harvest", new Palette("harvest", new int[]{ 0xff313a42, 0xff9aad2e, 0xfff0ae3c, 0xffdf4822, 0xff8eac9b, 0xffcc3d3f, 0xffec8b1c, 0xff1b9268, }, 0xff463930, 0xffe5e2cf));
    palettes.put("honey", new Palette("honey", new int[]{ 0xfff14d42, 0xfff4fdec, 0xff4fbe5d, 0xff265487, 0xfff6e916, 0xfff9a087, 0xff2e99d6 }, 0xff141414, 0xfff4fdec));
    palettes.put("jungle", new Palette("jungle", new int[]{ 0xffadb100, 0xffe5f4e9, 0xfff4650f, 0xff4d6838, 0xffcb9e00, 0xff689c7d, 0xffe2a1a8, 0xff151c2e, }, 0xff0e0f27, 0xffcecaa9));
    palettes.put("skyspider", new Palette("skyspider", new int[]{ 0xfff4b232, 0xfff2dbbd, 0xff01799c, 0xffe93e48, 0xff0b1952, 0xff006748, 0xffed817d }, 0xff050505, 0xfff0dbbc));
    palettes.put("atlas", new Palette("atlas", new int[]{ 0xff5399b1, 0xfff4e9d5, 0xffde4037, 0xffed942f, 0xff4e9e48, 0xff7a6e62 }, 0xff3d352b, 0xfff0c328));
    palettes.put("giftcard", new Palette("giftcard", new int[]{ 0xffFBF5E9, 0xffFF514E, 0xffFDBC2E, 0xff4561CC, 0xff2A303E, 0xff6CC283, 0xffA71172, 0xff238DA5, 0xff9BD7CB, 0xff231E58, 0xff4E0942, }, 0xff000000, 0xffFBF5E9));
    palettes.put("giftcard_sub", new Palette("giftcard_sub", new int[]{ 0xffFBF5E9, 0xffFF514E, 0xffFDBC2E, 0xff4561CC, 0xff2A303E, 0xff6CC283, 0xff238DA5, 0xff9BD7CB, }, 0xff000000, 0xffFBF5E9));
    palettes.put("dale_paddle", new Palette("dale_paddle", new int[]{ 0xffff7a5a, 0xff765aa6, 0xfffee7bc, 0xff515e8c, 0xffffc64a, 0xffb460a6, 0xffffffff, 0xff4781c1, }, 0xff000000, 0xffabe9e8));
    palettes.put("dale_night", new Palette("dale_night", new int[]{ 0xffae5d9d, 0xfff1e8bc, 0xffef8fa3, 0xfff7c047, 0xff58c9ed, 0xfff77150 }, 0xff000000, 0xff00ae83));
    palettes.put("dale_cat", new Palette("dale_cat", new int[]{ 0xfff77656, 0xfff7f7f7, 0xffefc545, 0xffdfe0e2, 0xff3c70bd, 0xff66bee4 }, 0xff000000, 0xfff6e0b8));
    palettes.put("cako1", new Palette("cako1", new int[]{ 0xff000000, 0xffd55a3a, 0xff2a5c8a, 0xff7e7d14, 0xffdbdac9 }, 0xff000000, 0xfff4e9d5));
    palettes.put("cako2", new Palette("cako2", new int[]{ 0xffdbdac9, 0xffd55a3a, 0xff2a5c8a, 0xffb47b8c, 0xff7e7d14 }, 0xff000000, 0xff000000));
    palettes.put("cako2_sub1", new Palette("cako2_sub1", new int[]{ 0xffdbdac9, 0xffd55a3a, 0xff2a5c8a }, 0xff000000, 0xff000000));
    palettes.put("cako2_sub2", new Palette("cako2_sub2", new int[]{ 0xffdbdac9, 0xffd55a3a, 0xff7e7d14 }, 0xff000000, 0xff000000));
    palettes.put("mayo1", new Palette("mayo1", new int[]{ 0xffea510e, 0xffffd203, 0xff0255a3, 0xff039177, 0xff111111 }, 0xff111111, 0xffffffff));
    palettes.put("mayo2", new Palette("mayo2", new int[]{ 0xffea663f, 0xfff9cc27, 0xff84afd7, 0xff7ca994, 0xfff1bbc9, 0xff242424 }, 0xff2a2a2a, 0xfff5f6f1));
    palettes.put("mayo3", new Palette("mayo3", new int[]{ 0xffea5b19, 0xfff8c9b9, 0xff137661, 0xff2a2a2a }, 0xff2a2a2a, 0xfff5f4f0));
    palettes.put("exposito", new Palette("exposito", new int[]{ 0xff8bc9c3, 0xffffae43, 0xffea432c, 0xff228345, 0xffd1d7d3, 0xff524e9c, 0xff9dc35e, 0xfff0a1a1, }, 0xffffffff, 0xff000000));
    palettes.put("exposito_sub1", new Palette("exposito_sub1", new int[]{ 0xff8bc9c3, 0xffffae43, 0xffea432c, 0xff524e9c }, 0xffffffff, 0xff000000));
    palettes.put("exposito_sub2", new Palette("exposito_sub2", new int[]{ 0xff8bc9c3, 0xffffae43, 0xffea432c, 0xff524e9c, 0xfff0a1a1, 0xff228345 }, 0xffffffff, 0xff000000));
    palettes.put("exposito_sub3", new Palette("exposito_sub3", new int[]{ 0xffffae43, 0xffea432c, 0xff524e9c, 0xfff0a1a1 }, 0xffffffff, 0xff000000));

    keys = palettes.keySet().toArray(new String[0]);
  }
}
