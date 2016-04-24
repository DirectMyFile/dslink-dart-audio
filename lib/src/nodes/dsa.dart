part of dslink.audio.nodes;

class DsaAudioInputNode extends AudioInputNode {
  String _targetPath;

  DsaAudioInputNode(String path) : super(path);

  @override
  void loadSettings(Map<String, dynamic> map) {
    _targetPath = map["targetPath"];
  }

  @override
  AudioInput createAudioInput() {
    return new DsaAudioInput(requester, _targetPath);
  }

  @override
  List<Map<String, dynamic>> describeSettings() => [
    {
      "name": "targetPath",
      "type": "string"
    }
  ];

  String get adapterDisplayName => "DSA Audio Input";
}

class DsaAudioOutputNode extends AudioOutputNode {
  DsaAudioOutputNode(String path) : super(path);

  @override
  void loadSettings(Map<String, dynamic> map) {
  }

  @override
  AudioOutput createAudioOutput() {
    return new DsaAudioOutput(this);
  }

  @override
  List<Map<String, dynamic>> describeSettings() => [];

  String get adapterDisplayName => "DSA Audio Output";
}
