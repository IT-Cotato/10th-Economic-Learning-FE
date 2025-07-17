import 'package:economic_fe/view/screens/article/article_detail_page.dart';
import 'package:economic_fe/view/screens/article/article_list_page.dart';
import 'package:economic_fe/view/screens/chatbot_page.dart';
import 'package:economic_fe/view/screens/community/community_page.dart';
import 'package:economic_fe/view/screens/community/new_post_page.dart';
import 'package:economic_fe/view/screens/finish_page.dart';
import 'package:economic_fe/view/screens/learning_set/learning_concept_page.dart';
import 'package:economic_fe/view/screens/community/detail_page.dart';
import 'package:economic_fe/view/screens/community/talk_detail_page.dart';
import 'package:economic_fe/view/screens/level_test/level_test_test_page.dart';
import 'package:economic_fe/view/screens/level_test/test_answer_page.dart';

import 'package:economic_fe/view/screens/login/agreement_detail_page.dart';
import 'package:economic_fe/view/screens/login/agreement_page.dart';
import 'package:economic_fe/view/screens/dictionary_page.dart';

import 'package:economic_fe/view/screens/home_page.dart';
import 'package:economic_fe/view/screens/learning_set/learning_list_page.dart';
import 'package:economic_fe/view/screens/level_test/leveltest_result_page.dart';
import 'package:economic_fe/view/screens/login/login_exist_page.dart';
import 'package:economic_fe/view/screens/login/login_leveltest_skip_page.dart';
import 'package:economic_fe/view/screens/mypage/bookmarked_articles_page.dart';
import 'package:economic_fe/view/screens/mypage/bookmarked_post_page.dart';
import 'package:economic_fe/view/screens/mypage/community_activity_page.dart';
import 'package:economic_fe/view/screens/mypage/my_learning_page.dart';
import 'package:economic_fe/view/screens/mypage/my_profile_page.dart';
import 'package:economic_fe/view/screens/mypage/mypage_home_page.dart';
import 'package:economic_fe/view/screens/mypage/scrap_learning_set_page.dart';
import 'package:economic_fe/view/screens/mypage/setting_page.dart';
import 'package:economic_fe/view/screens/mypage/wrong_quiz_page.dart';
import 'package:economic_fe/view/screens/notification/notification_page.dart';

import 'package:economic_fe/view/screens/onboarding/onboarding_card_page.dart';

import 'package:economic_fe/view/screens/login/login_page.dart';

import 'package:economic_fe/view/screens/onboarding/onboarding_page.dart';
import 'package:economic_fe/view/screens/profile_setting/basic_info_page.dart';
import 'package:economic_fe/view/screens/profile_setting/job_select_page.dart';
import 'package:economic_fe/view/screens/profile_setting/part_select_page.dart';
import 'package:economic_fe/view/screens/profile_setting/profile_setting_page.dart';
import 'package:economic_fe/view/screens/quiz/level_select_page.dart';
import 'package:economic_fe/view/screens/quiz/quiz_test_page.dart';
import 'package:economic_fe/view/screens/search/search_page.dart';
import 'package:economic_fe/view/screens/level_test/test_page.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

// GetX의 라우터를 사용하는 방식
class UserRouter {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: '/',
        page: () => const OnboardingPage(),
      ), // 홈 페이지
      GetPage(
        name: '/onboarding',
        page: () => const OnboardingCardPage(),
      ),
      GetPage(
        name: '/test',
        page: () => const TestPage(),
        children: [
          // GetPage(
          //   name: '/multi',
          //   page: () => const TestMultipleChoicePage(),
          // ),
          // GetPage(
          //   name: '/ox',
          //   page: () => const TestOxPage(),
          // ),
          GetPage(
            name: '/test',
            page: () => const LevelTestTestPage(),
          ),
        ],
      ),
      GetPage(
          name: '/leveltest_result',
          page: () => const LeveltestResultPage(),
          children: [
            GetPage(
              name: '/answer',
              page: () => const TestAnswerPage(),
            ),
          ]),
      // 카카오로 시작하기
      GetPage(
        name: '/login',
        page: () => const LoginPage(),
        children: [
          GetPage(
            name: '/agreement',
            page: () => const AgreementPage(),
            children: [
              GetPage(name: '/detail', page: () => const AgreementDetailPage())
            ],
          ),
          // 레벨테스트 스킵
          GetPage(
            name: '/skip',
            page: () => const LoginLeveltestSkipPage(),
          ),
        ],
      ),
      // 카카오 로그인
      GetPage(
        name: '/login_exist',
        page: () => const LoginExistPage(),
      ),
      GetPage(
        name: '/profile_setting',
        page: () => const ProfileSettingPage(),
        children: [
          GetPage(
            name: '/basic',
            page: () => const BasicInfoPage(),
          ),
          GetPage(
            name: '/job',
            page: () => const JobSelectPage(),
          ),
          GetPage(
            name: '/part',
            page: () => const PartSelectPage(),
          ),
        ],
      ),
      GetPage(
        name: '/home',
        page: () => const HomePage(),
      ),
      GetPage(
        name: '/learning_list',
        page: () => const LearningListPage(),
        children: [
          GetPage(
            name: '/level_select',
            page: () => const LevelSelectPage(),
            children: [
              GetPage(
                name: '/quiz',
                page: () => const QuizTestPage(),
              ),
            ],
          ),
          GetPage(
            name: '/learning_concept',
            page: () => const LearningConceptPage(),
          ),
        ],
      ),
      GetPage(
        name: '/chatbot',
        page: () => ChatbotPage(),
      ),
      GetPage(
        name: '/dictionary',
        page: () => const DictionaryPage(),
      ),
      // 커뮤니티 탭
      GetPage(
        name: '/community',
        page: () => const CommunityPage(),
        children: [
          // 경제 톡톡 세부 페이지
          GetPage(
            name: '/talk_detail',
            page: () => const TalkDetailPage(),
          ),
          // 일반 게시판 세부 페이지
          GetPage(
            name: '/detail',
            page: () => const DetailPage(),
          ),
          // 게시글 작성 페이지
          GetPage(
            name: '/new_post',
            page: () => const NewPostPage(),
          ),
        ],
      ),
      // 경제 기사
      GetPage(
        name: '/article',
        page: () => const ArticleListPage(),
        children: [
          // 기사 세부 페이지
          GetPage(
            name: '/detail',
            page: () => const ArticleDetailPage(),
          ),
        ],
      ),
      // 완료 페이지
      GetPage(
        name: '/finish',
        page: () => const FinishPage(),
      ),
      // 마이페이지
      GetPage(
        name: '/mypage',
        page: () => const MypageHomePage(),
        children: [
          // 설정 및 약관
          GetPage(
            name: '/profile',
            page: () => const MyProfilePage(),
          ),
          // 설정 및 약관
          GetPage(
            name: '/setting',
            page: () => const SettingPage(),
          ),
          // 스크랩 한 기사
          GetPage(
            name: '/article',
            page: () => const BookmarkedArticlesPage(),
          ),
          // 커뮤니티 활동
          GetPage(
            name: '/community',
            page: () => const CommunityActivityPage(),
            children: [
              // 스크랩 한 글/좋아요 한 글/좋아요 한 댓글
              GetPage(
                name: '/post',
                page: () => const BookmarkedPostPage(),
              ),
            ],
          ),
          // 나의 학습
          GetPage(
            name: '/learning',
            page: () => const MyLearningPage(),
            children: [
              GetPage(
                name: '/learning_concept',
                page: () => const ScrapLearningSetPage(),
              ),
            ],
          ),
          // 틀린 문제 다시 풀기
          GetPage(
            name: '/wrong',
            page: () => const WrongQuizPage(),
          ),
        ],
      ),
      // 알림 화면
      GetPage(
        name: '/notification',
        page: () => const NotificationPage(),
      ),
      // 검색 화면
      GetPage(
        name: '/search',
        page: () => const SearchPage(),
      ),
    ];
  }
}
