"
I have multiple samples that display how to use this library for generating procedural textures.
"
Class {
	#name : #FPLBasicProceduralSamples,
	#superclass : #Object,
	#category : #'FormProceduralLibrary-Samples'
}

{ #category : #'examples - color' }
FPLBasicProceduralSamples class >> exampleBlack [
	^ ((FPLFormRenderer extent: 128@128)
		renderColor: [:x :y | Color black];
		form)
		inspect.
]

{ #category : #'examples - basic functions' }
FPLBasicProceduralSamples class >> exampleCheckboard [
	^ ((FPLFormRenderer extent: 128@128)
		renderGray: [:x :y |
			| xp yp |
			xp := (x * 5.0) floorFractionPart < 0.5.
			yp := (y * 5.0) floorFractionPart < 0.5.
			(xp xor: yp) asBit
		];
		form)
		inspect.
]

{ #category : #'examples - basic functions' }
FPLBasicProceduralSamples class >> exampleCheckboardNormalMap [
	^ ((FPLFormRenderer extent: 128@128)
		renderGray: [:x :y |
			| xp yp |
			xp := (x * 5.0) floorFractionPart < 0.5.
			yp := (y * 5.0) floorFractionPart < 0.5.
			(xp xor: yp) asBit
		];
		makeIntoNormalMap;
		form)
		inspect.
]

{ #category : #'examples - basic functions' }
FPLBasicProceduralSamples class >> exampleHorizontalGrayGradient [
	^ ((FPLFormRenderer extent: 128@128)
		renderGray: [:x :y | x ];
		form)
		inspect.
]

{ #category : #'examples - basic functions' }
FPLBasicProceduralSamples class >> exampleHorizontalPulse [
	^ ((FPLFormRenderer extent: 128@128)
		renderGray: [:x :y | ((x * 5.0) floorFractionPart < 0.5) asBit];
		form)
		inspect.
]

{ #category : #'examples - basic functions' }
FPLBasicProceduralSamples class >> exampleHorizontalPulseNormalMap [
	^ ((FPLFormRenderer extent: 128@128)
		renderGray: [:x :y | ((x * 5.0) floorFractionPart < 0.5) asBit];
		makeIntoNormalMap;
		form)
		inspect.
]

{ #category : #'examples - basic functions' }
FPLBasicProceduralSamples class >> exampleHorizontalSawTooth [
	^ ((FPLFormRenderer extent: 128@128)
		renderGray: [:x :y | (x * 5) floorFractionPart ];
		form)
		inspect.
]

{ #category : #'examples - basic functions' }
FPLBasicProceduralSamples class >> exampleHorizontalSawToothNormalMap [
	^ ((FPLFormRenderer extent: 128@128)
		renderGray: [:x :y | (x * 5) floorFractionPart ];
		makeIntoNormalMap;
		form)
		inspect.
]

{ #category : #'examples - basic functions' }
FPLBasicProceduralSamples class >> exampleRGGradient [
	^ ((FPLFormRenderer extent: 128@128)
		renderColor: [:x :y | Color r: x g: y b: 0.0];
		form)
		inspect.
]

{ #category : #'examples - color' }
FPLBasicProceduralSamples class >> exampleRed [
	^ ((FPLFormRenderer extent: 128@128)
		renderColor: [:x :y | Color red];
		form)
		inspect.
]

{ #category : #'examples - basic functions' }
FPLBasicProceduralSamples class >> exampleVerticalGrayGradient [
	^ ((FPLFormRenderer extent: 128@128)
		renderGray: [:x :y | y ];
		form)
		inspect.
]

{ #category : #'examples - basic functions' }
FPLBasicProceduralSamples class >> exampleVerticalPulse [
	^ ((FPLFormRenderer extent: 128@128)
		renderGray: [:x :y | ((y * 5.0) floorFractionPart < 0.5) asBit];
		form)
		inspect.
]

{ #category : #'examples - basic functions' }
FPLBasicProceduralSamples class >> exampleVerticalSawTooth [
	^ ((FPLFormRenderer extent: 128@128)
		renderGray: [:x :y | (y * 5) floorFractionPart ];
		form)
		inspect.
]

{ #category : #'examples - basic functions' }
FPLBasicProceduralSamples class >> exampleVerticalSawToothNormalMap [
	^ ((FPLFormRenderer extent: 128@128)
		renderGray: [:x :y | (y * 5) floorFractionPart ];
		makeIntoNormalMap;
		form)
		inspect.
]

{ #category : #'see class side' }
FPLBasicProceduralSamples >> seeClassSide [
]
