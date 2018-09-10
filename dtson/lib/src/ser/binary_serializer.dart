part of tson;

class _BinarySerializer {

  td.Uint8List _bytes;
  td.ByteData _byteData;
  int _intByteOffset;
  int _byteOffset;
  

  _BinarySerializer.from(object) {
    
    _initializeFromObject(object);
  }

  _BinarySerializer.fromBytes(this._bytes, [int offset]) {
    _intByteOffset = offset == null ? 0 : offset;
    _byteData = new td.ByteData.view(_bytes.buffer, _bytes.offsetInBytes);
  }

  void _initializeFromObject(object) {
    _intByteOffset = 0;
    var size = 0;
    size = _computeObjectSize(TsonSpec.VERSION);
    size += _computeMapOrListSize(object);

    _bytes = new td.Uint8List(size);
    _byteOffset = _intByteOffset;
    _byteData = new td.ByteData.view(_bytes.buffer, _bytes.offsetInBytes);
    _addString(TsonSpec.VERSION);
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
    _addType(TsonSpec.NULL_TYPE);
  }

  int _readObjectType() {
    var type = _byteData.getUint8(_byteOffset);
    _byteOffset++;
    return type;
  }

  //Null terminated string
  _addString(String object) {
    _addType(TsonSpec.STRING_TYPE);
    var bytes = UTF8.encode(object);
    _bytes.setRange(_byteOffset, _byteOffset + bytes.length, bytes);
    _byteOffset += bytes.length;
    _byteData.setUint8(_byteOffset, 0);
    _byteOffset++;
  }

  _addInt(int object) {
    _addType(TsonSpec.INTEGER_TYPE);
    _byteData.setInt32(_byteOffset, object, td.Endianness.LITTLE_ENDIAN);
    _byteOffset += 4;
  }

  _addDouble(double object) {
    _addType(TsonSpec.DOUBLE_TYPE);
    _byteData.setFloat64(_byteOffset, object, td.Endianness.LITTLE_ENDIAN);
    _byteOffset += 8;
  }

  _addBool(bool object) {
    _addType(TsonSpec.BOOL_TYPE);
    _byteData.setUint8(_byteOffset, object ? 1 : 0);
    _byteOffset += 1;
  }

  _addTypedData(td.TypedData object) {
    var len;
    if (object is td.Uint8List) {
      _addType(TsonSpec.LIST_UINT8_TYPE);
      len = object.length;
    } else if (object is td.Uint16List) {
      _addType(TsonSpec.LIST_UINT16_TYPE);
      len = object.length;
    } else if (object is td.Uint32List) {
      _addType(TsonSpec.LIST_UINT32_TYPE);
      len = object.length;
    } else if (object is td.Int8List) {
      _addType(TsonSpec.LIST_INT8_TYPE);
      len = object.length;
    } else if (object is td.Int16List) {
      _addType(TsonSpec.LIST_INT16_TYPE);
      len = object.length;
    } else if (object is td.Int32List) {
      _addType(TsonSpec.LIST_INT32_TYPE);
      len = object.length;
    } else if (object is td.Int64List) {
      _addType(TsonSpec.LIST_INT64_TYPE);
      len = object.length;
    } else if (object is td.Float32List) {
      _addType(TsonSpec.LIST_FLOAT32_TYPE);
      len = object.length;
    } else if (object is td.Float64List) {
      _addType(TsonSpec.LIST_FLOAT64_TYPE);
      len = object.length;
    } else if (object is td.Uint64List) {
      _addType(TsonSpec.LIST_UINT64_TYPE);
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
    _addType(TsonSpec.LIST_TYPE);
    _addLength(object.length);
    object.forEach(_add);
  }

  _addMap(Map object) {
    _addType(TsonSpec.MAP_TYPE);
    _addLength(object.length);
    object.forEach((k, v) {
      if (k is! String) throw new TsonError(
          500, "wrong.map.key.format", "Map key must be a String");
      _add(k);
      _add(v);
    });
  }

  _addCStringList(CStringList object) {
    _addType(TsonSpec.LIST_STRING_TYPE);
    _addLength(object.lengthInBytes);
    _bytes.setRange(
        _byteOffset, _byteOffset + object.lengthInBytes, object.toBytes());
    _byteOffset += object.lengthInBytes;
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
    } else if (object is CStringList) {
      _addCStringList(object);
    } else if (object is List) {
      _addList(object);
    } else if (object is Map) {
      _addMap(object);
    } else {
      _add(object.toJson());
//      throw new TsonError(404, "unknown.value.type",
//          "Unknow value type : ${object}");
    }
  }

  int _computeMapOrListSize(object) {
    var size = TsonSpec.TYPE_LENGTH_IN_BYTES + TsonSpec.ELEMENT_LENGTH_IN_BYTES;
    if (object is Map) {
      object.forEach((k, v) {
        size += _computeObjectSize(k);
        size += _computeObjectSize(v);
      });
    }
    else if (object is CStringList) {
      size += object.lengthInBytes;
    } else if (object is td.TypedData) {
      size += object.lengthInBytes;
    } else if (object is List) {
      object.forEach((v) {
        size += _computeObjectSize(v);
      });
    } else {
      throw new TsonError(404, "unknown.value.type",
          "Unknow value type 2: ${object}");
    }

    return size;
  }

  int _computeObjectSize(object) {
    var sizeInBytes = TsonSpec.TYPE_LENGTH_IN_BYTES;
    if (object == null) {
      sizeInBytes += 0;
    } else if (object is String) {
      var bytes = UTF8.encode(object);
      sizeInBytes += bytes.length + TsonSpec.NULL_TERMINATED_LENGTH_IN_BYTES;
    } else if (object is int) {
      sizeInBytes += 4;
    } else if (object is double) {
      sizeInBytes += 8;
    } else if (object is bool) {
      sizeInBytes += 1;
    } else if (object is td.TypedData) {
      sizeInBytes += object.lengthInBytes + TsonSpec.ELEMENT_LENGTH_IN_BYTES;
    } else if (object is CStringList || object is List || object is Map) {
      sizeInBytes += _computeMapOrListSize(object);
    } else {
      return _computeObjectSize(object.toJson());
//      throw new TsonError(404, "unknown.value.type",
//          "Unknow value type : ${object}");
    }
    return sizeInBytes;
  }

  td.Uint8List toBytes() => _bytes;

  Object toObject() {
    _byteOffset = _intByteOffset;
    var version = _readObject();
    if (version != TsonSpec.VERSION) throw new TsonError(500, "version.mismatch",
        "TSON version mismatch, found : $version , expected : ${TsonSpec.VERSION}");
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
    var answer = UTF8.decode(new td.Uint8List.view(_bytes.buffer,
        _bytes.offsetInBytes +start,  _byteOffset - start));
    //new String.fromCharCodes(_bytes, start, _byteOffset);
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

  int _readLength() {
    final len = _byteData.getUint32(_byteOffset, td.Endianness.LITTLE_ENDIAN);
    _byteOffset += 4;
    return len;
  }

  CStringList _readCStringList() {
    var lengthInBytes = _readLength();
    var answer = new CStringList.fromBytes(
        _bytes.sublist(_byteOffset, _byteOffset + lengthInBytes));
    _byteOffset += lengthInBytes;
    return answer;
  }

  int _elementSizeFromType(int type) {
    if (type == TsonSpec.LIST_UINT8_TYPE) {
      return 1;
    } else if (type == TsonSpec.LIST_UINT16_TYPE) {
      return 2;
    } else if (type == TsonSpec.LIST_UINT32_TYPE) {
      return 4;
    } else if (type == TsonSpec.LIST_INT8_TYPE) {
      return 1;
    } else if (type == TsonSpec.LIST_INT16_TYPE) {
      return 2;
    } else if (type == TsonSpec.LIST_INT32_TYPE) {
      return 4;
    } else if (type == TsonSpec.LIST_INT64_TYPE) {
      return 8;
    } else if (type == TsonSpec.LIST_FLOAT32_TYPE) {
      return 4;
    } else if (type == TsonSpec.LIST_FLOAT64_TYPE) {
      return 8;
    } else if (type == TsonSpec.LIST_UINT64_TYPE) {
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

    if (type == TsonSpec.LIST_UINT8_TYPE) {
      return answer;
    } else if (type == TsonSpec.LIST_UINT16_TYPE) {
      return new td.Uint16List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_UINT32_TYPE) {
      return new td.Uint32List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_INT8_TYPE) {
      return new td.Int8List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_INT16_TYPE) {
      return new td.Int16List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_INT32_TYPE) {
      return new td.Int32List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_INT64_TYPE) {
      return new td.Int64List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_FLOAT32_TYPE) {
      return new td.Float32List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_FLOAT64_TYPE) {
      return new td.Float64List.view(answer.buffer, answer.offsetInBytes, len);
    } else if (type == TsonSpec.LIST_UINT64_TYPE) {
      return new td.Uint64List.view(answer.buffer, answer.offsetInBytes, len);
    } else {
      throw new TsonError(404, "unknown.typed.data", "Unknown typed data");
    }
  }

  Object _readObject() {
    var type = _readObjectType();
    if (type == TsonSpec.NULL_TYPE) {
      return null;
    } else if (type == TsonSpec.MAP_TYPE) {
      return _readMap();
    } else if (type == TsonSpec.STRING_TYPE) {
      return _readString();
    } else if (type == TsonSpec.INTEGER_TYPE) {
      return _readInteger();
    } else if (type == TsonSpec.DOUBLE_TYPE) {
      return _readDouble();
    } else if (type == TsonSpec.BOOL_TYPE) {
      return _readBool();
    } else if (type == TsonSpec.LIST_STRING_TYPE) {
      return _readCStringList();
    } else if (type == TsonSpec.LIST_TYPE) {
      return _readList();
    } else {
      return _readTypedData(type);
    }
  }
}