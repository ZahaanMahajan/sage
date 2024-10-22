import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:sage_app/core/constants/constants.dart';

class ChatBotRepository {
  final OpenAI _openAI;

  ChatBotRepository(this._openAI);

  Future<List<ChatMessage>> getChatResponse(
      List<ChatMessage> messages, ChatUser user, ChatUser sage) async {
    List<Map<String, dynamic>> messagesHistory = [
      {'role': 'system', 'content': AppConstants.counselorPersona},
      ...messages
          .map((m) {
            return {
              'role': m.user.id == user.id ? 'user' : 'assistant',
              'content': m.text,
            };
          })
          .toList()
          .reversed,
    ];

    final request = ChatCompleteText(
      model: Gpt4OChatModel(),
      messages: messagesHistory,
      maxToken: 1000,
    );

    final response = await _openAI.onChatCompletion(request: request);

    if (response == null || response.choices.isEmpty) {
      throw Exception('Failed to get response from API');
    }

    return response.choices.map((choice) {
      return ChatMessage(
        user: sage,
        createdAt: DateTime.now(),
        text: choice.message?.content ?? '',
      );
    }).toList();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveChatMessage(String uid, ChatMessage message) async {
    // Reference to the user's sub-collection 'chats'
    final chatRef = _firestore.collection('users').doc(uid).collection('chats');

    // Add the chat message to the 'chats' sub-collection
    await chatRef.add({
      'text': message.text,
      'userId': message.user.id,
      'userName': message.user.firstName ?? '',
      'createdAt': message.createdAt.toIso8601String(),
    });
  }

  Future<List<ChatMessage>> loadChatHistory(
      String uid, ChatUser user, ChatUser sage) async {
    // Load chat history from Firestore
    final chatRef = _firestore.collection('users').doc(uid).collection('chats');
    final chatDocs = await chatRef.orderBy('createdAt', descending: true).get();

    return chatDocs.docs.map((doc) {
      final data = doc.data();
      final isUser = data['userId'] == user.id;

      return ChatMessage(
        user: isUser ? user : sage,
        text: data['text'] ?? '',
        createdAt: DateTime.parse(data['createdAt']),
      );
    }).toList();
  }

  Future<String> getSummary(List messages) async {
    if (messages.isEmpty) {
      return 'No conversation data available.';
    }

    // Extract key information from the messages
    String studentConcerns = '';
    String studentDescription = '';
    int messageCount = messages.length;
    List<String> keyIssues = [];
    List<String> emotionalTone = [];

    // Loop through the messages and look for key words or phrases
    for (var message in messages) {
      if (message is Map && message['sender'] == 'student') {
        String content = message['content'] ?? '';

        // Expanded keyword-based analysis for concerns
        if (content.contains(
            RegExp(r'\bstress\b|\banxiety\b|\bworried\b|\btension\b'))) {
          keyIssues.add('Stress or anxiety');
        }
        if (content.contains(RegExp(
            r'\bbullying\b|\bpeer pressure\b|\bharrassment\b|\bteased\b'))) {
          keyIssues.add('Bullying or peer pressure');
        }
        if (content.contains(RegExp(
            r'\bacademic\b|\bexam\b|\bschool\b|\bgrades\b|\bstudy\b|\bhomework\b|\bcollege\b'))) {
          keyIssues.add('Academic issues or exam pressure');
        }
        if (content.contains(RegExp(
            r'\bfamily\b|\bhome\b|\bparents\b|\bsibling\b|\bdomestic\b'))) {
          keyIssues.add('Family-related concerns');
        }
        if (content.contains(
            RegExp(r'\bfriends\b|\bsocial\b|\bisolation\b|\bloneliness\b'))) {
          keyIssues.add('Social issues or isolation');
        }
        if (content.contains(RegExp(
            r'\bcareer\b|\bfuture\b|\bunemployed\b|\bjob\b|\binterview\b'))) {
          keyIssues.add('Career or future-related concerns');
        }
        if (content.contains(
            RegExp(r'\bmoney\b|\bfinancial\b|\bdebt\b|\bexpenses\b'))) {
          keyIssues.add('Financial difficulties');
        }
        if (content.contains(RegExp(
            r'\bmental health\b|\bdepression\b|\bbipolar\b|\bsuicidal\b|\bself-harm\b'))) {
          keyIssues.add('Mental health issues');
        }
        if (content.contains(RegExp(
            r'\bphysical health\b|\bill\b|\binjured\b|\bdisease\b|\bdisability\b'))) {
          keyIssues.add('Physical health concerns');
        }
        if (content
            .contains(RegExp(r'\bgrief\b|\bloss\b|\bmourning\b|\bfuneral\b'))) {
          keyIssues.add('Grief or loss');
        }
        if (content.contains(
            RegExp(r'\brelationship\b|\bbreakup\b|\bdivorce\b|\bpartner\b'))) {
          keyIssues.add('Relationship problems');
        }
        if (content.contains(RegExp(
            r'\bviolence\b|\btrauma\b|\bptsd\b|\bdomestic violence\b'))) {
          keyIssues.add('Trauma or violence');
        }
        if (content.contains(RegExp(
            r'\bsubstance abuse\b|\baddiction\b|\balcohol\b|\bdrugs\b'))) {
          keyIssues.add('Substance abuse or addiction');
        }
        // Expanded emotional tone extraction
        if (content.contains(
            RegExp(r'\bsad\b|\bupset\b|\bhopeless\b|\bdepressed\b'))) {
          emotionalTone.add('Sadness');
        }
        if (content.contains(
            RegExp(r'\bangry\b|\bfrustrated\b|\brage\b|\bannoyed\b'))) {
          emotionalTone.add('Frustration or anger');
        }
        if (content.contains(
            RegExp(r'\bhopeful\b|\boptimistic\b|\bexcited\b|\bhappy\b'))) {
          emotionalTone.add('Positivity or hope');
        }
        if (content
            .contains(RegExp(r'\banxious\b|\bnervous\b|\bscared\b|\bfear\b'))) {
          emotionalTone.add('Anxiety or fear');
        }
        if (content
            .contains(RegExp(r'\blonely\b|\bisolated\b|\babandoned\b'))) {
          emotionalTone.add('Loneliness');
        }
        if (content
            .contains(RegExp(r'\bgrateful\b|\bthankful\b|\bappreciative\b'))) {
          emotionalTone.add('Gratitude');
        }
        if (content.contains(RegExp(r'\bconfused\b|\buncertain\b|\bdoubt\b'))) {
          emotionalTone.add('Confusion');
        }
        if (content.contains(RegExp(r'\bemotional\b|\bteary\b|\bcrying\b'))) {
          emotionalTone.add('Emotional distress');
        }
        if (content.contains(RegExp(r'\bcalm\b|\bpeaceful\b|\brelaxed\b'))) {
          emotionalTone.add('Calmness');
        }
        if (content
            .contains(RegExp(r'\bloved\b|\bcherished\b|\bsupported\b'))) {
          emotionalTone.add('Feeling loved or supported');
        }
        if (content
            .contains(RegExp(r'\bguilty\b|\bashamed\b|\bembarrassed\b'))) {
          emotionalTone.add('Guilt or shame');
        }
      }
    }

    // Avoid duplicating key issues and emotional tones
    keyIssues = keyIssues.toSet().toList();
    emotionalTone = emotionalTone.toSet().toList();

    // Form the summary based on extracted information
    studentConcerns = keyIssues.isNotEmpty
        ? 'The student seems to be dealing with: ${keyIssues.join(", ")}.'
        : 'No specific concerns mentioned.';

    // Generating the 5-6 line description of the student
    studentDescription =
        _generateStudentDescription(emotionalTone, keyIssues, messageCount);

    // Final summary string
    String summary = 'Conversation Summary:\n'
        'Total Messages: $messageCount\n'
        '$studentConcerns\n\n'
        'Student Description:\n'
        '$studentDescription';

    return summary;
  }

  String _generateStudentDescription(
      List<String> emotionalTone, List<String> keyIssues, int messageCount) {
    // Generate a simple description based on the data
    String description =
        'The student has been actively engaged in the conversation, '
        'exchanging approximately $messageCount messages.\n';

    if (emotionalTone.isNotEmpty) {
      description +=
          'Their emotional tone often reflected ${emotionalTone.join(", ")} during the chat.\n';
    } else {
      description += 'Their emotional tone was neutral throughout the chat.\n';
    }

    if (keyIssues.isNotEmpty) {
      description +=
          'They have shared concerns related to ${keyIssues.join(", ")}.\n';
    } else {
      description +=
          'No specific concerns were raised explicitly by the student.\n';
    }

    description +=
        'The student appears to be seeking support and understanding, '
        'and their responses suggest they are open to discussing their feelings.\n';

    return description;
  }
}
