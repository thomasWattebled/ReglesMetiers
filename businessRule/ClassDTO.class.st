Class {
	#name : #ClassDTO,
	#superclass : #Object,
	#category : #businessRule
}

{ #category : #'as yet unclassified' }
ClassDTO >> deleteDTOAndGWTInName: aDTOList [

	| className |
	^ aDTOList collect: [ :c | 
		  className := c name asLowercase.
			className := className copyReplaceAll: 'dto' with: ''.
			className := className copyReplaceAll: 'gwt' with: ''. 
		 ]
]

{ #category : #'as yet unclassified' }
ClassDTO >> findDTO: aClassList [

	| blsp blp |
	blsp := (aClassList detect: [ :c | c name = 'BLLazyServerPojo' ])
		        subclassHierarchy.
	blp := (aClassList detect: [ :c | c name = 'BLLazyPojo' ])
		       subclassHierarchy.
	^ blsp union: blp
]
