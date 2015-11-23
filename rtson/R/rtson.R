
toTSON <- function(object){
  return (Serializer$new(object)$bytes)
}

fromTSON <- function(bytes, offset=NULL){
  
}

tson.float32 = function(object){
  return (addAttribute(as.double(object), "kind", "float32"))
}

tson.scalar = function(object){
  return (addAttribute(object, "kind", "scalar"))
}

VERSION = "1.1.0"
TYPE_LENGTH_IN_BYTES = 1
NULL_TERMINATED_LENGTH_IN_BYTES = 1
ELEMENT_LENGTH_IN_BYTES = 4;

NULL_TYPE = 0
STRING_TYPE = 1
INTEGER_TYPE = 2
DOUBLE_TYPE = 3
BOOL_TYPE = 4

LIST_TYPE = 10
MAP_TYPE = 11

LIST_UINT8_TYPE = 100
LIST_UINT16_TYPE = 101
LIST_UINT32_TYPE = 102

LIST_INT8_TYPE = 103
LIST_INT16_TYPE = 104
LIST_INT32_TYPE = 105
LIST_INT64_TYPE = 106

LIST_FLOAT32_TYPE = 110
LIST_FLOAT64_TYPE = 111

LIST_STRING_TYPE = 112
 
addAttribute = function(object, name, value){
  attr = attributes(object)
  if (is.null(attr)){
    attr <- list()
    attr[[name]] <- value
  } else {
    attr[[name]] = value
  }
  attributes(object) <- attr 
  return (object)
}



Serializer <- R6Class(
  "Serializer",
  public = list(
    bytes = NULL,
    bufferList = NULL,
    initialize = function(object){
      self$bufferList = list()
      self$addString(VERSION)
      self$addListOrMap(object)
      self$bytes = unlist(do.call("c" , self$bufferList))
      self$bufferList = NULL
    },
    addBuffer = function(buffer){
      list = self$bufferList
      list[[length(list)+1]] <- buffer
      self$bufferList <- list 
    },
    addType = function(type){
      self$addBuffer(writeBin(as.integer(type), raw(0), size=1, endian =  "little"))
    },
    addLength = function(len){
      self$addBuffer(writeBin(as.integer(len), raw(0), size=4, endian =  "little"))
    },
    addListOrMap = function(object){
      names = names(object)
      if (is.null(names)){
        self$addList(object)
      } else {
        self$addMap(object)
      }
    },
    addObject = function(object){
      
      if (is.character(object)){
        if (length(object) == 1){
          attr = attributes(object)
          if (!is.null(attr) && !is.null(attr$kind) && attr$kind == "scalar"){
            self$addString(object)
          } else {
            self$addStringList(object)
          }
        } else {
          self$addStringList(object)
        }
      } else if (is.integer(object)){
        if (length(object) == 1){
          attr = attributes(object)
          if (!is.null(attr) && !is.null(attr$kind) && attr$kind == "scalar"){
            self$addInteger(object)
          } else {
            self$addIntegerList(object)
          }
        } else {
          self$addIntegerList(object)
        }
      } else if (is.double(object)){
        if (length(object) == 1){
          attr = attributes(object)
          if (!is.null(attr) && !is.null(attr$kind) && attr$kind == "scalar"){
            self$addDouble(object)
          } else {
            self$addDoubleList(object)
          }
        } else {
          self$addDoubleList(object)
        }
      } else if (is.list(object)){
        self$addListOrMap(object)
      } else {
        stop("unknwon object type")
      }
    },
    addList = function(object){
      self$addType(LIST_TYPE)
      self$addLength(length(object))
      lapply(object, function(each) self$addObject(each))
    },
    addMap = function(object){
      self$addType(MAP_TYPE)
      self$addLength(length(object))
      names = unique(names(object))
      if (length(names) != length(object)){
        stop("Map keys must be unique.")
      }
      lapply(names, function(name){
        self$addString(name)
        self$addObject(object[[name]])
      })
    },
    addString = function(object){
      self$addType(STRING_TYPE)
      self$addBuffer(writeBin(as.vector(object), raw(0)))
    },
    addStringList = function(object){
      self$addType(LIST_STRING_TYPE)
      bin = writeBin(object, raw(0))
      self$addLength(length(bin))
      self$addBuffer(bin)
    },
    addInteger = function(object){
      self$addType(INTEGER_TYPE)
      self$addBuffer(writeBin(as.integer(as.vector(object)), raw(0), size=4, endian = "little"))
    },
    addIntegerList = function(object){
      attr = attributes(object)
      if (!is.null(attr)){
        if (!is.null(attr$kind) && attr$kind == "int8"){
          self$addInt8List(object)
        } else if (!is.null(attr$kind) && attr$kind == "int16"){
          self$addInt16List(object)
        } else if (!is.null(attr$kind) && attr$kind == "int32"){
          self$addInt32List(object)
        } else {
          self$addInt32List(object)
        }
      } else {
        self$addInt32List(object)
      }
    },
    addInt8List = function(object){
      self$addType(LIST_INT8_TYPE)
      self$addLength(length(object))
      self$addBuffer(writeBin(as.integer(as.vector(object)), raw(0), size=1, endian =  "little"))
    },
    addInt16List = function(object){
      self$addType(LIST_INT16_TYPE)
      self$addLength(length(object))
      self$addBuffer(writeBin(as.integer(as.vector(object)), raw(0), size=2, endian =  "little"))
    },
    addInt32List = function(object){
      self$addType(LIST_INT32_TYPE)
      self$addLength(length(object))
      self$addBuffer(writeBin(as.integer(as.vector(object)), raw(0), size=4, endian =  "little"))
    },
    addDouble = function(object){
      self$addType(DOUBLE_TYPE)
      self$addBuffer(writeBin(as.double(as.vector(object)), raw(0), size=8, endian =  "little"))
    },
    addDoubleList = function(object){
      attr = attributes(object)
      if (!is.null(attr)){
        if (!is.null(attr$kind) && attr$kind == "float32"){
          self$addFloat32List(object)
        } else if (!is.null(attr$kind) && attr$kind == "float64"){
          self$addFloat64List(object)
        } else {
          self$addFloat64List(object)
        }
      } else {
        self$addFloat64List(object)
      }
    },
    addFloat32List = function(object){
      self$addType(LIST_FLOAT32_TYPE)
      self$addLength(length(object))
      self$addBuffer(writeBin(as.double(as.vector(object)), raw(0), size=4, endian =  "little"))
    },
    addFloat64List = function(object){
      self$addType(LIST_FLOAT64_TYPE)
      self$addLength(length(object))
      self$addBuffer(writeBin(as.double(as.vector(object)), raw(0), size=8, endian =  "little"))
    }
  )
)




















