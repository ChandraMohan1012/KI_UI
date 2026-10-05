// ─────────────────────────────────────────────────────────────
//  AppAssets — central registry for all static asset paths.
//  Strictly no magic string paths scattered across widget files.
// ─────────────────────────────────────────────────────────────

abstract final class AppAssets {
  AppAssets._();

  static const String _images = 'assets/images';

  static const String logo = '$_images/logo.png';
  static const String luxuryVillaBg = '$_images/luxury_villa_bg.png';
  static const String architecturalBg = '$_images/architectural_bg.jpg';
  static const String blueprintPlaceholder =
      '$_images/blueprint_placeholder.png';
  static const String isometricPreview = '$_images/3d_isometric_preview.png';
  static const String doorGlass = '$_images/door_glass.jpg';
  static const String doorTeak = '$_images/door_teak.jpg';
  static const String doorPanel = '$_images/door_panel.jpg';
  static const String windowWood = '$_images/window_wood.jpg';
  static const String windowUpvc = '$_images/window_upvc.jpg';
  static const String windowBlack = '$_images/window_black.jpg';
  static const String houseGif = '$_images/house.gif';
  static const String loadingGif = '$_images/loading.gif';
  static const String searchIcon = '$_images/search.png';
  static const String sampleImage = '$_images/image.png';
  static const String placeholder3D = '$_images/3d_isometric_preview.png';
}
