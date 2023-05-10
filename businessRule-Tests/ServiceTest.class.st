Class {
	#name : #ServiceTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'runner',
		'service',
		'firstMethod',
		'secondMethod',
		'listMethod'
	],
	#category : #'businessRule-Tests'
}

{ #category : #test }
ServiceTest >> newEntity: aClass named: aString [

	^ aClass new
		  name: aString;
		  mooseModel: model;
		  yourself
]

{ #category : #test }
ServiceTest >> setUp [

	super setUp.
	listMethod := OrderedCollection new.
	model := FamixJavaModel new.
	runner := Service new.
	service := self newEntity: FamixJavaClass named: 'Service'.
	firstMethod := self newEntity: FamixJavaMethod named: 'firstMethod'.
	secondMethod := FamixJavaMethod new name: 'secondMethod'.
	listMethod add: firstMethod.
	"listMethod add: secondMethod"
]

{ #category : #test }
ServiceTest >> testGetInterface [

	| iService |
	iService := self newEntity: FamixJavaInterface named: 'IService'.
	service addInterfaceImplementation: (FamixJavaImplementation new
			 interface: iService ;
			 implementingClass: service).

	self
		assertCollection: (runner getInterface: service)
		hasSameElements: { iService }
]

{ #category : #test }
ServiceTest >> testGetMethodsReferences [

		| classReferenced |
	classReferenced := self newEntity: FamixJavaClass named: 'methodInvoke'.
	firstMethod  addOutgoingReference: (FamixJavaReference new
			 referencer: firstMethod ;
			 referredType: classReferenced).
		self
		assertCollection: (runner getMethodsReferences: listMethod)
		hasSameElements: { classReferenced }
]

{ #category : #test }
ServiceTest >> testGetMethodsWithInvocation [

	| methodInvoke |
	methodInvoke := self newEntity: FamixJavaMethod named: 'methodInvoke'.
	FamixJavaInvocation new
		sender: firstMethod;
		candidates: { methodInvoke }.
	self
		assertCollection: (runner getMethodsWithInvocation: listMethod)
		hasSameElements: { firstMethod }
]

{ #category : #test }
ServiceTest >> testGetTypeEntitiesOFIService [

	| aClass iService |
	aClass := self newEntity: FamixJavaClass named: 'aClass'.
	iService := self newEntity: FamixJavaInterface named: 'ImyDAOClass'.
	service addInterfaceImplementation: (FamixJavaImplementation new
			 interface: iService;
			 implementingClass: service).
	aClass addAttribute: ((FamixJavaAttribute named: 'daoClient')
			 parentType: aClass;
			 declaredType: iService).

	self
		assertCollection: (runner getTypeEntitiesOFIService: service)
		hasSameElements: { aClass }
]
