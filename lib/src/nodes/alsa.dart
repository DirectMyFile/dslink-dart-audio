part of dslink.audio.nodes;

class AlsaAudioInputNode extends AudioInputNode {
  AlsaAudioInputNode(String path) : super(path);

  @override
  void loadSettings(Map<String, dynamic> map) {
  }

  @override
  AudioInput createAudioInput() {
    return new AlsaAudioInput();
  }

  @override
  List<Map<String, dynamic>> describeSettings() => [];

  String get adapterDisplayName => "Alsa Audio Input";
}


class AlsaAudioOutputNode extends AudioOutputNode {
  AlsaAudioOutputNode(String path) : super(path);

  @override
  void loadSettings(Map<String, dynamic> map) {
  }

  @override
  AudioOutput createAudioOutput() {
    return new AlsaAudioOutput();
  }

  @override
  List<Map<String, dynamic>> describeSettings() => [];

  String get adapterDisplayName => "Alsa Audio Output";
}
