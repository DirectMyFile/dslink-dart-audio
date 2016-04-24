import "package:dslink_audio/driver.dart";

main() async {
  var input = new FileAudioInput.forPath("out.wav");
  var output = new SoxAudioOutput();

  input.pipe(output);
}
