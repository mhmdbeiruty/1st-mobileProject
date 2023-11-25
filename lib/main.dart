import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp( const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FirstPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
    );
  }
}
class FirstPage extends StatelessWidget{
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Unit Conversion App',
          style: TextStyle(fontSize: 35),
        ),
      ),
      body:  Center(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,

          

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('images/scale.jpg'),),

              const Text(
                'Welcome to my Unit App',
                style: TextStyle(fontSize: 35,
                    color: Colors.red),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                    return  const ConverterScreen();
                  }));

                }, child: const Text('Start'),
              ),
              ElevatedButton(
                onPressed: (){
                  if (Platform.isAndroid){
                    SystemNavigator.pop();
                  }else{
                    exit(0);
                  }
                },
                child: const Text('Exit'),
              )
            ],)

      ),
      ),
    );
  }
}
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  double _inputValue = 0.0;
  double _outputValue = 0.0;
  LengthUnit _inputUnit = LengthUnit.meter;
  LengthUnit _outputUnit = LengthUnit.feet;

  final Map<LengthUnit, String> _unitLabels = {
    LengthUnit.meter: 'Meter',
    LengthUnit.feet: 'Feet',
    LengthUnit.inch: 'Inch',
    LengthUnit.yard: 'Yard',
  };

  final Map<LengthUnit, double> _unitFactors = {
    LengthUnit.meter: 1.0,
    LengthUnit.feet: 3.28084,
    LengthUnit.inch: 39.3701,
    LengthUnit.yard: 1.09361,
  };

  void _convertLength() {
    double inputValue = _inputValue;
    double inputFactor = _unitFactors[_inputUnit]!;
    double outputFactor = _unitFactors[_outputUnit]!;


    double metersValue = inputValue * inputFactor;

    _outputValue = metersValue / outputFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _inputValue = double.tryParse(value) ?? 0.0;
                  _convertLength();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Enter value',
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<LengthUnit>(
              value: _inputUnit,
              onChanged: (value) {
                setState(() {
                  _inputUnit = value!;
                  _convertLength();
                });
              },
              items: _unitLabels.entries.map((entry) {
                return DropdownMenuItem<LengthUnit>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'From',
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<LengthUnit>(
              value: _outputUnit,
              onChanged: (value) {
                setState(() {
                  _outputUnit = value!;
                  _convertLength();
                });
              },
              items: _unitLabels.entries.map((entry) {
                return DropdownMenuItem<LengthUnit>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'To',
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              '$_inputValue ${_unitLabels[_inputUnit]} = $_outputValue ${_unitLabels[_outputUnit]}',
              style: const TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

enum LengthUnit { meter, feet, inch, yard }
