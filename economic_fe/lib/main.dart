import 'package:economic_fe/data/services/user_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<void> main() async {
  //await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  String nativeAppKey = dotenv.env['NATIVE_APP_KEY']!;
  print('nativeAppKey: $nativeAppKey');
  KakaoSdk.init(nativeAppKey: nativeAppKey);
  runApp(const RippleApp());
}

class RippleApp extends StatelessWidget {
  const RippleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ripple',
      initialRoute: '/',
      getPages: UserRouter.getPages(), // 라우트 설정
    );
  }
}
