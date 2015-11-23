# TSON

TSON, short for Typed JSON, is a binary-encoded serialization of JSON-like document that support javascript typed data.

# Specification Version 1.1.0

TSON is a binary format in which zero or more key/value pairs are stored as a single entity. We call this entity a document.

The following grammar specifies version 1.1.0 of the TSON standard.
We've written the grammar using a pseudo-BNF syntax.
Valid TSON data is represented by the document non-terminal.

# Changes
## 1.1.0
- add type null : null ::= "\x00"
- change type code for cstring, integer, double and bool types
- add type cstring_list : cstring_list ::= "\x70" list_length (cstring*)
- add 

# Basic Types

The following basic types are used as terminals in the rest of the grammar.
Each type must be serialized in little-endian format.

```
uint8	1 byte (8-bit unsigned integer)
uint16   2 bytes (16-bit unsigned integer)
uint32	4 bytes (32-bit unsigned integer)

int8	1 byte (8-bit signed integer)
int16   2 bytes (16-bit signed integer)
int32   2 bytes (32-bit signed integer)
int64	8 bytes (64-bit signed integer, two's complement)

float32	4 bytes (32-bit IEEE 754-2008 binary floating point)
float64	8 bytes (64-bit IEEE 754-2008 binary floating point)
```

# Non-terminals

The following specifies the rest of the TSON grammar.
Note that we use the * operator as shorthand for repetition (e.g. ("\x01"*2) is "\x01\x01").
When used as a unary operator, * means that the repetition can occur 0 or more times.

```
document ::= version map_list      TSON Document. cstring is the version of the specification.

map_list ::= map | list | uint8_list | uint16_list | uint32_list | int8_list | int16_list | int32_list | float32_list | float64_list | cstring_list
list ::= "\x0A" uint32 (element*)     "\x0A" is the code type for list element. uint32 is the length of the list
map ::= "\x0B" uint32 (key_value*)    "\x0B" is the code type for map element. uint32 is the length of the map
key_value ::= cstring element
element ::= map_list
	   | null 
           | integer
           | double
           | bool
           | cstring
	   | cstring_list
           | uint8_list
           | uint16_list
           | uint32_list
           | int8_list
           | int16_list
           | int32_list
           | int64_list
           | float32_list
           | float64_list

version ::= cstring
null ::= "\x00"
cstring	::= "\x01" (uint8*) null           First "\x00" is the code type for cstring element
integer ::= "\x02" int32
double ::= "\x03" float64
bool ::= "\x04" uint8

list_length ::= uint32
list_length_in_bytes ::= uint32
 
uint8_list ::= "\x64" list_length (uint8*)
uint16_list ::= "\x65" list_length (uint16*)
uint32_list ::= "\x66" list_length (uint32*)
int8_list ::= "\x67" list_length (int8*)
int16_list ::= "\x68" list_length (int16*)
int32_list ::= "\x69" list_length (int32*)
int64_list ::= "\x6A" list_length (int64*)
float32_list ::= "\x6E" list_length (float32*)
float64_list ::= "\x6F" list_length (float64*)
cstring_list ::= "\x70" list_length_in_bytes (cstring*)
```
