# TSON

R implementation of [TSON specification](https://github.com/amaurel/TSON).

## Note

Type int64 is not yet implemented.

## Changes
### 1.1

- package now export tson.scalar
- tson.scalar, tson.character ... return NULL if given object is NULL
- values can be NULL in maps
- correct endianess for readBin


## Example

```
library(rtson)

list = list(integer=42L,
          double=42,
          bool=TRUE,
          uint8=tson.uint8.vec(c(42,0)),
          uint16=tson.uint16.vec(c(42,0)),
          uint32=tson.uint32.vec(c(42,0)),
          int8=tson.int8.vec(c(42,0)),
          int16=tson.int16.vec(c(42,0)),
          int32=as.integer(c(42,0)),
          float32=tson.float32.vec(c(0.0, 42.0)),
          float64=c(42.0,42.0),
          map=list(x=42, y=42, label="42"),
          list=list("42",42)
)

bytes = toTSON(list)

print(as.integer(bytes))

object = fromTSON(bytes)

print(object)

```