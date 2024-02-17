import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wiki/function/getdata.dart';
import 'package:wiki/settings/local_settings.dart';
import 'package:http/http.dart' as http;

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController controller;
  late Future<String> initialData;

  Future<void> _submitData(String textContent) async {
    var exists = await credentialsFile.exists();
    var credentials;
    if (exists) {
      await rootBundle.loadString('~/.myapp/credentials.json');
    } else {
      credentials = "null";
    }
    final headers = {
      'User-Agent': 'MyApp/1.0',
      // 根据实际情况设置认证信息，例如：
      'Authorization': 'Bearer $credentials', // 如果使用OAuth
    };
    final code = await http.post(
      Uri(
          scheme: 'https',
          host: fullServerName,
          path: '${wgScriptPath}api.php',
          queryParameters: {
            'action': 'query',
            'meta': 'tokens',
            'format': 'json',
          }),
      headers: headers // 根据实际情况调整请求体
    );
    var data = code.body;
    final Map wikiTOC = jsonDecode(data);
    String token = wikiTOC['query']['tokens']['csrftoken'];
    final apiUrl = Uri(
      scheme: 'https',
      host: wgServer,
      path: '${wgScriptPath}api.php',
      queryParameters: {
        'action': 'edit',
        'format': 'json',
        'token': token
      },);


    final response = await http.post(
      apiUrl,
      headers: headers,
      body: {'title': PageName, // 或者根据需要替换为 wgArticleId
        'summary': 'Edited via MyApp',
        'text': textContent,'token': token,},
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('成功提交页面内容')),
      );
      Navigator.pop(context);
    } else if (response.statusCode == 301){
      print(response.headersSplitValues);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('提交失败: ${response.statusCode}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    initialData = getData('wikitext', articleURLWikitext(PageName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("编辑页面"),
      ),
      body: FutureBuilder<String>(
        future: initialData,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 数据正在加载时显示加载指示器
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 加载失败时显示错误信息
            return Center(child: Text('加载失败: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // 数据加载成功后设置文本控制器并显示TextFormField
            controller.text = snapshot.data!;
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                controller: controller,
                maxLines: null,
              ),
            );
          } else {
            // 应该不会到达此处，但作为安全措施返回一个占位Widget
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          final textContent = controller.text;
          if (textContent.isNotEmpty) {
            _submitData(textContent);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('请输入页面内容')),
            );
          }
        },
        tooltip: '提交页面',
        child: const Icon(Icons.check),
      ),
    );
  }
}