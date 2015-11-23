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
  expect_less(found,1e-06, label=label)
}

context("TSON test")

test_that("Empty list", {
   bytes = toTSON(list())
   print(as.integer(bytes))
})

test_that("Simple list", {
  bytes = toTSON(list(tson.scalar("a"), tson.scalar(as.integer(42)), tson.scalar(as.double(42.0)) ))
  print(as.integer(bytes))
})
 
test_that("Simple map", {
  bytes = toTSON(list(a=tson.scalar("a"), i=tson.scalar(as.integer(42)), d=tson.scalar(42.0) ))
  print(as.integer(bytes))
})

test_that("Simple map of int32, float32 and float64 list", {
  bytes = toTSON(list(i=as.integer(42), f=tson.float32(42.0) , d=as.double(42.0) ))
  print(as.integer(bytes))
})


 