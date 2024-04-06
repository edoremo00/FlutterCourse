class QuizQuestion{
  QuizQuestion({required this.questiontext, required this.answers});
  final String questiontext;
  final List<String> answers;

  List<String> getShuffledAnswers(){
   final List<String> listcopy=[...answers];
   listcopy.shuffle();
   return listcopy;
  }
}