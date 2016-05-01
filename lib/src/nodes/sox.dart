part of dslink.audio.nodes;

class SoxAudioOutputNode extends AudioOutputNode {
  int channels;
  int sampleRate;
  String driver;

  SoxAudioOutputNode(String path) : super(path);

  @override
  void loadSettings(Map<String, dynamic> map) {
    channels = map["channels"];
    driver = map["driver"];
    sampleRate = map["sampleRate"];
  }

  @override
  AudioOutput createAudioOutput() {
    return new SoxAudioOutput(
      channels: channels,
      driver: driver
    );
  }

  @override
  List<Map<String, dynamic>> describeSettings() => [
    {
      "name": "channels",
      "type": "number",
      "default": 4
    },
    {
      "name": "sampleRate",
      "type": "number",
      "default": 8000
    },
    {
      "name": "driver",
      "type": "enum[coreaudio,alsa,pulseaudio]"
    }
  ];

  String get adapterDisplayName => "Sox Audio Output";
}
