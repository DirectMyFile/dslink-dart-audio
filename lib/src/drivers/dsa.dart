part of dslink.audio.driver;

class DsaAudioInput extends AudioInput {
  final Requester requester;
  final String path;

  StreamSubscription _sub;

  DsaAudioInput(this.requester, this.path);

  @override
  Stream<List<int>> read() {
    return requester.onValueChange("${path}/audioData", 1).where((update) {
      return update.value is ByteData && (update.value as ByteData).lengthInBytes > 0;
    }).map((update) {
      ByteData data = update.value;

      return data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes
      );
    });
  }

  @override
  Future start() async {
  }

  @override
  Future stop() async {
    if (_sub != null) {
      _sub.cancel();
    }
  }
}

class DsaAudioOutput extends AudioOutput {
  final SimpleNode node;

  StreamController<List<int>> _controller;

  SimpleNode _dataNode;

  DsaAudioOutput(this.node) {
    _dataNode = new SimpleNode("${node.path}/audioData");

    _dataNode.load({
      r"$name": "Audio Data",
      r"$type": "binary"
    });

    node.provider.setNode("${node.path}/audioData", _dataNode);
  }

  @override
  Future start() async {
    if (_controller != null) {
      _controller.close();
      _controller = null;
    }
    _controller = new StreamController<List<int>>.broadcast();

    _controller.stream.listen((data) {
      Uint8List byteList;

      if (data is Uint8List) {
        byteList = data;
      } else {
        byteList = new Uint8List.fromList(data);
      }

      _dataNode.updateValue(byteList.buffer.asByteData(
        byteList.offsetInBytes,
        byteList.lengthInBytes
      ));
    });
  }

  @override
  Future stop() async {
    if (_controller != null) {
      _controller.close();
      _controller = null;
    }
  }

  @override
  Future write(List<int> bytes) async {
    if (_controller != null) {
      _controller.add(bytes);
    }
  }
}
