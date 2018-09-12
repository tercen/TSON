library tson.test;

import 'package:test/test.dart';

import 'package:tson/tson.dart' as TSON;

main() {

    test('Test fromList', () {

      var cstring_list = new TSON.CStringList.fromList(["héllo", "tson"]);

      expect(cstring_list.lengthInBytes , equals(12));
      expect(cstring_list.length , equals(2));
      expect(cstring_list[0] , "héllo");
      expect(cstring_list[1] , "tson");

    });

    test('Test fromBytes', () {

      var cstring_list = new TSON.CStringList.fromList(["héllo", "tson"]);

       cstring_list = new TSON.CStringList.fromBytes(cstring_list.toBytes());

      expect(cstring_list.length , equals(2));
      expect(cstring_list[0] , "héllo");
      expect(cstring_list[1] , "tson");

    });

}
