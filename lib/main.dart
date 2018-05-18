import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {return new MyAppState();}
}

typedef OperatorFunc = double Function(double accu, double operand);

class MyAppState extends State<MyApp> {

  double accu = 0.0;
  double operand = 0.0;
  OperatorFunc queuedOperation;

  String resultString = "0.0";

  void numberPressed(int value)  {
    operand = operand * 10 + value;
    setState(() => resultString = operand.toString());
  }

  void calc(OperatorFunc operation) {
    if (operation == null) { // C was pressed
      accu = 0.0;
    } else {
      accu = queuedOperation != null ? queuedOperation(accu, operand) : operand;
    }
    queuedOperation = operation;
    operand = 0.0;
    var result = accu.toString();
    setState(() => resultString = result.toString().substring(0, min(10,result.length) ));
  }

  List<Widget> buildNumberButtons(int count, int from, int flex) {
    return new Iterable.generate(count, (index) {
      return new Expanded(flex: flex,
        child: new Padding(padding: const EdgeInsets.all(8.0),
          child: RaisedButton(onPressed: () => numberPressed(from + index),
              color: const Color(0xffeeffff), highlightColor: const Color(0xffaaddaa),
              elevation: 8.0, highlightElevation: 12.0,
              child: Text(
                "${from + index}", style: TextStyle(fontSize: 40.0),)),
        ),
      );
    }).toList();
  }

  Widget buildOperatorButton(String label, OperatorFunc func, int flex,) {
    return Expanded(flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RaisedButton(onPressed: () => calc(func),
            color: const Color(0xffffddff), highlightColor: const Color(0xffffaaff), elevation: 10.0, highlightElevation: 16.0,
            child: Text(label,style:  new TextStyle(fontSize: 32.0))),
      ),
    );
  }

  Widget buildRow(int numberKeyCount, int startNumber,  int numberFlex, String operationLabel, OperatorFunc operation, int operrationFlex){
      return new Expanded(child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: new List.from(buildNumberButtons(numberKeyCount,startNumber ,numberFlex,))
                                    ..add(buildOperatorButton(operationLabel, operation, operrationFlex))));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new SafeArea(
              child: new Material(color: const Color(0xffffeeff),
                child: Column( crossAxisAlignment: CrossAxisAlignment.end,
                   children: <Widget>[
            Expanded(child: new Card(child:Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.end,
                children: [Text(resultString,textAlign: TextAlign.right, style: TextStyle(fontSize: 50.0, color: const Color(0xff114411)),)]))),
            buildRow(3,7,1,"/", (accu, dividor)=> accu / dividor , 1),
            buildRow(3,4,1,"x", (accu, dividor)=> accu * dividor , 1),
            buildRow(3,1,1,"-", (accu, dividor)=> accu - dividor , 1),
            buildRow(1, 0,3,"+", (accu, dividor)=> accu + dividor , 1),
            Expanded(child:Row(crossAxisAlignment: CrossAxisAlignment.stretch,children: [buildOperatorButton("C", null, 1,),buildOperatorButton("=", (accu, dividor)=> accu, 3)],))
          ],),
        ),
      )
    );
  }
}


