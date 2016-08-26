console.log("TSON");

VERSION = "1.1.0";
TYPE_LENGTH_IN_BYTES = 1;
NULL_TERMINATED_LENGTH_IN_BYTES = 1;
ELEMENT_LENGTH_IN_BYTES = 4;

NULL_TYPE = 0;
STRING_TYPE = 1;
INTEGER_TYPE = 2;
DOUBLE_TYPE = 3;
BOOL_TYPE = 4;

LIST_TYPE = 10;
MAP_TYPE = 11;

LIST_UINT8_TYPE = 100;
LIST_UINT16_TYPE = 101;
LIST_UINT32_TYPE = 102;

LIST_INT8_TYPE = 103;
LIST_INT16_TYPE = 104;
LIST_INT32_TYPE = 105;
LIST_INT64_TYPE = 106;

LIST_FLOAT32_TYPE = 110;
LIST_FLOAT64_TYPE = 111;

LIST_STRING_TYPE = 112;


function TSONSerializer (object){
    this.object = object;
    this.bytes = null;
    this.view = null;
}

TSONSerializer.prototype.addType = function(type){
    console.log("addType type " + type + " offset ", this.offset);
    this.bytes[this.offset] = type;
    this.offset++;
}

TSONSerializer.prototype.addUint8Array = function(object){
    this.addType(LIST_UINT8_TYPE);
    var len = object.length;
    for (var i = 0 ; i < len ; i++){
        this.view.setUint8(this.offset, object[i]);
        this.offset += 1;
    }
}

TSONSerializer.prototype.addUint16Array = function(object){
    this.addType(LIST_UINT16_TYPE);
    var len = object.length;
    for (var i = 0 ; i < len ; i++){
        this.view.setUint16(this.offset, object[i], true);
        this.offset += 2;
    }
}

TSONSerializer.prototype.addUint32Array = function(object){
    this.addType(LIST_UINT32_TYPE);
    var len = object.length;
    for (var i = 0 ; i < len ; i++){
        this.view.setUint32(this.offset, object[i], true);
        this.offset += 4;
    }
}

TSONSerializer.prototype.addInt8Array = function(object){
    this.addType(LIST_INT8_TYPE);
    var len = object.length;
    for (var i = 0 ; i < len ; i++){
        this.view.setInt8(this.offset, object[i]);
        this.offset += 1;
    }
}

TSONSerializer.prototype.addInt16Array = function(object){
    this.addType(LIST_INT16_TYPE);
    var len = object.length;
    for (var i = 0 ; i < len ; i++){
        this.view.setInt16(this.offset, object[i], true);
        this.offset += 2;
    }
}

TSONSerializer.prototype.addInt32Array = function(object){
    this.addType(LIST_INT32_TYPE);
    var len = object.length;
    for (var i = 0 ; i < len ; i++){
        this.view.setInt32(this.offset, object[i], true);
        this.offset += 4;
    }
}

TSONSerializer.prototype.addFloat32Array = function(object){
    this.addType(LIST_FLOAT32_TYPE);
    var len = object.length;
    for (var i = 0 ; i < len ; i++){
        this.view.setFloat32(this.offset, object[i], true);
        this.offset += 4;
    }
}

TSONSerializer.prototype.addFloat64Array = function(object){
    this.addType(LIST_FLOAT64_TYPE);
    var len = object.length;
    for (var i = 0 ; i < len ; i++){
        this.view.setFloat64(this.offset, object[i], true);
        this.offset += 8;
    }
}

TSONSerializer.prototype.addString= function(object){
    console.log("addString object " + object + " offset ", this.offset);

    this.addType(STRING_TYPE);
    for (var i = 0 ; i<object.length;i++){
        this.bytes[this.offset] = object.charCodeAt(i);
        this.offset++;
    }
    this.bytes[this.offset] = 0;
    this.offset++;
}

TSONSerializer.prototype.addNumber = function(object){
    console.log("addNumber object " + object + " offset ", this.offset );
    this.addType(DOUBLE_TYPE);
    this.view.setFloat64(this.offset, object, true);
    this.offset += 8;
}

TSONSerializer.prototype.addBool = function(object){
    this.addType(BOOL_TYPE);
    if (object){
        this.bytes[this.offset] = 1;
    } else {
        this.bytes[this.offset] = 0;
    }
    this.offset += 1;
}

TSONSerializer.prototype.addLength  = function(object){
    console.log("addLength object " + object + " offset ", this.offset + " bytes " + this.bytes);
    this.view.setUint32(this.offset, object, true);
    this.offset += 4;
}

TSONSerializer.prototype.addMap = function(object){
    console.log("addMap object " + object + " offset ", this.offset + " bytes " + this.bytes);

    this.addType(MAP_TYPE);
    var keys = Object.keys(object);
    this.addLength(keys.length);
    for (var i = 0; i < keys.length; i += 1) {
        var key = keys[i];
        if (typeof key === 'string'){
            this.addString(key);
        } else {
            throw "Map key must be string";
        }
        this.addObject(object[key]);
    }
}

TSONSerializer.prototype.addList = function(object){

    this.addType(LIST_TYPE);
    this.addLength(object.length);
    for (var i = 0; i < object.length; i += 1) {
        this.addObject(object[i]);
    }
}

TSONSerializer.prototype.addRootObject = function(object){
    this.addObject(VERSION);
    this.addObject(object);
}

TSONSerializer.prototype.serialize = function(object){
    var sizeInBytes = this.computeSizeInBytes(VERSION);
    sizeInBytes = sizeInBytes + this.computeSizeInBytes(object)
    console.log("sizeInBytes " + sizeInBytes);
    this.bytes = new Uint8Array(sizeInBytes);
    this.view = new DataView(this.bytes.buffer);
    this.offset = 0;
    this.addRootObject(object);
    return this.bytes;
}



TSONSerializer.prototype.addObject = function(object){
    console.log("addObject object " + object + " offset ", this.offset + " bytes " + bytes);

    if (typeof object === 'undefined'){
        this.addType(NULL_TYPE);
    } else if (typeof object === 'string'){
        this.addString(object);
    } else if (typeof object === 'number'){
        this.addNumber(object);
    } else if (typeof object === 'boolean'){
        this.addBool(object);
    } else if (typeof object === 'object'){
        var objectType = Object.prototype.toString.apply(object);
        if (objectType === '[object Array]') this.addList(object);
        else if (objectType === '[object Uint8Array]') this.addUint8Array(object);
        else if (objectType === '[object Uint16Array]') this.addUint16Array(object);
        else if (objectType === '[object Uint32Array]') this.addUint32Array(object);
        else if (objectType === '[object Int8Array]') this.addInt8Array(object);
        else if (objectType === '[object Int16Array]') this.addInt16Array(object);
        else if (objectType === '[object Int32Array]') this.addInt32Array(object);
        else if (objectType === '[object Float32Array]') this.addFloat32Array(object);
        else if (objectType === '[object Float64Array]') this.addFloat64Array(object);
        else this.addMap(object);
    }
}

TSONSerializer.prototype.computeSizeInBytes = function(object){
    console.log("computeSizeInBytes " + object);
    var sizeInBytes = TYPE_LENGTH_IN_BYTES;
    if (typeof object === 'undefined'){
        console.log("computeSizeInBytes undefined " + object);
    } else if (typeof object === 'string'){
        sizeInBytes += object.length + NULL_TERMINATED_LENGTH_IN_BYTES;
        console.log("computeSizeInBytes string " + object);
     } else if (typeof object === 'number'){
        sizeInBytes += 8;
        console.log("computeSizeInBytes number " + object);
    } else if (typeof object === 'boolean'){
        sizeInBytes += 1;
        console.log("computeSizeInBytes boolean " + object);
    } else if (typeof object === 'object'){
        sizeInBytes += ELEMENT_LENGTH_IN_BYTES
        if (Object.prototype.toString.apply(object) === '[object Array]') {
            var length = object.length;
            for (var i = 0; i < length; i += 1) {
                sizeInBytes += this.computeSizeInBytes(object[i]);
            }
            console.log("computeSizeInBytes Array " + object);
        } else {
            var keys = Object.keys(object);
            for (var i = 0; i < keys.length; i += 1) {
                var key = keys[i];
                if (typeof key === 'string'){
                    sizeInBytes += this.computeSizeInBytes(key);
                } else {
                    throw "Map key must be string";
                }
                var value = object[key];
                sizeInBytes += this.computeSizeInBytes(value);
            }
            console.log("computeSizeInBytes Object " + object);
        }
    }
    return sizeInBytes;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

TSONDeserializer = function(bytes, offset){
    this.bytes = bytes;
    this.view = new DataView(bytes.buffer);
    this.offset = offset;
}


TSONDeserializer.prototype.toObject = function(){
    this.readVersion();
    return this.readObject();
}

TSONDeserializer.prototype.readUint8 = function(){
    console.log('readUint8');
    var result = this.view.getUint8(this.offset)
    this.offset += 1;
    console.log(result);
    return result;
}

TSONDeserializer.prototype.readUint16 = function(){
    console.log('readUint16');
    var result = this.view.getUint16(this.offset, true)
    this.offset += 2;
    console.log(result);
    return result;
}

TSONDeserializer.prototype.readUint32 = function(){
    console.log('readUint32');
    var result = this.view.getUint32(this.offset, true)
    this.offset += 4;
    console.log(result);
    return result;
}

TSONDeserializer.prototype.readBool= function(){
    console.log('readBool');
    var result = readUint8()
    return result > 0;
}

TSONDeserializer.prototype.readInt8 = function(){
    console.log('readInt8');
    var result = this.view.getInt8(this.offset)
    this.offset += 1;
    console.log(result);
    return result;
}

TSONDeserializer.prototype.readInt16 = function(){
    console.log('readInt16');
    var result = this.view.getInt16(this.offset, true)
    this.offset += 2;
    console.log(result);
    return result;
}

TSONDeserializer.prototype.readInt32 = function(){
    console.log('readInt32');
    var result = this.view.getInt32(this.offset, true)
    this.offset += 4;
    console.log(result);
    return result;
}


TSONDeserializer.prototype.readFloat32 = function(){
    console.log('readInt32');
    var result = this.view.getFloat32(this.offset, true)
    this.offset += 4;
    console.log(result);
    return result;
}

TSONDeserializer.prototype.readDouble = function(){
    console.log('readInt32');
    var result = this.view.getFloat64(this.offset, true)
    this.offset += 8;
    console.log(result);
    return result;
}

TSONDeserializer.prototype.readType = function(){
    console.log('readType');
    return this.readUint8();
}

TSONDeserializer.prototype.readLength = function(){
    console.log('readLength');
    return this.readUint32();
}

TSONDeserializer.prototype.readNull = function(){
    console.log('readNull');
    return null;
}

TSONDeserializer.prototype.readList = function(){
    console.log('readList');
    var len = this.readLength();
    var list = [];
    for (var i = 0 ; i < len ; i++){
        list.push(this.readObject());
    }
    return list;
}

TSONDeserializer.prototype.readMap = function(){
    console.log('readMap');
    var len = this.readLength();
    var map = {};
    for (var i = 0 ; i < len ; i++){
        var key = this.readObject();
        var value = this.readObject();
        map[key] = value;
    }
    return map;
}

TSONDeserializer.prototype.readListUint8 = function(){
    console.log('readListUint8');
    var len = this.readLength();
    var list = new Uint8Array(len);
    for (var i = 0 ; i < len ; i++) list[i] = this.readUint8();
    return list;
}

TSONDeserializer.prototype.readListUint16 = function(){
    console.log('readListUint16');
    var len = this.readLength();
    var list = new Uint16Array(len);
    for (var i = 0 ; i < len ; i++) list[i] = this.readUint16();
    return list;
}

TSONDeserializer.prototype.readListUint32 = function(){
    console.log('readListUint32');
    var len = this.readLength();
    var list = new Uint32Array(len);
    for (var i = 0 ; i < len ; i++) list[i] = this.readUint32();
    return list;
}

TSONDeserializer.prototype.readListInt8 = function(){
    console.log('readListUint8');
    var len = this.readLength();
    var list = new Int8Array(len);
    for (var i = 0 ; i < len ; i++) list[i] = this.readInt8();
    return list;
}

TSONDeserializer.prototype.readListInt16 = function(){
    console.log('readListInt16');
    var len = this.readLength();
    var list = new Int16Array(len);
    for (var i = 0 ; i < len ; i++) list[i] = this.readInt16();
    return list;
}

TSONDeserializer.prototype.readListInt32 = function(){
    console.log('readListInt32');
    var len = this.readLength();
    var list = new Int32Array(len);
    for (var i = 0 ; i < len ; i++) list[i] = this.readInt32();
    return list;
}

TSONDeserializer.prototype.readListFloat32 = function(){
    console.log('readListInt32');
    var len = this.readLength();
    var list = new Float32Array(len);
    for (var i = 0 ; i < len ; i++) list[i] = this.readFloat32();
    return list;
}

TSONDeserializer.prototype.readListFloat64 = function(){
    console.log('readListInt32');
    var len = this.readLength();
    var list = new Float64Array(len);
    for (var i = 0 ; i < len ; i++) list[i] = this.readDouble();
    return list;
}

TSONDeserializer.prototype.readCStringList = function(){
    console.log('readListInt32');
    var len = this.readLength();
    var list = new Uint8Array(len);
    for (var i = 0 ; i < len ; i++) list[i] = this.readUint8();
    return new CStringList(list);
}


TSONDeserializer.prototype.readObject = function(){
    var type = this.readType();
    if (type == NULL_TYPE ) return this.readNull();
    else if (type == STRING_TYPE ) return this.readString();
    else if (type == INTEGER_TYPE ) return this.readInt32();
    else if (type == DOUBLE_TYPE ) return this.readDouble();
    else if (type == BOOL_TYPE ) return this.readBool();
    else if (type == LIST_TYPE ) return this.readList();
    else if (type == MAP_TYPE ) return this.readMap();
    else if (type == LIST_UINT8_TYPE ) return this.readListUint8();
    else if (type == LIST_UINT16_TYPE ) return this.readListUint16();
    else if (type == LIST_UINT32_TYPE ) return this.readListUint32();
    else if (type == LIST_INT8_TYPE ) return this.readListInt8();
    else if (type == LIST_INT16_TYPE ) return this.readListInt16();
    else if (type == LIST_INT32_TYPE ) return this.readListInt32();
    else if (type == LIST_FLOAT32_TYPE ) return this.readListFloat32();
    else if (type == LIST_FLOAT64_TYPE ) return this.readListFloat64();
    else if (type == LIST_STRING_TYPE ) return this.readCStringList();
    else throw 'readObject : unknown type ' + type;
}

TSONDeserializer.prototype.readString = function(){
    var str = '';
    var byte = this.readUint8();
    while (byte != 0){
        str += String.fromCharCode(byte);
        byte = this.readUint8();
    }
    return str;
}

TSONDeserializer.prototype.readVersion = function(){
    console.log('readVersion');
    var type = this.readType();
    if (type != STRING_TYPE) throw 'readVersion : wrong type';
    var version = this.readString();
    if (version != VERSION) throw  'readVersion : wrong version expected ' + VERSION + ' found ' + version;
    return version;
}

CStringList = function(bytes){
    this.bytes = bytes;
    this.length = 0;
    this.starts = this.buildStarts();
}

CStringList.fromList = function(list){
    var lengthInBytes = 0;
    for (var i = 0 ; i < list.length ; i++){
        var str = list[i];
        lengthInBytes += str.length + 1;
    }

    var bytes = new Uint8Array(lengthInBytes);
    var offset = 0;
    for (var i = 0 ; i < list.length ; i++){
        var str = list[i].toString();
        for (var k = 0 ; k < str.length ; k++){
            bytes[offset] = str.charCodeAt(k);
            offset++;
        }
    }
    return new CStringList(bytes);
}

CStringList.prototype.buildStarts = function(){
    var n = 0;
    var len = this.bytes.length;
    for (var i = 0 ; i < len ; i++){
        if (this.bytes[i] == 0) n++;
    }
    this.length = n;
    this.starts = new Uint32Array(n+1);
    this.starts[0] = 0;
    n = 1;
    for (var i = 0 ; i < len ; i++){
        if (this.bytes[i] == 0){
            this.starts[n] = i+1;
            n++;
        }
    }
}

CStringList.prototype.get = function(index){
    if (index >= this.length) throw 'CStringList : index ' +  index +' is out of range : [0,'+this.length+'[';
    var start = this.starts[index];
    var end = this.starts[index+1] - 1;

    var str = '';
    for (var i = start ; i < end ; i++){
        str += String.fromCharCode(this.bytes[i]);
    }
    return str;
}

CStringList.prototype.toList = function(){
    var list = [];
    for (var i = 0 ; i < this.length ; i++){
        list.push(this.get(i));
    }
    return list;
}



if (typeof TSON !== 'object') {
    TSON = {};
    TSONDecode = function (byteArray) {
        var deser = new TSONDeserializer(byteArray, 0)
        var object = deser.toObject();
        return object;
    }
    TSONEncode = function (object) {
        var ser = new TSONSerializer();
        return ser.serialize(object);
    }
    TSON.encode = TSONEncode;
    TSON.decode = TSONDecode;
}


var uint8List = new  Uint8Array(2);
uint8List[0] = 1;
uint8List[1] = 2;

var map = {a:"a", i:42, list: [1,"2",4], map: {s:4}, uint8List: uint8List};
//
// var bytes = TSON.encode(map);

// console.log(bytes);

// var map = {a:"a"};

var bytes = TSON.encode(map);

console.log(bytes);

// deser = new Deserializer(bytes, 0);
// var version = deser.readVersion();
//
// console.log(version);

console.log('TSON.decode');
var object = TSON.decode(bytes);
console.log('object = '+ JSON.stringify(object));



