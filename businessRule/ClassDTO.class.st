Class {
	#name : #ClassDTO,
	#superclass : #Object,
	#category : #businessRule
}

{ #category : #'as yet unclassified' }
ClassDTO >> findDTO: aClassList [

	| blsp blp |
	blsp := (aClassList detect: [ :c | c name = 'BLLazyServerPojo' ])
		        subclassHierarchy.
	blp := (aClassList detect: [ :c | c name = 'BLLazyPojo' ])
		       subclassHierarchy.
	^ blsp union: blp
]
