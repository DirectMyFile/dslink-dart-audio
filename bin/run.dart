import "package:dslink/dslink.dart";
import "package:dslink/nodes.dart";

import "package:dslink_audio/nodes.dart";

LinkProvider link;

main(List<String> args) async {
  var p = new SimpleNodeProvider();
  link = new LinkProvider(
    args,
    "Audio-",
    profiles: {
      "remove": (String path) => new DeleteActionNode.forParent(path, p, onDelete: () {
        link.save();
      })
    },
    autoInitialize: false,
    provider: p,
    isRequester: true,
    isResponder: true,
    encodePrettyJson: true
  );

  link.configure();

  SimpleNodeProvider provider = link.provider;

  for (String key in FACTORIES.keys) {
    provider.addProfile(key, FACTORIES[key]);

    AudioNode node = FACTORIES[key]("/_FAKE_");
    var n = "add${key[0].toUpperCase() + key.substring(1)}";

    var creator = (String path) {
      return new SimpleActionNode(path, (Map<String, dynamic> params) {
        String name = params["name"];

        if (name is! String || name.isEmpty) {
          throw new Exception("Name not specified.");
        }

        link.addNode("/${NodeNamer.createName(name)}", {
          r"$name": name,
          r"$is": key,
          r"$audio_settings": params,
          "remove": {
            r"$name": "Remove",
            r"$is": "remove",
            r"$invokable": "write"
          }
        });

        link.save();
      });
    };

    provider.addProfile(n, creator);

    var mm = node.describeSettings();

    mm.insert(0, {
      "name": "name",
      "type": "string"
    });

    var np = link.addNode("/${n}", {
      r"$is": "${n}",
      r"$name": "Add ${node.adapterDisplayName}",
      r"$invokable": "write",
      r"$params": mm
    });

    np.serializable = false;

    if (provider.hasNode("/_FAKE_")) {
      provider.removeNode("/_FAKE_");
    }
  }

  link.init();
  link.connect();
  requester = await link.onRequesterReady;
  while (callReadyList.isNotEmpty) {
    callReadyList.removeAt(0)();
  }
}
