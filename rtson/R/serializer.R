#' @import R6
library(R6)
Serializer <- R6Class(
  "Serializer",
  public = list(
    con = NULL,
    initialize = function(object, con){
      if (!inherits(con,'connection')) stop("con must be of type connection")
      if (!isOpen(con, rw='w')) stop("con must be open read")
      
      self$con = con
      self$addString(TSON_SPEC_VERSION)
      self$addRootObject(object)
    },
    addType = function(type){
      writeBin(as.integer(type), self$con, size=1, endian =  "little")
    },
    addLength = function(len){
      writeBin(as.integer(len), self$con, size=4, endian =  "little")
    },
    addListOrMap = function(object){
      names = names(object)
      if (is.null(names)){
        attr = attributes(object)
        if (!is.null(attr) && !is.null(attr[[TSON_KIND]]) && attr[[TSON_KIND]] == MAP_TYPE){
          self$addMap(object)
        } else {
          self$addList(object)
        }
      } else {
        self$addMap(object)
      }
    },
    addRootObject = function(object) {
      if (is.character(object)){
        self$addStringList(object)
      } else if (is.integer(object)){
        self$addIntegerList(object)
      } else if (is.double(object)){
        self$addDoubleList(object)
      } else if (is.list(object)){
        self$addListOrMap(object)
      } else {
        stop("unknwon object type")
      }
    },
    addObject = function(object) {
      if (is.null(object)){
        self$addNull()
      }else if (is.logical(object)){
        self$addBool(object)
      } else if (is.character(object)){
        if (length(object) == 1){
          attr = attributes(object)
          if (!is.null(attr) && !is.null(attr[[TSON_KIND]]) && attr[[TSON_KIND]] == TSON_SCALAR){
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
          if (!is.null(attr) && !is.null(attr[[TSON_KIND]]) && attr[[TSON_KIND]] == TSON_SCALAR){
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
          if (!is.null(attr) && !is.null(attr[[TSON_KIND]]) && attr[[TSON_KIND]] == TSON_SCALAR){
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
    addNull = function(){
      self$addType(NULL_TYPE)
    },
    addBool = function(object){
      if (length(object) > 1) stop("Cannot serialize vector of logical")
      bool = 0
      if (object) bool = 1
      self$addType(BOOL_TYPE)
      writeBin(as.integer(bool), self$con, size=1, endian =  "little")
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
      # to overcone writeBin 10000 chars
      writeChar(str, nchars=nchar(object), self$con) 
    },
    addStringList = function(object){
      self$addType(LIST_STRING_TYPE)
      bin = writeBin(object, raw(0))
      self$addLength(length(bin))
      writeBin(bin, self$con)
    },
    addInteger = function(object){
      self$addType(INTEGER_TYPE)
      writeBin(as.integer(as.vector(object)), self$con, size=4, endian = "little")
    },
    addIntegerList = function(object){
      attr = attributes(object)
      if (!is.null(attr)){
        if (!is.null(attr[[TSON_KIND]]) && attr[[TSON_KIND]] == LIST_INT8_TYPE){
          self$addInt8List(object)
        } else if (!is.null(attr[[TSON_KIND]]) && attr[[TSON_KIND]] == LIST_INT16_TYPE){
          self$addInt16List(object)
        } else if (!is.null(attr[[TSON_KIND]]) && attr[[TSON_KIND]] == LIST_UINT8_TYPE){
          self$addUInt8List(object)
        } else if (!is.null(attr[[TSON_KIND]]) && attr[[TSON_KIND]] == LIST_UINT16_TYPE){
          self$addUInt16List(object)
        } else if (!is.null(attr[[TSON_KIND]]) && attr[[TSON_KIND]] == LIST_UINT32_TYPE){
          self$addUInt32List(object)
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
      writeBin(as.integer(as.vector(object)), self$con, size=1, endian =  "little")
    },
    addInt16List = function(object){
      self$addType(LIST_INT16_TYPE)
      self$addLength(length(object))
      writeBin(as.integer(as.vector(object)), self$con, size=2, endian =  "little")
    },
    addInt32List = function(object){
      self$addType(LIST_INT32_TYPE)
      self$addLength(length(object))
      writeBin(as.integer(as.vector(object)), self$con, size=4, endian =  "little")
    },
    
    addUInt8List = function(object){
      self$addType(LIST_UINT8_TYPE)
      self$addLength(length(object))
      writeBin(as.integer(as.vector(object)), self$con, size=1, endian =  "little")
    },
    addUInt16List = function(object){
      self$addType(LIST_UINT16_TYPE)
      self$addLength(length(object))
      writeBin(as.integer(as.vector(object)), self$con, size=2, endian =  "little")
    },
    addUInt32List = function(object){
      self$addType(LIST_UINT32_TYPE)
      self$addLength(length(object))
      writeBin(as.integer(as.vector(object)), self$con, size=4, endian =  "little")
    },
    
    addDouble = function(object){
      self$addType(DOUBLE_TYPE)
      writeBin(as.double(as.vector(object)), self$con, size=8, endian =  "little")
    },
    addDoubleList = function(object){
      attr = attributes(object)
      if (!is.null(attr)){
        if (!is.null(attr[[TSON_KIND]]) && attr[[TSON_KIND]] == LIST_FLOAT32_TYPE){
          self$addFloat32List(object)
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
      writeBin(as.double(as.vector(object)), self$con, size=4, endian =  "little")
    },
    addFloat64List = function(object){
      self$addType(LIST_FLOAT64_TYPE)
      self$addLength(length(object))
      writeBin(as.double(as.vector(object)), self$con, size=8, endian =  "little")
    }
  )
)