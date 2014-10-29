// Subclasses of Android::App::IntentService must implement an empty (no-argument) constructor. In RubyMotion, this has to be donein pure Java.
public MyService() {
  super("MyService");
}
