Class {
	#name : #Analyser,
	#superclass : #Object,
	#category : #businessRule
}

{ #category : #'as yet unclassified' }
Analyser >> find: aClass in: aModel [

	^ aModel allModelClasses detect: [ :c | c name = aClass ]
]

{ #category : #'as yet unclassified' }
Analyser >> findparameterizableClass: aClassList [

	^aClassList select: [ :c | c class name = 'FamixJavaParameterizableClass' ].
]

{ #category : #'as yet unclassified' }
Analyser >> getAllName: aClassList [

	^ aClassList collect: [ :c | c name asLowercase  ]
]

{ #category : #'as yet unclassified' }
Analyser >> getAllReceiver: aListOfInvocations [
"analyseur getMethod: methodWithInvocation  using: alldto  "
	^ (aListOfInvocations flatCollect: [ :m | 
		   m outgoingInvocations collect: #receiver ]) asSet asArray
]

{ #category : #'as yet unclassified' }
Analyser >> getClass: aListOfClas using: aListOfClass [

	"analyseur getClass: listService using: alldto"

	| dict |
	dict := Dictionary new.
	aListOfClas do: [ :c | 
		| intermediaire resultat |
		intermediaire := self getMethodsWithInvocation: c.
		resultat := self getMethod: intermediaire using: aListOfClass.
		resultat notEmpty ifTrue: [ dict at: c put: resultat ] ].
	^ dict
]

{ #category : #'as yet unclassified' }
Analyser >> getClassAndSubclassNames: aClassList [

	|  result |
	result := OrderedCollection new.
	aClassList  do:  [ :c | result add:c.
									result addAll: c subclassHierarchy  ].
	^ result 
]

{ #category : #'as yet unclassified' }
Analyser >> getIService: aClass [

	| result |
	result := self getTypeEntitiesofList:  (self getInterface: aClass).
	^ result flatCollect: [ :c | self getInterface: c ]
]

{ #category : #'as yet unclassified' }
Analyser >> getInterface: aClass [

	^ aClass interfaceImplementations collect: #interface
]

{ #category : #'as yet unclassified' }
Analyser >> getInterfaceOfList: aListOfClass [

	^ aListOfClass flatCollect: [ :c |
		  self getInterface: c]

]

{ #category : #'as yet unclassified' }
Analyser >> getMethod: aListOfMethod using: aListOfClass [
"analyseur getMethod: methodWithInvocation  using: alldto  "
	^ aListOfMethod select: [ :m | 
		  | i1 |
		  i1 := m invokedMethods select: [ :c | 
			        | intermediaire |
			        intermediaire := c parentType.
			        aListOfClass includes: intermediaire ].
		  i1 notEmpty ]
]

{ #category : #'as yet unclassified' }
Analyser >> getMethodsReferences: aClass [

		^ aClass methods flatCollect: [ :m | 
		  m outgoingReferences collect: #referredType ]
]

{ #category : #'as yet unclassified' }
Analyser >> getMethodsWithInvocation: aClass [ 

	^ aClass methods select: [ :m | 
		  m outgoingInvocations
			  collect: #receiver;
			  notEmpty ]
]

{ #category : #'as yet unclassified' }
Analyser >> getSubClassOfListParameterizableClass: aListOfClass [

	^ aListOfClass  flatCollect: [ :p | p parameterizedTypes flatCollect:  [ :c | (c  subInheritances collect: #subclass)]].
]

{ #category : #'as yet unclassified' }
Analyser >> getTypeEntities: aClass [

	| interface |
	interface := self getInterface: aClass.
	^ (interface flatCollect: [ :i | 
		   i typedEntities flatCollect: [ :c | c atScope: FamixJavaClass ] ])
		  asSet
]

{ #category : #'as yet unclassified' }
Analyser >> getTypeEntitiesOFListIService: aListofService [

	| result |
	result := Dictionary new.
	aListofService do: [ :each | 
		result at: each put: (self getTypeEntities: each) ].
	^ result
]

{ #category : #'as yet unclassified' }
Analyser >> getTypeEntitiesofList: aClassList [

	^ (aClassList flatCollect: [ :s | 
		   s typedEntities flatCollect: [ :each | 
			   each atScope: FamixJavaClass ] ]) asSet
]

{ #category : #'as yet unclassified' }
Analyser >> getUc: aDaoClass [

	| intermediaire result |
	intermediaire := self getIService: aDaoClass.
	^ result := self getTypeEntitiesofList:  intermediaire
]
