Class {
	#name : #Uc,
	#superclass : #Object,
	#category : #businessRule
}

{ #category : #'as yet unclassified' }
Uc >> getIService: aClass [

	| result |
	result := self getTypeEntities: (self getInterface: aClass).
	^ result flatCollect: [ :c | self getInterface: c ]
]

{ #category : #'as yet unclassified' }
Uc >> getInterface: aClass [

	^ aClass interfaceImplementations collect: #interface.
]

{ #category : #'as yet unclassified' }
Uc >> getTypeEntities: aClassList [

	^ (aClassList flatCollect: [ :s | 
		   s typedEntities flatCollect: [ :each | 
			   each atScope: FamixJavaClass ] ]) asSet
]

{ #category : #'as yet unclassified' }
Uc >> getUc: aDaoClass [

	| intermediaire result |
	intermediaire := self getIService: aDaoClass.
	^ result := self getTypeEntities: intermediaire.
	
]
