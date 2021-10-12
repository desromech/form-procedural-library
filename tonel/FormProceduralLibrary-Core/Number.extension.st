Extension { #name : #Number }

{ #category : #'*FormProceduralLibrary-Core' }
Number >> floorFractionPart [
	^ self - self floor
]
