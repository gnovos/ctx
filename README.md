ctx
===

Simple utility to limit method redefinition within the bounds of arbitrary logical scopes

Example
===

Here, figure it out:

    class ::String
      ctx_define :reversaroo, :+ do |other|
        "#{other.reverse}#{self.reverse}"
      end
      ctx_define :camels, :+ do |other|
        "#{self.capitalize}#{other.capitalize}"
      end
      ctx_define :polite, :+ do |other|
        "I say, good day to you there #{other}, may I introduce you to my good friend #{self}?"
      end
      ctx_define :+ do |other|
        "#{self} + #{other} = ?"
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
