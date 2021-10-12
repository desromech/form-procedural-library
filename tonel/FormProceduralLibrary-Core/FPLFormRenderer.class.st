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

{ #category : #accessing }
FPLFormRenderer >> decodeGrays [
	| result destIndex |
	result := ByteArray new: form width * form height.
	destIndex := 1.
	form unhibernate.
	form bits do: [ :word |
		result at: destIndex put: (word bitAnd: 16rff).
		destIndex := destIndex + 1
	].
	^ result
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
FPLFormRenderer >> encodeColorBGRA32R: r g: g b: b a: a [
	| cr cg cb ca |
	cr := (r * 255) asInteger min: 255 max: 0.
	cg := (g * 255) asInteger min: 255 max: 0.
	cb := (b * 255) asInteger min: 255 max: 0.
	ca := (a * 255) asInteger min: 255 max: 0.
	^ ((cb bitOr: (cg bitShift: 8)) bitOr: (cr bitShift: 16)) bitOr: (ca bitShift: 24)
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

{ #category : #accessing }
FPLFormRenderer >> grayPixelFetcher [
	| grays w h |
	w := form width.
	h := form height.
	
	grays := self decodeGrays.
	^ [ :x :y |
		| nx ny|
		nx := x \\ w.
		ny := y \\ h.
		grays at: ny * w + nx + 1
	]
]

{ #category : #transforming }
FPLFormRenderer >> makeIntoNormalMap [
	self makeIntoNormalMapWithScale: 1.0
]

{ #category : #transforming }
FPLFormRenderer >> makeIntoNormalMapWithScale: heightScale [
	self makeIntoNormalMapWithXScale: 1.0 yScale: 1.0 heightScale: heightScale
]

{ #category : #transforming }
FPLFormRenderer >> makeIntoNormalMapWithXScale: xScale yScale: yScale heightScale: heightScale [
	| w h resultForm fetchGray bits destIndex |
	w := form width.
	h := form height.
	
	fetchGray := self grayPixelFetcher.

	resultForm := Form extent: form extent depth: 32.
	resultForm unhibernate.
	bits := resultForm bits.
	destIndex := 1.
	0 to: h - 1 do: [ :y |
		0 to: w - 1 do: [ :x |
			| dx dy nx ny nz nl |
			dx := (fetchGray value: x + 1 value: y) - (fetchGray value: x - 1 value: y) * heightScale.
			dy := (fetchGray value: x value: y + 1) - (fetchGray value: x value: y - 1) * heightScale.
			
			"
			tangent: (step, 0.0, dx)
			bitangent: (0.0, step, dy)
			normal: tangent x bitangent => (-step * dx, -step *dy, step * step)
			"
			nx := -2.0 * dx * xScale.
			ny := -2.0 * dy * yScale.
			nz := 4.0.
			nl := ((nx*nx) + (ny*ny) + (nz*nz)) sqrt.
			nx := nx / nl * 0.5 + 0.5.
			ny := ny / nl * 0.5 + 0.5.
			nz := nz / nl * 0.5 + 0.5.
			
			bits at: destIndex put: (self encodeColorBGRA32R: nx g: ny b: nz a: 1.0).
			destIndex := destIndex + 1
		]
	].

	form := resultForm
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
