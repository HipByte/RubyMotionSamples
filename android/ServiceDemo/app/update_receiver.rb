class UpdateReceiver < Android::Content::BroadcastReceiver
  Message = "UpdateReceiverMessage"

  attr_accessor :delegate

  def onReceive(content, intent)
    # This method is called when we receive a broadcasted message. We just notify our delegate.
    update = intent.getStringExtra(MyService::UpdateStatus)
    if update and @delegate.respond_to?(:updateReceived)
      @delegate.updateReceived(Java::Lang::Integer.new(update))
    end
  end
end
