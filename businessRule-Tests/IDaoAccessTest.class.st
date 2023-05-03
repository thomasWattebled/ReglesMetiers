Class {
	#name : #IDaoAccessTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'runner',
		'aInterface',
		'aMethod',
		'aClass'
	],
	#category : #'businessRule-Tests'
}

{ #category : #'instance creation' }
IDaoAccessTest >> newEntity: ainterface named: aString [

	^ ainterface new
		  name: aString;
		  mooseModel: model;
		  yourself
]

{ #category : #initialization }
IDaoAccessTest >> setUp [

	super setUp.

	model := FamixJavaModel new.
	runner := IDaoAccess new.

	aInterface := self newEntity: FamixJavaInterface named: 'IDAO'.
	aMethod := self newEntity: FamixJavaMethod named: 'daoMethod'.
	aClass := self newEntity: FamixJavaClass named: 'Dao'.
	FamixJavaReference new
		referencer: aMethod;
		referredType: aInterface.
	FamixJavaReference new 
		referencer: aMethod;
		referredType: aClass 
]

{ #category : #tests }
IDaoAccessTest >> testFindExternalTo [

	self
		assertCollection: (runner findExternalAccess: aInterface )
		hasSameElements: { aMethod }
]

{ #category : #tests }
IDaoAccessTest >> testFindExternalToNone [

	aMethod parentType: aInterface.

	self assert: (runner findExternalAccess: aInterface) isEmpty
]

{ #category : #tests }
IDaoAccessTest >> testFindExternalToOutside [

	| outSideMethod |
	outSideMethod := self
		                 newEntity: FamixJavaMethod
		                 named: 'outsideMethod'.
	FamixJavaInvocation new
		sender: outSideMethod;
		candidates: { aMethod }.

	aMethod parentType: aInterface.

	self
		assertCollection: (runner findExternalAccess: aInterface )
		hasSameElements: { outSideMethod }
]
