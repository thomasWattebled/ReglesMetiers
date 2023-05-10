Class {
	#name : #ClassDAOTest,
	#superclass : #TestCase,
	#instVars : [
		'listClass',
		'model',
		'runner',
		'noDAO',
		'myDAOClass',
		'mySecondDAOClass',
		'genericDaoPClass',
		'genericDao',
		'genericDaoPType1',
		'genericDaoPType2'
	],
	#category : #'businessRule-Tests'
}

{ #category : #initialization }
ClassDAOTest >> newEntity: aClass named: aString [

	^ aClass new
		  name: aString;
		  mooseModel: model;
		  yourself
]

{ #category : #initialization }
ClassDAOTest >> setUp [

	super setUp.
	listClass := OrderedCollection new.
	model := FamixJavaModel new.
	runner := ClassDAO new.
	genericDaoPClass := self
		                    newEntity: FamixJavaParameterizableClass
		                    named: 'GenericDAO'.
	genericDaoPType1 := FamixJavaParameterizedType new name: 'GenericDAO'.
	noDAO := self newEntity: FamixJavaClass named: 'NoDao'.
	myDAOClass := self newEntity: FamixJavaClass named: 'myDAOClass'.

	genericDaoPType1 parameterizableClass: genericDaoPClass.
	myDAOClass addSuperInheritance: (FamixJavaInheritance new
			 subclass: myDAOClass;
			 superclass: genericDaoPType1).


	genericDaoPType2 := FamixJavaParameterizedType new name: 'GenericDAO'.
	mySecondDAOClass := self
		                    newEntity: FamixJavaClass
		                    named: 'mySecondDAOClass'.

	genericDaoPType2 parameterizableClass: genericDaoPClass.
	mySecondDAOClass addSuperInheritance: (FamixJavaInheritance new
			 subclass: mySecondDAOClass;
			 superclass: genericDaoPType2).


	model add: genericDaoPClass.
	model add: genericDaoPType1.
	model add: myDAOClass.
	model add: noDAO.

	listClass := model allModelClasses
]

{ #category : #test }
ClassDAOTest >> testDaoNotInvokeMethodOr [

	| firstmethod secondMethod thirdMethod dict expected |
	dict := Dictionary new.
	firstmethod := self newEntity: FamixJavaMethod named: 'firstmethod'.
	secondMethod := self newEntity: FamixJavaMethod named: 'secondMethod'.
	thirdMethod := self newEntity: FamixJavaMethod named: 'thirdMethod'.
	myDAOClass addMethod: firstmethod.
	noDAO addMethod: thirdMethod.
	FamixJavaInvocation new
		sender: firstmethod;
		candidates: { secondMethod }.
	dict := runner
		        dao: listClass
		        notInvokeMethod: 'firstmethod'
		        or: 'secondMethod'.

	self assertCollection: dict keys hasSameElements: { noDAO }.

	myDAOClass addMethod: thirdMethod.
	expected := OrderedCollection new.
	expected add: myDAOClass.
	expected add: noDAO.
	dict := runner
		        dao: listClass
		        notInvokeMethod: 'firstmethod'
		        or: 'secondMethod'.
	self assertCollection: dict keys hasSameElements: { myDAOClass }.
]

{ #category : #test }
ClassDAOTest >> testDaoUsing [

	| listDto firstDto secondDto method result |
	listDto := OrderedCollection new.
	firstDto := self newEntity: FamixJavaClass named: 'firstDto'.
	secondDto := self newEntity: FamixJavaClass named: 'secondDto'.
	method := FamixJavaMethod new name: 'method'.
	myDAOClass addMethod: method.
	method addOutgoingReference: (FamixJavaReference new
			 referencer: method;
			 referredType: firstDto).
	listDto add: firstDto.
	listDto add: secondDto.
	result := runner dao: listClass using: listDto.
	self assert: result keys size = 1.
	self assertCollection: result keys hasSameElements: { myDAOClass }.
	self
		assertCollection: (result at: myDAOClass)
		hasSameElements: { firstDto }.
]

{ #category : #test }
ClassDAOTest >> testFindClassImplementingIn [

	| method method2 expected |
	method := FamixJavaMethod new name: 'method'.
	method2 := FamixJavaMethod new name: 'method'.
	myDAOClass addMethod: method.
	noDAO addMethod: method2.
	expected := OrderedCollection new.
	expected add: myDAOClass.
	expected add: noDAO.
	self
		assertCollection:
		(runner findClassImplementing: 'method' in: listClass)
		hasSameElements: expected.


	self
		assertCollection: (runner
				 findClassImplementing: 'method'
				 in: (runner findDao: listClass))
		hasSameElements: { myDAOClass }
]

{ #category : #initialization }
ClassDAOTest >> testFindDAO [
	| result |
	result := OrderedCollection new.
	result add: myDAOClass .
	result add: mySecondDAOClass .
	self
		assertCollection: (runner findDao: listClass)
		hasSameElements: result
]

{ #category : #test }
ClassDAOTest >> testFindService [

	| service iDao |
	service := self newEntity: FamixJavaClass named: 'ServiceDao'.
	iDao := self newEntity: FamixJavaInterface named: 'ImyDAOClass'.
	myDAOClass addInterfaceImplementation: (FamixJavaImplementation new
					 interface: iDao;
					implementingClass: myDAOClass).
	service  addAttribute: ((FamixJavaAttribute named:'daoClient')
		 		parentType: service    ;
		       declaredType: iDao).
		
	self assertCollection: (runner findService:  myDAOClass)
		hasSameElements: { service }
]

{ #category : #test }
ClassDAOTest >> testInvokedMethodsIn [

	| method methodInvoke |
	method := FamixJavaMethod new name: 'method'.
	methodInvoke := FamixJavaMethod new name: 'methodInvoke'.
	myDAOClass addMethod: method.
	FamixJavaInvocation new
		sender: method;
		candidates: { methodInvoke }.
	self
		assertCollection: (runner invokedMethodsIn: myDAOClass)
		hasSameElements: { methodInvoke }
]

{ #category : #test }
ClassDAOTest >> testNotInvokedMethodsInMethodOr [

	| firstmethod secondMethod thirdMethod |
	firstmethod := self newEntity: FamixJavaMethod named: 'firstmethod'.
	secondMethod := self newEntity: FamixJavaMethod named: 'secondMethod'.
	thirdMethod := self newEntity: FamixJavaMethod named: 'thirdMethod'.
		myDAOClass addMethod: firstmethod .
		myDAOClass addMethod: thirdMethod .
	FamixJavaInvocation new
		sender: firstmethod;
		candidates: { secondMethod }.
	self
		assertCollection: (runner notInvokedMethodsIn: myDAOClass  method:'firstmethod'  or:'secondMethod' )
		hasSameElements: { thirdMethod }
]

{ #category : #initialization }
ClassDAOTest >> testReference [

	| method |
	method := FamixJavaMethod new name: 'method'.
	myDAOClass addMethod: method.
	method addOutgoingReference: (FamixJavaReference new
			 referencer: method;
			 referredType: noDAO).
	self
		assertCollection: (runner reference: myDAOClass)
		hasSameElements: { noDAO }
]

{ #category : #initialization }
ClassDAOTest >> testdeleteDAOInName [

	| expected input thirdDaoClass |
	expected := #( myclass mysecondclass ).
	input := runner findDao: listClass.
	self
		assertCollection: (runner deleteDAOInName: input)
		hasSameElements: expected.


	"Ajout d'un Deuxime DAo mais sans DAO dans son nom"


	thirdDaoClass := self
		                 newEntity: FamixJavaClass
		                 named: 'ThirdD_A_OClass'.
	thirdDaoClass addSuperInheritance: (FamixJavaInheritance new
			 subclass: thirdDaoClass;
			 superclass: genericDaoPType1).
	model add: thirdDaoClass.


	expected := #( myclass mysecondclass thirdd_a_oclass ).
	input := runner findDao: listClass.
	self
		assertCollection: (runner deleteDAOInName: input)
		hasSameElements: expected
]
