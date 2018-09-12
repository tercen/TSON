import 'dart:collection';
import 'dart:typed_data' as td;
import 'dart:convert';

class CStringList  extends ListBase<String> implements List<String>  {

  td.Uint8List _bytes;
  td.Int32List _starts;

  CStringList.fromBytes(this._bytes);
  CStringList.fromList(List<String> list) {
    var lengthInBytes = list.fold(0, (len, str) {
      if (str == null) throw new ArgumentError("Null values are not allowed.");
      return len + UTF8.encode(str).length + 1;
    });
    _bytes = new td.Uint8List(lengthInBytes);
    var offset = 0;
    list.forEach((str){
      var bytes = UTF8.encode(str);
      _bytes.setRange(offset, offset + bytes.length, bytes);
      offset += bytes.length + 1;
    });
  }

  td.Uint8List toBytes() => _bytes;
  int get lengthInBytes => _bytes.length;

  td.Int32List _buildStarts() {
    var len = 0;
    for (int i = 0; i < _bytes.length; i++) {
      if (_bytes[i] == 0) len++;
    }
    _starts = new td.Int32List(len + 1);
    _starts[0] = 0;
    var offset = 0;

    for (int i = 0; i < len; i++) {
      var start = offset;
      while (_bytes[offset] != 0) offset++;
      offset += 1;
      _starts[i + 1] = _starts[i] + (offset - start);
    }
    return _starts;
  }

  td.Int32List get starts => _starts == null ? _buildStarts() : _starts;

  int get length => starts.length - 1;

  void set length(int newLength) => throw "list is read only";

  operator [](int i) {
    var start = starts[i];
    var end = starts[i + 1];
    return UTF8.decode(_bytes.sublist(start, end-1));
    return new String.fromCharCodes(_bytes, start, end - 1);
  }

  operator []=(int i, String value) => throw "list is read only";
}
