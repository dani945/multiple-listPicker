import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    home: ListData(),
  ));
}

class ListData extends StatefulWidget {
  @override
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  final data = <String>['satu', 'dua', 'tiga'];
  final controllers = <TextEditingController>[];
  final children = <Widget>[];
  Treatment _treatment;
  final _listPicker = <ListPicker>[];
  
  @override
  void initState() {
    super.initState();
    
    setState((){
      _treatment = Treatment(
        klaim: Treatment.klaimList[0],
      );
    });
    
    for (int i = 0; i < data.length; i++) {
      final f = data[i];
      final controller = TextEditingController(text: f);
      controllers.add(controller);
      final listPick = ListPicker(
                    'Opsi Klaim', Treatment.klaimList,
                    selected: _treatment.klaim,);
      _listPicker.add(listPick);
      children.add(Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        alignment: Alignment.bottomLeft,
        child: Text('KUITANSI - ${i + 1}'),
      ));
      children.add(Divider(height: 0));
      children.add(ViewerTile(label: 'Tanggal kuitansi', value: 'keterangan'));
      children.add(Divider(height: 0));
      children.add(ViewerTile(label: 'Klaim kuitansi', value: 'klaim kuitansi'));
      children.add(Divider(height: 0));
      children.add(ViewerTile(
          label: 'Keterangan kuitansi', value: 'keterangan kuitansi'));
      children.add(Divider(height: 0));
      children.add(Material(
        child: ListTile(
          onTap: () async {
            final picked = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => listPick,
                fullscreenDialog: true,
              ),
            );

            if (picked is String) {
              setState(() {          
                  _treatment.klaim = picked;                
                print(_treatment.klaim);
              });
            }
          },
          contentPadding: const EdgeInsets.only(left: 16, right: 8),
          title: const Text('Klaim', style: TextStyle(fontSize: 16.0)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(_treatment.klaim, style: TextStyle(fontSize: 16.0)),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ));
      children.add(Divider(height: 0));
      children.add(Material(
        child: ListTile(
          title: Text(
            'Keterangan',
          ),
          subtitle: new TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Keterangan'),
            onChanged: (val) {
              data[i] = val;
            },
          ),
        ),
      ));
      children.add(Divider(height: 0));
      children.add(SizedBox(height: 32));
    }

  }

  @override
  Widget build(BuildContext context) {
    final childrenListView = <Widget>[
      Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 32,
          bottom: 4,
        ),
        alignment: Alignment.bottomLeft,
        child: Text('TREATMENT'),
      ),
      Divider(height: 0),
      SizedBox(height: 32),
    ];
    
    if (children.isNotEmpty) {
      childrenListView.addAll(children);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple listPicker'),
      ),
      body: ListView(
        children: childrenListView,
      ),
      
    );
  }
}


class ListPicker extends StatelessWidget {
  final String title;
  final List<String> list;
  final String selected;

  ListPicker(this.title, this.list, {this.selected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: list.map(
            (item) => Material(
              child: ListTile(
                onTap: () => Navigator.pop(context, item),
                title: Text(item),
                trailing: selected == item ? Icon(Icons.check) : null,
              ),
            ),
          ),
        ).toList(),
      ),
    );
  }
}

class Treatment {
  static const klaimList = <String>['Kantor', 'Asuransi'];
  
  String klaim;
  
  Treatment({this.klaim});
}

class ViewerTile extends StatelessWidget {
  ViewerTile({
    @required this.label,
    @required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;
    final themeBody = textTheme.body1.copyWith(fontSize: 16);
    final themeCaption = textTheme.caption;

    return Material(
      child: ListTile(
        title: Text(
          label,
          style: themeBody,
        ),
        trailing: Text(
          value ?? '',
          style: themeBody.copyWith(color: themeCaption.color),
        ),
      ),
    );
  }
}
