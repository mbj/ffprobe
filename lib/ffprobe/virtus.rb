# Extensions for virtus to support rationals as first class citizens
module Virtus
  # Extensions to coercion classes
  class Coercion
    # String coercions
    class String < ::Virtus::Coercion::Object
      DIVISION_FORMAT = %r(\A(:?-?)([0-9]+)/([0-9]+)\z)
      FLOAT_FORMAT    = %r(\A(:?-?)([0-9]+)\.([0-9]+)\z)
      INTEGER_FORMAT  = %r(\A(:?-?)([0-9]+)\z)

      TABLE = {
        DIVISION_FORMAT => :division_to_rational,
        FLOAT_FORMAT    => :float_to_rational,
        INTEGER_FORMAT  => :integer_to_rational
      }

      # Creates a rational from an String
      #
      # @example
      #   Virtus::Coercion::String.to_rational('1.9') => Rational(19,10)
      #
      # @param [String] value
      #
      # @return [Rational|String]
      #   returns Rational if is a valid rational
      #   retunrs String if not
      #
      # @api private
      def self.to_rational(value)
        TABLE.each do |regexp,method|
          match = regexp.match(value)
          next unless match
          return send(method,match)
        end

        value
      end

      # Convert division match into rational
      #
      # @api private
      #
      # @param [MatchData] match
      #
      # @return [Rational]
      #
      # @api private
      #
      def self.division_to_rational(match)
        sign,numerator,denominator = match.captures
        numerator   = numerator.to_i(10)
        denominator = denominator.to_i(10)
        if numerator.zero? or denominator.zero?
          numerator = 0
          denominator = 1
        end
        Rational(numerator,denominator) * to_sign(sign)
      end
      private_class_method :division_to_rational

      # Convert float match into rational
      #
      # @api private
      #
      # @param [MatchData] match
      #
      # @return [Rational]
      #
      # @api private
      #
      def self.float_to_rational(match)
        sign,full,fraction = match.captures
        scale       = 10**(fraction.length)
        numerator   = (full.to_i(10))*scale+fraction.to_i(10)
        Rational(numerator,scale) * to_sign(sign)
      end
      private_class_method :float_to_rational

      # Convert integer match into rational
      #
      # @api private
      #
      # @param [MatchData] match
      #
      # @return [Rational]
      #
      # @api private
      #
      def self.integer_to_rational(match)
        sign,numerator = match.captures
        Rational(numerator.to_i(10),1) * to_sign(sign)
      end
      private_class_method :integer_to_rational

      # Convert string to sign
      #
      # @param [String] value
      #
      # @return [1|-1] 
      #
      # @api private
      #
      def self.to_sign(value)
        value == '-' ? -1 : 1
      end
    end

#   # Integer coercions
#   class Integer < ::Virtus::Coercion::Numeric
#     # Creates a rational from an Integer
#     #
#     # @example
#     #   Virtus::Coercion::Integer.to_rational(10) => Rational(10,1)
#     #
#     # @param [Integer] value
#     #
#     # @return [Rational]
#     #
#     # @api private
#     def self.to_rational(value)
#       Rational(value,1)
#     end
#   end
  end

  # Attribute baseclass
  class Attribute
    # Rational attribute
    #
    # @example
    #   class Entity
    #     include Virtus
    #
    #     attribute :rational,Rational
    #   end
    #
    #   post = Entity.new(:rational => 1)
    #
    class Rational < Virtus::Attribute::Object
      primitive ::Rational
      coercion_method :to_rational
    end
  end
end

