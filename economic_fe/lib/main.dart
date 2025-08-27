import 'package:economic_fe/data/services/remote_data_source.dart';
import 'package:economic_fe/data/services/sse_manager.dart';
import 'package:economic_fe/data/services/user_router.dart';
import 'package:economic_fe/data/services/validate_access_token.dart';
import 'package:economic_fe/utils/notification_utils.dart';
import 'package:economic_fe/utils/scaffold_messenger_key.dart';
import 'package:economic_fe/view_model/mypage/mypage_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko', null);
  await dotenv.load(fileName: '.env');

  await GetStorage.init();
  await initLocalNotifications();

  final nativeAppKey = dotenv.env['NATIVE_APP_KEY']!;
  KakaoSdk.init(nativeAppKey: nativeAppKey);

  bool isValidToken = await validateAccessToken();
  bool isAlarmOn = false;

  if (isValidToken) {
    // 사용자 정보에서 알림 설정 확인
    final remoteDataSource = RemoteDataSource();
    final userInfo = await remoteDataSource.fetchUserInfo(null);

    isAlarmOn = userInfo["isAlarmOn"] == true;
    if (isAlarmOn) {
      await SSEManager().init(); // 알림이 켜져 있을 때만 SSE 연결
    }

    Get.put(MypageHomeController(), permanent: true);
  }

  runApp(RippleApp(
    initialRoute: isValidToken ? '/home' : '/',
    isLoggedIn: isValidToken,
  ));
}

class RippleApp extends StatelessWidget {
  final String initialRoute;
  final bool isLoggedIn;

  const RippleApp(
      {super.key, required this.initialRoute, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 740),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0), // 시스템 폰트 크기 조정 방지
          ),
          child: GetMaterialApp(
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            title: 'Ripple',
            initialRoute: initialRoute,
            getPages: UserRouter.getPages(),
            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: widget!,
              );
            },
            navigatorObservers: [routeObserver],
          ),
        );
      },
    );
  }
}
