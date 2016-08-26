dart_library.library('tson', null, /* Imports */[
  'dart_sdk'
], function load__tson(exports, dart_sdk) {
  'use strict';
  const core = dart_sdk.core;
  const js = dart_sdk.js;
  const typed_data = dart_sdk.typed_data;
  const _interceptors = dart_sdk._interceptors;
  const collection = dart_sdk.collection;
  const dart = dart_sdk.dart;
  const dartx = dart_sdk.dartx;
  const lib__tson = Object.create(null);
  let JSArrayOfJsObject = () => (JSArrayOfJsObject = dart.constFn(_interceptors.JSArray$(js.JsObject)))();
  let ListOfString = () => (ListOfString = dart.constFn(core.List$(core.String)))();
  let VoidToUint8List = () => (VoidToUint8List = dart.constFn(dart.definiteFunctionType(typed_data.Uint8List, [])))();
  let dynamicToUint8List = () => (dynamicToUint8List = dart.constFn(dart.definiteFunctionType(typed_data.Uint8List, [dart.dynamic])))();
  let Uint8List__ToObject = () => (Uint8List__ToObject = dart.constFn(dart.definiteFunctionType(core.Object, [typed_data.Uint8List], [core.int])))();
  let dynamicAnddynamicTovoid = () => (dynamicAnddynamicTovoid = dart.constFn(dart.definiteFunctionType(dart.void, [dart.dynamic, dart.dynamic])))();
  let dynamicTodynamic = () => (dynamicTodynamic = dart.constFn(dart.definiteFunctionType(dart.dynamic, [dart.dynamic])))();
  let dynamicTovoid = () => (dynamicTovoid = dart.constFn(dart.definiteFunctionType(dart.void, [dart.dynamic])))();
  let dynamicAndStringTodynamic = () => (dynamicAndStringTodynamic = dart.constFn(dart.definiteFunctionType(dart.dynamic, [dart.dynamic, core.String])))();
  let StringTovoid = () => (StringTovoid = dart.constFn(dart.definiteFunctionType(dart.void, [core.String])))();
  lib__tson.encodeJs = function() {
    let o = js.context.get('TSONObject2Encode');
    return new lib__tson._BinarySerializer.from(o).toBytes();
  };
  dart.fn(lib__tson.encodeJs, VoidToUint8List());
  lib__tson.encode = function(object) {
    return new lib__tson._BinarySerializer.from(object).toBytes();
  };
  dart.fn(lib__tson.encode, dynamicToUint8List());
  lib__tson.decode = function(bytes, offset) {
    if (offset === void 0) offset = null;
    return new lib__tson._BinarySerializer.fromBytes(bytes, offset).toObject();
  };
  dart.fn(lib__tson.decode, Uint8List__ToObject());
  const _data = Symbol('_data');
  lib__tson.TsonError = class TsonError extends core.Object {
    new(statusCode, error, reason) {
      this[_data] = null;
      this[_data] = dart.map({statusCode: statusCode, error: error, reason: reason});
    }
    get statusCode() {
      return core.int._check(this[_data][dartx.get]("statusCode"));
    }
    get error() {
      return core.String._check(this[_data][dartx.get]("error"));
    }
    get reason() {
      return core.String._check(this[_data][dartx.get]("reason"));
    }
    toString() {
      return dart.str`${this.runtimeType}(${this.statusCode}, "${this.error}", "${this.reason}")`;
    }
  };
  dart.setSignature(lib__tson.TsonError, {
    constructors: () => ({new: dart.definiteFunctionType(lib__tson.TsonError, [core.int, core.String, core.String])})
  });
  const _bytes = Symbol('_bytes');
  const _byteData = Symbol('_byteData');
  const _intByteOffset = Symbol('_intByteOffset');
  const _byteOffset = Symbol('_byteOffset');
  const _initializeFromObject = Symbol('_initializeFromObject');
  const _computeObjectSize = Symbol('_computeObjectSize');
  const _computeMapOrListSize = Symbol('_computeMapOrListSize');
  const _addString = Symbol('_addString');
  const _add = Symbol('_add');
  const _addType = Symbol('_addType');
  const _addLength = Symbol('_addLength');
  const _readObjectType = Symbol('_readObjectType');
  const _addInt = Symbol('_addInt');
  const _addDouble = Symbol('_addDouble');
  const _addBool = Symbol('_addBool');
  const _addTypedData = Symbol('_addTypedData');
  const _addList = Symbol('_addList');
  const _addMap = Symbol('_addMap');
  const _addCStringList = Symbol('_addCStringList');
  const _readObject = Symbol('_readObject');
  const _readLength = Symbol('_readLength');
  const _readMap = Symbol('_readMap');
  const _readString = Symbol('_readString');
  const _readInteger = Symbol('_readInteger');
  const _readDouble = Symbol('_readDouble');
  const _readBool = Symbol('_readBool');
  const _readList = Symbol('_readList');
  const _readCStringList = Symbol('_readCStringList');
  const _elementSizeFromType = Symbol('_elementSizeFromType');
  const _readTypedData = Symbol('_readTypedData');
  lib__tson._BinarySerializer = class _BinarySerializer extends core.Object {
    from(object) {
      this[_bytes] = null;
      this[_byteData] = null;
      this[_intByteOffset] = null;
      this[_byteOffset] = null;
      this[_initializeFromObject](object);
    }
    fromBytes(bytes, offset) {
      if (offset === void 0) offset = null;
      this[_bytes] = bytes;
      this[_byteData] = null;
      this[_intByteOffset] = null;
      this[_byteOffset] = null;
      this[_intByteOffset] = offset == null ? 0 : offset;
      this[_byteData] = typed_data.ByteData.view(this[_bytes][dartx.buffer]);
    }
    [_initializeFromObject](object) {
      this[_intByteOffset] = 0;
      let size = this[_computeObjectSize](lib__tson._BinarySerializer.VERSION);
      size = dart.notNull(size) + dart.notNull(this[_computeMapOrListSize](object));
      this[_bytes] = typed_data.Uint8List.new(size);
      this[_byteOffset] = this[_intByteOffset];
      this[_byteData] = typed_data.ByteData.view(this[_bytes][dartx.buffer]);
      this[_addString](lib__tson._BinarySerializer.VERSION);
      this[_add](object);
      this[_byteOffset] = this[_intByteOffset];
    }
    [_addType](type) {
      this[_byteData][dartx.setUint8](this[_byteOffset], type);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 1;
    }
    [_addLength](len) {
      this[_byteData][dartx.setUint32](this[_byteOffset], len, typed_data.Endianness.LITTLE_ENDIAN);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 4;
    }
    addNull() {
      this[_addType](lib__tson._BinarySerializer.NULL_TYPE);
    }
    [_readObjectType]() {
      let type = this[_byteData][dartx.getUint8](this[_byteOffset]);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 1;
      return type;
    }
    [_addString](object) {
      this[_addType](lib__tson._BinarySerializer.STRING_TYPE);
      let bytes = object[dartx.codeUnits];
      this[_bytes][dartx.setRange](this[_byteOffset], dart.notNull(this[_byteOffset]) + dart.notNull(bytes[dartx.length]), bytes);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + dart.notNull(bytes[dartx.length]);
      this[_byteData][dartx.setUint8](this[_byteOffset], 0);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 1;
    }
    [_addInt](object) {
      this[_addType](lib__tson._BinarySerializer.INTEGER_TYPE);
      this[_byteData][dartx.setInt32](this[_byteOffset], object, typed_data.Endianness.LITTLE_ENDIAN);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 4;
    }
    [_addDouble](object) {
      this[_addType](lib__tson._BinarySerializer.DOUBLE_TYPE);
      this[_byteData][dartx.setFloat64](this[_byteOffset], object, typed_data.Endianness.LITTLE_ENDIAN);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 8;
    }
    [_addBool](object) {
      this[_addType](lib__tson._BinarySerializer.BOOL_TYPE);
      this[_byteData][dartx.setUint8](this[_byteOffset], dart.test(object) ? 1 : 0);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 1;
    }
    [_addTypedData](object) {
      let len = null;
      if (typed_data.Uint8List.is(object)) {
        this[_addType](lib__tson._BinarySerializer.LIST_UINT8_TYPE);
        len = object[dartx.length];
      } else if (typed_data.Uint16List.is(object)) {
        this[_addType](lib__tson._BinarySerializer.LIST_UINT16_TYPE);
        len = object[dartx.length];
      } else if (typed_data.Uint32List.is(object)) {
        this[_addType](lib__tson._BinarySerializer.LIST_UINT32_TYPE);
        len = object[dartx.length];
      } else if (typed_data.Int8List.is(object)) {
        this[_addType](lib__tson._BinarySerializer.LIST_INT8_TYPE);
        len = object[dartx.length];
      } else if (typed_data.Int16List.is(object)) {
        this[_addType](lib__tson._BinarySerializer.LIST_INT16_TYPE);
        len = object[dartx.length];
      } else if (typed_data.Int32List.is(object)) {
        this[_addType](lib__tson._BinarySerializer.LIST_INT32_TYPE);
        len = object[dartx.length];
      } else if (typed_data.Int64List.is(object)) {
        this[_addType](lib__tson._BinarySerializer.LIST_INT64_TYPE);
        len = object.length;
      } else if (typed_data.Float32List.is(object)) {
        this[_addType](lib__tson._BinarySerializer.LIST_FLOAT32_TYPE);
        len = object[dartx.length];
      } else if (typed_data.Float64List.is(object)) {
        this[_addType](lib__tson._BinarySerializer.LIST_FLOAT64_TYPE);
        len = object[dartx.length];
      } else {
        dart.throw(new lib__tson.TsonError(404, "unknown.typed.data", "unknown typed data"));
      }
      this[_byteData][dartx.setUint32](this[_byteOffset], core.int._check(len), typed_data.Endianness.LITTLE_ENDIAN);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 4;
      let bytes = typed_data.Uint8List.view(object[dartx.buffer], object[dartx.offsetInBytes], core.int._check(dart.dsend(len, '*', object[dartx.elementSizeInBytes])));
      this[_bytes][dartx.setRange](this[_byteOffset], dart.notNull(this[_byteOffset]) + dart.notNull(bytes[dartx.length]), bytes);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + dart.notNull(bytes[dartx.length]);
    }
    [_addList](object) {
      this[_addType](lib__tson._BinarySerializer.LIST_TYPE);
      this[_addLength](object[dartx.length]);
      object[dartx.forEach](dart.bind(this, _add));
    }
    [_addMap](object) {
      this[_addType](lib__tson._BinarySerializer.MAP_TYPE);
      this[_addLength](object[dartx.length]);
      object[dartx.forEach](dart.fn((k, v) => {
        if (!(typeof k == 'string')) dart.throw(new lib__tson.TsonError(500, "wrong.map.key.format", "Map key must be a String"));
        this[_add](k);
        this[_add](v);
      }, dynamicAnddynamicTovoid()));
    }
    [_addCStringList](object) {
      this[_addType](lib__tson._BinarySerializer.LIST_STRING_TYPE);
      this[_addLength](object.lengthInBytes);
      this[_bytes][dartx.setRange](this[_byteOffset], dart.notNull(this[_byteOffset]) + dart.notNull(object.lengthInBytes), object.toBytes());
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + dart.notNull(object.lengthInBytes);
    }
    [_add](object) {
      if (object == null) {
        this.addNull();
      } else if (typeof object == 'string') {
        this[_addString](object);
      } else if (typeof object == 'number') {
        this[_addInt](object);
      } else if (typeof object == 'number') {
        this[_addDouble](object);
      } else if (typeof object == 'boolean') {
        this[_addBool](object);
      } else if (typed_data.TypedData.is(object)) {
        this[_addTypedData](object);
      } else if (lib__tson.CStringList.is(object)) {
        this[_addCStringList](object);
      } else if (core.List.is(object)) {
        this[_addList](object);
      } else if (core.Map.is(object)) {
        this[_addMap](object);
      } else {
        dart.throw(new lib__tson.TsonError(404, "unknown.value.type", dart.str`Unknow value type : ${object}`));
      }
    }
    [_computeMapOrListSize](object) {
      let size = lib__tson._BinarySerializer.TYPE_LENGTH_IN_BYTES + lib__tson._BinarySerializer.ELEMENT_LENGTH_IN_BYTES;
      if (core.Map.is(object)) {
        object[dartx.forEach](dart.fn((k, v) => {
          size = dart.notNull(size) + dart.notNull(this[_computeObjectSize](k));
          size = dart.notNull(size) + dart.notNull(this[_computeObjectSize](v));
        }, dynamicAnddynamicTovoid()));
      } else if (js.JsObject.is(object)) {
        let keys = dart.dsend(dart.dindex(js.context.get('Object'), 'keys'), 'apply', JSArrayOfJsObject().of([object]));
        dart.dsend(keys, 'forEach', dart.fn(k => {
          core.print(dart.str`k ${k} object[k] ${object.get(k)}`);
          size = dart.notNull(size) + dart.notNull(this[_computeObjectSize](k));
          size = dart.notNull(size) + dart.notNull(this[_computeObjectSize](object.get(k)));
        }, dynamicTodynamic()));
      } else if (lib__tson.CStringList.is(object)) {
        size = dart.notNull(size) + dart.notNull(object.lengthInBytes);
      } else if (typed_data.TypedData.is(object)) {
        size = dart.notNull(size) + dart.notNull(object[dartx.lengthInBytes]);
      } else if (core.List.is(object)) {
        object[dartx.forEach](dart.fn(v => {
          size = dart.notNull(size) + dart.notNull(this[_computeObjectSize](v));
        }, dynamicTovoid()));
      } else {
        dart.throw(new lib__tson.TsonError(404, "unknown.value.type", dart.str`Unknow value type 2: ${object}`));
      }
      return size;
    }
    [_computeObjectSize](object) {
      let sizeInBytes = lib__tson._BinarySerializer.TYPE_LENGTH_IN_BYTES;
      if (object == null) {
        sizeInBytes = dart.notNull(sizeInBytes) + 0;
      } else if (typeof object == 'string') {
        sizeInBytes = dart.notNull(sizeInBytes) + (dart.notNull(object[dartx.codeUnits][dartx.length]) + lib__tson._BinarySerializer.NULL_TERMINATED_LENGTH_IN_BYTES);
      } else if (typeof object == 'number') {
        sizeInBytes = dart.notNull(sizeInBytes) + 4;
      } else if (typeof object == 'number') {
        sizeInBytes = dart.notNull(sizeInBytes) + 8;
      } else if (typeof object == 'boolean') {
        sizeInBytes = dart.notNull(sizeInBytes) + 1;
      } else if (typed_data.TypedData.is(object)) {
        sizeInBytes = dart.notNull(sizeInBytes) + (dart.notNull(object[dartx.lengthInBytes]) + lib__tson._BinarySerializer.ELEMENT_LENGTH_IN_BYTES);
      } else if (lib__tson.CStringList.is(object) || core.List.is(object) || core.Map.is(object)) {
        sizeInBytes = dart.notNull(sizeInBytes) + dart.notNull(this[_computeMapOrListSize](object));
      } else {
        dart.throw(new lib__tson.TsonError(404, "unknown.value.type", dart.str`Unknow value type : ${object}`));
      }
      return sizeInBytes;
    }
    toBytes() {
      return this[_bytes];
    }
    toObject() {
      this[_byteOffset] = this[_intByteOffset];
      let version = this[_readObject]();
      if (!dart.equals(version, lib__tson._BinarySerializer.VERSION)) dart.throw(new lib__tson.TsonError(500, "version.mismatch", dart.str`TSON version mismatch, found : ${version} , expected : ${lib__tson._BinarySerializer.VERSION}`));
      return this[_readObject]();
    }
    [_readMap]() {
      let len = this[_readLength]();
      let answer = core.Map.new();
      for (let i = 0; i < dart.notNull(len); i++) {
        let key = this[_readObject]();
        if (!(typeof key == 'string')) dart.throw(new lib__tson.TsonError(500, "wrong.map.key.format", "Map key must be a String"));
        answer[dartx.set](key, this[_readObject]());
      }
      return answer;
    }
    [_readString]() {
      let start = this[_byteOffset];
      while (this[_byteData][dartx.getUint8](this[_byteOffset]) != 0) {
        this[_byteOffset] = dart.notNull(this[_byteOffset]) + 1;
      }
      let answer = core.String.fromCharCodes(this[_bytes], start, this[_byteOffset]);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 1;
      return answer;
    }
    [_readInteger]() {
      let answer = this[_byteData][dartx.getInt32](this[_byteOffset], typed_data.Endianness.LITTLE_ENDIAN);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 4;
      return answer;
    }
    [_readDouble]() {
      let answer = this[_byteData][dartx.getFloat64](this[_byteOffset], typed_data.Endianness.LITTLE_ENDIAN);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 8;
      return answer;
    }
    [_readBool]() {
      let answer = this[_byteData][dartx.getUint8](this[_byteOffset]);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 1;
      return dart.notNull(answer) > 0;
    }
    [_readList]() {
      let len = this[_readLength]();
      let answer = core.List.new(len);
      for (let i = 0; i < dart.notNull(len); i++) {
        answer[dartx.set](i, this[_readObject]());
      }
      return answer;
    }
    [_readLength]() {
      let len = this[_byteData][dartx.getUint32](this[_byteOffset], typed_data.Endianness.LITTLE_ENDIAN);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + 4;
      return len;
    }
    [_readCStringList]() {
      let lengthInBytes = this[_readLength]();
      let answer = new lib__tson.CStringList.fromBytes(typed_data.Uint8List._check(this[_bytes][dartx.sublist](this[_byteOffset], dart.notNull(this[_byteOffset]) + dart.notNull(lengthInBytes))));
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + dart.notNull(lengthInBytes);
      return answer;
    }
    [_elementSizeFromType](type) {
      if (type == lib__tson._BinarySerializer.LIST_UINT8_TYPE) {
        return 1;
      } else if (type == lib__tson._BinarySerializer.LIST_UINT16_TYPE) {
        return 2;
      } else if (type == lib__tson._BinarySerializer.LIST_UINT32_TYPE) {
        return 4;
      } else if (type == lib__tson._BinarySerializer.LIST_INT8_TYPE) {
        return 1;
      } else if (type == lib__tson._BinarySerializer.LIST_INT16_TYPE) {
        return 2;
      } else if (type == lib__tson._BinarySerializer.LIST_INT32_TYPE) {
        return 4;
      } else if (type == lib__tson._BinarySerializer.LIST_INT64_TYPE) {
        return 8;
      } else if (type == lib__tson._BinarySerializer.LIST_FLOAT32_TYPE) {
        return 4;
      } else if (type == lib__tson._BinarySerializer.LIST_FLOAT64_TYPE) {
        return 8;
      } else {
        dart.throw(new lib__tson.TsonError(404, "unknown.typed.data", dart.str`Unknown typed data ${type}`));
      }
    }
    [_readTypedData](type) {
      let len = this[_readLength]();
      let elementSize = this[_elementSizeFromType](type);
      let answer = typed_data.Uint8List.new(dart.notNull(len) * dart.notNull(elementSize));
      answer[dartx.setRange](0, answer[dartx.length], this[_bytes], this[_byteOffset]);
      this[_byteOffset] = dart.notNull(this[_byteOffset]) + dart.notNull(answer[dartx.length]);
      if (type == lib__tson._BinarySerializer.LIST_UINT8_TYPE) {
        return answer;
      } else if (type == lib__tson._BinarySerializer.LIST_UINT16_TYPE) {
        return typed_data.Uint16List.view(answer[dartx.buffer]);
      } else if (type == lib__tson._BinarySerializer.LIST_UINT32_TYPE) {
        return typed_data.Uint32List.view(answer[dartx.buffer]);
      } else if (type == lib__tson._BinarySerializer.LIST_INT8_TYPE) {
        return typed_data.Int8List.view(answer[dartx.buffer]);
      } else if (type == lib__tson._BinarySerializer.LIST_INT16_TYPE) {
        return typed_data.Int16List.view(answer[dartx.buffer]);
      } else if (type == lib__tson._BinarySerializer.LIST_INT32_TYPE) {
        return typed_data.Int32List.view(answer[dartx.buffer]);
      } else if (type == lib__tson._BinarySerializer.LIST_INT64_TYPE) {
        return typed_data.Int64List.view(answer[dartx.buffer]);
      } else if (type == lib__tson._BinarySerializer.LIST_FLOAT32_TYPE) {
        return typed_data.Float32List.view(answer[dartx.buffer]);
      } else if (type == lib__tson._BinarySerializer.LIST_FLOAT64_TYPE) {
        return typed_data.Float64List.view(answer[dartx.buffer]);
      } else {
        dart.throw(new lib__tson.TsonError(404, "unknown.typed.data", "Unknown typed data"));
      }
    }
    [_readObject]() {
      let type = this[_readObjectType]();
      if (type == lib__tson._BinarySerializer.NULL_TYPE) {
        return null;
      } else if (type == lib__tson._BinarySerializer.MAP_TYPE) {
        return this[_readMap]();
      } else if (type == lib__tson._BinarySerializer.STRING_TYPE) {
        return this[_readString]();
      } else if (type == lib__tson._BinarySerializer.INTEGER_TYPE) {
        return this[_readInteger]();
      } else if (type == lib__tson._BinarySerializer.DOUBLE_TYPE) {
        return this[_readDouble]();
      } else if (type == lib__tson._BinarySerializer.BOOL_TYPE) {
        return this[_readBool]();
      } else if (type == lib__tson._BinarySerializer.LIST_STRING_TYPE) {
        return this[_readCStringList]();
      } else if (type == lib__tson._BinarySerializer.LIST_TYPE) {
        return this[_readList]();
      } else {
        return this[_readTypedData](type);
      }
    }
  };
  dart.defineNamedConstructor(lib__tson._BinarySerializer, 'from');
  dart.defineNamedConstructor(lib__tson._BinarySerializer, 'fromBytes');
  dart.setSignature(lib__tson._BinarySerializer, {
    constructors: () => ({
      from: dart.definiteFunctionType(lib__tson._BinarySerializer, [dart.dynamic]),
      fromBytes: dart.definiteFunctionType(lib__tson._BinarySerializer, [typed_data.Uint8List], [core.int])
    }),
    methods: () => ({
      [_initializeFromObject]: dart.definiteFunctionType(dart.void, [dart.dynamic]),
      [_addType]: dart.definiteFunctionType(dart.dynamic, [core.int]),
      [_addLength]: dart.definiteFunctionType(dart.dynamic, [core.int]),
      addNull: dart.definiteFunctionType(dart.dynamic, []),
      [_readObjectType]: dart.definiteFunctionType(core.int, []),
      [_addString]: dart.definiteFunctionType(dart.dynamic, [core.String]),
      [_addInt]: dart.definiteFunctionType(dart.dynamic, [core.int]),
      [_addDouble]: dart.definiteFunctionType(dart.dynamic, [core.double]),
      [_addBool]: dart.definiteFunctionType(dart.dynamic, [core.bool]),
      [_addTypedData]: dart.definiteFunctionType(dart.dynamic, [typed_data.TypedData]),
      [_addList]: dart.definiteFunctionType(dart.dynamic, [core.List]),
      [_addMap]: dart.definiteFunctionType(dart.dynamic, [core.Map]),
      [_addCStringList]: dart.definiteFunctionType(dart.dynamic, [lib__tson.CStringList]),
      [_add]: dart.definiteFunctionType(dart.void, [dart.dynamic]),
      [_computeMapOrListSize]: dart.definiteFunctionType(core.int, [dart.dynamic]),
      [_computeObjectSize]: dart.definiteFunctionType(core.int, [dart.dynamic]),
      toBytes: dart.definiteFunctionType(typed_data.Uint8List, []),
      toObject: dart.definiteFunctionType(core.Object, []),
      [_readMap]: dart.definiteFunctionType(core.Map, []),
      [_readString]: dart.definiteFunctionType(core.String, []),
      [_readInteger]: dart.definiteFunctionType(core.int, []),
      [_readDouble]: dart.definiteFunctionType(core.double, []),
      [_readBool]: dart.definiteFunctionType(core.bool, []),
      [_readList]: dart.definiteFunctionType(core.List, []),
      [_readLength]: dart.definiteFunctionType(core.int, []),
      [_readCStringList]: dart.definiteFunctionType(lib__tson.CStringList, []),
      [_elementSizeFromType]: dart.definiteFunctionType(core.int, [core.int]),
      [_readTypedData]: dart.definiteFunctionType(typed_data.TypedData, [core.int]),
      [_readObject]: dart.definiteFunctionType(core.Object, [])
    })
  });
  lib__tson._BinarySerializer.VERSION = "1.1.0";
  lib__tson._BinarySerializer.TYPE_LENGTH_IN_BYTES = 1;
  lib__tson._BinarySerializer.NULL_TERMINATED_LENGTH_IN_BYTES = 1;
  lib__tson._BinarySerializer.ELEMENT_LENGTH_IN_BYTES = 4;
  lib__tson._BinarySerializer.NULL_TYPE = 0;
  lib__tson._BinarySerializer.STRING_TYPE = 1;
  lib__tson._BinarySerializer.INTEGER_TYPE = 2;
  lib__tson._BinarySerializer.DOUBLE_TYPE = 3;
  lib__tson._BinarySerializer.BOOL_TYPE = 4;
  lib__tson._BinarySerializer.LIST_TYPE = 10;
  lib__tson._BinarySerializer.MAP_TYPE = 11;
  lib__tson._BinarySerializer.LIST_UINT8_TYPE = 100;
  lib__tson._BinarySerializer.LIST_UINT16_TYPE = 101;
  lib__tson._BinarySerializer.LIST_UINT32_TYPE = 102;
  lib__tson._BinarySerializer.LIST_INT8_TYPE = 103;
  lib__tson._BinarySerializer.LIST_INT16_TYPE = 104;
  lib__tson._BinarySerializer.LIST_INT32_TYPE = 105;
  lib__tson._BinarySerializer.LIST_INT64_TYPE = 106;
  lib__tson._BinarySerializer.LIST_FLOAT32_TYPE = 110;
  lib__tson._BinarySerializer.LIST_FLOAT64_TYPE = 111;
  lib__tson._BinarySerializer.LIST_STRING_TYPE = 112;
  const _starts = Symbol('_starts');
  const _buildStarts = Symbol('_buildStarts');
  lib__tson.CStringList = class CStringList extends collection.ListBase$(core.String) {
    fromBytes(bytes) {
      this[_bytes] = bytes;
      this[_starts] = null;
    }
    fromList(list) {
      this[_bytes] = null;
      this[_starts] = null;
      let lengthInBytes = list[dartx.fold](dart.dynamic)(0, dart.fn((len, str) => {
        if (str == null) dart.throw(core.Exception.new("Null values are not allowed."));
        return dart.dsend(dart.dsend(len, '+', str[dartx.codeUnits][dartx.length]), '+', 1);
      }, dynamicAndStringTodynamic()));
      this[_bytes] = typed_data.Uint8List.new(core.int._check(lengthInBytes));
      let offset = 0;
      list[dartx.forEach](dart.fn(str => {
        let bytes = str[dartx.codeUnits];
        this[_bytes][dartx.setRange](offset, offset + dart.notNull(bytes[dartx.length]), bytes);
        offset = offset + (dart.notNull(bytes[dartx.length]) + 1);
      }, StringTovoid()));
    }
    toBytes() {
      return this[_bytes];
    }
    get lengthInBytes() {
      return this[_bytes][dartx.length];
    }
    [_buildStarts]() {
      let len = 0;
      for (let i = 0; i < dart.notNull(this[_bytes][dartx.length]); i++) {
        if (this[_bytes][dartx.get](i) == 0) len++;
      }
      this[_starts] = typed_data.Uint32List.new(len + 1);
      this[_starts][dartx.set](0, 0);
      let offset = 0;
      for (let i = 0; i < len; i++) {
        let start = offset;
        while (this[_bytes][dartx.get](offset) != 0)
          offset++;
        offset = offset + 1;
        this[_starts][dartx.set](i + 1, dart.notNull(this[_starts][dartx.get](i)) + (offset - start));
      }
      return this[_starts];
    }
    get starts() {
      return this[_starts] == null ? this[_buildStarts]() : this[_starts];
    }
    get length() {
      return dart.notNull(this.starts[dartx.length]) - 1;
    }
    set length(newLength) {
      return dart.throw("list is read only");
    }
    get(i) {
      let start = this.starts[dartx.get](i);
      let end = this.starts[dartx.get](dart.notNull(i) + 1);
      return core.String.fromCharCodes(this[_bytes], start, dart.notNull(end) - 1);
    }
    set(i, value) {
      (() => {
        return dart.throw("list is read only");
      })();
      return value;
    }
  };
  dart.addSimpleTypeTests(lib__tson.CStringList);
  dart.defineNamedConstructor(lib__tson.CStringList, 'fromBytes');
  dart.defineNamedConstructor(lib__tson.CStringList, 'fromList');
  lib__tson.CStringList[dart.implements] = () => [ListOfString()];
  dart.setSignature(lib__tson.CStringList, {
    constructors: () => ({
      fromBytes: dart.definiteFunctionType(lib__tson.CStringList, [typed_data.Uint8List]),
      fromList: dart.definiteFunctionType(lib__tson.CStringList, [core.List$(core.String)])
    }),
    methods: () => ({
      toBytes: dart.definiteFunctionType(typed_data.Uint8List, []),
      [_buildStarts]: dart.definiteFunctionType(typed_data.Uint32List, []),
      get: dart.definiteFunctionType(core.String, [core.int]),
      set: dart.definiteFunctionType(dart.void, [core.int, core.String])
    })
  });
  dart.defineExtensionMembers(lib__tson.CStringList, ['get', 'set', 'length', 'length']);
  // Exports:
  exports.lib__tson = lib__tson;
});

//# sourceMappingURL=tson.js.map
