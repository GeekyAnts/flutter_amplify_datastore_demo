import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_amplify_demo/amplifyconfiguration.dart';
import 'package:flutter_amplify_demo/models/ModelProvider.dart';

class AmplifyService {
  static configureAmplify() async {
    // Add Pinpoint and Cognito Plugins, or any other plugins you want to use
    AmplifyAPI apiPlugin = AmplifyAPI();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyDataStore datastorePlugin = AmplifyDataStore(
      modelProvider: ModelProvider.instance,
    );
    // AmplifyStorageS3 amplifyStorageS3 = AmplifyStorageS3();
    Amplify.addPlugins([
      datastorePlugin,
      // amplifyStorageS3,
      authPlugin,
      apiPlugin,
    ]);
    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }
}
