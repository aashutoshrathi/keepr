import 'package:flutter_test/flutter_test.dart';
import 'package:keepr/main.dart';


void main(){
  testWidgets('Build Test',(WidgetTester tester)async{
    await tester.pumpWidget(NotesApp());
  });
}