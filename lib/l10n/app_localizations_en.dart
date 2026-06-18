// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'AI Study Buddy';

  @override
  String get recentSessions => 'Recent Sessions';

  @override
  String get seeAll => 'See All';

  @override
  String get noSessionsYet => 'No sessions yet';

  @override
  String get captureFirstPageSubtitle =>
      'Capture your first page to start generating quiz questions!';

  @override
  String get capturePageSubtitle => 'Capture a page to get started!';

  @override
  String get captureAPage => 'Capture a Page';

  @override
  String get takePhotoOfNotes =>
      'Take a photo of your notes to generate a quiz';

  @override
  String get thisWeek => 'This Week';

  @override
  String get questionsLabel => 'questions';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get correctLabel => 'correct';

  @override
  String get streak => 'Streak';

  @override
  String get daysLabel => 'days';

  @override
  String get history => 'History';

  @override
  String get all => 'All';

  @override
  String get noSessionsFound => 'No sessions found';

  @override
  String get tryDifferentFilterOrStart =>
      'Try a different filter or start a new study session.';

  @override
  String get tryDifferentFilter => 'Try a different filter.';

  @override
  String questionsCount(int count) {
    return '$count questions';
  }

  @override
  String get stageReadingNotes => 'Reading your notes…';

  @override
  String get stageExtractingConcepts => 'Extracting key concepts…';

  @override
  String get stageGeneratingQuestions => 'Generating questions…';

  @override
  String get stageFindingSources => 'Finding reference sources…';

  @override
  String get stageAlmostReady => 'Almost ready…';

  @override
  String get processingFailed =>
      'Processing failed. Please try capturing again.';

  @override
  String stepOfTotal(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue your study sessions';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'At least 6 characters';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get startStudyJourney => 'Start your AI-powered study journey';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get alignPageWithinFrame => 'Align your page within the frame';

  @override
  String get makeSureTextIsClear => 'Make sure the text is clear and well-lit';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get retake => 'Retake';

  @override
  String get upload => 'Upload';

  @override
  String get uploadFailed => 'Upload Failed';

  @override
  String get tryAgain => 'Try Again';

  @override
  String questionOfTotal(int index, int total) {
    return 'Question $index of $total';
  }

  @override
  String get multipleChoice => 'Multiple Choice';

  @override
  String get trueOrFalse => 'True or False';

  @override
  String get seeResults => 'See Results';

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get confirmAnswer => 'Confirm Answer';

  @override
  String get explanation => 'Explanation';

  @override
  String get scoreOutstanding => 'Outstanding! 🎉';

  @override
  String get scoreWellDone => 'Well done! 👏';

  @override
  String get scoreGoodEffort => 'Good effort! Keep going.';

  @override
  String get scoreKeepStudying => 'Keep studying — you\'ll get there!';

  @override
  String scoreCorrectOfTotal(int correct, int total) {
    return '$correct / $total correct';
  }

  @override
  String get backToHome => 'Back to Home';

  @override
  String get newSession => 'New Session';

  @override
  String get review => 'Review';

  @override
  String get mistakesOnly => 'Mistakes only';

  @override
  String questionNumberAndText(int number, String text) {
    return 'Q$number. $text';
  }

  @override
  String get correctAnswer => 'Correct: ';

  @override
  String get yourAnswer => 'Your answer: ';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get account => 'Account';

  @override
  String get accountInfo => 'Account Info';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get signOut => 'Sign Out';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get signOutConfirmation => 'Are you sure you want to sign out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get onboardingTitle1 => 'Capture Your Notes';

  @override
  String get onboardingSubtitle1 =>
      'Take a photo of your textbook or handwritten notes — AI Study Buddy reads it instantly.';

  @override
  String get onboardingTitle2 => 'AI Generates Questions';

  @override
  String get onboardingSubtitle2 =>
      'Our AI pipeline creates targeted quiz questions with explanations and real reference sources.';

  @override
  String get onboardingTitle3 => 'Learn & Improve';

  @override
  String get onboardingSubtitle3 =>
      'Test your understanding, review explanations, and track your progress over time.';

  @override
  String get skip => 'Skip';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';
}
