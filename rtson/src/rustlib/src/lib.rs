// #[macro_use]
extern crate rustr;
extern crate rtsonlib;

pub mod export;

pub use rustr::*;

// #[rustr_export]
pub fn to_tson(object: SEXP) -> RResult<RawVec> {
    rtsonlib::to_tson(object)
}

// #[rustr_export]
pub fn from_tson(rbytes: RawVec) -> RResult<SEXP> {
    rtsonlib::from_tson(rbytes)
}

// #[rustr_export]
pub fn to_json(object: SEXP) -> RResult<String> {
    rtsonlib::to_json(object)
}

// #[rustr_export]
pub fn from_json(data: String) -> RResult<SEXP> {
    rtsonlib::from_json(&data)
}
