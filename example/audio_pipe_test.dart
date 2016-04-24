import "dart:async";

import "package:dslink_audio/driver.dart";

main() async {
  var ffmpeg = new FfmpegMacAudioInput("1:2");
  var sox = new SoxAudioOutput(channels: 5);

  ffmpeg.pipe(sox);
}
