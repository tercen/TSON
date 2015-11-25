| package |
package := Package name: 'TSON'.
package paxVersion: 1;
	basicComment: '
TSON encode: #() .
TSON encode: Dictionary new. 
TSON encode: #(nil) . 
TSON encode: #(''a'' true false 42 42.0) .  
 
TSON encode: (SDWORDArray withAll: #(42 42)) .
TSON encode: (CStringList withAll: #(''42.0'' ''42'')) .

aDict := Dictionary new.
aDict at: ''a'' put: ''a''.
aDict at: ''i'' put: 42.
aDict at: ''d'' put: 42.0.
 
TSON encode:  aDict.

aDict := Dictionary new.
aDict at: ''i'' put:  (SDWORDArray withAll: #(42)) .
aDict at: ''f'' put:  (FLOATArray withAll: #(42.0)) .
aDict at: ''d'' put:  (DOUBLEArray withAll: #(42.0)) .

TSON encode: aDict. 

aDict := Dictionary new.
aDict at: ''null'' put: nil. 
aDict at: ''string'' put: ''hello''.
aDict at: ''integer'' put: 42.
aDict at: ''float'' put: 42.0.
aDict at: ''bool_t'' put: true.
aDict at: ''bool_f'' put: false.
aDict at: ''map'' put:  (Dictionary new at: ''string'' put: ''42'' ; yourself).
aDict at: ''list'' put: (  (Array withAll: ( #(42 ''42''  nil #(''42'' 42)) )) at: 3 put:  (Dictionary new at: ''string'' put: ''42'' ; yourself) ; yourself) .
aDict at: ''uint8'' put: (ByteArray withAll: #(42 42)) .
aDict at: ''uint16'' put: (WORDArray withAll: #(42 42)) .
aDict at: ''uint32'' put: (DWORDArray withAll: #(42 42)) .
aDict at: ''int8'' put: (SignedByteArray withAll: #(-42 42)) .
aDict at: ''int16'' put: (SWORDArray withAll: #(42 42)) .
aDict at: ''int32'' put: (SDWORDArray withAll: #(42 42)) .
aDict at: ''int64'' put: nil.
aDict at: ''float32'' put: (FLOATArray withAll: #(42 42)) .
aDict at: ''float64'' put: (DOUBLEArray withAll: #(42 42)) .
aDict at: ''cstringlist'' put: (CStringList withAll: #(''42.0'' ''42'')).

TSON decode: (TSON encode: aDict) .   
'.


package classNames
	add: #CStringList;
	add: #SignedByteArray;
	add: #TSON;
	yourself.

package methodNames
	add: #WriteStream -> #nextDOUBLEPut:;
	yourself.

package globalNames
	add: #TSON_SPEC;
	yourself.

package binaryGlobalNames: (Set new
	yourself).

package globalAliases: (Set new
	yourself).

package setPrerequisites: (IdentitySet new
	add: '..\..\..\..\..\..\..\bin\Object Arts\Dolphin\Base\Dolphin';
	yourself).

package!

"Class Definitions"!

Object subclass: #CStringList
	instanceVariableNames: 'byteArray'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #TSON
	instanceVariableNames: 'writeStream byteArray offset'
	classVariableNames: ''
	poolDictionaries: 'TSON_SPEC'
	classInstanceVariableNames: ''!
ByteArray variableByteSubclass: #SignedByteArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

"Global Aliases"!


"Loose Methods"!

!WriteStream methodsFor!

nextDOUBLEPut: aFloat 
	"Append a 64-bit IEEE floating point value 
	as the next 8 bytes on the receiver."

	#TSONadded.
	self nextPutAll: ((ByteArray new: 8)
				doubleAtOffset: 0 put: aFloat;
				yourself).
	^aFloat! !
!WriteStream categoriesFor: #nextDOUBLEPut:!public! !

"End of package definition"!

"Source Globals"!

Smalltalk at: #TSON_SPEC put: (PoolConstantsDictionary named: #TSON_SPEC)!
TSON_SPEC at: 'BOOL_TYPE' put: 16r4!
TSON_SPEC at: 'DOUBLE_TYPE' put: 16r3!
TSON_SPEC at: 'INTEGER_TYPE' put: 16r2!
TSON_SPEC at: 'LIST_FLOAT32_TYPE' put: 16r6E!
TSON_SPEC at: 'LIST_FLOAT64_TYPE' put: 16r6F!
TSON_SPEC at: 'LIST_INT16_TYPE' put: 16r68!
TSON_SPEC at: 'LIST_INT32_TYPE' put: 16r69!
TSON_SPEC at: 'LIST_INT64_TYPE' put: 16r6A!
TSON_SPEC at: 'LIST_INT8_TYPE' put: 16r67!
TSON_SPEC at: 'LIST_STRING_TYPE' put: 16r70!
TSON_SPEC at: 'LIST_TYPE' put: 16rA!
TSON_SPEC at: 'LIST_UINT16_TYPE' put: 16r65!
TSON_SPEC at: 'LIST_UINT32_TYPE' put: 16r66!
TSON_SPEC at: 'LIST_UINT8_TYPE' put: 16r64!
TSON_SPEC at: 'MAP_TYPE' put: 16rB!
TSON_SPEC at: 'NULL_TYPE' put: 16r0!
TSON_SPEC at: 'STRING_TYPE' put: 16r1!
TSON_SPEC at: 'TSON_SPEC_VERSION' put: '1.1.0'!
TSON_SPEC shrink!

"Classes"!

CStringList guid: (GUID fromString: '{5EB6B51E-D59E-4760-AB2A-907BFABC5E72}')!
CStringList comment: ''!
!CStringList categoriesForClass!Unclassified! !
!CStringList methodsFor!

asByteArray
	^byteArray!

initializeFromBytes: aByteArray 
	byteArray := aByteArray!

initializeFromList: aList 
	| writeStream |
	writeStream := ByteArray writeStream.
	aList do: 
			[:each | 
			writeStream
				nextPutAll: each asByteArray;
				nextPut: 0].
	byteArray := writeStream contents!

lengthInBytes
	^byteArray size! !
!CStringList categoriesFor: #asByteArray!public! !
!CStringList categoriesFor: #initializeFromBytes:!public! !
!CStringList categoriesFor: #initializeFromList:!public! !
!CStringList categoriesFor: #lengthInBytes!public! !

!CStringList class methodsFor!

fromBytes: byteArray 
	^(self new)
		initializeFromBytes: byteArray;
		yourself!

withAll: anArrayOfString 
	^(self new)
		initializeFromList: anArrayOfString;
		yourself! !
!CStringList class categoriesFor: #fromBytes:!public! !
!CStringList class categoriesFor: #withAll:!public! !

TSON guid: (GUID fromString: '{1C23EC45-5BE2-41A2-81A9-06C97AF16512}')!
TSON comment: ''!
!TSON categoriesForClass!Kernel-Objects! !
!TSON methodsFor!

addBool: anObject 
	| anInteger |
	self addType: BOOL_TYPE.
	anInteger := anObject ifTrue: [1] ifFalse: [0].
	writeStream nextPut: anInteger!

addCollection: mapOrList 
	self addType: LIST_TYPE.
	self addLength: mapOrList size.
	mapOrList do: [:eachValue | self addObject: eachValue]!

addDouble: anObject 
	"TSON spec : scalar float is double"

	self addType: DOUBLE_TYPE.
	writeStream nextDOUBLEPut: anObject!

addInteger: anObject 
	self addType: INTEGER_TYPE.
	writeStream nextSDWORDPut: anObject!

addLength: anInteger 
	writeStream nextDWORDPut: anInteger!

addMap: mapOrList 
	self addType: MAP_TYPE.
	self addLength: mapOrList size.
	mapOrList keysAndValuesDo: 
			[:eachKey :eachValue | 
			(eachKey isKindOf: String) ifFalse: [self error: 'Map keys must be string'].
			self addString: eachKey.
			self addObject: eachValue]!

addNull
	self addType: NULL_TYPE.!

addObject: anObject 
	anObject ifNil: [^self addNull].
	(anObject isKindOf: String) ifTrue: [^self addString: anObject].
	(anObject isKindOf: Integer) ifTrue: [^self addInteger: anObject].
	(anObject isKindOf: Float) ifTrue: [^self addDouble: anObject].
	(anObject isKindOf: Boolean) ifTrue: [^self addBool: anObject].
	(anObject isKindOf: Dictionary) ifTrue: [^self addMap: anObject].
	(anObject isKindOf: ByteArray) ifTrue: [^self addTypedArray: anObject].
	(anObject isKindOf: Collection) ifTrue: [^self addCollection: anObject].
	^self addTypedArray: anObject!

addRootObject: anObject 
	(anObject isKindOf: Dictionary) ifTrue: [^self addMap: anObject].
	(anObject isKindOf: ByteArray) ifTrue: [^self addTypedArray: anObject].
	(anObject isKindOf: Collection) ifTrue: [^self addCollection: anObject].
	^self addTypedArray: anObject!

addString: aString 
	self addType: STRING_TYPE.
	writeStream
		nextPutAll: aString asByteArray;
		nextPut: 0!

addTsonSpecVersion
	self addString: TSON_SPEC_VERSION!

addType: aType 
	writeStream nextPut: aType!

addTypedArray: anObject 
	| type len |
	(anObject isKindOf: ByteArray) ifTrue: [type := LIST_UINT8_TYPE].
	(anObject isKindOf: SignedByteArray) ifTrue: [type := LIST_INT8_TYPE].
	(anObject isKindOf: WORDArray) ifTrue: [type := LIST_UINT16_TYPE].
	(anObject isKindOf: SWORDArray) ifTrue: [type := LIST_INT16_TYPE].
	(anObject isKindOf: DWORDArray) ifTrue: [type := LIST_UINT32_TYPE].
	(anObject isKindOf: SDWORDArray) ifTrue: [type := LIST_INT32_TYPE].
	(anObject isKindOf: FLOATArray) ifTrue: [type := LIST_FLOAT32_TYPE].
	(anObject isKindOf: DOUBLEArray) ifTrue: [type := LIST_FLOAT64_TYPE].
	(anObject isKindOf: CStringList) ifTrue: [type := LIST_STRING_TYPE].
	type ifNil: [self error: 'Unknown object type'].
	self addType: type.
	len := (anObject isKindOf: CStringList) ifTrue: [anObject lengthInBytes] ifFalse: [anObject size].
	self addLength: len.
	writeStream nextPutAll: anObject asByteArray!

decode: aByteArray 
	| version object |
	offset := 0.
	byteArray := aByteArray.
	version := self readObject.
	version = TSON_SPEC_VERSION 
		ifFalse: 
			[self error: 'TSONspecification version mismatch, found ' , version displayString , ' expected ' 
						, TSON_SPEC_VERSION].
	object := self readObject.
	byteArray := nil.
	offset := nil.
	^object!

encode: mapOrList 
	| answer |
	writeStream := ByteArray writeStream.
	self addTsonSpecVersion.
	self addRootObject: mapOrList.
	answer := writeStream contents.
	writeStream := nil.
	^answer!

readBool
	| answer |
	answer := byteArray byteAtOffset: offset.
	offset := offset + 1.
	^answer > 0!

readDouble
	| answer |
	answer := byteArray doubleAtOffset: offset.
	offset := offset + 8.
	^answer!

readDoubleList
	| answer len |
	len := self readLength.
	answer := DOUBLEArray new: len.
	byteArray 
		replaceBytesOf: answer bytes
		from: 1
		to: answer bytes size
		startingAt: offset + 1.
	offset := offset + answer bytes size.
	^answer!

readFloatList
	| answer len |
	len := self readLength.
	answer := FLOATArray new: len.
	byteArray 
		replaceBytesOf: answer bytes
		from: 1
		to: answer bytes size
		startingAt: offset + 1.
	offset := offset + answer bytes size.
	^answer!

readInt16List
	| answer len |
	len := self readLength.
	answer := SWORDArray new: len.
	byteArray 
		replaceBytesOf: answer bytes
		from: 1
		to: answer bytes size
		startingAt: offset + 1.
	offset := offset + answer bytes size.
	^answer!

readInt32List
	| answer len |
	len := self readLength.
	answer := SDWORDArray new: len.
	byteArray 
		replaceBytesOf: answer bytes
		from: 1
		to: answer bytes size
		startingAt: offset + 1.
	offset := offset + answer bytes size.
	^answer!

readInt64List
	^Error notYetImplemented!

readInt8List
	| len bytes |
	len := self readLength.
	bytes := (byteArray copyFrom: offset + 1 to: offset + (len * 1)) becomeA: SignedByteArray.
	offset := offset + bytes size.
	^bytes!

readInteger
	| answer |
	answer := byteArray sdwordAtOffset: offset.
	offset := offset + 4.
	^answer!

readLength
	| answer |
	answer := byteArray dwordAtOffset: offset.
	offset := offset + 4.
	^answer!

readList
	| len list |
	len := self readLength.
	list := Array new: len.
	1 to: len do: [:i | list at: i put: self readObject].
	^list!

readMap
	| len dic |
	len := self readLength.
	dic := Dictionary new.
	1 to: len
		do: 
			[:i | 
			| k |
			k := self readObject.
			dic at: k put: self readObject].
	^dic!

readObject
	| type |
	type := self readType.
	type = NULL_TYPE ifTrue: [^nil].
	type = STRING_TYPE ifTrue: [^self readString].
	type = INTEGER_TYPE ifTrue: [^self readInteger].
	type = DOUBLE_TYPE ifTrue: [^self readDouble].
	type = BOOL_TYPE ifTrue: [^self readBool].
	type = LIST_TYPE ifTrue: [^self readList].
	type = MAP_TYPE ifTrue: [^self readMap].
	type = LIST_UINT8_TYPE ifTrue: [^self readUint8List].
	type = LIST_UINT16_TYPE ifTrue: [^self readUint16List].
	type = LIST_UINT32_TYPE ifTrue: [^self readUint32List].
	type = LIST_INT8_TYPE ifTrue: [^self readInt8List].
	type = LIST_INT16_TYPE ifTrue: [^self readInt16List].
	type = LIST_INT32_TYPE ifTrue: [^self readInt32List].
	type = LIST_INT64_TYPE ifTrue: [^self readInt64List].
	type = LIST_FLOAT32_TYPE ifTrue: [^self readFloatList].
	type = LIST_FLOAT64_TYPE ifTrue: [^self readDoubleList].
	type = LIST_STRING_TYPE ifTrue: [^self readStringList].
	self error: 'unknown objec type ' , type displayString!

readString
	| answer start |
	start := offset.
	[(byteArray byteAtOffset: offset) = 0] whileFalse: [offset := offset + 1].
	answer := byteArray copyStringFrom: start + 1 to: offset.
	offset := offset + 1.
	^answer!

readStringList
	| answer lengthInBytes bytes |
	lengthInBytes := self readLength.
	bytes := byteArray copyFrom: offset + 1 to: offset + lengthInBytes.
	answer := CStringList fromBytes: bytes.
	offset := offset + lengthInBytes.
	^answer!

readType
	| answer |
	answer := byteArray byteAtOffset: offset.
	offset := offset + 1.
	^answer!

readUint16List
	| answer len |
	len := self readLength.
	answer := WORDArray new: len.
	byteArray 
		replaceBytesOf: answer bytes
		from: 1
		to: answer bytes size
		startingAt: offset + 1.
	offset := offset + answer bytes size.
	^answer!

readUint32List
	| answer len |
	len := self readLength.
	answer := DWORDArray new: len.
	byteArray 
		replaceBytesOf: answer bytes
		from: 1
		to: answer bytes size
		startingAt: offset + 1.
	offset := offset + answer bytes size.
	^answer!

readUint8List
	| len bytes |
	len := self readLength.
	bytes := byteArray copyFrom: offset + 1 to: offset + (len * 1).
	offset := offset + bytes size.
	^bytes! !
!TSON categoriesFor: #addBool:!private! !
!TSON categoriesFor: #addCollection:!private! !
!TSON categoriesFor: #addDouble:!private! !
!TSON categoriesFor: #addInteger:!private! !
!TSON categoriesFor: #addLength:!private! !
!TSON categoriesFor: #addMap:!private! !
!TSON categoriesFor: #addNull!private! !
!TSON categoriesFor: #addObject:!private! !
!TSON categoriesFor: #addRootObject:!private! !
!TSON categoriesFor: #addString:!private! !
!TSON categoriesFor: #addTsonSpecVersion!private! !
!TSON categoriesFor: #addType:!private! !
!TSON categoriesFor: #addTypedArray:!private! !
!TSON categoriesFor: #decode:!public! !
!TSON categoriesFor: #encode:!public! !
!TSON categoriesFor: #readBool!public! !
!TSON categoriesFor: #readDouble!public! !
!TSON categoriesFor: #readDoubleList!public! !
!TSON categoriesFor: #readFloatList!public! !
!TSON categoriesFor: #readInt16List!public! !
!TSON categoriesFor: #readInt32List!public! !
!TSON categoriesFor: #readInt64List!public! !
!TSON categoriesFor: #readInt8List!public! !
!TSON categoriesFor: #readInteger!public! !
!TSON categoriesFor: #readLength!public! !
!TSON categoriesFor: #readList!public! !
!TSON categoriesFor: #readMap!public! !
!TSON categoriesFor: #readObject!public! !
!TSON categoriesFor: #readString!public! !
!TSON categoriesFor: #readStringList!public! !
!TSON categoriesFor: #readType!public! !
!TSON categoriesFor: #readUint16List!public! !
!TSON categoriesFor: #readUint32List!public! !
!TSON categoriesFor: #readUint8List!public! !

!TSON class methodsFor!

decode: byteArray 
	^self new decode: byteArray!

encode: mapOrList 
	^self new encode: mapOrList! !
!TSON class categoriesFor: #decode:!public! !
!TSON class categoriesFor: #encode:!public! !

SignedByteArray guid: (GUID fromString: '{A66FD7BF-6F8B-4ECA-8F59-10ECA43634DB}')!
SignedByteArray comment: ''!
!SignedByteArray categoriesForClass!Collections-Arrayed! !
!SignedByteArray methodsFor!

at: index 
	| answer |
	answer := super at: index.
	^answer > 127 ifTrue: [answer - 256] ifFalse: [answer]!

at: index put: newElement 
	| answer |
	newElement < -128 ifTrue: [self error: 'can not hold ' , newElement displayString].
	newElement > 127 ifTrue: [self error: 'can not hold ' , newElement displayString].
	answer := newElement < 0 ifTrue: [256 + newElement] ifFalse: [newElement].
	super at: index put: answer! !
!SignedByteArray categoriesFor: #at:!accessing!public! !
!SignedByteArray categoriesFor: #at:put:!accessing!public! !

"Binary Globals"!

