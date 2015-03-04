Swift Extended Library is aiming to offer native Swift alternatives to Cocoa/CocoaTouch and missing conveniences in standard Swift library.

#Get Started
- Download Swift Extended Library
- Add `import SwiftExt` to your Swift source file
- Enjoy your journey of Swift Extended Library

#Contents
##New Operators
####`^^`: 
To calculate the power to a given `Int` value, function definition: `func ^^(var base: Int, var exponent: Int) -> Int`.

##New Types
####`SequenceDifference`:
Indicates differences between two sequences.
####`OptionSetTraversalOptions`:
Indicates how to traverse a `RawOptionSetType` conformed Swift type.

##New Functions
####`func contains<S : SequenceType where S.Generator.Element : Equatable>(containerSeq: S, containedSeq: S) -> Bool`:
To check if a sequence whose generator’s element type conformed to `Equatable` protocol contains another.
####`func containsObject<S : SequenceType where S.Generator.Element : AnyObject>(domain: S, value: S.Generator.Element) -> Bool`:
To check if a sequence of object contains an object.
####`containsObjects<S : SequenceType where S.Generator.Element : AnyObject>(containerSeq: S, containedSeq: S) -> Bool`:
To check if a sequence of object contains another.
####`findObject<C : CollectionType where C.Generator.Element : AnyObject>(domain: C, value: C.Generator.Element) -> C.Index?`:
To find the index for a given object in a sequence of object. Return nil if the given object were not contained in the sequence.
####`intersects<S : SequenceType where S.Generator.Element : Equatable>(seqA: S, seqB: S) -> Bool`:
To check if a sequence whose generator’s element type conformed to `Equatable` protocol intersects with another.
####`intersected<C : ExtensibleCollectionType where C.Generator.Element : Equatable>(collectionA: C, collectionB: C) -> C`:
To check if a collection conformed to `ExtensibleCollectionType` protocol whose generator’s element type conformed to `Equatable` protocol intersects with another.
####`func diff<Seq: SequenceType where Seq.Generator.Element : Equatable> (from fromSequence: Seq?, to toSequence: Seq?, #differences: SequenceDifference, usingClosure changesHandler: (change: SequenceDifference, fromElement: (index: Int, element: Seq.Generator.Element)?, toElement: (index: Int, element: Seq.Generator.Element)?) -> Void)`:
To get the difference between two sequence whose elements conformed to `Equatable` protocol.
####`func diff<Seq: SequenceType> (from fromSequence: Seq?, to toSequence: Seq?, #differences: SequenceDifference, #equalComparator: ((Seq.Generator.Element, Seq.Generator.Element) -> Bool), #unchangedComparator: ((Seq.Generator.Element, Seq.Generator.Element) -> Bool), usingClosure changesHandler: (change: SequenceDifference, fromElement: (index: Int, element: Seq.Generator.Element)?, toElement: (index: Int, element: Seq.Generator.Element)?) -> Void)`:
To get the difference between two sequence by using custom equality and unchange judging handler.
####`enumerate<T: RawOptionSetType where T.RawValue == UInt>(optionSet: T, withOptions options: OptionSetTraversalOptions, usingClosure handler:(optionSet: T, option: T) -> Bool )`:
To traverse all the options in a `RawOptionSetType` conformed type.

#License
Swift Extended Library is available under the MIT license. See the LICENSE file for more info.

