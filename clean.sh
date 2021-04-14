flutter clean
pod repo update
rm -rf ios/Podfile.lock ios/Pods/
rm -rf pubspec.lock .packages .flutter-plugins
flutter pub pub cache repair
flutter pub get
cd ios; pod install 