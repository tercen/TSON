library tson.test;

import 'package:test/test.dart';
import 'dart:async';
import 'package:tson/tson.dart' as TSON;

main() {
  group('binary_serializer', () {
    test('Tson stream', () async {
      var list = new List.generate(10, (i) => {'hello': i});

      var stream = new Stream<dynamic>.fromIterable(list)
          .transform(new TSON.TsonStreamEncoderTransformer())
          .transform(new TSON.TsonStreamDecoderTransformer());

      var result = await stream.toList();

      expect(result, equals(list));
    });
  });
}
