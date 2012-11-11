require 'mobj'

module CTX

  class Context < Hash
    attr_reader :name
    def initialize(name) @name = name.sym end
    def eql?(other) @name.eql?(other.name) end
    def hash() @name.hash end
    def to_s() "#{name} #{super.to_s}" end
  end

  class ::Object
    def ctxputs(*args)
      ctxs = @@contexts.map(&:name)[1..-1].reverse.join(":")
      ctxs = "[CTX #{ctxs}] " unless ctxs.empty?
      puts "#{ctxs}#{args.map(&:to_s).join(', ')}"
    end
    def ctxp(*args)
      ctxs = @@contexts.map(&:name)[1..-1].reverse.join(":")
      ctxs = "[CTX #{ctxs.empty? ? "-" : ctxs}]"
      puts "#{ctxs}\n#{args.map(&:inspect).join("\n")}"
    end

    @@contexts ||= [Context.new(nil)]
    def ctx(context = :anonymous, &contextual)
      if contextual.nil?
        @@contexts.first
      else
        @@contexts.unshift(Context.new(context))
        instance_eval(&contextual)
        @@contexts.shift()
      end
    end

  end

  class Template < BasicObject

    attr_accessor :added
    def initialize() @added ||= [] end
    def singleton_method_added(name) added << name end

  end

  class ::Class

    attr_accessor :ctx_methods

    def ctx(context = :anonymous, &contextual)
      @ctx_methods ||= {}

      template = Template.new
      template.instance_exec(self, &contextual)

      matching = template.added

      matching.each do |method_name|
        if ctx_methods[method_name].nil?
          ctx_methods[method_name] = {}
          if instance_methods(true).includes? method_name
            ctx_methods[method_name][nil.sym] = instance_method(method_name)
          elsif singleton_methods(true).include? method_name
            ctx_methods[method_name][nil.sym] = singleton_class.instance_method(method_name)
          end
        end
      end

      self.class_eval(&contextual)

      matching.each do |method_name|
        if instance_methods(true).includes? method_name
          ctx_methods[method_name][context] = instance_method(method_name)
          define_method(method_name) do |*args|
            methods = self.class.ctx_methods[method_name]
            matched = @@contexts.return_first { |currentctx|  methods[currentctx.name] }
            matched.bind(self).(*args)
          end

        elsif singleton_methods(true).include? method_name
          ctx_methods[method_name][context] = singleton_class.instance_method(method_name)

          define_singleton_method(method_name) do |*args|
            methods = self.ctx_methods[method_name]
            matched = @@contexts.return_first { |currentctx|  methods[currentctx.name] }
            matched.bind(self).(*args)
          end
        end
      end
    end
  end
end
