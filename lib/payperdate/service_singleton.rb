module ServiceSingleton
  def instance=(impl)
    @instance = (Symbol === impl) ? build_impl(impl) : impl
  end

  def instance
    @instance
  end

  def respond_to_missing?(method_name, include_private=false)
    instance.respond_to?(method_name, include_private)
  end

  private

  def method_missing(method_name, *args, &block)
    instance.respond_to?(method_name) ? instance.send(method_name, *args, &block) : super
  end
end