import 'dart:convert';

import 'package:http/http.dart' as http;

/// One reply from the agent. [skill] is the name of the skill it used (if any).
class AgentReply {
  final String text;
  final String? skill;
  const AgentReply(this.text, {this.skill});
}

/// The "brain" of Kavya.
///
/// If the app is started with a server address, messages go to the Kavya
/// backend (see the kavya_backend folder), which asks the Claude API:
///
///   flutter run --dart-define=KAVYA_API=http://10.0.2.2:8787 \
///               --dart-define=KAVYA_TOKEN=your-app-token
///
/// Without KAVYA_API the app uses small offline demo replies.
/// Never put an AI API key inside the app. Keep it on the server.
class AgentService {
  AgentService._();
  static final AgentService instance = AgentService._();

  static const String _baseUrl = String.fromEnvironment('KAVYA_API');
  static const String _token = String.fromEnvironment('KAVYA_TOKEN');

  final List<Map<String, String>> _history = [];

  Future<AgentReply> reply(String message) async {
    if (_baseUrl.isEmpty) return _demo(message);

    _history.add({'role': 'user', 'content': message});
    try {
      final res = await http
          .post(
            Uri.parse('$_baseUrl/chat'),
            headers: {
              'content-type': 'application/json',
              if (_token.isNotEmpty) 'x-app-token': _token,
            },
            body: jsonEncode({'messages': _history}),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}');
      }
      final data = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
      final text = (data['text'] as String?) ?? '';
      final skill = data['skill'] as String?;
      _history.add({'role': 'assistant', 'content': text});
      return AgentReply(text, skill: skill);
    } catch (_) {
      _history.removeLast();
      return const AgentReply(
        'Net ya server mein dikkat aa rahi hai. Thodi der baad try karo.',
      );
    }
  }

  // ---- Offline demo replies ----
  Future<AgentReply> _demo(String message) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final m = message.toLowerCase();

    if (m.contains('alarm')) {
      return const AgentReply('Theek hai, alarm skill khol rahi hoon.',
          skill: 'Alarm skill');
    }
    if (m.contains('gaana') || m.contains('gaane') || m.contains('music')) {
      return const AgentReply('Lo-fi chill laga rahi hoon.',
          skill: 'Gaane skill');
    }
    if (m.contains('journal')) {
      return const AgentReply('Bolo, main likh leti hoon. Aaj kya hua?',
          skill: 'Journal skill');
    }
    if (m.contains('padhai') || m.contains('quiz')) {
      return const AgentReply('Chalo shuru karte hain. Kaunsa topic?',
          skill: 'Padhai skill');
    }
    return const AgentReply('Samajh gayi. Thoda aur batao?');
  }
}
