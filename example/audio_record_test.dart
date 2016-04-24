import "dart:async";

import "package:dslink_audio/driver.dart";

main() async {
  var input = new FfmpegMacAudioInput("1:2");
  var output = new FileAudioOutput.forPath("out.wav");

  input.pipe(output);

  new Future.delayed(const Duration(seconds: 5), () {
    input.stop();
  });
}
