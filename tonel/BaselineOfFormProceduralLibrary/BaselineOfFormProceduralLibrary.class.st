Class {
	#name : #BaselineOfFormProceduralLibrary,
	#superclass : #BaselineOf,
	#category : #BaselineOfFormProceduralLibrary
}

{ #category : #baselines }
BaselineOfFormProceduralLibrary >> baseline: spec [
    <baseline>
	spec for: #'common' do: [
		spec
			package: #'FormProceduralLibrary-Core';
			package: #'FormProceduralLibrary-Tests' with: [
				spec requires: #( #'FormProceduralLibrary-Core' ).
			];
			package: #'FormProceduralLibrary-Samples' with: [
				spec requires: #( #'FormProceduralLibrary-Core' ).
			]
	].

]
