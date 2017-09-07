part of tson;

class TypedTsonStreamProvider {
  final int type;
  final int length;
  final Stream<List<int>> stream;

  TypedTsonStreamProvider(this.type, this.length, this.stream);
}

class _StreamSerializer {
  Object _currentObject;

  StreamController<List<int>> controller;

  td.Uint8List _byte4Buffer;
  td.ByteData _byte4DataBuffer;

  td.Uint8List _byte8Buffer;
  td.ByteData _byte8DataBuffer;

  _StreamSerializer.from(object) {
    _byte4Buffer = new td.Uint8List(4);
    _byte4DataBuffer = new td.ByteData.view(_byte4Buffer.buffer);

    _byte8Buffer = new td.Uint8List(8);
    _byte8DataBuffer = new td.ByteData.view(_byte8Buffer.buffer);

    _currentObject = object;

    controller = new StreamController(
        onListen: _onListen, onResume: _onResume, onCancel: _onCancel);
  }

  _onListen() {
    _addString(TsonSpec.VERSION);
    _start();
  }

  _start() async {
    await _add(_currentObject);
    controller.close();
  }

  _onResume() {
//    _add(_currentObject);
  }

  _onCancel() {
    _currentObject = null;
    _byte4Buffer = null;
    _byte4DataBuffer = null;
    _byte8Buffer = null;
    _byte8DataBuffer = null;
  }

  _addController(List<int> bytes) {
    controller.add(new td.Uint8List.fromList(bytes));
  }

  _addType(int type) {
    _addController([type]);
  }

  _addLength(int len) {
    _byte4DataBuffer.setUint32(0, len, td.Endianness.LITTLE_ENDIAN);
    _addController(_byte4Buffer);
  }

  addNull() {
    _addType(TsonSpec.NULL_TYPE);
  }

  //Null terminated string
  _addString(String object) {
    _addType(TsonSpec.STRING_TYPE);
    _addController(object.codeUnits);
    _addController([0]);
  }

  _addInt(int object) {
    _addType(TsonSpec.INTEGER_TYPE);
    _byte4DataBuffer.setInt32(0, object, td.Endianness.LITTLE_ENDIAN);
    _addController(_byte4Buffer);
  }

  _addDouble(double object) {
    _addType(TsonSpec.DOUBLE_TYPE);
    _byte8DataBuffer.setFloat64(0, object, td.Endianness.LITTLE_ENDIAN);
    _addController(_byte8Buffer);
  }

  _addBool(bool object) {
    _addType(TsonSpec.BOOL_TYPE);
    _addController([object ? 1 : 0]);
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

    _addLength(len);

    var bytes = new td.Uint8List.view(
        object.buffer, object.offsetInBytes, len * object.elementSizeInBytes);

    _addController(bytes);
  }

  _addList(List object) async {
    _addType(TsonSpec.LIST_TYPE);
    _addLength(object.length);

    for (var o in object) {
      await _add(o);
    }
  }

  _addMap(Map object) async {
    _addType(TsonSpec.MAP_TYPE);
    _addLength(object.length);
    for (var k in object.keys) {
      if (k is! String)
        throw new TsonError(
            500, "wrong.map.key.format", "Map key must be a String");
      _add(k);

      await _add(object[k]);
    }
  }

  _addCStringList(CStringList object) {
    _addType(TsonSpec.LIST_STRING_TYPE);
    _addLength(object.lengthInBytes);
    _addController(object.toBytes());
  }

  Future _addStream(TypedTsonStreamProvider streamProvider) {
    _addType(streamProvider.type);
    _addLength(streamProvider.length);
    return controller.addStream(streamProvider.stream);
  }

  Future _add(object) async {
    if (controller.isClosed) return;

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
      await _addList(object);
    } else if (object is Map) {
      await _addMap(object);
    } else if (object is TypedTsonStreamProvider) {
      await _addStream(object);
    } else {
      throw new TsonError(
          404, "unknown.value.type", "Unknow value type : ${object}");
    }
  }

}
