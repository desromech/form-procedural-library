"
I am an utility class for rendering procedural textures into a form.
"
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
	form unhibernate.
	form depth = 8 ifTrue: [ 
		result := form bits copy.
		ByteArray adoptInstance: result.
		^ result 
	].

	self assert: form depth = 32.
	result := ByteArray new: form width * form height.
	destIndex := 1.
	form bits do: [ :word |
		| b g r l |
		b := (word bitAnd: 16rff).
		g := (word bitAnd: 16rff00) bitShift: -8.
		r := (word bitAnd: 16rff0000) bitShift: -16.

		l := ((299 * r) + (587 * g) + (114 * b)) / 1000 min: 255 max: 0.
		result at: destIndex put: r.
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

{ #category : #accessing }
FPLFormRenderer >> heightFetcherWithScale: scale bias: bias [
	| grayFetcher factor |
	grayFetcher := self grayPixelFetcher.
	factor := scale / 255.0.
	^ [ :x :y |
		(grayFetcher value: x value: y) * factor + bias
	]
]

{ #category : #transforming }
FPLFormRenderer >> intoNormalMap [
	self intoNormalMapWithScale: 1.0
]

{ #category : #transforming }
FPLFormRenderer >> intoNormalMapWithScale: heightScale [
	self intoNormalMapWithXScale: 1.0 yScale: 1.0 heightScale: heightScale
]

{ #category : #transforming }
FPLFormRenderer >> intoNormalMapWithXScale: xScale yScale: yScale heightScale: heightScale [
	^ self intoNormalMapWithXScale: xScale yScale: yScale heightScale: heightScale gradientOperator: FPLGradientOperator discrete
]

{ #category : #transforming }
FPLFormRenderer >> intoNormalMapWithXScale: xScale yScale: yScale heightScale: heightScale gradientOperator: gradientOperator [
	^ self intoNormalMapWithXScale: xScale yScale: yScale heightScale: heightScale heightBias: 0.0 gradientOperator: gradientOperator
]

{ #category : #transforming }
FPLFormRenderer >> intoNormalMapWithXScale: xScale yScale: yScale heightScale: heightScale heightBias: heightBias gradientOperator: gradientOperator [
	| w h resultForm fetchGray bits destIndex gradientOperatorX gradientOperatorY |
	w := form width.
	h := form height.
	
	fetchGray := self heightFetcherWithScale: heightScale bias: heightBias.

	resultForm := Form extent: form extent depth: 32.
	resultForm unhibernate.
	bits := resultForm bits.
	destIndex := 1.
	gradientOperatorX := gradientOperator first.
	gradientOperatorY := gradientOperator second.
	0 to: h - 1 do: [ :y |
		0 to: w - 1 do: [ :x |
			| dx dy nx ny nz nl |
			dx := (gradientOperatorX value: fetchGray value: x value: y) * xScale.
			dy := (gradientOperatorY value: fetchGray value: x value: y) * yScale.
			
			"
			tangent: (1, 0.0, dx)
			bitangent: (0.0, 1, dy)
			normal: tangent x bitangent => (-stepY*dx*stepX, -stepX*dy, stepX*stepY)
			"
			nx := dx negated.
			ny := dy negated.
			nz := 1.0.
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
