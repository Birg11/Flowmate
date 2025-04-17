import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> sendMessage(String phoneNumber, String message) async {
    final encoded = Uri.encodeComponent(message);
    final uri = Uri.parse("https://wa.me/$phoneNumber?text=$encoded");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch WhatsApp');
    }
  }
}
