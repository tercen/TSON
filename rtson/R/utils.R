TSON_KIND = "kind"
TSON_SCALAR = -1

add.tson.attribute = function(object, name, value){
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

tson.map = function(object){
  return (add.tson.attribute(as.list(object), TSON_KIND, MAP_TYPE))
}

tson.float32.vec = function(object){
  return (add.tson.attribute(as.double(object), TSON_KIND, LIST_FLOAT32_TYPE))
}

tson.int8.vec = function(object){
  return (add.tson.attribute(as.integer(object), TSON_KIND, LIST_INT8_TYPE))
}

tson.int16.vec = function(object){
  return (add.tson.attribute(as.integer(object), TSON_KIND, LIST_INT16_TYPE))
}

tson.uint8.vec = function(object){
  return (add.tson.attribute(as.integer(object), TSON_KIND, LIST_UINT8_TYPE))
}

tson.uint16.vec = function(object){
  return (add.tson.attribute(as.integer(object), TSON_KIND, LIST_UINT16_TYPE))
}

tson.uint32.vec = function(object){
  return (add.tson.attribute(as.integer(object), TSON_KIND, LIST_UINT32_TYPE))
}

tson.scalar = function(object){
  return (add.tson.attribute(object, TSON_KIND, TSON_SCALAR))
}

tson.int = function(object){
  return (tson.scalar(as.integer(object)))
}

tson.double = function(object){
  return (tson.scalar(as.double(object)))
}

tson.character = function(object){
  return (tson.scalar(as.character(object)))
}
