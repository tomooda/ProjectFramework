callbacks
removeProject
	" Remove the selected project "

	(self confirm: 'Are you sure you want to remove the selected project: ' , self currentProjectName)
		ifFalse: [ ^ self ].
	self releaseProject.
	self closeProjectButton disable.
	self exploreProjectButton disable.
	self saveProjectButton disable.