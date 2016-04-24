part of dslink.audio.nodes;

class FfmpegMacAudioInputNode extends AudioInputNode {
  String device;

  FfmpegMacAudioInputNode(String path) : super(path);

  @override
  void loadSettings(Map<String, dynamic> map) {
    device = map["device"];
  }

  @override
  AudioInput createAudioInput() {
    return new FfmpegMacAudioInput(device);
  }

  @override
  List<Map<String, dynamic>> describeSettings() => [
    {
      "name": "device",
      "type": "string"
    }
  ];

  String get adapterDisplayName => "Ffmpeg Mac Audio Input";
}
