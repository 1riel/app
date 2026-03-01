import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:app_1riel/utilities/Debug.dart';

//
String TITLE = '1riel.com';

String HOST_API = kDebugMode ? 'http://127.0.0.1:8000' : 'https://api.1riel.com/';

String MINIO = 'https://pub.1riel.com';

// String DEPARTMENT_NAME_EN = "Department of Telecommunications and Network Engineering";
// String DEPARTMENT_NAME_FR = "Génie des Télécommunications et Réseaux";

// // fastapi URL
// String HOST_API = kDebugMode ? 'http://127.0.0.1:8000' : 'https://api.codeshift.me';

// // minio URL public
// // String MINIO = 'https://pubs.codeshift.me'; // staging
// String MINIO = 'https://pub.codeshift.me'; // production
// String MINIO_PUBLIC = '$MINIO/public';

// String LOGO_ITC = "$MINIO_PUBLIC/assets/logo_itc.png";
// String LOGO_GTR = "$MINIO_PUBLIC/assets/logo_gtr.png";
// String BACKGROUND = "$MINIO_PUBLIC/assets/background.png";

// List<String> BANNERS = [
//   "$MINIO_PUBLIC/assets/banner/image_1.jpeg",
//   "$MINIO_PUBLIC/assets/banner/image_2.jpeg",
//   "$MINIO_PUBLIC/assets/banner/image_3.png", //
// ];
