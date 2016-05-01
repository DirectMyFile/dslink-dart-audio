part of dslink.audio.nodes;

class AlsaAudioInputNode extends AudioInputNode {
  String device;

  AlsaAudioInputNode(String path) : super(path);

  @override
  void loadSettings(Map<String, dynamic> map) {
    device = map["device"];
  }

  @override
  AudioInput createAudioInput() {
    return new AlsaAudioInput(deviceName: device);
  }

  @override
  List<Map<String, dynamic>> describeSettings() => [
    {
      "name": "device",
      "type": "string",
      "default": "default"
    }
  ];

  String get adapterDisplayName => "Alsa Audio Input";
}

class AlsaAudioOutputNode extends AudioOutputNode {
  String device;

  AlsaAudioOutputNode(String path) : super(path);

  @override
  void loadSettings(Map<String, dynamic> map) {
    device = map["device"];
  }

  @override
  AudioOutput createAudioOutput() {
    return new AlsaAudioOutput(deviceName: device);
  }

  @override
  List<Map<String, dynamic>> describeSettings() => [
    {
      "name": "device",
      "type": "string",
      "default": "default"
    }
  ];

  String get adapterDisplayName => "Alsa Audio Output";
}
