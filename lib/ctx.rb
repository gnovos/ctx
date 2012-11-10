module CTX

  class ::Array
    def return_first(&block)
      returned = nil
      each { |item| break if (returned = block.call(item)) }
      returned
    end
  end

  class Context < Hash
    attr_reader :name
    def initialize(name) @name = name.sym end
    def eql?(other) @name.eql?(other.name) end
    def hash() @name.hash end
    def to_s() "#{name} #{super.to_s}" end
  end

  class ::Object
    def sym() respond_to?(:to_sym) ? to_sym : to_s.to_sym end
    def ctxputs(*args)
      ctxs = @@contexts.map(&:name)[1..-1].join(":")
      ctxs = "[CTX #{ctxs}] " unless ctxs.empty?
      puts "#{ctxs}#{args.map(&:to_s).join(', ')}"
    end
    def ctxp(*args)
      ctxs = @@contexts.map(&:name)[1..-1].join(":")
      ctxs = "[CTX #{ctxs.empty? ? "-" : ctxs}]"
      puts "#{ctxs}\n#{args.map(&:inspect).join("\n")}"
    end

    @@contexts ||= [Context.new(nil)]
    def ctx(context = :anonymous, &contextual)
      if contextual.nil?
        @@contexts.reverse.first
      else
        @@contexts.push(Context.new(context))
        instance_eval(&contextual)
        @@contexts.pop()
      end
    end

  end

  class ::Class

    def object_methods() self.instance_methods - Object.instance_methods end
    def class_methods() self.singleton_methods - Object.singleton_methods end
    def defined_methods() class_methods | object_methods end

    attr_accessor :ctx_methods

    def ctx(context = :anonymous, &contextual)
      @ctx_methods ||= {}

      template = Class.new
      template.class_eval(&contextual)

      matching = self.object_methods & template.object_methods
      matching.each do |method_name|
        if ctx_methods[method_name].nil?
          ctx_methods[method_name] = {}
          ctx_methods[method_name][nil.sym] = instance_method(method_name)
        end
      end

      self.class_eval(&contextual)

      template.object_methods.each do |method_name|
        if ctx_methods[method_name].nil?
          ctx_methods[method_name] = {}
        end

        ctx_methods[method_name][context] = instance_method(method_name)

        define_method(method_name) do |*args|
          methods = self.class.ctx_methods[method_name]
          matched = @@contexts.reverse.return_first { |currentctx|  methods[currentctx.name] }
          matched.bind(self).(*args)
        end

      end
    end
  end
end
