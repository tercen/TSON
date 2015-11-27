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




function TSONSerializer (){

}

addType = function(type, offset, bytes){
    console.log("addType type " + type + " ioffset ", offset + " bytes " + bytes);
    bytes[offset] = type;
    return offset + 1;
}

addString= function(object, ioffset, bytes){
    console.log("addString object " + object + " ioffset ", ioffset + " bytes " + bytes);
    var offset = ioffset;
    offset = addType(STRING_TYPE, offset, bytes);
    for (var i = 0 ; i<object.length;i++){
        bytes[offset] = object.charCodeAt(i);
        offset++;
    }
    return offset;
}

addNumber = function(object, ioffset, bytes){
    console.log("addNumber object " + object + " ioffset ", ioffset + " bytes " + bytes);
    var offset = ioffset;
    offset = addType(DOUBLE_TYPE, offset, bytes);
    new DataView(bytes.buffer).setFloat64(offset, object, true);
    return offset + 8;
}

addBool = function(object, ioffset, bytes){
    var offset = ioffset;
    offset = addType(BOOL_TYPE, offset, bytes);
    if (object){
        bytes[offset] = 1;
    }
    return offset + 1;
}

addLength  = function(object, ioffset, bytes){
    console.log("addLength object " + object + " ioffset ", ioffset + " bytes " + bytes);
    var offset = ioffset;
    new DataView(bytes.buffer).setUint32(offset, object, true);
    return offset + 4;
}

addMap = function(object, ioffset, bytes){
    console.log("addMap object " + object + " ioffset ", ioffset + " bytes " + bytes);
    var offset = ioffset;
    offset = addType(MAP_TYPE, offset, bytes);
    var keys = Object.keys(object);
    offset = addLength(keys.length, offset, bytes);
    for (var i = 0; i < keys.length; i += 1) {
        var key = keys[i];
        if (typeof key === 'string'){
            offset = addString(key,offset,bytes);
        } else {
            throw "Map key must be string";
        }
        offset = addObject(object[key],offset,bytes);
    }
    return offset;
}

addList = function(object, ioffset, bytes){
    var offset = ioffset;
    offset = addType(LIST_TYPE, offset, bytes);
    offset = addLength(object.length, offset, bytes);
    for (var i = 0; i < object.length; i += 1) {
        offset = addObject(object[i],offset,bytes);
    }
    return offset;
}


addObject = function(object, ioffset, bytes){
    console.log("addObject object " + object + " ioffset ", ioffset + " bytes " + bytes);
    var offset = ioffset;
    if (typeof object === 'undefined'){
        offset = addType(NULL_TYPE, offset, bytes);
        console.log("addObject undefined " + object);
    } else if (typeof object === 'string'){
        offset = addString(object, offset, bytes);
        console.log("addObject string " + object);
    } else if (typeof object === 'number'){
        offset = addNumber(object, offset, bytes);
        console.log("addObject number " + object);
    } else if (typeof object === 'boolean'){
        offset = addBool(object, offset, bytes);
        console.log("addObject boolean " + object);
    } else if (typeof object === 'object'){
        if (Object.prototype.toString.apply(object) === '[object Array]') {
            offset = addList(object, offset, bytes);
            console.log("addObject Array " + object);
        } else {
            offset = addMap(object, offset, bytes);
            console.log("addObject Object " + object);
        }
    }
    return offset;
}

computeSizeInBytes = function(object){
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
                sizeInBytes += computeSizeInBytes(object[i]);
            }
            console.log("computeSizeInBytes Array " + object);
        } else {
            var keys = Object.keys(object);
            for (var i = 0; i < keys.length; i += 1) {
                var key = keys[i];
                if (typeof key === 'string'){
                    sizeInBytes += computeSizeInBytes(key);
                } else {
                    throw "Map key must be string";
                }
                var value = object[key];
                sizeInBytes += computeSizeInBytes(value);
            }
            console.log("computeSizeInBytes Object " + object);
        }
    }
    return sizeInBytes;
}

TSONEncode = function (object) {
    var sizeInBytes = computeSizeInBytes(object);
    console.log("sizeInBytes " + sizeInBytes);
    var bytes = new Uint8Array(sizeInBytes);
    addObject(object, 0, bytes);
    return bytes;
}

TSONDecode = function (byteArray) {

}

if (typeof TSON !== 'object') {
    TSON = {};
    TSON.encode = TSONEncode;
    TSON.decode = TSONDecode;
}

var map = {a:"a", i:42};

var bytes = TSON.encode(map);

console.log(bytes);
