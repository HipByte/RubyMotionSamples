# RubyMotion Storyboard With Automatic View-Loading
This is a [RubyMotion](http://www.rubymotion.com) sample project to demonstrate:  

* Storyboard based view design
* view transition using segues
* automatic instatiation of **custom** ViewControllers via the storyboard
* passing variables to new VCs using prepareForSegue:sender: callback

* * *

The project was inpired by a great series of blog posts by @dalacv.  
You can find his original project on [WordSearcher](https://github.com/dalacv/WordSearcher) on [GitHub](http://www.github.com).  
His blog posts describing the project are located here:

* [Rubymotion and Storyboards](http://dangerousapps.com/blog/2012/05/08/rubymotion-and-storyboards/)
* [Rubymotion ViewController Setup And Uibutton Actions](http://dangerousapps.com/blog/2012/05/08/rubymotion-viewcontroller-setup-and-uibutton-actions/)

### **Note:** *you no longer need to compile the storybord manually RubyMotion 1.4 will take care of that.*

### My code is different in two points:  

First it's using the segue machinism to load and move between views on the storyboard.
Second I'm only ever instanciating the rootViewController explicitly - all other view are created by the storyboard flow.

* * *

### What you'll see

When you run the app you're presented with a view with a text field.
This is managed by *CustomViewController1* - the text you put in the text field will be passed the the subview.
When you press the *To Subview* button the storyboard will create a new *CustomViewController2* instance,
let the current view configure it (using *prepareForSegue:sender:*) and push it to the navigation controller.

*CustomViewController2* consist of a label showing the text from it's parent (the text you entered) and a loop-button.
When the *Push Loop* button is pressed the storyboard will create another *CustomViewController1* and push that on the navigation controller.

To make it easier to distinguish the views each one has a greyed out label at the to showing the vies ruby object.
In addition to this you can observe the creation of new views in the REPL console as each ViewController will do some puts messages.


* * *

### Screenshots

![http://i.imgur.com/bYm7bRw.png](http://i.imgur.com/bYm7bRw.png)
![http://i.imgur.com/bA8XOfn.png](http://i.imgur.com/bA8XOfn.png)

