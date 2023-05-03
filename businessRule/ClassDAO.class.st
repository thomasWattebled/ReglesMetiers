Class {
	#name : #ClassDAO,
	#superclass : #Object,
	#category : #businessRule
}

{ #category : #'as yet unclassified' }
ClassDAO >> findDao: aClassList [

	| genericDao |
	genericDao := aClassList detect: [ :c | c name = 'GenericDAO' ].

	genericDao := genericDao parameterizedTypes.

	^ genericDao flatCollect: [ :c | 
		  c subInheritances collect: #subclass ]
]
