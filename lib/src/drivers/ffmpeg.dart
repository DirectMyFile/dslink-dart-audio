part of dslink.audio.driver;

class FfmpegAudioInput extends AudioInput {
  final List<String> options;

  FfmpegAudioInput(this.options);

  Process _process;

  @override
  Future start() async {
    if (_process != null) {
      await stop();
    }

    var args = new List<String>.from(options);

    if (!args.contains("-")) {
      args.add("-");
    }

    _process = await Process.start("ffmpeg", args);

    _process.exitCode.then(_handleExitCode);
  }

  void _handleExitCode(int code) {
    _process = null;
  }

  @override
  Future stop() async {
    if (_process != null) {
      _process.kill(ProcessSignal.SIGKILL);
      _process = null;
    }
  }

  @override
  Stream<List<int>> read() {
    return _process.stdout;
  }
}

class FfmpegMacAudioInput extends FfmpegAudioInput {
  factory FfmpegMacAudioInput(String device) {
    var opts = [
      "-f",
      "avfoundation",
      "-i",
      device,
      "-vn",
      "-f",
      "u16le",
      "-"
    ];

    return new FfmpegMacAudioInput._(opts);
  }

  FfmpegMacAudioInput._(List<String> options) : super(options);
}
