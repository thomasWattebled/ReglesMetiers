Class {
	#name : #ClassDAOTest,
	#superclass : #TestCase,
	#instVars : [
		'listClass',
		'model',
		'runner',
		'GenericDAO',
		'NotDAO',
		'noDAO',
		'myDAOClass',
		'genericDao',
		'genericDaoPClass',
		'genericDaoPType'
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
	genericDaoPType := FamixJavaParameterizedType new name: 'GenericDAO'.
	noDAO := self newEntity: FamixJavaClass named: 'NoDao'.
	myDAOClass := self newEntity: FamixJavaClass named: 'myDAOClass'.

	genericDaoPType parameterizableClass: genericDaoPClass.
	myDAOClass addSuperInheritance: (FamixJavaInheritance new
			 subclass: myDAOClass;
			 superclass: genericDaoPType).

	model add: genericDaoPClass.
	model add: genericDaoPType.
	model add: myDAOClass.
	model add: noDAO.
	
	listClass := model allModelClasses.
]

{ #category : #initialization }
ClassDAOTest >> testFindDAO [

	self
		assertCollection: (runner findDao: listClass)
		hasSameElements: { myDAOClass }
]

{ #category : #initialization }
ClassDAOTest >> testReference [

	| method expected |
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

	| expected input secondDaoClass |
	expected := #( myclass ).
	input := runner findDao: listClass.
	self
		assertCollection: (runner deleteDAOInName: input)
		hasSameElements: expected.


"Ajout d'un Deuxime DAo mais sans DAO dans son nom"


	secondDaoClass := self
		                  newEntity: FamixJavaClass
		                  named: 'SecondD_A_OClass'.
	secondDaoClass addSuperInheritance: (FamixJavaInheritance new
			 subclass: secondDaoClass;
			 superclass: genericDaoPType).
	model add: secondDaoClass.


	expected := #( myclass secondd_a_oclass ).
	input := runner findDao: listClass.
	self
		assertCollection: (runner deleteDAOInName: input)
		hasSameElements: expected
]
