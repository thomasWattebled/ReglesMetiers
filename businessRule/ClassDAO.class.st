Class {
	#name : #ClassDAO,
	#superclass : #Object,
	#category : #businessRule
}

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
