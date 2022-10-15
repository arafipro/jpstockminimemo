import 'package:flutter/material.dart';
import 'package:jpstockmemo2/components/custom_text_form_field.dart';
import 'package:jpstockmemo2/databases/tables.dart';
import 'package:drift/drift.dart' as drift;

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late MemoDatabase _db;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _db = MemoDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditPage'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            CustomTextFormField(
              controller: _codeController,
              labelText: '証券コード',
              maxLines: 1,
              maxLength: 4,
              onChanged: (text) {
                _codeController.text = text;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return '証券コードを入力してください';
                } else if (!RegExp(r"\d{4}").hasMatch(value)) {
                  return '４桁の半角数字を入力してください';
                }
              },
              keyboardType: TextInputType.number,
            ),
            CustomTextFormField(
              controller: _nameController,
              labelText: '銘柄名',
              maxLines: 1,
              maxLength: null,
              onChanged: (text) {
                _nameController.text = text;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return '銘柄名を入力してください';
                }
              },
              keyboardType: TextInputType.text,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final entity = MemosCompanion(
                      code: drift.Value(_codeController.text),
                      stockname: drift.Value(_nameController.text),
                    );
                    _db.insertMemo(entity).then(
                          (value) => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("保存しました"),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/');
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                  }
                },
                child: const Text(
                  '保存',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
