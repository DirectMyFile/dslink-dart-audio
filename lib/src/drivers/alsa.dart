part of dslink.audio.driver;

class AlsaAudioInput extends AudioInput {
  final String deviceName;

  AlsaAudioInput({this.deviceName});

  Process _process;

  @override
  Future start() async {
    if (_process != null) {
      await stop();
    }

    var args = ["-traw", "-r8000", "-c2"];

    if (deviceName != null && deviceName != "default") {
      args.addAll(["-D", deviceName]);
    }

    _process = await Process.start("arecord", args);
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

class AlsaAudioOutput extends AudioOutput {
  final String deviceName;

  AlsaAudioOutput({this.deviceName});

  Process _process;

  @override
  Future start() async {
    var args = ["-traw", "-r8000", "-c2"];

    if (deviceName != null && deviceName != "default") {
      args.addAll(["-D", deviceName]);
    }

    _process = await Process.start("aplay", args);
  }

  @override
  Future stop() async {
    if (_process != null) {
      _process.kill(ProcessSignal.SIGKILL);
      _process = null;
    }
  }

  @override
  Future write(List<int> bytes) async {
    if (_process != null) {
      _process.stdin.add(bytes);
    }
  }
}
