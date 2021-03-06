module FHIR

  class AnyType

    attr_accessor :type
    attr_accessor :value

    PRIMITIVES = ['integer','positiveInt','unsignedInt','decimal','string','markdown','uri','oid','boolean','code','id','base64binary']
    DATE_TIMES = ['datetime','date','time','instant']

    def initialize(type,value)
      @type = type
      @value = value
    end

    def ==(other)
      type == other.type && value == other.value
    end

    # # Converts an object of this instance into a database friendly value.
    # def mongoize
    #   {'type'=>type, 'value'=>val}
    # end

    # class << self

    #   # Get the object as it was stored in the database, and instantiate
    #   # this custom class from it.
    #   def demongoize(object)
    #     case object
    #     when Hash
    #       type = object['type']
    #       value = object['value']
    #       type.constantize.create(value)
    #     else
    #       object
    #     end
    #   end

    #   # Takes any possible object and converts it to how it would be
    #   # stored in the database.
    #   def mongoize(object)
    #     case object
    #     when AnyType then object.mongoize
    #     when Hash
    #       v = object[:value]
    #       case object[:type].downcase
    #       when 'integer', 'decimal', 'boolean'
    #         v = YAML.load(v)
    #       end
    #       convertType(v)
    #     else
    #       convertType(object)
    #     end
    #   end

    #   def convertType(object)
    #     if (object.respond_to?(:is_fhir_class?) && object.is_fhir_class?(object.class.name))
    #       AnyType.new(object).mongoize
    #     else
    #       object
    #     end
    #   end

    #   # Converts the object that was supplied to a criteria and converts it
    #   # into a database friendly form.
    #   def evolve(object)
    #     case object
    #     when AnyType then object.mongoize
    #     else object
    #     end
    #   end

    # end
  end
end
