# There are two ways to execute code in the background using the AsyncTask class
#
# In the first one, we create a Runnable class, which is simply a class which
# implements the 'run' method, where the code to be run in the background is
# implemented. Then we simply run it like this:
#
# Android::Os::AsyncTask.execute(MyRunnable.new)
#
class MyRunnable
  def run
    puts "I'm running in the background"
  end
end

# The other way is to create a subclass of AsyncTask, overriding a few methods.
class MyAsyncTask < Android::Os::AsyncTask

  # This method will be run in the background. The parameter is an array passed
  # to the 'execute' method.
  def doInBackground(params)
    puts "doInBackground #{params}"
    # You can use this method to update the progress
    self.publishProgress([1,2,3])
    # Whatever this method returns will be passed to the onPostExecute method
    "Win"
  end

  # This method will be called *before* the work is done
  def onPreExecute
    puts "onPreExecute"
  end

  def onProgressUpdate(params)
    puts "onProgressUpdate: #{params}"
  end

  # This method will be called *after* the work is done, with the return value
  # of the 'doInBackground' method.
  def onPostExecute(result)
    puts "Result: #{result}"
  end
end

class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super
    Android::Os::AsyncTask.execute(MyRunnable.new)

    # If you dont want any params, just use an empty array.
    my_task = MyAsyncTask.new
    my_task.execute(['foo','bar'])
  end
end
