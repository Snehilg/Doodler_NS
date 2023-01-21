import 'package:doodler/UI/Quiz/models/quiz_model.dart';
import 'package:doodler/UI/Quiz/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputScreen extends StatefulWidget {
  @override
  State<InputScreen> createState() {
    return InputScreenState();
  }
}

class InputScreenState extends State<InputScreen> {
  Quiz quiz = Quiz(
      number: 10,
      category: 'All',
      difficulty: Difficulty.easy,
      type: QuestionType.all);

  List<String> images = [
    "https://firebasestorage.googleapis.com/v0/b/doodler-6fab7.appspot.com/o/backgrounds%2Falice-butenko-hwU6ubmAxyw-unsplash.jpg?alt=media&token=93133e24-b357-406e-a0ba-38ef3c5b2e44",
    "https://firebasestorage.googleapis.com/v0/b/doodler-6fab7.appspot.com/o/backgrounds%2Fandrew-buchanan-pVMhOC7HnzQ-unsplash.jpg?alt=media&token=61e4fff6-bc4c-4137-bcbe-55b0404fef6d",
    "https://firebasestorage.googleapis.com/v0/b/doodler-6fab7.appspot.com/o/backgrounds%2Fandrew-ridley-jR4Zf-riEjI-unsplash.jpg?alt=media&token=13cf3f60-d48c-4298-aee1-7a4a4b759ae1",
    "https://firebasestorage.googleapis.com/v0/b/doodler-6fab7.appspot.com/o/backgrounds%2Fcurioso-photography-v5yPUQYbrcw-unsplash.jpg?alt=media&token=f88ba55d-ca0b-49b9-b1c5-6915705b1a82",
    "https://firebasestorage.googleapis.com/v0/b/doodler-6fab7.appspot.com/o/backgrounds%2Fjason-leung-UMncYEfO9-U-unsplash.jpg?alt=media&token=582edfa7-1515-45ac-b5e9-e20b27a0fe4a",
    "https://firebasestorage.googleapis.com/v0/b/doodler-6fab7.appspot.com/o/backgrounds%2Fmona-eendra-vC8wj_Kphak-unsplash.jpg?alt=media&token=42f6852a-1542-4ce0-955c-0c7cf89e0f61",
    "https://firebasestorage.googleapis.com/v0/b/doodler-6fab7.appspot.com/o/backgrounds%2Fpawel-czerwinski-8uZPynIu-rQ-unsplash.jpg?alt=media&token=29f9babf-0acf-413e-9eed-99846946b850",
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<List<String?>> getCategories() async {
    await quiz.getCategories();
    return quiz.categories.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[200],
        title: Text('Quiz'),
      ),
      body: FutureBuilder<List<String?>>(
        future: getCategories(), // async work
        builder: (BuildContext context, AsyncSnapshot<List<String?>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return GridView.count(
                  crossAxisCount: 2,
                  children: quiz.categories.values.toList().map((category) {
                    return GestureDetector(
                      onTap: () {
                        print("LOG_NAME" + category);
                        quiz.category = category;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            maintainState: false,
                            builder: (BuildContext context) => QuizScreen(quiz),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(color: Colors.purple),
                        ),
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Stack(
                          children: [
                            /* Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Image.network(
                                    images[Random(DateTime.now()
                                            .microsecondsSinceEpoch)
                                        .nextInt(7)],
                                    fit: BoxFit.fill)),*/
                            Center(
                                child: Text(
                              category!,
                              style: GoogleFonts.portLligatSans(
                                textStyle:
                                    Theme.of(context).textTheme.headline4!,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            )),
                          ],
                        ),
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                );
          }
        },
      ),
    );
  }
}
