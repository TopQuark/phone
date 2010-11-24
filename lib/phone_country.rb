class PhoneCountry < Struct.new(:name, :country_code, :char_2_code, :area_code)
  cattr_accessor :all

  attr_reader :char_3_code

  def initialize(name, country_code, char_2_code, area_code, char_3_code)
    super(name, country_code, char_2_code, area_code)
    @char_3_code = char_3_code
  end

  def self.load
    return @@all if @@all.present?
    
    data_file = File.join(File.dirname(__FILE__), '..', 'data', 'phone_countries.yml')
    
    @@all = {}
    YAML.load(File.read(data_file)).each_pair do |key, c|
      @@all[key] = PhoneCountry.new(c[:name], c[:country_code], c[:char_2_code], c[:area_code], c[:char_3_code])
    end
    @@all
  end
  
  def to_s
    name
  end
  
  def self.find_by_country_code(code)
    @@all[code]    
  end

  def self.find_by_country_abbreviation(char_3_code)
    self.load unless @@all.present?

    @@all.each_pair do |k, c|
      return c if c.char_3_code == char_3_code
    end
  end
  
  def country_code_regexp
    Regexp.new("^[+]#{country_code}")    
  end
end
