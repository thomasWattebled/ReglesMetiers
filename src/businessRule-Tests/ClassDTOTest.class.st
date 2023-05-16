Class {
	#name : #ClassDTOTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'runner',
		'aClass',
		'listClass',
		'BLLazyServerPojo',
		'BLLazyPojo',
		'NoSousClasseBLLazyPojo'
	],
	#category : #'businessRule-Tests'
}

{ #category : #'instance creation' }
ClassDTOTest >> newEntity: aClass named: aString [

	^ aClass new
		  name: aString;
		  mooseModel: model;
		  yourself
]

{ #category : #running }
ClassDTOTest >> setUp [

	super setUp.
	listClass := OrderedCollection new.
	model := FamixJavaModel new.
	runner := ClassDTO new.
	BLLazyServerPojo := self
		                    newEntity: FamixJavaClass
		                    named: 'BLLazyServerPojo'.
	BLLazyPojo := self newEntity: FamixJavaClass named: 'BLLazyPojo'.
	listClass add: BLLazyServerPojo.
	listClass add: BLLazyPojo
]

{ #category : #'instance creation' }
ClassDTOTest >> testFindDTO [

	| SousClassBLLazyPojo |
	SousClassBLLazyPojo := self
		                       newEntity: FamixJavaClass
		                       named: 'SousClassBLLazyPojo'.
	SousClassBLLazyPojo addSuperInheritance: (FamixJavaInheritance new
			 subclass: SousClassBLLazyPojo;
			 superclass: BLLazyServerPojo).

	self
		assertCollection: (runner findDTO: listClass)
		hasSameElements: { SousClassBLLazyPojo }
]

{ #category : #'instance creation' }
ClassDTOTest >> testFindDTOEmpty [

	self assert: (runner findDTO: listClass ) isEmpty
]
