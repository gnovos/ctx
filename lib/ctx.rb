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

  class ::BasicObject

    def scope(name=:anonymous, &scoped) self.class.scope(name, &scoped) end
    def current_scope() self.class.current_scope end
    def scope_context() self.class.scope_context end

    class << self
      @@scope = [nil]
      @@scope_contexts = {}
      def scope(name, &scoped)
        @@scope.push(name)
        @@scope_contexts[name] = {}
        scoped.call(self)
        @@scope_contexts[name].clear
        @@scope.pop
      end
      def current_scope() @@scope.last end
      def scope_context() @@scope_contexts[current_scope] end
      def scoped_define(scope=:anonymous, method, &definition)
        method = method.to_sym
        @@scoped_methods ||= {}
        @@scoped_methods[method] ||= {}

        if @@scoped_methods[method][nil].nil?
          @@scoped_methods[method][nil] = instance_method(method) if method_defined? method
          define_method(method) do |*args|
            methods = @@scoped_methods[method]
            matched = @@scope.reverse.select_first { |scp| methods[scp] }
            matched.bind(self).(*args)
          end
        end

        scoped_method = "#{scope}_#{method}".to_sym
        define_method(scoped_method, &definition)
        @@scoped_methods[method][scope] = instance_method(scoped_method)
      end
    end
  end
end