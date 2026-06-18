// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'رفيق المذاكرة الذكي';

  @override
  String get recentSessions => 'الجلسات الأخيرة';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get noSessionsYet => 'لا توجد جلسات بعد';

  @override
  String get captureFirstPageSubtitle =>
      'قم بتصوير أول صفحة لتبدأ بتوليد أسئلة الاختبار!';

  @override
  String get capturePageSubtitle => 'قم بتصوير صفحة للبدء!';

  @override
  String get captureAPage => 'صوّر صفحة';

  @override
  String get takePhotoOfNotes => 'التقط صورة لمذكراتك لتوليد اختبار';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get questionsLabel => 'أسئلة';

  @override
  String get accuracy => 'الدقة';

  @override
  String get correctLabel => 'صحيح';

  @override
  String get streak => 'سلسلة الأيام';

  @override
  String get daysLabel => 'أيام';

  @override
  String get history => 'السجل';

  @override
  String get all => 'الكل';

  @override
  String get noSessionsFound => 'لم يتم العثور على جلسات';

  @override
  String get tryDifferentFilterOrStart =>
      'جرب فلتر آخر أو ابدأ جلسة مذاكرة جديدة.';

  @override
  String get tryDifferentFilter => 'جرب فلتر آخر.';

  @override
  String questionsCount(int count) {
    return '$count أسئلة';
  }

  @override
  String get stageReadingNotes => 'جاري قراءة مذكراتك…';

  @override
  String get stageExtractingConcepts => 'استخراج المفاهيم الأساسية…';

  @override
  String get stageGeneratingQuestions => 'جاري توليد الأسئلة…';

  @override
  String get stageFindingSources => 'البحث عن المصادر المرجعية…';

  @override
  String get stageAlmostReady => 'جاهز تقريباً…';

  @override
  String get processingFailed => 'فشلت المعالجة. يرجى المحاولة مرة أخرى.';

  @override
  String stepOfTotal(int step, int total) {
    return 'خطوة $step من $total';
  }

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInToContinue => 'سجل الدخول لمتابعة جلسات المذاكرة الخاصة بك';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get invalidEmail => 'أدخل بريد إلكتروني صحيح';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordTooShort => 'على الأقل 6 أحرف';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get startStudyJourney =>
      'ابدأ رحلة المذاكرة المدعومة بالذكاء الاصطناعي';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get alignPageWithinFrame => 'قم بمحاذاة الصفحة داخل الإطار';

  @override
  String get makeSureTextIsClear => 'تأكد من أن النص واضح ومضاء جيداً';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseFromGallery => 'اختيار من المعرض';

  @override
  String get retake => 'إعادة الالتقاط';

  @override
  String get upload => 'رفع';

  @override
  String get uploadFailed => 'فشل الرفع';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String questionOfTotal(int index, int total) {
    return 'سؤال $index من $total';
  }

  @override
  String get multipleChoice => 'اختيار من متعدد';

  @override
  String get trueOrFalse => 'صح أو خطأ';

  @override
  String get seeResults => 'عرض النتائج';

  @override
  String get nextQuestion => 'السؤال التالي';

  @override
  String get confirmAnswer => 'تأكيد الإجابة';

  @override
  String get explanation => 'الشرح';

  @override
  String get scoreOutstanding => 'ممتاز! 🎉';

  @override
  String get scoreWellDone => 'عمل جيد! 👏';

  @override
  String get scoreGoodEffort => 'مجهود جيد! استمر.';

  @override
  String get scoreKeepStudying => 'استمر في المذاكرة — ستصل قريباً!';

  @override
  String scoreCorrectOfTotal(int correct, int total) {
    return '$correct / $total صحيحة';
  }

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get newSession => 'جلسة جديدة';

  @override
  String get review => 'مراجعة';

  @override
  String get mistakesOnly => 'الأخطاء فقط';

  @override
  String questionNumberAndText(int number, String text) {
    return 'س$number. $text';
  }

  @override
  String get correctAnswer => 'الإجابة الصحيحة: ';

  @override
  String get yourAnswer => 'إجابتك: ';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get account => 'الحساب';

  @override
  String get accountInfo => 'معلومات الحساب';

  @override
  String get notSignedIn => 'لم يتم تسجيل الدخول';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get about => 'حول';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get signOutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get onboardingTitle1 => 'التقط ملاحظاتك';

  @override
  String get onboardingSubtitle1 =>
      'التقط صورة لكتابك أو ملاحظاتك المكتوبة بخط اليد — سيقوم رفيق الدراسة الذكي بقراءتها فوراً.';

  @override
  String get onboardingTitle2 => 'توليد الأسئلة بالذكاء الاصطناعي';

  @override
  String get onboardingSubtitle2 =>
      'يقوم نظام الذكاء الاصطناعي لدينا بإنشاء أسئلة اختبار موجهة مع شرح كامل ومصادر مرجعية حقيقية.';

  @override
  String get onboardingTitle3 => 'تعلم وتحسن';

  @override
  String get onboardingSubtitle3 =>
      'اختبر فهمك، وراجع الشروحات، وتتبع تقدمك بمرور الوقت.';

  @override
  String get skip => 'تخطي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get next => 'التالي';
}
