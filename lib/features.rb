# Feature Flag Singleton
# ======================
#
# Ruby'esque ENV inspector.
#
# String Booleans
# ---------------
#
# Example:
#
#   MY_FLAG=true rails c
#   > Features.my_flag?
#   # => true

class Features

  def self.method_missing(sym)
    key = sym.to_s.match(/(\w+)([\?$]?)/)

    if flag = ENV[key[1].upcase]
      if key[2] == "?"
        case flag
        when "true"
          true
        when "false"
          false
        else
          !!flag
        end
      else
        flag
      end
    else
      super
    end
  end
end
