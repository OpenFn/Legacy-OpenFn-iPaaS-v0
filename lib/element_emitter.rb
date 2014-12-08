require 'ox'
class ElementEmitter < ::Ox::Sax
  def initialize(&block)
    @line = nil
    @column = nil
    @active_handlers = []
    @block = block
  end

  def start_element(name)
    if handlers.keys.include?(name) && !@active_handlers.include?(name)
      @active_handlers << name 
    end
    call_handlers(:start_element,name)
  end

  def end_element(name)
    call_handlers(:end_element,name)
    @active_handlers -= [name] if handlers.keys.include? name
  end

  def attr(name, value)
    call_handlers(:attr,name,value)
  end

  class << self
    def handlers
      @handlers
    end

    def handler(handler,callbacks)
      @handlers ||= {}
      @handlers.merge!({handler => callbacks})
    end
  end
  private

  def handlers
    self.class.handlers
  end

  def emit(descriptor)
    @block.call(descriptor)
  end

  def call_handlers(event,*args)
    @active_handlers.each { |key|
      proc = handlers[key][event]
      self.instance_exec(*args,&proc) if proc
    }
  end
end
