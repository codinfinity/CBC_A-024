import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'skin_type_survey_provider.dart';
import '../../../models/fitzpatrick_question_model.dart';
import 'package:flareline/pages/auth/sign_up/sign_up_provider.dart';
import 'package:flareline_uikit/utils/snackbar_util.dart';

class SkinTypeSurveyPage extends StatelessWidget {
  final List<FitzpatrickQuestion> questions = [
    FitzpatrickQuestion(question: 'What color are your eyes?', options: ['Light blue, gray or green', 'Blue, gray, or green', 'Blue', 'Dark Brown', 'Brownish Black']),
    FitzpatrickQuestion(question: 'What is the natural color of your hair?', options: ['Sandy red', 'Blonde', 'Chestnut/Dark Blonde', 'Dark brown', 'Black']),
    FitzpatrickQuestion(question: 'What color is your skin in non-exposed areas?', options: ['Reddish', 'Very Pale', 'Pale with beige tint', 'Light brown', 'Dark brown']),
    FitzpatrickQuestion(question: 'Do you have freckles on unexposed areas?', options: ['Many', 'Several', 'Few', 'Incidental', 'None']),
    FitzpatrickQuestion(question: 'What happens when you stay too long in the sun?', options: ['Painful redness, blistering, peeling', 'Blistering then peeling', 'Burns sometimes followed by peeling', 'Rare burns', 'Never had burns']),
    FitzpatrickQuestion(question: 'To what degree do you turn brown?', options: ['Hardly at all', 'Light tan', 'Reasonable tan', 'Tan very easily', 'Turn dark brown quickly']),
    FitzpatrickQuestion(question: 'Do you turn brown after hours of sun exposure?', options: ['Never', 'Seldom', 'Sometimes', 'Often', 'Always']),
    FitzpatrickQuestion(question: 'How does your face react to the sun?', options: ['Very sensitive', 'Sensitive', 'Normal', 'Very resistant', 'Never had a problem']),
    FitzpatrickQuestion(question: 'When did you last expose your body to the sun?', options: ['> 3 months ago', '2-3 months ago', '1 month ago', '< 1 month ago', '< 2 weeks ago']),
    FitzpatrickQuestion(question: 'How often do you expose your face/body to the sun?', options: ['Never', 'Hardly ever', 'Sometimes', 'Often', 'Always']),
  ];

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return ChangeNotifierProvider(
      create: (_) => SkinTypeSurveyProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Skin Type Survey')),
        body: Consumer<SkinTypeSurveyProvider>(
          builder: (context, surveyProvider, _) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length + 1,
              itemBuilder: (context, index) {
                if (index < questions.length) {
                  final q = questions[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(q.question, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ...List.generate(q.options.length, (optIndex) {
                            return RadioListTile<int>(
                              title: Text(q.options[optIndex]),
                              value: optIndex,
                              groupValue: surveyProvider.answers[index],
                              onChanged: (value) {
                                surveyProvider.updateAnswer(index, value!);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      if (surveyProvider.isComplete)
                        Text(
                          'Your Fitzpatrick Skin Type: ${surveyProvider.skinType}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (!surveyProvider.isComplete) {
                            SnackBarUtil.showSnack(context, 'Please answer all questions.');
                            return;
                          }

                          if (args == null ||
                              !args.containsKey('name') ||
                              !args.containsKey('age') ||
                              !args.containsKey('gender') ||
                              !args.containsKey('email') ||
                              !args.containsKey('password')) {
                            SnackBarUtil.showSnack(context, 'Missing sign-up details. Please go back.');
                            return;
                          }

                          final signUpProvider = SignUpProvider(context);
                          await signUpProvider.saveUserToFirebase(
                            context: context,
                            name: args['name'],
                            age: args['age'],
                            gender: args['gender'],
                            skinType: surveyProvider.skinType,
                            email: args['email'],
                            password: args['password'],
                          );
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Submit'),
                      ),
                    ],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
