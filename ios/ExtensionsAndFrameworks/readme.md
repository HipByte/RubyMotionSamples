
This app showcases the use of extension and framework targets in iOS. These were the console commands used to create the main app and targets:

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

## Enabling the custom keyboard:

1. Comple and run this app
2. Hit `CMD`+`Shift`+`h` to go to the home screen
3. Open the Settings app
4. Go to General -> Keyboard -> Keyboards
5. Tap "Add New Keyboard..." and select the "ExtensionsAndFrameworks" keyboard
6. Hit `CMD`+`Shift`+`h` to go back to the home screen
7. Launch the ExtensionsAndFrameworks app again
8. Tap the globe icon till the custom keyboard appears
