library dslink.audio.nodes;

import "package:dslink/dslink.dart";

import "driver.dart";

part "src/nodes/sox.dart";
part "src/nodes/ffmpeg.dart";
part "src/nodes/dsa.dart";
part "src/nodes/alsa.dart";

Requester requester;
List<Function> callReadyList = [];

final Map<String, NodeFactory> FACTORIES = {
  "soxAudioOutput": (String path) => new SoxAudioOutputNode(path),
  "ffmpegMacAudioInput": (String path) => new FfmpegMacAudioInputNode(path),
  "dsaAudioInput": (String path) => new DsaAudioInputNode(path),
  "dsaAudioOutput": (String path) => new DsaAudioOutputNode(path),
  "audioLink": (String path) => new AudioLinkNode(path),
  "alsaAudioOutput": (String path) => new AlsaAudioOutputNode(path),
  "alsaAudioInput": (String path) => new AlsaAudioInputNode(path)
};

abstract class AudioNode extends SimpleNode {
  AudioNode(String path) : super(path);

  @override
  void onCreated() {
    if (configs[r"$audio_settings"] is Map) {
      loadSettings(configs[r"$audio_settings"]);
    }

    callReadyList.add(init);
  }

  @override
  void onRemoving() {
    destroy();
  }

  void init();
  void destroy();

  List<Map<String, dynamic>> describeSettings();
  void loadSettings(Map<String, dynamic> map);
  String get adapterDisplayName;
}

class AudioLinkNode extends AudioNode {
  AudioOutputNode outNode;
  AudioInputNode inNode;

  AudioOutput output;
  AudioInput input;

  AudioLinkNode(String path) : super(path);

  @override
  String get adapterDisplayName => "Audio Link";

  @override
  List<Map<String, dynamic>> describeSettings() => [
    {
      "name": "input",
      "type": "string"
    },
    {
      "name": "output",
      "type": "string"
    }
  ];

  @override
  void init() {
    _loadSettings(_settings);
    input.pipe(output);
  }

  Map _settings;

  @override
  void destroy() {
    input.stop().then((_) {
      input.start();
    });

    output.stop().then((_) {
      output.start();
    });
  }

  void loadSettings(Map<String, dynamic> map) {
    _settings = map;
  }

  void _loadSettings(Map<String, dynamic> map) {
    String inp = map["input"];
    String outp = map["output"];

    var inpc = provider.getNode("/${inp}");
    var outpc = provider.getNode("/${outp}");

    if (inpc is! AudioInputNode) {
      throw new Exception("${inp} (${inpc}) is not an Audio Input.");
    }

    if (outpc is! AudioOutputNode) {
      throw new Exception("${outp} (${outpc}) is not an Audio Output.");
    }

    inNode = inpc;
    outNode = outpc;

    input = inNode.input;
    output = outNode.out;
  }
}

abstract class AudioOutputNode extends AudioNode {
  AudioOutput out;

  AudioOutputNode(String path) : super(path);
  AudioOutput createAudioOutput();

  @override
  void init() {
    out = createAudioOutput();
  }

  @override
  void destroy() {
    if (out != null) {
      out.stop();
    }
  }
}

abstract class AudioInputNode extends AudioNode {
  AudioInput input;

  AudioInputNode(String path) : super(path);
  AudioInput createAudioInput();

  @override
  void init() {
    input = createAudioInput();
  }

  @override
  void destroy() {
    if (input != null) {
      input.stop();
    }
  }
}
