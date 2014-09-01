
The app showcases the use of extension and framework targets in iOS. This were the console commands used to create the main app and targets:

```bash
motion create ExtensionsAndFrameworks --template=ios
cd ExtensionsAndFrameworks
mkdir extensions && cd extensions
motion create custom-keyboard --template=ios-custom-keyboard
motion create today-extension --template=ios-today-extension
cd ../ && mkdir frameworks && cd frameworks
motion create my-shared-framework --template=ios-framework
```

After that, we declare the extension targets in the main app Rakefile:

```ruby
app.target("extensions/today-extension", :extension)
app.target("extensions/custom-keyboard", :extension)
```

As well as the framework target in the main app and each extension Rakefile:

```ruby
app.target("frameworks/my-shared-framework", :framework)
```