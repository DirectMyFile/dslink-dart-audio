part of dslink.audio.driver;

class AlsaAudioInput extends AudioInput {
  Process _process;

  @override
  Future start() async {
    if (_process != null) {
      await stop();
    }

    _process = await Process.start("arecord", []);
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
  Process _process;

  @override
  Future start() async {
    _process = await Process.start("aplay", []);
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
