# TSON

R implementation of [TSON specification](https://github.com/tercen/TSON).

```R
 devtools::install_github("tercen/TSON", ref = "1.5.2-rtson", subdir="rtson", upgrade_dependencies = FALSE, args="--no-multiarch")
```

## Note

Type int64 partially implemented.

## Changes

### 1.5.0

- toTSON use native rust lib
- serialisation to uint64 and int64 is now possible using either interger or float vector

```R
toTSON(tson.int64.vec(42))
toTSON(tson.uint64.vec(42))
```

### 1.4.2

- fromTSON use native rust lib


### 1.4

- use jsonlite scalar definition : jsonlite::unbox and tson.scalar are now compatibles

### 1.3

- overcome readBin/writeBin character limit (10 kbytes)

### 1.2

- use of connection object : overall performance should be improved
- new function writeTSON : Write TSON specification binary-encoded format to a connection.
- new function readTSON : Read TSON specification binary-encoded format from a connection.

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

# rustrize

```R
rustinr::rustrize()
```

# Bench

```R

object = list(a=rtson::tson.scalar(6), p=seq(100))

rbenchmark::benchmark("jsonlite" = {
            jsonlite::fromJSON(jsonlite::toJSON(object))
          },
          "rtson-json" = {
            rtson::fromJSON(rtson::toJSON(object))
          },
          "rtson" = {
            rtson::fromTSON(rtson::toTSON(object))
          })
