Class {
	#name : #IDaoAccess,
	#superclass : #Object,
	#category : #businessRule
}

{ #category : #'as yet unclassified' }
IDaoAccess >> find: aMethodOrAClass externalTo: aInterface [

	| listMethod |
	aMethodOrAClass isMethod
		ifTrue: [ 
			aMethodOrAClass parentType = aInterface
				ifTrue: [ 
					listMethod := aMethodOrAClass queryAllIncoming withoutSelfLoops
						              atScope: FamixJavaClass.
					^ listMethod flatCollect: [ :each | 
						  self find: each externalTo: aInterface ] ]
				ifFalse: [ ^ { aMethodOrAClass } ] ]
		ifFalse: [ ^ { aMethodOrAClass superclass } ]
]

{ #category : #'as yet unclassified' }
IDaoAccess >> findExternalAccess: aInterface [

	^ aInterface queryAllIncoming withoutSelfLoops opposites flatCollect: [ 
		  :each | self find: each externalTo: aInterface  ]
]
