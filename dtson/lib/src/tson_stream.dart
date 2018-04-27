import 'dart:typed_data';
import 'dart:async';
import 'tson.dart' as TSON;

import 'package:async/async.dart';

class TsonStreamDecoderTransformer
    implements StreamTransformer<List<int>, Object> {
  static Object decode(Uint8List bytes) {
    final len = readLength(bytes);
    if (bytes.length  < len + 4)
//    if (bytes.length + 4 < len)
      throw new ArgumentError.value(
          len, 'TsonStreamDecoderTransformer.decode : wrong length');
    return TSON
        .decode(new Uint8List.view(bytes.buffer, bytes.offsetInBytes + 4, len));
  }

  static int readLength(Uint8List bytes) {
    if (bytes.length < 4)
      throw new ArgumentError.value(bytes.length,
          'TsonStreamDecoderTransformer.readLength : wrong length');
    return new ByteData.view(bytes.buffer)
        .getUint32(bytes.offsetInBytes, Endianness.LITTLE_ENDIAN);
  }

  StreamTransformer _transformer;

  List<int> _buffer = [];

  TsonStreamDecoderTransformer() {
    _transformer = new StreamTransformer.fromHandlers(
        handleData: handleData, handleDone: handleDone);
    _buffer = new Uint8List(0);
  }

  void handleData(List<int> data, EventSink<Object> sink) {
//    print('$this handleData data.length=${data.length} ');
    _addBuffer(data);
    _readObject(sink);
  }

  void _addBuffer(List<int> bytes) {
    var tmp = new Uint8List(_buffer.length + bytes.length);
    tmp.setRange(0, _buffer.length, _buffer);
    tmp.setRange(_buffer.length, _buffer.length + bytes.length, bytes);
    _buffer = tmp;
  }

  /*
  Recursively read objects from the buffer and add them to the sink
   */
  void _readObject(EventSink<Object> sink) {
    if (_buffer.length < 4) return;

    var len = readLength(_buffer);

      if (_buffer.length  >= len + 4) {
       sink.add(decode(_buffer));
      _buffer = _buffer.sublist(len + 4);
      _readObject(sink);
    }
  }

  void handleDone(EventSink<Object> sink) {
    _readObject(sink);
    assert(_buffer.length == 0);
    sink.close();
  }

  @override
  Stream<Object> bind(Stream<List> stream) => _transformer.bind(stream);
}

class TsonStreamEncoderTransformer
    implements StreamTransformer<dynamic, List<int>> {
  static List<int> encode(object) {
    var bytes = TSON.encode(object);
    var result = new Uint8List(bytes.length + 4);
    var byteData = new ByteData.view(result.buffer);
    byteData.setUint32(0, bytes.length, Endianness.LITTLE_ENDIAN);
    result.setRange(4, result.length, bytes);

    return result;
  }

  StreamTransformer<dynamic, List<int>> _transformer;

  TsonStreamEncoderTransformer() {
    _transformer = new StreamTransformer.fromHandlers(handleData: _handleData);
  }

  void _handleData(object, EventSink<List<int>> sink) =>
      sink.add(encode(object));

  @override
  Stream<List<int>> bind(Stream<dynamic> stream) => _transformer.bind(stream);
}


StreamSinkTransformer<Map, List<int>> streamSinkTransformer(){
  return new StreamSinkTransformer.fromHandlers(handleData : (Map data, EventSink<List<int>> sink){
    sink.add(TSON.encode(data));
  }, handleError: (Object error, StackTrace stackTrace, EventSink<List<int>> sink){
    sink.addError(error,stackTrace);
  }, handleDone: (EventSink<List<int>> sink){
    sink.close();
  } );
}



//class TsonSink {
//  StreamController<List<int>> _controller;
//
//  TsonSink() {
//    _controller = new StreamController();
//  }
//
//  Stream<List<int>> get stream => _controller.stream;
//
//  void _add(List<int> data) {
//    _controller.add(data);
//  }
//
//  void addObject(object) {
//    var bytes = TSON.encode(object);
//    _addLength(bytes.length);
//    this._add(TSON.encode(object));
//  }
//
//  void _addLength(int len) {
//    var byteData = new ByteData(4)..setUint32(0, len, Endianness.LITTLE_ENDIAN);
//    this._add(new Uint8List.view(byteData.buffer));
//  }
//
//  void close() {
//    _controller.close();
//  }
//}
