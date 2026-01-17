/// Banner types for API requests.
/// Each type corresponds to a specific location in the app where banners are displayed.
enum BannerType {
  /// Banner displayed on the Browse screen
  browsePage(1);

  const BannerType(this.value);

  /// The integer value sent to the backend API
  final int value;
}
