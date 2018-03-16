[![license-badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://travis-ci.org/hernanmd/ProjectFramework.svg?branch=master)](https://travis-ci.org/hernanmd/ProjectFramework)
[![Build status](https://ci.appveyor.com/api/projects/status/x265r8o52iirm9g2?svg=true)](https://ci.appveyor.com/project/hernanmd/projectframework)
[![Coverage Status](https://coveralls.io/repos/github/hernanmd/ProjectFramework/badge.svg?branch=master)](https://coveralls.io/github/hernanmd/ProjectFramework?branch=master)

# Description

ProjectFramework is a MIT licensed Open-Source library for project management at application level with Pharo Smalltalk. The ProjectFramework enables to build typical project-based desktop GUI applications, without reinventing the wheel for project-enabled behaviors such as Open, Save, Closing, Versioning, etc. A Spec UI application can be automatically generated from templates with basic menu options very few lines of code.

ProjectFramework is designed to create project-centric applications with minimal effort, and tries to be fairly agnostic regarding the choices of UI widget libraries, this means no widget toolkit dependent code.

# Installation

There are several ways to install the **ProjectFramework**. At minimum, you need a working Pharo virtual image installed in your system. Check the [Pharo website](http://www.pharo.org) for installation information regarding the Pharo Open-Source system. Once Pharo is launched you have the following installation options:

**Group**|**ProjectFramework**|**ProjectFrameworkSpec**|**ProjectFrameworkTests**|**ProjectFrameworkMorphic**|**ProjectFrameworkSpecSamples**|**ProjectFrameworkPharo**|**ProjectFrameworkSamples**
-----|-----|-----|-----|-----|-----|-----|-----
All|Yes|Yes|Yes| Yes| Yes| Yes| Yes
Basic|Yes|Yes|No|No|No|Yes|No
Core|Yes|No|No|No|Yes|No|No
Tests|Yes|No|Yes|No|No|No|Yes

For a short summary, you may follow these suggestions:

  - For a Spec UI in Pharo, without Tests and Samples, install the "Basic" group.
  - For a Morpic UI in Pharo, install the "Morphic" group.
  - For just the basic classes, to develop your own connector to an UI library, install the "Core" group.

## Stable version (All group) from CLI

Install **ProjectFramework** from Command-Line Interface using [Pharo Instal](https://github.com/hernanmd/pi)l:

```bash
pi install ProjectFramework
```

## Stable version (All group) from Pharo

[//]: # (pi)
```smalltalk
Metacello new	
  baseline: 'ProjectFramework';	
  repository: 'github://hernanmd/ProjectFramework/repository';	
  load.
```

## Stable version (Basic group) from Pharo

[//]: # (pidev)
```smalltalk
Metacello new	
  baseline: 'ProjectFramework';	
  repository: 'github://hernanmd/ProjectFramework/repository';
  loads: #('Basic');
  load.
```

## Baseline String

If you want to add the ProjectFramework to your Metacello Baselines or Configurations, copy and paste the following expression:
```smalltalk
	" ... "
	spec
		baseline: 'ProjectFramework' 
		with: [ spec repository: 'github://hernanmd/ProjectFramework/repository' ];
	" ... "
```

# Usage

## Adding an Application and Project

The ProjectFramework includes a class representing your whole Application. An Application is global to an image - only one application per image could be active at a time - and could contain a single active project or multiple projects. **PFProjectBase** is the basic core (abstract) class for user projects. A custom Project class could be created by inheriting from **PFProjectBase**. Such class will inherit basic project features for example: setting/getting project author, adding/removing project users, owner(s), creation/modification dates, file naming and project history information. Every instantiated project must belong to an application, so the first thing to do is to create an application class:An Application class should inherit from **PFProjectApplication**:s```smalltalkPFProjectApplication subclass: #MyApplicationClass   	instanceVariableNames: ''   	classVariableNames: ''   	package: 'MyApplication-Core'```If there is just one subclass of **PFProjectApplication** then it will be automatically configured and used as the "current application class". Otherwise, you should set up the current application class using the global preferences, for example:```smalltalkPFProjectSettings currentApplicationClass: PFSample1ApplicationClass.``` **PFProjectSettings** implements customization points in ProjectFramework, so that the Settings Framework might collect them and populate a setting browser with them.The following snippet details how to add your own Project class:```smalltalkPFProjectBase subclass: #MyPFProject   	instanceVariableNames: ''   	classVariableNames: ''   	package: 'MyApplication-Core'```**PFProjectBase** is responsible for implementing owners management, which can be used to authenticate operations on it, authoring, file naming, versioning and history.## Configuring the ApplicationTo link the Application with the Project, we need to add a method to MyApplicationClass in instance side:```smalltalkdefaultProjectClass	" Private - See superimplementor's comment "	^ MyPFProject```You can also configure the application name in class side of MyApplicationClass:```smalltalkapplicationName	" Answer a <String> with receiver's name "		^ 'My First Application'```If you want to customize your serialized project file extension, define this method:```smalltalkapplicationExtension	" Answer a <String> with receiver's project file extension "	^ 'ext'```Before jumping to automatic UI generation, you might want to explore the basic message sends and core classes in the **ProjectFramework**.## A session between an user and a projectAn user (**PFProjectUser**) represents an user with projects and can instantiate multiple projects, however only one will be the active project (#currentProject) at a time for the current application. Projects are identified by name (**String**), and an user cannot have duplicated (with the same name) projects. The following expressions show how to create an user with a project, and the type of operations which could be done:Creating an user with a new project:```smalltalk| usr prj |usr := PFProjectUser named: 'John Perez'.prj := usr addNewProject: 'My First Project'.```Check actually everything was correctly configured:```smalltalkprj authorName.  "'John Perez'"prj projectName. "'My First Project'"```A project can be queried for typical project expected attributes:```smalltalkprj fileName. "'My First Project.fuelprj'"prj creationDateAsString. "'2018-03-13 01:47:57'"prj saveStatus.  "false"```Projects can also have owners.```smalltalkprj hasOwner.  "false"```And versioning is also supported:```smalltalkprj version: '1.0.0'.prj versionString. "'1.0.0'"```Save the project to file and ask if it was actually saved:```smalltalkprj save.prj saveStatus.```The file name is actually the project name, added with a default "fuelprj" extension (extension **String** can be configured later):```smalltalk'My First Project.fuelprj' asFileReference exists.  "true"```Currently the **ProjectFramework** serializes and materialize its projects using the [Fuel](https://rmod.inria.fr/web/software/Fuel) serialization library.Now moving to an user perspective, the ProjectFramework offers different ways to create projects, depending on specific scenarios. Creating and adding projects are two separate things. An user can create a project meaning only instantiating a new **PFProjectBase**, without adding it as part of its projects. On the other hand, adding a project means creating the instance, and adding it to both the application and the collection of user projects.Let's create another project:```smalltalkprj2 := usr createProject: 'My Second Project'.```Check that such project was not added to the user projects yet: ```smalltalkusr hasProjectNamed: 'My Second Project'.```And then we can add it to the user projects:```smalltalkusr addProject: prj2.````> Note that previously we added a project passing its name, and now we use a **PFProjectBase** as parameter.Finally re-check again if it was added correctly: ```smalltalkusr hasProjectNamed: 'My Second Project'.```None of the previosuly message sends set the created project as the current application project. That should be done separately using:```smalltalkprj setCurrentFor: usr.```## Adding a Project Window The ProjectFramework has built-in support for several types of User-Interfaces. The differences between UI's are that they provide different layouts considering the available underlying widget library. This also provides an abstraction layer for future widget toolkits or libraries (such as [Bloc](https://github.com/pharo-graphics/Bloc)).First we require a "Window" class:```smalltalkPFStandardProjectWindow subclass: #MyAppProjectWindow	instanceVariableNames: ''	classVariableNames: ''	package: 'MyApplication-UI'```We need to link your application with your project. Add the following instance method in MyAppProjectWindow:```smalltalkapplicationClass	^ MyApplicationClass```Add the following instance methoda in MyAppProjectWindow:```smalltalkprojectClass	" Private - See superimplementor's comment "    	^ MyApplicationProject``````smalltalkcloseAfterCreateProject   	" Answer <true> if receiver's window should close after creation of a project "	^ false```Now the project is linked to an UI window.### ProjectFrameworkSpecProjectFrameworkSpec classes inherits from **ComposableModel** (in Pharo 6.x) or **ComposablePresenter** (in Pharo 7.x) and uses the [SpecUIAddOns](https://github.com/hernanmd/SpecUIAddOns) package classes to provide a "standard" layout. The standard project window is based in the Spec **ApplicationWithToolbar** class. Alternatively, a "Project Details" with or without recent projects list layout is also available.Here is a screenshot of both layouts:Classic Layout:![convertidor iso 11784 - senasa 754](https://user-images.githubusercontent.com/4825959/37262532-5fca39d8-2582-11e8-9a0a-c6c0e594a303.png)Recent Projects List Layout:![rehhcg_1](https://user-images.githubusercontent.com/4825959/37262533-5ffe728e-2582-11e8-85b5-893b2df53171.png)### ProjectFrameworkMorphicThe docking project window is based in the **DockingBarMorph** class, and enables to use the ProjectFramework without Spec (or other higher-level library) dependency.![dockingpfwindow](https://user-images.githubusercontent.com/4825959/37263455-0a19abae-2587-11e8-9087-828cdfea3e2d.png)## Finite State MachineProjectFramework uses the [SState](http://smalltalkhub.com/#!/~MasashiUmezawa/SState "SState") package to provide an extremely simple Finite State Machine (FSM) managing common project events, actions and states. Every ProjectFramework application (subclass of **PFProjectApplication**) contains, almost free of charge, a FSM with a predefined set of states and transitions.  - The actions, events and state names are configured in the #initializeFSM method.
  - The initial state is named *"stateWaitNewOrOpen"* which means, wait for a new project or open project event.
    - You can customize the FSM in the #initializeFSM method in your subclass of **PFProjectApplication**
  - Upon opening or creating a new project, the FSM transitions to a new state *"stateWaitChangeOrClose"*.
  - When a project changes, the FSM performs another transition to *"stateWaitSaveOrClose"*.
 The FSM can be visualized in the following transition graph:![fsm_simulator_-_2018-03-16_00 16 05](https://user-images.githubusercontent.com/4825959/37502697-0299434c-28b3-11e8-8b1c-d29ce44b03da.png)The following example method contains how FSM events can be triggered in user's code:```smalltalkcreateNewProject	" Request a project name and answer a new project if valid name is supplied "		| answer |	(answer := self requestMessage: self translator tNewProjectName) isEmptyOrNil 		ifFalse: [ 			self createAppProject: answer.			self fsm handleEvent: #actionNew  ]		ifTrue: [ self informMessage: self translator tNewProjectEmptyName ].```## EventsA nice common feature to inform the user of the current project, is to update the title of created or opened projects in the uppermost toolbar. To do this simply implement #defaultWindowTitle to answer a **String** and do not override the #title method.## Custom Application SettingsThe ProjectFramework provides also a class **PFProjectSettingsPharo** (using the Settings Framework of Pharo) to manage configuration of application and project.![pfsettingswindow](https://user-images.githubusercontent.com/4825959/37263696-0dfaa75e-2588-11e8-8468-773badd65a8a.png)To use this feature, subclass **PFProjectSettingsPharo** and add the following methods in class side:```smalltalkapplicationClass	" Private - See superimplementor's comment "	^ PFSample1ApplicationClass  ```You will have to create a pragma keyword which you will use in your specific methods with settings code:```smalltalkprojectFrameworkPragmaKeywords	^ Array with: 'projectSample1Settings'```For example a setting to configure the user name of the Application:```smalltalkusernameSettingsOn: aBuilder	<projectSample1Settings>	(aBuilder setting: #usernameSetting)		target: self;		description: 'Set the user name';		label: 'Username';		parent: #projectSettings```## TranslationThe Project Framework currently uses the i18N package to add translation support to menu items and messages. The package I18N was developed by Torsten Bergmann and it is available through SmalltalkHub with the MIT License. The abstract class to check for implementing i18N to your application is **PFTranslator**.**PFTranslator** adds two catalogs with related project operations. One for english (see #addTranslationsForEN) and another one for spanish (#addTranslationsForES).# Contribute

**Working on your first Pull Request?** You can learn how from this *free* series [How to Contribute to an Open Source Project on GitHub](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github)

If you have discovered a bug or have a feature suggestion, feel free to create an issue on Github.
If you have any suggestions for how this package could be improved, please get in touch or suggest an improvement using the GitHub issues page.
If you'd like to make some changes yourself, see the following:    

  - Fork this repository to your own GitHub account and then clone it to your local device
  - Do some modifications
  - Test.
  - Add <your GitHub username> to add yourself as author below.
  - Finally, submit a pull request with your changes!
  - This project follows the [all-contributors specification](https://github.com/kentcdodds/all-contributors). Contributions of any kind are welcome!

# License
	
This software is licensed under the MIT License.

Copyright Hernán Morales Durand, 2018.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Authors

Hernán Morales Durand


