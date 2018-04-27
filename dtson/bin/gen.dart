
 import 'dart:io';
import 'dart:convert';
import 'package:tson/tson.dart' as TSON;
import 'dart:typed_data' as td;

main(){
//  var map = {};
//
//  for (var i = 0 ; i < 1000 ; i++){
//    map[i.toString()] = i.toString();
//  }
//
//  for (var i = 1000 ; i < 2000 ; i++){
//    map[i.toString()] = i;
//  }
//   new File('./bin/test_data.tson').writeAsBytesSync(TSON.encode(map));
//  new File('./bin/test_data.json').writeAsStringSync(JSON.encode(map));

 for (var i = 0 ; i < 10 ; i++){
   var watch = new Stopwatch()..start();
   TSON.decode(new File('./bin/test_data.tson').readAsBytesSync());
   print('${watch.elapsedMicroseconds} us');
   watch.reset();
   JSON.decode(new File('./bin/test_data.json').readAsStringSync());
   print('${watch.elapsedMicroseconds} us');
 }

}