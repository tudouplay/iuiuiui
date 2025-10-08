import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'providers/movie_provider.dart';
import 'screens/home_screen.dart';
import 'utils/edgeone_adapter.dart';

void main() {
  // 配置 Web 插件
  setUrlStrategy(PathUrlStrategy());
  
  // 初始化 EdgeOne 适配器
  EdgeOneAdapter.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MovieProvider()),
      ],
      child: MaterialApp(
        title: 'MoonTV',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
        // SPA 路由配置
        navigatorKey: GlobalKey(),
        onGenerateRoute: (settings) {
          // 所有未知路由都重定向到首页
          return MaterialPageRoute(builder: (context) => HomeScreen());
        },
      ),
    );
  }
}