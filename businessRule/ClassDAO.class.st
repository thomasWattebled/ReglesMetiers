Class {
	#name : #ClassDAO,
	#superclass : #Object,
	#category : #businessRule
}

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
ClassDAO >> findDao: aClassList [

	| genericDao |
	genericDao := aClassList detect: [ :c | c name = 'GenericDAO' ].

	genericDao := genericDao parameterizedTypes.

	^ genericDao flatCollect: [ :c | 
		  c subInheritances collect: #subclass ]
]

{ #category : #'as yet unclassified' }
ClassDAO >> reference: Dao [
	| intermediaire |
	intermediaire := Dao methods flatCollect: #outgoingReferences.
	^ intermediaire collect: [ :c |c referredType  ]
]
