part of dslink.audio.driver;

class FileAudioOutput extends AudioOutput {
  final File file;

  IOSink _out;

  factory FileAudioOutput.forPath(String path) {
    return new FileAudioOutput(new File(path));
  }

  FileAudioOutput(this.file);

  @override
  Future start() async {
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }

    _out = await file.openWrite(mode: FileMode.APPEND);
  }

  @override
  Future stop() async {
    await _out.close();
  }

  @override
  Future write(List<int> bytes) async {
    await _out.add(bytes);
  }
}

class FileAudioInput extends AudioInput {
  final File file;

  factory FileAudioInput.forPath(String path) {
    return new FileAudioInput(new File(path));
  }

  FileAudioInput(this.file);

  @override
  Stream<List<int>> read() {
    return file.openRead();
  }

  @override
  Future start() async {
  }

  @override
  Future stop() async {
  }
}
