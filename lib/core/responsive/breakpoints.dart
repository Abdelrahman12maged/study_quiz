/// Breakpoint definitions for responsive layouts.
///
/// mobile:  width < 600
/// tablet:  600 <= width <= 1024
/// desktop: width > 1024
class Breakpoints {
  Breakpoints._();

  static const double mobile = 600;
  static const double tablet = 1024;

  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width <= tablet;
  static bool isDesktop(double width) => width > tablet;
}

/// Enum for referring to device class without raw numbers.
enum DeviceType { mobile, tablet, desktop }
