

import 'package:url_launcher/url_launcher_string.dart';

void openPhoneNumberCall(String phoneNumber) {
  launchUrlString("tel://$phoneNumber");
}

void openWebsiteAndLink(String? url) {
  if(url == null || url.isEmpty) {
    return;
  }
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'https://$url';
  }
  launchUrlString(url,mode: LaunchMode.externalApplication,);
}