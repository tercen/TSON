library(rtson)

test_that = function(name, expr){
  print(paste0("---------- ----------  Run test : ", name))
  new_test_environment <- new.env(parent = parent.frame())
  tryCatch(
    eval(expr, new_test_environment),
    error = function(e){
      print(paste0("error in test ", name))
      print(e)
    }
  )
  invisible()
}

context = function(c){
  print(paste0("---------- Context : ", c))
}

expect_equal = function(found,expected, label=NULL){
  if (expected != found) stop(paste0("expect_equal failed : ", label, " : expected ", expected , " found " , found))
}

expect_less = function(found,expected, label=NULL){
  if (expected <= found ) stop(paste0("expect_less failed : ", label, " : expected ", expected , " found " , found))
}

expect_lessEpsilon32 = function(found, label=NULL){
  expect_less(found, 1e-06, label=label)
}

expect_equal_list = function(found,expected, label=NULL){
  
  if ( (is.null(found) && !is.null(expected)) || (!is.null(found) && is.null(expected)) || (length(found) != length(expected)) ) stop(paste0("expect_equal_list length failed : ", label, " : expected ", expected , " found " , found))
  
  if (length(found) > 0) {
    found_names = names(found)
    expected_names = names(expected)
      
    if ( (is.null(found_names) && !is.null(expected_names)) || (!is.null(found_names) && is.null(expected_names)) ) stop(paste0("expect_equal_list name failed : ", label, " : expected ", expected , " found " , found))
    
    if (!is.null(found_names)) expect_equal_list(found_names, expected_names)
    
    if (length(found) > 1){
      for (i in seq(1,length(found))){
        expect_equal_list(found[[i]], expected[[i]])
      }
    } else {
      if (as.vector(found[[1]]) != as.vector(expected[[1]])) stop(paste0("expect_equal_list basic equality failed : ", label, " : expected ", expected , " found " , found))
    }
  }
}

context("TSON test")

# test_that("Test expect_equal_list", {
#   expect_equal_list(list(), list())
#   expect_equal_list(list(1 , list(a=1)),list(1, list(a=1)))
# })

test_that("Empty list", {
  list = list()
  bytes = toTSON(list)
  print(as.integer(bytes))
  object = fromTSON(bytes)
  expect_equal_list(object, list)
})

test_that("Empty map", {
  list = tson.map(list())
  bytes = toTSON(list)
  print(as.integer(bytes))
  object = fromTSON(bytes)
  expect_equal_list(object, list)
})

test_that("Simple list", {
  list = list(tson.character("a"), TRUE, FALSE, tson.int(42L), tson.double(42.0) )
  bytes = toTSON(list)
  print(as.integer(bytes))
  object = fromTSON(bytes)
  expect_equal_list(object, list)
})

test_that("Simple int32 list", {
  list = as.integer(c(42,42))
  bytes = toTSON(list)
  print(as.integer(bytes))
  object = fromTSON(bytes)
  expect_equal_list(object, list)
})

test_that("Simple cstring list", {
  list = list("42.0","42" )
  bytes = toTSON(list)
  print(as.integer(bytes))
  object = fromTSON(bytes)
  expect_equal_list(object, list)
})

test_that("Simple map", {
  list = list(a=tson.character("a"), i=tson.int(42L), d=tson.double(42.0) )
  bytes = toTSON(list)
  print(as.integer(bytes))
  object = fromTSON(bytes)
  expect_equal_list(object, list)
})

test_that("Simple map of int32, float32 and float64 list", {
  list = list(i=42L, f=tson.float32.list(42.0) , d=as.double(42.0) )
  bytes = toTSON(list)
  print(as.integer(bytes))
  object = fromTSON(bytes)
  expect_equal_list(object, list)
})

test_that("All types", {
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
  expect_equal_list(object, list)
})


