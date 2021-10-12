Class {
	#name : #FPLFormRenderer,
	#superclass : #Object,
	#instVars : [
		'form'
	],
	#category : #'FormProceduralLibrary-Core'
}

{ #category : #geometry }
FPLFormRenderer class >> extent: anExtent [
	^ self extent: anExtent depth: 32
]

{ #category : #geometry }
FPLFormRenderer class >> extent: anExtent depth: aDepth [
	^ self form: (Form extent: anExtent depth: aDepth)
]

{ #category : #geometry }
FPLFormRenderer class >> form: aForm [
	^ self new form: aForm
]

{ #category : #coloring }
FPLFormRenderer >> encodeColorBGRA32: aColor [
	| r g b a |
	r := (aColor red * 255) asInteger.
	g := (aColor green * 255) asInteger.
	b := (aColor blue * 255) asInteger.
	a := (aColor alpha * 255) asInteger.
	^ ((b bitOr: (g bitShift: 8)) bitOr: (r bitShift: 16)) bitOr: (a bitShift: 24)
]

{ #category : #coloring }
FPLFormRenderer >> encodeColorRGBA32: aColor [
	| r g b a |
	r := (aColor red * 255) asInteger.
	g := (aColor green * 255) asInteger.
	b := (aColor blue * 255) asInteger.
	a := (aColor alpha * 255) asInteger.
	^ ((r bitOr: (g bitShift: 8)) bitOr: (b bitShift: 16)) bitOr: (a bitShift: 24)
]

{ #category : #coloring }
FPLFormRenderer >> encodeGrayCCA32: aGrayValue [
	| v |
	v := (aGrayValue * 255) asInteger min: 255 max: 00.
	^ ((v bitOr: (v bitShift: 8)) bitOr: (v bitShift: 16)) bitOr: 16rff000000
]

{ #category : #coloring }
FPLFormRenderer >> fillWithColor: aColor [
]

{ #category : #accessing }
FPLFormRenderer >> form [

	^ form
]

{ #category : #accessing }
FPLFormRenderer >> form: anObject [

	form := anObject
]

{ #category : #coloring }
FPLFormRenderer >> renderColor: aBlock [
	self renderColorBGRA32: [:x :y |
		self encodeColorBGRA32: (aBlock value: x value: y).
	].
]

{ #category : #coloring }
FPLFormRenderer >> renderColorBGRA32: aBlock [
	| w iw h ih bits index |
	form depth = 32 ifFalse: [ self error: '32 bits depth is required here' ].

	form unhibernate.
	w := form width.
	h := form height.
	iw := w reciprocal.
	ih := h reciprocal.
	
	bits := form bits.
	index := 1.
	0 to: h - 1 do: [ :y |
		0 to: w - 1 do: [ :x |
			bits at: index put: (aBlock value: x * iw value: y * ih).
			index := index + 1.
		]
	]
]

{ #category : #coloring }
FPLFormRenderer >> renderGray: aBlock [
	self renderColorBGRA32: [:x :y |
		self encodeGrayCCA32: (aBlock value: x value: y).
	].

]
