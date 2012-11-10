ctx
===

Simple utility to limit method redefinition within the bounds of arbitrary logical scopes

Example
===

Here, figure it out:

    require 'ctx'

    class ::String
      ctx :reversaroo do
        def +(other)
          "#{other.reverse}#{self.reverse}"
        end
      end
      ctx :camels do
        def +(other)
          "#{self.capitalize}#{other.capitalize}"
        end
      end
      ctx :polite do
        def +(other)
          "I say, good day to you there '#{other}', may I introduce you to my good friend '#{self}'?"
        end
      end
      ctx do
        def +(other)
          "#{self} + #{other} = ?"
        end
      end
    end

    puts "hello" + "world"
    #=> helloworld

    ctx :camels do
      puts "hello" + "world"
      #=> HelloWorld

      ctx :polite do
        puts "hello" + "world"
        #=> I say, good day to you there 'world', may I introduce you to my good friend 'hello'?
      end

      ctx do
        puts "hello" + "world"
        #=> hello + world = ?
      end
    end

    ctx :reversaroo do
      puts "hello" + "world"
      #=> dlrowolleh
    end

    puts "hello" + "world"
    #=> helloworld


There are bugs.  You'll find them.

---

Caveats and such
===

For whatever goofy reason, this stuff doesn't play well with rspec all the time, particularly if you override stuff the matchers are hoping to also override, like == or =~ on String, or whatnot.  Don't do that right now unless you like stuff to break in inexplicable ways.  Personally, I do like that kind of stuff, makes life interesting (kind of explains my dating choices, when you get right down to it), but anywhoo, honestly, it's your call.

