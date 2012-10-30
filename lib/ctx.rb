module CTX

  class ::Array
    def select_first(&block)
      selected = nil
      each do |item|
        break if (selected = block.call(item))
      end
      selected
    end
  end

  class Context < Hash
    attr_reader :name
    def initialize(name) @name = name.to_sym end
    def eql?(other) @name.eql?(other.name) end
    def hash() @name.hash end
  end

  class ::BasicObject

    def ctx(name = :anonymous, &scoped) self.class.ctx(name, &scoped) end

    class << self
      @@contexts = [nil]
      def ctx(name = :anonymous, &scoped)
        return @@contexts.last if scoped.nil?

        context = Context.new(name)
        @@contexts.push(context)
        scoped.call(self)
        @@contexts.pop
      end

      def ctx_define(context = :anonymous, method, &definition)
        method = method.to_sym
        @@ctx_methods ||= {}
        @@ctx_methods[method] ||= {}

        if @@ctx_methods[method][nil].nil?
          @@ctx_methods[method][nil] = instance_method(method) if method_defined? method
          define_method(method) do |*args|
            methods = @@ctx_methods[method]
            matched = @@contexts.reverse.select_first { |ctx| methods[ctx ? ctx.name : nil] }
            matched.bind(self).(*args)
          end
        end

        scoped_method = "#{context}_#{method}".to_sym
        define_method(scoped_method, &definition)
        @@ctx_methods[method][context] = instance_method(scoped_method)
      end
    end
  end
end