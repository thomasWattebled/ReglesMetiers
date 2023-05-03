Class {
	#name : #DaoAccess,
	#superclass : #Object,
	#category : #businessRule
}

{ #category : #'as yet unclassified' }
DaoAccess >> find: aMethod externalTo: aClass [

	| listMethod |
	aMethod parentType = aClass
		ifTrue: [ 
			listMethod := aMethod queryAllIncoming withoutSelfLoops opposites.
			^listMethod flatCollect: [ :each | 
				self find: each externalTo: aClass ] ]
		ifFalse: [ ^ { aMethod } ]
]

{ #category : #'as yet unclassified' }
DaoAccess >> findExternalAccess: aClass [

	^ aClass  queryAllIncoming withoutSelfLoops opposites 
		  flatCollect: [ :each | self find: each externalTo: aClass  ]
]
