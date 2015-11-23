toTSON <- function(object) (Serializer$new(object)$bytes)
fromTSON <- function(bytes, offset=NULL) Deserializer$new(bytes, offset)$object


 

 





















