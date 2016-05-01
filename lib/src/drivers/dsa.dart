part of dslink.audio.driver;

class DsaAudioInput extends AudioInput {
  final Requester requester;
  final String path;

  StreamSubscription _sub;

  DsaAudioInput(this.requester, this.path);

  @override
  Stream<List<int>> read() {
    return requester.onValueChange("${path}/audioData").where((update) {
      return update.value is ByteData && (update.value as ByteData).lengthInBytes > 0;
    }).map((update) => (update.value as ByteData).buffer.asUint8List());
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
    _controller = new StreamController.broadcast();

    _controller.stream.listen((data) {
      Uint8List byteList;

      if (data is Uint8List) {
        byteList = data;
      } else {
        byteList = new Uint8List.fromList(data);
      }

      _dataNode.updateValue(byteList);
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
