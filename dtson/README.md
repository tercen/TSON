# TSON

JSON like format for binary serialization. Handle typed data.

# Specification Version 1.0.0

TSON is a binary format in which zero or more key/value pairs are stored as a single entity. We call this entity a document.

The following grammar specifies version 1.0.0 of the TSON standard.
We've written the grammar using a pseudo-BNF syntax.
Valid TSON data is represented by the document non-terminal.

# Basic Types

The following basic types are used as terminals in the rest of the grammar.
Each type must be serialized in little-endian format.

uint8	1 byte (8-bit unsigned integer)
uint16   2 bytes (16-bit unsigned integer)
uint32	4 bytes (32-bit unsigned integer)

int8	1 byte (8-bit signed integer)
int16   2 bytes (16-bit signed integer)
int32   2 bytes (32-bit signed integer)
int64	8 bytes (64-bit signed integer, two's complement)

float32	4 bytes (32-bit IEEE 754-2008 binary floating point)
float64	8 bytes (64-bit IEEE 754-2008 binary floating point)

# Non-terminals

The following specifies the rest of the TSON grammar.
Note that we use the * operator as shorthand for repetition (e.g. ("\x01"*2) is "\x01\x01").
When used as a unary operator, * means that the repetition can occur 0 or more times.

document ::= cstring map_list      TSON Document. cstring is the version of the specification.

map_list ::= map | list
list ::= "\x0A" uint32 (element*)     "\x0A" is the code type for list element. uint32 is the length of the list
map ::= "\x0B" uint32 (key_value*)    "\x0B" is the code type for map element. uint32 is the length of the map
key_value ::= cstring element
element ::= map_list
           | integer
           | double
           | bool
           | cstring
           | uint8_list
           | uint16_list
           | uint32_list
           | int8_list
           | int16_list
           | int32_list
           | int64_list
           | float32_list
           | float64_list

cstring	::=	"\x00" (uint8*) "\x00"           First "\x00" is the code type for cstring element
integer ::= "\x01" int32
double ::= "\x02" float64
bool ::= "\x03" uint8

uint8_list ::= "\x64" uint32 (uint8*)
uint16_list ::= "\x65" uint32 (uint16*)
uint32_list ::= "\x66" uint32 (uint32*)
int8_list ::= "\x67" uint32 (int8*)
int16_list ::= "\x68" uint32 (int16*)
int32_list ::= "\x69" uint32 (int32*)
int64_list ::= "\x6A" uint32 (int64*)
float32_list ::= "\x6E" uint32 (float32*)
float64_list ::= "\x6F" uint32 (float64*)