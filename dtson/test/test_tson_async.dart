library tson.test;

import 'dart:async';
 import 'package:test/test.dart';

import 'package:tson/tson.dart' as TSON;
import 'dart:typed_data' as td;

encodeDecode(object, [expectedObject]) async {
//  print('object = ${JSON.encode(object)}');
  var bytes = await TSON.encodeAsync(object);
//  print('tson bytes = $bytes');
  if (expectedObject == null){
    expectedObject = object;
  }
  var decodedObject = TSON.decode(bytes);
    print('tson decodedObject = $decodedObject');
  expect(decodedObject, equals(expectedObject));
}

main() {
  group('binary_serializer', () {
    test('Empty list,map', () async {
      await encodeDecode([]);
      await encodeDecode({});
    });

    test('Simple list with null', () async {
      await encodeDecode([null]);
    });

    test('Simple list with one', () async {
      await encodeDecode([1]);
    });

    test('Simple list', () async {
      await encodeDecode(["a", true, false, 42, 42.0]);
    });

    test('Simple int32 list', () async {
      await encodeDecode(new td.Int32List.fromList([42, 42]));
    });

    test('Simple cstring list', () async {
      await encodeDecode(new TSON.CStringList.fromList(["42.0", "42"]));
    });

    test('Simple map 2', () async {
      await encodeDecode({"a": "a", "d": 42.0});
      await encodeDecode({"a": "a", "i": 42, "d": 42.0});
    });

    test('Simple map of int32, float32 and float64 list', () async {
      await encodeDecode({
        "i": new td.Int32List.fromList([42]),
        "f": new td.Float32List.fromList([42.0]),
        "d": new td.Float64List.fromList([42.0])
      });
    });

    test('factor', () async {
      await encodeDecode({
        "type": "factor",
        "dictionary": new TSON.CStringList.fromList(["sample1", "sample2"]),
        "data": [0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1]
      });
    });

    test('all types', () async {
      var map = {
        "null": null,
        "string": "hello",
        "integer": 42,
        "float": 42.0,
        "bool_t": true,
        "bool_f": false,
        "map": {"string": "42"},
        "list": [
          42,
          "42",
          {"string": "42"},
          ["42", 42]
        ],
        "uint8": new td.Uint8List.fromList([42, 42]),
        "uint16": new td.Uint16List.fromList([42, 42]),
        "uint32": new td.Uint32List.fromList([42, 42]),
        "int8": new td.Int8List.fromList([-42, 42]),
        "int16": new td.Int16List.fromList([42, 42]),
        "int32": new td.Int32List.fromList([42, 42]),
        "int64": new td.Int64List.fromList([42, 42]),
        "float32": new td.Float32List.fromList([42.0, 42.0]),
        "float64": new td.Float64List.fromList([42.0, 42.0]),
        "cstringlist": new TSON.CStringList.fromList(["42.0", "42"])
      };

      await encodeDecode(map);
    });
  });

  test('stream provider', () async {
    var values = new td.Uint8List.fromList(new List.generate(10, (i)=>i));
    var valuesStream = new Stream.fromIterable([values]);
    var valuesStreamProvider = new TSON.TypedTsonStreamProvider(
        TSON.TsonSpec.LIST_UINT8_TYPE, 10, valuesStream);

    await encodeDecode(valuesStreamProvider, values);
  });

  test('stream provider : map', () async {
    var values1 = new td.Uint8List.fromList(new List.generate(10, (i)=>i));
    var values2 = new td.Uint8List.fromList(new List.generate(10, (i)=>i+1));

    var valuesStreamProvider1 = new TSON.TypedTsonStreamProvider(
        TSON.TsonSpec.LIST_UINT8_TYPE, 10, new Stream.fromIterable([values1]));

    var valuesStreamProvider2 = new TSON.TypedTsonStreamProvider(
        TSON.TsonSpec.LIST_UINT8_TYPE, 10, new Stream.fromIterable([values2]));

    var object = {'value1': valuesStreamProvider1, 'value2': valuesStreamProvider2};
    var expected = {'value1': values1,'value2': values2};

    await encodeDecode(object, expected);
  });
}
