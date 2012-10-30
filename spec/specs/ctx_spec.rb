require 'spec_helper'

describe CTX do

  it "Can scope method definitions within a dynamic context" do

    class ContextTest
      def some_method(num)
        "original context : #{num}"
      end
    end

    class ContextTest
      ctx_define :bar, :some_method do |num|
        "bar context : #{num * 2}"
      end

      ctx_define :foo, :some_method do |num|
        "foo context : #{num / 2}"
      end

      ctx_define :some_method do |num|
        "anonymous context : #{num + 2}"
      end

    end

    context = ContextTest.new

    ctx.should be_nil

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
          context.some_method(10).should == "bar context : 20"
        end
      end

      ctx.name.should == :foo

      context.some_method(10).should == "foo context : 5"

      ctx do
        ctx.name.should == :anonymous
        context.some_method(10).should == "anonymous context : 12"
      end
    end

    context.some_method(10).should == "original context : 10"

    class ::String
      ctx_define :+ do |other|
        "#{self.capitalize} #{other.capitalize}!"
      end
    end

    ("hello" + "world").should_not == "Hello World!"

    ctx {
      ("hello" + "world").should == "Hello World!"
    }

  end

end
