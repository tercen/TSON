part of tson;

td.Uint8List encode(object) {
  return new _BinarySerializer.from(object).toBytes();
}

Object decode(td.Uint8List bytes, [int offset]) {
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

class _BinarySerializer {
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

  static const int LIST_FLOAT32_TYPE = 110;
  static const int LIST_FLOAT64_TYPE = 111;

  static const int LIST_STRING_TYPE = 112;

  td.Uint8List _bytes;
  td.ByteData _byteData;
  int _intByteOffset;
  int _byteOffset;

  _BinarySerializer.from(object) {
    _initializeFromObject(object);
  }

  _BinarySerializer.fromBytes(this._bytes, [int offset]) {
    _intByteOffset = offset == null ? 0 : offset;
    _byteData = new td.ByteData.view(_bytes.buffer);
  }

  void _initializeFromObject(object) {
    _intByteOffset = 0;
    var size = _computeObjectSize(VERSION);
    size += _computeMapOrListSize(object);

    _bytes = new td.Uint8List(size);
    _byteOffset = _intByteOffset;
    _byteData = new td.ByteData.view(_bytes.buffer);
    _addString(VERSION);
    _add(object);
    _byteOffset = _intByteOffset;
  }

  _addType(int type) {
    _byteData.setUint8(_byteOffset, type);
    _byteOffset++;
  }

  _addLength(int len) {
    _byteData.setUint32(_byteOffset, len, td.Endianness.LITTLE_ENDIAN);
    _byteOffset += 4;
  }

  addNull() {
    _addType(NULL_TYPE);
  }

  int _readObjectType() {
    var type = _byteData.getUint8(_byteOffset);
    _byteOffset++;
    return type;
  }

  //Null terminated string
  _addString(String object) {
    _addType(STRING_TYPE);
    var bytes = object.codeUnits;
    _bytes.setRange(_byteOffset, _byteOffset + bytes.length, bytes);
    _byteOffset += bytes.length;
    _byteData.setUint8(_byteOffset, 0);
    _byteOffset++;
  }

  _addInt(int object) {
    _addType(INTEGER_TYPE);
    _byteData.setInt32(_byteOffset, object, td.Endianness.LITTLE_ENDIAN);
    _byteOffset += 4;
  }

  _addDouble(double object) {
    _addType(DOUBLE_TYPE);
    _byteData.setFloat64(_byteOffset, object, td.Endianness.LITTLE_ENDIAN);
    _byteOffset += 8;
  }

  _addBool(bool object) {
    _addType(BOOL_TYPE);
    _byteData.setUint8(_byteOffset, object ? 1 : 0);
    _byteOffset += 1;
  }

  _addTypedData(td.TypedData object) {
    var len;
    if (object is td.Uint8List) {
      _addType(LIST_UINT8_TYPE);
      len = object.length;
    } else if (object is td.Uint16List) {
      _addType(LIST_UINT16_TYPE);
      len = object.length;
    } else if (object is td.Uint32List) {
      _addType(LIST_UINT32_TYPE);
      len = object.length;
    } else if (object is td.Int8List) {
      _addType(LIST_INT8_TYPE);
      len = object.length;
    } else if (object is td.Int16List) {
      _addType(LIST_INT16_TYPE);
      len = object.length;
    } else if (object is td.Int32List) {
      _addType(LIST_INT32_TYPE);
      len = object.length;
    } else if (object is td.Int64List) {
      _addType(LIST_INT64_TYPE);
      len = object.length;
    } else if (object is td.Float32List) {
      _addType(LIST_FLOAT32_TYPE);
      len = object.length;
    } else if (object is td.Float64List) {
      _addType(LIST_FLOAT64_TYPE);
      len = object.length;
    } else {
      throw new TsonError(404, "unknown.typed.data", "unknown typed data");
    }
    _byteData.setUint32(_byteOffset, len, td.Endianness.LITTLE_ENDIAN);
    _byteOffset += 4;
    var bytes = new td.Uint8List.view(
        object.buffer, object.offsetInBytes, len * object.elementSizeInBytes);
    _bytes.setRange(_byteOffset, _byteOffset + bytes.length, bytes);
    _byteOffset += bytes.length;
  }

  _addList(List object) {
    _addType(LIST_TYPE);
    _addLength(object.length);
    object.forEach(_add);
  }

  _addMap(Map object) {
    _addType(MAP_TYPE);
    _addLength(object.length);
    object.forEach((k, v) {
      if (k is! String) throw new TsonError(
          500, "wrong.map.key.format", "Map key must be a String");
      _add(k);
      _add(v);
    });
  }

  _addCStringList(CStringList object) {
    _addType(LIST_STRING_TYPE);
    _addLength(object.lengthInBytes);
    _bytes.setRange(_byteOffset, _byteOffset + object.lengthInBytes, object.toBytes());
  }

  void _add(object) {
    if (object == null) {
      addNull();
    } else if (object is String) {
      _addString(object);
    } else if (object is int) {
      _addInt(object);
    } else if (object is double) {
      _addDouble(object);
    } else if (object is bool) {
      _addBool(object);
    } else if (object is td.TypedData) {
      _addTypedData(object);
    }  else if (object is CStringList) {
      _addCStringList(object);
    } else if (object is List) {
      _addList(object);
    } else if (object is Map) {
      _addMap(object);
    } else {
      throw new TsonError(404, "unknown.value.type",
          "Unknow value type : ${object.runtimeType}");
    }
  }

  int _computeMapOrListSize(object) {
    var size = TYPE_LENGTH_IN_BYTES + ELEMENT_LENGTH_IN_BYTES;
    if (object is Map) {
      object.forEach((k, v) {
        size += _computeObjectSize(k);
        size += _computeObjectSize(v);
      });
    } else if (object is CStringList) {
      size += object.lengthInBytes;
    }
     else if (object is List) {
      object.forEach((v) {
        size += _computeObjectSize(v);
      });
    } else {
      throw new TsonError(404, "unknown.value.type",
          "Unknow value type : ${object.runtimeType}");
    }

    return size;
  }

  int _computeObjectSize(object) {
    var sizeInBytes = TYPE_LENGTH_IN_BYTES;
    if (object == null) {
      sizeInBytes += 0;
    } else if (object is String) {
      sizeInBytes += object.codeUnits.length + NULL_TERMINATED_LENGTH_IN_BYTES;
    } else if (object is int) {
      sizeInBytes += 4;
    } else if (object is double) {
      sizeInBytes += 8;
    } else if (object is bool) {
      sizeInBytes = 4;
    } else if (object is td.TypedData) {
      sizeInBytes += object.lengthInBytes + ELEMENT_LENGTH_IN_BYTES;
    } else if (object is CStringList || object is List || object is Map) {
      sizeInBytes += _computeMapOrListSize(object);
    } else {
      throw new TsonError(404, "unknown.value.type",
          "Unknow value type : ${object.runtimeType}");
    }
    return sizeInBytes;
  }

  td.Uint8List toBytes() => _bytes;

  Object toObject() {
    _byteOffset = _intByteOffset;
    var version = _readObject();
    if (version != VERSION) throw new TsonError(500, "version.mismatch",
        "TSON version mismatch, found : $version , expected : $VERSION");
    return _readObject();
  }

  Map _readMap() {
    final len = _readLength();
    var answer = new Map();
    for (int i = 0; i < len; i++) {
      var key = _readObject();
      if (key is! String) throw new TsonError(
          500, "wrong.map.key.format", "Map key must be a String");
      answer[key] = _readObject();
    }
    return answer;
  }

  String _readString() {
    var start = _byteOffset;
    while (_byteData.getUint8(_byteOffset) != 0) _byteOffset++;
    var answer = new String.fromCharCodes(_bytes, start, _byteOffset);
    _byteOffset++; //skip null
    return answer;
  }

  int _readInteger() {
    var answer = _byteData.getInt32(_byteOffset, td.Endianness.LITTLE_ENDIAN);
    _byteOffset += 4;
    return answer;
  }

  double _readDouble() {
    var answer = _byteData.getFloat64(_byteOffset, td.Endianness.LITTLE_ENDIAN);
    _byteOffset += 8;
    return answer;
  }

  bool _readBool() {
    var answer = _byteData.getUint8(_byteOffset);
    _byteOffset += 1;
    return answer > 0;
  }

  List _readList() {
    final len = _readLength();
    var answer = new List(len);
    for (int i = 0; i < len; i++) {
      answer[i] = _readObject();
    }
    return answer;
  }

  int _readLength(){
    final len = _byteData.getUint32(_byteOffset, td.Endianness.LITTLE_ENDIAN);
    _byteOffset += 4;
    return len;
  }

  CStringList _readCStringList(){
    var lengthInBytes = _readLength();
    var answer = new CStringList.fromBytes(_bytes.sublist(_byteOffset,_byteOffset + lengthInBytes));
    _byteOffset += lengthInBytes;
    return answer;
  }

  int _elementSizeFromType(int type) {
    if (type == LIST_UINT8_TYPE) {
      return 1;
    } else if (type == LIST_UINT16_TYPE) {
      return 2;
    } else if (type == LIST_UINT32_TYPE) {
      return 4;
    } else if (type == LIST_INT8_TYPE) {
      return 1;
    } else if (type == LIST_INT16_TYPE) {
      return 2;
    } else if (type == LIST_INT32_TYPE) {
      return 4;
    } else if (type == LIST_INT64_TYPE) {
      return 8;
    } else if (type == LIST_FLOAT32_TYPE) {
      return 4;
    } else if (type == LIST_FLOAT64_TYPE) {
      return 8;
    } else {
      throw new TsonError(
          404, "unknown.typed.data", "Unknown typed data $type");
    }
  }

  td.TypedData _readTypedData(int type) {
    final len = _readLength();
    final elementSize = _elementSizeFromType(type);
    var answer = new td.Uint8List(len * elementSize);
    answer.setRange(0, answer.length, _bytes, _byteOffset);
    _byteOffset += answer.length;

    if (type == LIST_UINT8_TYPE) {
      return answer;
    } else if (type == LIST_UINT16_TYPE) {
      return new td.Uint16List.view(answer.buffer);
    } else if (type == LIST_UINT32_TYPE) {
      return new td.Uint32List.view(answer.buffer);
    } else if (type == LIST_INT8_TYPE) {
      return new td.Int8List.view(answer.buffer);
    } else if (type == LIST_INT16_TYPE) {
      return new td.Int16List.view(answer.buffer);
    } else if (type == LIST_INT32_TYPE) {
      return new td.Int32List.view(answer.buffer);
    } else if (type == LIST_INT64_TYPE) {
      return new td.Int64List.view(answer.buffer);
    } else if (type == LIST_FLOAT32_TYPE) {
      return new td.Float32List.view(answer.buffer);
    } else if (type == LIST_FLOAT64_TYPE) {
      return new td.Float64List.view(answer.buffer);
    } else {
      throw new TsonError(404, "unknown.typed.data", "Unknown typed data");
    }
  }

  Object _readObject() {
    var type = _readObjectType();
    if (type == NULL_TYPE) {
      return null;
    } else if (type == MAP_TYPE) {
      return _readMap();
    } else if (type == STRING_TYPE) {
      return _readString();
    } else if (type == INTEGER_TYPE) {
      return _readInteger();
    } else if (type == DOUBLE_TYPE) {
      return _readDouble();
    } else if (type == BOOL_TYPE) {
      return _readBool();
    } else if (type == LIST_STRING_TYPE) {
      return _readCStringList();
    }  else if (type == LIST_TYPE) {
      return _readList();
    } else {
      return _readTypedData(type);
    }
  }
}
