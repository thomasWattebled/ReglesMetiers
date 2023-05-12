"
An AnalyserTest is a test class for testing the behavior of Analyser
"
Class {
	#name : #AnalyserTest,
	#superclass : #TestCase,
	#instVars : [
		'listMethod',
		'model',
		'runner',
		'service',
		'firstMethod',
		'secondMethod'
	],
	#category : #'businessRule-Tests'
}

{ #category : #test }
AnalyserTest >> newEntity: aClass named: aString [

	^ aClass new
		  name: aString;
		  mooseModel: model;
		  yourself
]

{ #category : #test }
AnalyserTest >> setUp [

	super setUp.
	listMethod := OrderedCollection new.
	model := FamixJavaModel new.
	runner := Analyser new.
	service := self newEntity: FamixJavaClass named: 'Service'.
	firstMethod := self newEntity: FamixJavaMethod named: 'firstMethod'.
	secondMethod := FamixJavaMethod new name: 'secondMethod'.
	service addMethod: firstMethod.
	listMethod add: firstMethod
	"listMethod add: secondMethod"
]

{ #category : #test }
AnalyserTest >> testFindIn [

	| secondClass |
	secondClass := self newEntity: FamixJavaClass named: 'SecondClass'.
	model add: service.
	model add: secondClass.
	self assert: (runner find: 'Service' in: model) = service
]

{ #category : #test }
AnalyserTest >> testGetAllName [

	| list secondClass classWithMaj expected |
	list := OrderedCollection new.
	expected := OrderedCollection new.
	secondClass := self newEntity: FamixJavaClass named: 'NomDifferent'.
	classWithMaj := self newEntity: FamixJavaClass named: 'MaJuScULe'.
	list add: secondClass.
	list add: classWithMaj.
	expected := #( nomdifferent majuscule ).
	self assertCollection: (runner getAllName:  list)
		hasSameElements: expected
]

{ #category : #test }
AnalyserTest >> testGetAllReceiver [

	| methodInvoke invocations |
	methodInvoke := self newEntity: FamixJavaMethod named: 'methodInvoke'.
	FamixJavaInvocation new
		sender: firstMethod;
		candidates: { methodInvoke };
		receiver: secondMethod.
	invocations := runner getMethodsWithInvocation: service.
	self
		assertCollection: (runner getAllReceiver: invocations)
		hasSameElements: { secondMethod  }
]

{ #category : #test }
AnalyserTest >> testGetClassAndSubclassNames [

	| firstSubClass secondSubClass thirdSubClass listClass expected secondClass |
	listClass := OrderedCollection new.
	expected := OrderedCollection new.
	listClass add: service.
	firstSubClass := self
		                 newEntity: FamixJavaClass
		                 named: 'FirstSubClass'.
	secondSubClass := self
		                  newEntity: FamixJavaClass
		                  named: 'SecondSubClass'.
	thirdSubClass := self
		                 newEntity: FamixJavaClass
		                 named: 'ThirdSubClass'.

	firstSubClass addSuperInheritance: (FamixJavaInheritance new
			 subclass: firstSubClass;
			 superclass: service).
	expected add: firstSubClass.
	expected add: service.
	secondSubClass addSuperInheritance: (FamixJavaInheritance new
			 subclass: secondSubClass;
			 superclass: service).
	expected add: secondSubClass.

	self
		assertCollection: (runner getClassAndSubclassNames: listClass)
		hasSameElements: expected.

	secondClass := self newEntity: FamixJavaClass named: 'SecondClass'.

	thirdSubClass addSuperInheritance: (FamixJavaInheritance new
			 subclass: thirdSubClass;
			 superclass: secondClass).
			
	listClass add:secondClass.
	expected add:secondClass.
	expected add:thirdSubClass.
	

self
		assertCollection: (runner getClassAndSubclassNames: listClass)
		hasSameElements: expected.






]

{ #category : #test }
AnalyserTest >> testGetInterface [

	| iService |
	iService := self newEntity: FamixJavaInterface named: 'IService'.
	service addInterfaceImplementation: (FamixJavaImplementation new
			 interface: iService;
			 implementingClass: service).

	self
		assertCollection: (runner getInterface: service)
		hasSameElements: { iService }
]

{ #category : #test }
AnalyserTest >> testGetInterfaceOfList [

	| firstIService secondIService list secondService expected |
	list := OrderedCollection new.
	expected := OrderedCollection new.
	firstIService := self newEntity: FamixJavaInterface named: 'IService'.
	service addInterfaceImplementation: (FamixJavaImplementation new
			 interface: firstIService;
			 implementingClass: service).
	list add: service.
	expected add: firstIService.
	self
		assertCollection: (runner getInterfaceOfList: list)
		hasSameElements: { firstIService }.

	secondService := self
		                 newEntity: FamixJavaClass
		                 named: 'SecondService'.
	secondIService := self
		                  newEntity: FamixJavaInterface
		                  named: 'SecondIService'.

	secondService addInterfaceImplementation:
		(FamixJavaImplementation new
			 interface: secondIService;
			 implementingClass: secondService).

	list add: secondService.
	expected add: secondIService.
	self
		assertCollection: (runner getInterfaceOfList: list)
		hasSameElements: expected 
]

{ #category : #test }
AnalyserTest >> testGetMethodsReferences [

	| classReferenced |
	classReferenced := self
		                   newEntity: FamixJavaClass
		                   named: 'methodInvoke'.
	firstMethod addOutgoingReference: (FamixJavaReference new
			 referencer: firstMethod;
			 referredType: classReferenced).
	self
		assertCollection: (runner getMethodsReferences: service)
		hasSameElements: { classReferenced }
]

{ #category : #test }
AnalyserTest >> testGetMethodsWithInvocation [

	| methodInvoke |
	methodInvoke := self newEntity: FamixJavaMethod named: 'methodInvoke'.
	FamixJavaInvocation new
		sender: firstMethod;
		candidates: { methodInvoke }.

	self
		assertCollection: (runner getMethodsWithInvocation:  service)
		hasSameElements: { firstMethod }
]

{ #category : #test }
AnalyserTest >> testGetTypeEntities [

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
		assertCollection: (runner getTypeEntities: service)
		hasSameElements: { aClass }
]

{ #category : #test }
AnalyserTest >> testGetTypeEntitiesofList [

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
		assertCollection: (runner getTypeEntitiesofList: { iService })
		hasSameElements: { aClass }
]
