part of dslink.audio.driver;

abstract class AudioInput {
  Future start();
  Stream<List<int>> read();
  Future stop();

  Future pipe(AudioOutput output) async {
    await start();
    await output.start();

    read().listen((data) {
      output.write(data);
    });
  }
}
