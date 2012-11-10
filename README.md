ctx
===

Simple utility to limit method redefinition within the bounds of arbitrary logical scopes

Example
===

Here, figure it out:

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
          "I say, good day to you there #{other}, may I introduce you to my good friend #{self}?"
        end
      end
      ctx do
        def +(other)
          "#{self} + #{other} = ?"
        end
      end
    end

    puts "hello" + "world"

    ctx :camels do
      puts "hello" + "world"
      ctx :polite do
        puts "hello" + "world"
      end

      ctx do
        puts "hello" + "world"
      end
    end

    ctx :reversaroo do
      puts "hello" + "world"
    end

    puts "hello" + "world"


There are bugs.  You'll find them.

---

Caveats and such
===

For whatever goofy reason, this stuff doesn't play well with rspec all the time, particularly if you override stuff the matchers are hoping to also override, like == or =~ on String, or whatnot.  Don't do that right now unless you like stuff to break in inexplicable ways.  Personally, I do like that kind fo stuff, makes life interesting, but honestly, it's your call.

