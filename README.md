Swift Extended Library is aiming to offer native Swift alternatives to Cocoa/CocoaTouch and missing conveniences in standard Swift library.

#Get Started
- Download Swift Extended Library
- Drag Swift Extended Library’s Xcode project file to your workspace
- Add Swift Extended Library to your`Emebed Binaries`  field in your target’s general page if you are building an app. Or add Swift Extended Library to your `Linked Frameworks and Libraries` field in your target’s general page if you are building a framework.
- Add `import SwiftExt` to your Swift source file
- Enjoy your journey of Swift Extended Library

#Contents
##New Operators
####`^`: 
Logical exclusive-or operator.
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
To traverse all occurred or not occurred options in a `RawOptionSetType` conformed type value.
####`setValue<V, B: RawOptionSetType where B.RawValue == UInt>(value: V, forBitmask bitmask: B, inout inDictionary dictionary: Dictionary<UInt, V>)`
To set a value in a dictionary with a given `RawOptionSetType` conformed type value.
####`getValueForBitmask<V, B: RawOptionSetType where B.RawValue == UInt>(bitmask: B, inDictionary dictionary: [UInt: V]) -> V?`
To get the value in a dictionary with a given `RawOptionSetType` conformed type value.

#License
Swift Extended Library is available under the MIT license. See the LICENSE file for more info.

