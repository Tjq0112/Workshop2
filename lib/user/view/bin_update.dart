import 'package:flutter/material.dart';
import 'package:mockapp/user/view/bin_list.dart';
import '../controller/bin_controller.dart';

class BinUpdatePage extends StatefulWidget {
  final String loginId;
  final String binId;

  const BinUpdatePage({Key? key, required this.loginId,required this.binId}) : super(key: key);

  @override
  State<BinUpdatePage> createState() => _BinUpdatePage();
}

class _BinUpdatePage extends State<BinUpdatePage> {
  final TextEditingController aliasController = TextEditingController();
  final BinPageController _updateBinController = BinPageController();

  bool update=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Image.asset('assets/wastewise.png', height: 45)
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const SizedBox(height: 24),
          TextField(
            decoration: const InputDecoration(labelText: "Alias"),
            controller: aliasController,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              update = await _updateBinController.updateBinAlias(
                widget.loginId,aliasController.text,widget.binId,
              );
              if(update==true)
              {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alias Updated'),
                    ));
                Navigator.of(context).pop(BinPage(loginId: widget.loginId));
              }
            },
            child: const Text('Update Alias'),
          ),
        ],
      ),
    );
  }
}
