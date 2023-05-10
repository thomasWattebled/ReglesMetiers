Class {
	#name : #Service,
	#superclass : #Object,
	#category : #businessRule
}

{ #category : #'as yet unclassified' }
Service >> findIN: aModel service: aService [

	^ aModel  allModelClasses  detect: [ :c | c name = aService].
]

{ #category : #'as yet unclassified' }
Service >> getAllReceiver: aListOfInvocations [

	^ (aListOfInvocations flatCollect: [ :m | m outgoingInvocations collect:#receiver]) asSet asArray.
]

{ #category : #'as yet unclassified' }
Service >> getInterface: aService [

	^ aService interfaceImplementations collect: #interface
]

{ #category : #'as yet unclassified' }
Service >> getMethodsReferences: aListOfMethods [

	^ aListOfMethods  flatCollect: [ :m | m outgoingReferences collect:#referredType].
]

{ #category : #'as yet unclassified' }
Service >> getMethodsWithInvocation: aListOfMethods [

	^ aListOfMethods select: [ :m | 
		  m outgoingInvocations
			  collect: #receiver;
			  notEmpty ]
]

{ #category : #'as yet unclassified' }
Service >> getTypeEntitiesOFIService: aService [

	^ ((self getInterface: aService) flatCollect: [ :c | 
		   c typedEntities flatCollect: [ :each | each atScope: FamixJavaClass ] ])
		  asSet
]

{ #category : #'as yet unclassified' }
Service >> getTypeEntitiesOFListIService: aListofService [

	| result | 
	result:= Dictionary new.
	aListofService do: [ :each | result at:each put: (self getTypeEntitiesOFIService: each)].
	^ result
]
