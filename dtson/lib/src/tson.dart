library tson;

import 'dart:typed_data' as td;
import 'dart:async';
import 'dart:convert';

import 'package:typed_data/typed_data.dart' as tb;

import 'string_list.dart';
part './ser/binary_serializer.dart';
part './ser/stream_serializer.dart';

td.Uint8List encode(object) {
  return new _BinarySerializer.from(object).toBytes();
}

Future<td.Uint8List> encodeAsync(object) async {
  var s = stream(object);
  tb.Uint8Buffer buffer = await s.fold(new tb.Uint8Buffer(),
      (tb.Uint8Buffer buffer, List<int> element) {
//    print('encodeAsync previous $buffer element $element');
    buffer.addAll(element);
    return buffer;
  });

  return new td.Uint8List.view(
      buffer.buffer, buffer.offsetInBytes, buffer.lengthInBytes);
}

Stream<List<int>> stream(object) {
  return new _StreamSerializer.from(object).controller.stream;
}

Object decode(bytesOrBuffer, [int offset]) {
  td.Uint8List bytes;
  if (bytesOrBuffer is td.ByteBuffer){
    bytes = new td.Uint8List.view(bytesOrBuffer);
  } else if (bytesOrBuffer is td.Uint8List){
    bytes = bytesOrBuffer;
  } else throw 'bad type';
  return new _BinarySerializer.fromBytes(bytes, offset).toObject();
}

class TsonError {
  Map _data;
  TsonError(int statusCode, String error, String reason) {
    _data = {"statusCode": statusCode, "error": error, "reason": reason};
  }
  int get statusCode => _data["statusCode"];
  String get error => _data["error"];
  String get reason => _data["reason"];

  String toString() => '${this.runtimeType}($statusCode, "$error", "$reason")';
}

class TsonSpec {
  static const String VERSION = "1.1.0";
  static const int TYPE_LENGTH_IN_BYTES = 1;
  static const int NULL_TERMINATED_LENGTH_IN_BYTES = 1;
  static const int ELEMENT_LENGTH_IN_BYTES = 4;

  static const int NULL_TYPE = 0;
  static const int STRING_TYPE = 1;
  static const int INTEGER_TYPE = 2;
  static const int DOUBLE_TYPE = 3;
  static const int BOOL_TYPE = 4;

  static const int LIST_TYPE = 10;
  static const int MAP_TYPE = 11;

  static const int LIST_UINT8_TYPE = 100;
  static const int LIST_UINT16_TYPE = 101;
  static const int LIST_UINT32_TYPE = 102;

  static const int LIST_INT8_TYPE = 103;
  static const int LIST_INT16_TYPE = 104;
  static const int LIST_INT32_TYPE = 105;
  static const int LIST_INT64_TYPE = 106;
  static const int LIST_UINT64_TYPE = 107;

  static const int LIST_FLOAT32_TYPE = 110;
  static const int LIST_FLOAT64_TYPE = 111;

  static const int LIST_STRING_TYPE = 112;
}
