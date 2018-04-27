#[macro_use]
extern crate rustr;
extern crate rustson;

pub mod export;
pub use rustr::*;
pub use rustson::*;

use std::io::Cursor;

// #[rustr_export]
pub fn from_tson(rbytes: RawVec) -> RResult<SEXP> {
    let mut bytes: Vec<u8> = Vec::new();

    for b in rbytes.into_iter() {
        bytes.push(b);
    }

    match decode(Cursor::new(&bytes)) {
        Ok(ref object) => value_to_r(object),
        Err(ref e) => Err(RError::unknown(e.clone())),
    }
}

fn value_to_r(value: &Value) -> RResult<SEXP> {
    match *value {
        Value::NULL => ().intor(),
        Value::STR(ref v) => v.intor(),
        Value::I32(v) => v.intor(),
        Value::F64(v) => v.intor(),
        Value::BOOL(v) => v.intor(),
        Value::LST(ref v) => {
            let mut lst = RList::alloc(v.len());
            let mut i = 0;
            for obj in v.iter() {
                lst.set(i, value_to_r(obj)?);
                i += 1;
            }
            lst.intor()
        }
        Value::MAP(ref v) => {
            let mut names = CharVec::alloc(v.len());
            let mut values = RList::alloc(v.len());
            let mut i = 0;
            for (k,v) in v.iter() {
                names.set(i, k);
                values.set(i, value_to_r(v)?);
                i += 1;
            }

            unsafe {
                Rf_setAttrib(values.s(), R_NamesSymbol, names.s());
            }
            values.intor()
        }
        Value::LSTU8(ref v) => v.intor(),
        Value::LSTI8(ref v) => v.intor(),
        Value::LSTU16(ref v) => v.intor(),
        Value::LSTI16(ref v) => v.intor(),
        Value::LSTU32(ref v) => v.intor(),
        Value::LSTI32(ref v) => v.intor(),
        Value::LSTU64(ref v) => v.intor(),
        Value::LSTI64(ref v) => v.intor(),
        Value::LSTF32(ref v) => v.intor(),
        Value::LSTF64(ref v) => v.intor(),
        Value::LSTSTR(ref v) => v.intor(),
    }
}
