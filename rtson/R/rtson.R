library(R6)
#' Serialize a list 
#'
#' Write TSON specification binary-encoded format to a connection.
#'
#' @param object A list
#' @param con A connection
#' @return invisibly NULL
#'
#' @examples
#' ## Example
#' 
#' library(rtson)
#' 
#' list = list(integer=42L,
#'             double=42,
#'             bool=TRUE,
#'             uint8=tson.uint8.vec(c(42,0)),
#'             uint16=tson.uint16.vec(c(42,0)),
#'             uint32=tson.uint32.vec(c(42,0)),
#'             int8=tson.int8.vec(c(42,0)),
#'             int16=tson.int16.vec(c(42,0)),
#'             int32=as.integer(c(42,0)),
#'             float32=tson.float32.vec(c(0.0, 42.0)),
#'             float64=c(42.0,42.0),
#'             map=list(x=42, y=42, label="42"),
#'             list=list("42",42)
#' )
#' 
#' con = rawConnection(raw(0), "r+")
#' writeTSON(list, con)
#' bytes = rawConnectionValue(con)
#' close(con)
#' con = rawConnection(bytes, "r")
#' object = readTSON(con)
#' @export
writeTSON <- function(object, con) {
  if (!inherits(con,'connection')) stop('object must a connection')
  Serializer$new(object, con)
}
 
#' Serialize a list 
#'
#' This function convert a list into raw following TSON specification binary-encoded format.
#'
#' @param object A list
#' @return A raw vector
#'
#' @examples
#' ## Example
#' 
#' library(rtson)
#' 
#' list = list(integer=42L,
#'             double=42,
#'             bool=TRUE,
#'             uint8=tson.uint8.vec(c(42,0)),
#'             uint16=tson.uint16.vec(c(42,0)),
#'             uint32=tson.uint32.vec(c(42,0)),
#'             int8=tson.int8.vec(c(42,0)),
#'             int16=tson.int16.vec(c(42,0)),
#'             int32=as.integer(c(42,0)),
#'             float32=tson.float32.vec(c(0.0, 42.0)),
#'             float64=c(42.0,42.0),
#'             map=list(x=42, y=42, label="42"),
#'             list=list("42",42)
#' )
#' 
#' bytes = toTSON(list)
#' @export
toTSON <- function(object) {
  con = rawConnection(raw(0), "r+")
  return(tryCatch({
    writeTSON(object,con)
    bytes = rawConnectionValue(con)
    return(bytes)
  }, finally=close(con)))
}

#' Deserialize a connection 
#'
#' Read TSON specification binary-encoded format from a connection.
#'
#' @param con A connection or a raw vector
#' @return A list
#'
#' @examples
#' ## Example
#' 
#' library(rtson)
#' 
#' list = list(integer=42L,
#'             double=42,
#'             bool=TRUE,
#'             uint8=tson.uint8.vec(c(42,0)),
#'             uint16=tson.uint16.vec(c(42,0)),
#'             uint32=tson.uint32.vec(c(42,0)),
#'             int8=tson.int8.vec(c(42,0)),
#'             int16=tson.int16.vec(c(42,0)),
#'             int32=as.integer(c(42,0)),
#'             float32=tson.float32.vec(c(0.0, 42.0)),
#'             float64=c(42.0,42.0),
#'             map=list(x=42, y=42, label="42"),
#'             list=list("42",42)
#' )
#' 
#' con = rawConnection(raw(0), "r+")
#' writeTSON(list, con)
#' bytes = rawConnectionValue(con)
#' close(con)
#' con = rawConnection(bytes, "r")
#' object = readTSON(con)
#' @export
readTSON <- function(con){
  if (!inherits(con,'connection')) stop('con must a connection')
  deser = Deserializer$new(con)
  object = deser$object
  return (object) 
} 

#' Deserialize a raw vector 
#'
#' This function convert a raw vector into a list following TSON specification binary-encoded format.
#'
#' @param bytes A raw vector
#' @return A list
#'
#' @examples
#' ## Example
#' 
#' library(rtson)
#' 
#' list = list(integer=42L,
#'             double=42,
#'             bool=TRUE,
#'             uint8=tson.uint8.vec(c(42,0)),
#'             uint16=tson.uint16.vec(c(42,0)),
#'             uint32=tson.uint32.vec(c(42,0)),
#'             int8=tson.int8.vec(c(42,0)),
#'             int16=tson.int16.vec(c(42,0)),
#'             int32=as.integer(c(42,0)),
#'             float32=tson.float32.vec(c(0.0, 42.0)),
#'             float64=c(42.0,42.0),
#'             map=list(x=42, y=42, label="42"),
#'             list=list("42",42)
#' )
#' 
#' bytes = toTSON(list)
#' object = fromTSON(bytes)
#' @export
fromTSON <- function(bytes){
  if (!is.raw(bytes)) stop('bytes must a raw vector')
  con = rawConnection(bytes, "r")
  return(tryCatch(readTSON(con), finally = close(con)))
} 