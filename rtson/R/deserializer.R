#' @import R6
library(R6)
Deserializer <- R6Class(
  'Deserializer',
  public = list(
    con = NULL,
    object = NULL,
    initialize = function(con = NULL){
      if (!inherits(con,'connection')) stop("con must be of type connection")
      if (!isOpen(con, rw='r')) stop("con must be open read")
      
      self$con = con
      version = self$readObject()
      if (version != TSON_SPEC_VERSION) stop(paste0("TSON spec version mismatch, found ", version, " expected " , TSON_SPEC_VERSION))
      self$object = self$readObject()
    },
    readType = function() {
      type = readBin(self$con, integer(), n=1, size=1, endian =  "little")
      return (type)
    },
    readObject = function(){
      type = self$readType()
      if (type == NULL_TYPE){
        return(NULL)
      } else if (type == STRING_TYPE){
        return(self$readString())
      } else if (type == INTEGER_TYPE){
        return(self$readInteger())
      } else if (type == DOUBLE_TYPE){
        return(self$readDouble())
      } else if (type == BOOL_TYPE){
        return(self$readBool())
      } else if (type == LIST_TYPE){
        return(self$readList())
      } else if (type == MAP_TYPE){
        return(self$readMap())
      } else if (type == LIST_UINT8_TYPE){
        return(self$readUint8List())
      } else if (type == LIST_UINT16_TYPE){
        return(self$readUint16List())
      } else if (type == LIST_UINT32_TYPE){
        return(self$readUint32List())
      } else if (type == LIST_INT8_TYPE){
        return(self$readInt8List())
      } else if (type == LIST_INT16_TYPE){
        return(self$readInt16List())
      } else if (type == LIST_INT32_TYPE){
        return(self$readInt32List())
      } else if (type == LIST_INT64_TYPE){
        
        stop('int64 not supported')
        
      } else if (type == LIST_UINT64_TYPE){
        
        stop('uint64 not supported')
        
      } else if (type == LIST_FLOAT32_TYPE){
        return(self$readFloat32List())
      } else if (type == LIST_FLOAT64_TYPE){
        return(self$readFloat64List())
      } else if (type == LIST_STRING_TYPE){
        return(self$readStringList())
      } 
    },
    readString = function(){
      block = 1024
      zz = self$con
      rr = raw()
      found = 0
      while ( found==0 ) {
        r <- readBin(zz, "raw", block)
        len = length(r)
        if( length(w<-head(which(r==0),1)) ) {
          rr <- c(rr, r[1:(w-1)])
          found <- 1
          seek(zz, -(len-w), origin="current") #rewind
        } else {
          rr <- c(rr, r)
        }
      }
      
      object = rawToChar(rr)
      return (object)
    },
    readInteger = function(){
      object = readBin(self$con, integer(), n=1, endian =  "little")
      return (object)
    },
    readDouble = function(){
      object = readBin(self$con, double(), n=1, endian =  "little")
      return (object)
    },
    readBool = function(){
      object = readBin(self$con, integer(), n=1, size=1, endian =  "little")
      return (object == 1)
    },
    readLength = function(){
      len = self$readInteger()
      if (len < 0) stop("Length must be greater or equals to 0")
      return (len)
    },
    readList = function(){
      len = self$readLength()
      list = NULL
      if (len > 0){
        list = lapply(seq(1,len), function(i) self$readObject())
      } else {
        list = list()
      }
      return (list)
    },
    readMap = function(){
      len = self$readLength()
      list = NULL
      if (len > 0){
        keys = list()
        list = list()
        for (i in 1:len){
          keys[[i]] = self$readObject()
          value = self$readObject()
          if (is.null(value)){
            list[i] = list(NULL)
          } else {
            list[[i]] = value
          }
        }
        names(list) = keys
      } else {
        list = list()
      }
      return (list)
    },
    readTypedList = function(what, size, signed){
      len = self$readLength()
      object = readBin(self$con, what, n=len, size=size, signed = signed, endian =  "little")
      return (object)
    },
    readUint8List = function() self$readTypedList(integer(), 1 , FALSE),
    readUint16List = function() self$readTypedList(integer(), 2, FALSE),
    readUint32List = function() self$readTypedList(integer(), 4, TRUE),
    readInt8List = function() self$readTypedList(integer(), 1 , TRUE),
    readInt16List = function() self$readTypedList(integer(), 2, TRUE),
    readInt32List = function() self$readTypedList(integer(), 4, TRUE),
    readFloat32List = function() self$readTypedList(double(), 4, TRUE),
    readFloat64List = function() self$readTypedList(double(), 8, TRUE),
    readStringList = function(){
      bytes = self$readTypedList(raw(), 1 , FALSE)  
      object = readBin(bytes, character(), n=length(bytes[bytes==0]))
      return (object)
    }
  )
)