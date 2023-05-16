"
A DaoAccessTest is a test class for testing the behavior of DaoAccess
"
Class {
	#name : #DaoAccessTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'runner',
		'aClass',
		'aMethod'
	],
	#category : #'businessRule-Tests'
}

{ #category : #'instance creation' }
DaoAccessTest >> newEntity: aClass named: aString [
	^aClass new
		name: aString ;
		mooseModel: model ;
		yourself
]

{ #category : #running }
DaoAccessTest >> setUp [

	super setUp.

	model := FamixJavaModel new.
	runner := DaoAccess new.

	aClass := self newEntity: FamixJavaClass named: 'DAO'.
	aMethod := self newEntity: FamixJavaMethod named: 'daoMethod'.
	FamixJavaReference new
		referencer: aMethod;
		referredType: aClass
]

{ #category : #tests }
DaoAccessTest >> testFindExternalTo [

	self
		assertCollection: (runner findExternalAccess: aClass)
		hasSameElements: { aMethod }
]

{ #category : #tests }
DaoAccessTest >> testFindExternalToNone [
	aMethod parentType: aClass.

	self assert: (runner findExternalAccess: aClass) isEmpty
]

{ #category : #tests }
DaoAccessTest >> testFindExternalToOutside [

	| outSideMethod |
	outSideMethod := self newEntity: FamixStMethod named: 'outsideMethod'.
	FamixStInvocation new
	sender: outSideMethod ;
	candidates: {aMethod}.

	aMethod parentType: aClass.

	self assertCollection: (runner findExternalAccess: aClass) hasSameElements: { outSideMethod  }
]
