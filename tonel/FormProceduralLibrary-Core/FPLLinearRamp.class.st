"
I am used for defining a linear ramp of interpolated values.
"
Class {
	#name : #FPLLinearRamp,
	#superclass : #Object,
	#instVars : [
		'stops'
	],
	#category : #'FormProceduralLibrary-Core'
}

{ #category : #'instance creation' }
FPLLinearRamp class >> with: stops [
	^ self new initializeWith: stops
]

{ #category : #initialization }
FPLLinearRamp >> initializeWith: theStops [
	stops := theStops
]

{ #category : #accessing }
FPLLinearRamp >> value: x [
	x <= stops first key ifTrue: [ ^ stops first value ].
	stops last key <= x ifTrue: [ ^ stops last value ].
	
	1 to: stops size - 1 do: [ :i |
		| prev next prevKey nextKey |
		prev := stops at: i.
		next := stops at: i + 1.
		prevKey := prev key.
		nextKey := next key.
		(prev key <= x and: [ x <= next key ]) ifTrue: [
			| alpha |
			alpha := (x - prevKey) / (nextKey - prevKey).
			^ prev value interpolateTo: next value at: alpha
		]
	].

	self error: 'This should not be reachable'.
]
