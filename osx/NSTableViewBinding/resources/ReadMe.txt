NSTableViewBinding
==================

NSTableViewBinding is an application that demonstrates how to use Cocoa Bindings with a NSTableView.  It demonstrates how to setup bindings in both Interface Builder or programatically.  The compile flag "kUse_Bindings_By_Code" inside MyWindowController.m will instruct the compiler to build code that establishes the very same bindings created in Interface Builder.  Of course, to set this flag will mean that these bindings setup in Interface Builder will not be necessary and become redundant.

It demonstrates controlling NSTableView with the following:
NSArrayController drives the content for each table column.
NSArrayController drives the table's current selection.
Provides table row double-click inspection.
Proper enabling/disabling of buttons based on the table's current selection.
NSArrayController drives the content of several NSTextFields based on the controller's selection.
Provides notification of table selection changes through the use of observeValueForKeyPath.

===========================================================================
Sample Requirements
The supplied Xcode project was created using Xcode v4.3 or later running under Mac OS X 10.6.x or later.

===========================================================================
Using the Sample
Build and run the sample using Xcode.  Use the Add and Remove buttons to and remove people from the table.  You can edit each person's info by changing the first, last, and phone text fields.  By double-clicking a row in the table can also alternately edit a given person through the use of a sheet window.

===========================================================================
Changes from Previous Versions
1.0 - First version
1.1 - Upgraded to Xcode 4.3 and Mac OS X 10.7.


Copyright (C) 2010-2012 Apple Inc. All rights reserved.