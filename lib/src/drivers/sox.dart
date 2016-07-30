part of dslink.audio.driver;

class SoxAudioOutput extends AudioOutput {
  final int sampleRate;
  final int channels;
  final String driver;
  final List<String> driverArgs;

  SoxAudioOutput({
    this.sampleRate: 44100,
    this.channels: 1,
    this.driver,
    this.driverArgs
  });

  Process _process;

  @override
  Future start() async {
    if (_process != null) {
      await stop();
    }

    var args = [
      "-ts16",
      "-r",
      "${sampleRate}",
      "-e",
      "signed-integer",
      "-c",
      "${channels}",
      "--endian",
      "little",
      "-"
    ];

    if (driver == null) {
      var d = "-talsa";

      if (Platform.isMacOS) {
        d = "-tcoreaudio";
      }

      args.add(d);
      args.add("-d");
    } else {
      args.add("-t${driver}");
      if (driverArgs != null && driverArgs.isNotEmpty) {
        args.addAll(driverArgs);
      }
    }

    _process = await Process.start("sox", args, runInShell: true);
    _process.exitCode.then((_) {
      _process = null;
    });
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
