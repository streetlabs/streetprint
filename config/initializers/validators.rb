ActiveRecord::Base.class_eval do
  
  def self.validates_liquid_syntax(*attr_names)
    validates_each(attr_names) do |record, attr_name, value|
      unless value.nil?
        begin
          Liquid::Template.parse(value)
        rescue Liquid::SyntaxError
          record.errors.add(attr_name, "has the liquid syntax error:\n#{$!}")
        end
      end
    end
  end
end