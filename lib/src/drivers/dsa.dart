part of dslink.audio.driver;

class DsaAudioInput extends AudioInput {
  final Requester requester;
  final String path;

  StreamSubscription _sub;

  DsaAudioInput(this.requester, this.path);

  @override
  Stream<List<int>> read() {
    var controller = new StreamController<List<int>>();
    _sub = requester.invoke("${path}/readAudioData").listen((RequesterInvokeUpdate update) {
      if (update.streamStatus == "closed") {
        controller.close();
        return;
      }

      for (var u in update.updates) {
        if (u.length > 0 && u[0] is ByteData) {
          ByteData d = u[0];
          controller.add(d.buffer.asUint8List());
        }
      }
    });
    return controller.stream;
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

  DsaAudioOutput(this.node) {
    var san = new SimpleActionNode("${node.path}/readAudioData", (Map<String, dynamic> params) async {
      return _controller.stream.map((bytes) {
        var ui = bytes is Uint8List ? bytes : new Uint8List.fromList(bytes);
        return [[ui.buffer.asByteData()]];
      });
    });

    san.load({
      r"$name": "Read Audio Data",
      r"$invokable": "read"
    });

    node.provider.setNode("${node.path}/readAudioData", san);
  }

  @override
  Future start() async {
    if (_controller != null) {
      _controller.close();
      _controller = null;
    }
    _controller = new StreamController.broadcast();
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
