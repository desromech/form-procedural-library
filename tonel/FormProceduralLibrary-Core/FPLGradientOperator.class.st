"
I am a discrete operator for computing a gradient in a 2D scalar field. I am typically used for generating normal maps from height maps.
"
Class {
	#name : #FPLGradientOperator,
	#superclass : #Object,
	#category : #'FormProceduralLibrary-Core'
}

{ #category : #transforming }
FPLGradientOperator class >> discrete [
	^ { 
		[ :function :x :y | ((function value: x + 1 value: y) - (function value: x - 1 value: y)) * 0.5].
		[ :function :x :y | ((function value: x value: y + 1) - (function value: x value: y - 1)) * 0.5 ]
	}
]

{ #category : #transforming }
FPLGradientOperator class >> prewitt3x3 [
	^ { 
		[ :function :x :y | (
			(function value: x + 1 value: y + 1)
			+ (function value: x + 1 value: y)
			+ (function value: x + 1 value: y - 1)

			- (function value: x - 1 value: y + 1)
			- (function value: x - 1 value: y)
			- (function value: x - 1 value: y - 1)
			) / 6.0
		].
		[ :function :x :y | (
			(function value: x - 1 value: y + 1)
			+ (function value: x value: y + 1)
			+ (function value: x + 1 value: y + 1)

			- (function value: x - 1 value: y - 1)
			- (function value: x value: y - 1)
			- (function value: x + 1 value: y - 1)
			) / 6.0
		].
	}
]

{ #category : #transforming }
FPLGradientOperator class >> sobel3x3 [
	^ { 
		[ :function :x :y | (
			(function value: x + 1 value: y + 1)
			+ ((function value: x + 1 value: y) * 2.0)
			+ (function value: x + 1 value: y - 1)

			- (function value: x - 1 value: y + 1)
			- ((function value: x - 1 value: y) * 2.0)
			- (function value: x - 1 value: y - 1)
			) * "8.0 reciprocal"  0.125
		].
		[ :function :x :y | (
			(function value: x - 1 value: y + 1)
			+ ((function value: x value: y + 1) * 2.0)
			+ (function value: x + 1 value: y + 1)

			- (function value: x - 1 value: y - 1)
			- ((function value: x value: y - 1) * 2.0)
			- (function value: x + 1 value: y - 1)
			) * "8.0 reciprocal"  0.125
		].
	}
]
