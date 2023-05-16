Class {
	#name : #ClassDAO,
	#superclass : #Analyser,
	#category : #businessRule
}

{ #category : #'as yet unclassified' }
ClassDAO >> dao: aListOfDao invokeMethod: method [

	| result |
	result := OrderedCollection new.
	aListOfDao collect: [ :class | 
		| intermediaire |
		intermediaire := self invokedMethodsIn: class.
		intermediaire select: [ :m | m name=method  ].
		intermediaire notEmpty 
		ifTrue: [ result add: class ]  ].
	^result
]

{ #category : #'as yet unclassified' }
ClassDAO >> dao: aListOfDao notInvokeMethod: aMethod or: aAnotherMethod [

	| dict |
	dict := Dictionary new.
	aListOfDao collect: [ :class | 
		| intermediaire |
		intermediaire := self
			                 notInvokedMethodsIn: class
			                 method: aMethod
			                 or: aAnotherMethod.
		intermediaire notEmpty ifTrue: [ dict at: class put: intermediaire  ] ].
	^ dict
]

{ #category : #'as yet unclassified' }
ClassDAO >> dao: aListOfDao using: aListClass [

	| result dict |
	dict := Dictionary new.
	aListOfDao collect: [ :class | 
		| intermediaire |
		intermediaire := self reference: class.
		result := intermediaire intersection: aListClass.
		result notEmpty ifTrue: [ dict at: class put: result ] ].
	^ dict select: [ :valeur | valeur notEmpty ]
]

{ #category : #'as yet unclassified' }
ClassDAO >> deleteDAOInName: aDAOList [

	| className |
	^ aDAOList collect: [ :c | 
		  className := c name asLowercase copyReplaceAll: 'dao' with: '' ]
]

{ #category : #'as yet unclassified' }
ClassDAO >> findAllService: aListOfClass [

	"| result |
	result := OrderedCollection new.
	aListOfClass collect: [ :c | 
		| intermediaire |
		intermediaire := self findService: c.
		result addAll: intermediaire ].
	^ result"
]

{ #category : #'as yet unclassified' }
ClassDAO >> findClassImplementing: method in: aClassList [

^ aClassList select: [ :c | (c methods select: [:m | m name= method]) notEmpty.].
]

{ #category : #'as yet unclassified' }
ClassDAO >> findDao: aClassList [

	| genericDao |
	genericDao := aClassList detect: [ :c | c name = 'GenericDAO' ].

	genericDao := genericDao parameterizedTypes.

	^ genericDao flatCollect: [ :c | 
		  c subInheritances collect: #subclass ]
]

{ #category : #'as yet unclassified' }
ClassDAO >> findService: aClass [

"	| interface |
	interface := aClass interfaceImplementations collect: #interface.
	^ (interface flatCollect: [ :i | 
		   i typedEntities flatCollect: [ :c | c atScope: FamixJavaClass ] ])
		  asSet"
]

{ #category : #'as yet unclassified' }
ClassDAO >> invokedMethodsIn: aClass [

	^ aClass methods flatCollect: #invokedMethods
]

{ #category : #'as yet unclassified' }
ClassDAO >> notInvokedMethodsIn: aClass method: amethod or: anothermethod [

	^ aClass methods reject: [ :m | 
		  | intermediaire |
		  intermediaire := m invokedMethods anySatisfy: [ :n | 
			                   n name = amethod or: n name = anothermethod ] ]
]

{ #category : #'as yet unclassified' }
ClassDAO >> reference: aClass [

	| intermediaire |
	intermediaire := aClass methods flatCollect: #outgoingReferences.
	^ intermediaire collect: [ :c | c referredType ]
]
