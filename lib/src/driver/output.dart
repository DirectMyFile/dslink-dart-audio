part of dslink.audio.driver;

abstract class AudioOutput {
  Future start();
  Future write(List<int> bytes);
  Future stop();
}
