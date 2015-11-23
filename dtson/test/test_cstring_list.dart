library tson.test;

import 'package:test/test.dart';

import 'package:tson/tson.dart' as TSON;
import 'dart:typed_data' as td;

main() {

    test('Test fromList', () {

      var cstring_list = new TSON.CStringList.fromList(["hello", "tson"]);

      expect(cstring_list.length , equals(2));
      expect(cstring_list[0] , "hello");
      expect(cstring_list[1] , "tson");

    });

    test('Test fromBytes', () {

      var cstring_list = new TSON.CStringList.fromList(["hello", "tson"]);

      var bytes = cstring_list.toBytes();
      cstring_list = new TSON.CStringList.fromBytes(cstring_list.toBytes());

      expect(cstring_list.length , equals(2));
      expect(cstring_list[0] , "hello");
      expect(cstring_list[1] , "tson");

    });

}
