require 'spec_helper'

describe CTX do

  it "Can scope method definitions within a dynamic context" do

    class ContextTest
      def some_method(num)
        "original context : #{num}"
      end
    end

    class ContextTest
      ctx :bar do
        def some_method(num)
          "bar context : #{num * 2}"
        end
        def self.some_other_method(num)
          "other bar context : #{num * 2}"
        end
      end

      ctx :foo do
        def some_method(num)
          "foo context : #{num / 2}"
        end
      end

      ctx do
        def some_method(num)
          "anonymous context : #{num + 2}"
        end
      end

    end

    context = ContextTest.new

    ctx.name.should == nil.sym

    context.some_method(10).should == "original context : 10"

    ctx :foo do
      ctx.name.should == :foo
      ctx[:var] = "in foo context"
      ctx[:var].should == "in foo context"

      context.some_method(10).should == "foo context : 5"

      ctx(:bar) do
        ctx.name.should == :bar
        ctx[:var] = "in bar context"
        ctx[:var].should == "in bar context"

        context.some_method(10).should == "bar context : 20"
        ctx :unknown do
          ctx[:var].should be_nil
          context.some_method(10).should == "bar context : 20"
        end

        context.class.some_other_method(10).should == "other bar context : 20"

      end

      ctx.name.should == :foo
      ctx[:var].should == "in foo context"

      context.some_method(10).should == "foo context : 5"

      ctx do
        ctx.name.should == :anonymous
        context.some_method(10).should == "anonymous context : 12"
      end
    end

    context.some_method(10).should == "original context : 10"

    class ::String
      ctx do
        def +(other)
          "#{self.capitalize} #{other.capitalize}!"
        end
      end
      ctx :test do
        def <<(other)
          "is #{self} << #{other}?"
        end
      end

    end

    ("hello" << "world").should == "helloworld"
    ctx(:test) {
      ("hello" << "world").should == "is hello << world?"
    }

    ("hello" + "world").should_not == "Hello World!"

    ctx {
      ("hello" + "world").should == "Hello World!"
    }


  end

end
