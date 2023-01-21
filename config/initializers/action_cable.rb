require 'action_cable/subscription_adapter/redis'

module ActionCableRedisListenerPatch
  private

  def ensure_listener_running
    @thread ||= Thread.new do
      Thread.current.abort_on_exception = true
      conn = @adapter.redis_connection_for_subscriptions
      listen conn
    rescue ::Redis::BaseConnectionError
      @thread = @raw_client = nil
      ::ActionCable.server.restart
    end
  end
end

ActionCable::SubscriptionAdapter::Redis::Listener.prepend(ActionCableRedisListenerPatch)
