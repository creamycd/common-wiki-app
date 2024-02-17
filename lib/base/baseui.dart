import 'package:flutter/material.dart';
import 'package:wiki/settings/local_settings.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wiki/function/login.dart';
import 'package:wiki/function/getdata.dart';


class BaseUI extends StatefulWidget {
  const BaseUI({super.key});
  @override
  State<BaseUI> createState() => _BaseUIState();
}

class _BaseUIState extends State<BaseUI> {
  bool shouldUpdate = false;
  bool isUpdating = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 检查路由参数或依赖项是否已更改并设置 shouldUpdate 标志
    final route = ModalRoute.of(context);
    if (route?.settings.arguments == 'refresh') {
      setState(() {
        isUpdating = true;
        shouldUpdate = true;
      });

    }
  }
  Future<bool> _onLinkTap(String url) async {
    setState(() {
      PageName = url.replaceAll('/wiki/', '');
      PageName = Uri.decodeComponent(PageName);
      requestURL = articleURLContent(PageName); // 调整这里以使用 wgMainPageName
    });
    // 发起新的数据请求并等待其完成
    setState(() {
    });
    return false;
  }
  @override
  Widget build(BuildContext context) {
    if (shouldUpdate) {
      // 执行实际的数据更新或其他操作
      // ...
      // 更新完成后重置 shouldUpdate 和 isUpdating 标志
      setState(() {
        shouldUpdate = false;
        isUpdating = false;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            PageName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),),
        actions: [IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),],),
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: getData('text',requestURL),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // 请求已结束
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // 请求失败，显示错误
                    return const Text("Error");
                  } else {
                    // 请求成功，显示数据
                    return HtmlWidget(
                      snapshot.data,
                      onTapUrl: _onLinkTap,
                      customStylesBuilder: customStyleBuilder(),

                    );
                  }
                } else {
                  // 请求未结束，显示loading
                  return const CircularProgressIndicator();
                }
              })
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/edit");
        },
        tooltip: '编辑页面',
        child: const Icon(Icons.edit),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            // const DrawerHeader(child: Row(
            //   children: [
            //     SizedBox(
            //       child: Icon(
            //         Icons.supervised_user_circle_rounded,
            //         size: 75.0,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 15,
            //     ),
            //     SizedBox(
            //       height: 24.0,
            //       width: 175.0,
            //       child: Text('Usernamenamememememememe', style: TextStyle(fontFamily: "Sans", overflow: TextOverflow.ellipsis),),
            //     ),
            //   ],
            // )),
            const ListTile(
              title: Text("获取Token", style: TextStyle(fontFamily: "Sans"),),
              onTap: getToken,
            ),
            ListTile(
              title: const Text("首页", style: TextStyle(fontFamily: "Sans"),),
              onTap: (){
                setState(() {
                  PageName = wgMainPageName;
                  requestURL = articleURLContent(wgMainPageName);
                });
                // Then close the drawer
                Navigator.pop(context);
                // Navigator.pushNamed(context, "/");
              },
            ),
            ListTile(
              title: const Text("茶馆", style: TextStyle(fontFamily: "Sans"),),
              onTap: (){
                setState(() {
                  PageName = wgTalkPageName;
                  requestURL = articleURLContent(wgTalkPageName);
                });
                // Then close the drawer
                Navigator.pop(context);
                // Navigator.pushNamed(context, "/");
              },
            ),
          ],
        ),
      ),
    );
  }
}

