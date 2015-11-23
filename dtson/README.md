# TSON

Dart implementation of [TSON specification](https://github.com/amaurel/TSON).

## CStrinList implements List<String>

A CStringList can efficiently store very large collection of strings, it internally stores its elements in a byte array.

```
var cstring_list = new TSON.CStringList.fromList(["42.0", "42"])
```

```
library tson.test;

import 'package:test/test.dart';

import 'package:tson/tson.dart'as TSON;
import 'dart:typed_data' as td;

main() {
  group('binary_serializer', () {
    test('binary_serializer', () {
      var map = {
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

      expect(map, equals(TSON.decode(TSON.encode(map))));
    });
  });
}
```