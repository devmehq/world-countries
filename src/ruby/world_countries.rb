require 'json'

module WorldCountries
  class Countries
    attr_reader :countries

    def initialize
      json_path = File.join(File.dirname(__FILE__), '..', '..', 'data', 'world-countries.json')
      json_content = File.read(json_path)
      @countries = JSON.parse(json_content)
    end

    def all
      @countries
    end

    def get_by_alpha2_code(code)
      code_upper = code.upcase
      @countries.find { |country| country['cca2'] == code_upper }
    end

    def get_by_alpha3_code(code)
      code_upper = code.upcase
      @countries.find { |country| country['cca3'] == code_upper }
    end

    def get_by_numeric_code(code)
      @countries.find { |country| country['ccn3'] == code.to_s }
    end

    def get_by_common_name(name)
      name_lower = name.downcase
      @countries.find { |country| country['name']['common'].downcase == name_lower }
    end

    def get_by_official_name(name)
      name_lower = name.downcase
      @countries.find { |country| country['name']['official'].downcase == name_lower }
    end

    def get_by_region(region)
      region_lower = region.downcase
      @countries.select { |country| country['region'].downcase == region_lower }
    end

    def get_by_subregion(subregion)
      subregion_lower = subregion.downcase
      @countries.select { |country| country['subregion'].downcase == subregion_lower }
    end

    def get_by_currency(currency_code)
      code_upper = currency_code.upcase
      @countries.select { |country| country['currencies'].key?(code_upper) }
    end

    def get_by_language(language_code)
      code_lower = language_code.downcase
      @countries.select { |country| country['languages'].key?(code_lower) }
    end

    def get_by_capital(capital)
      capital_lower = capital.downcase
      @countries.select do |country|
        country['capital'].any? { |cap| cap.downcase == capital_lower }
      end
    end

    def get_by_continent(continent)
      continent_lower = continent.downcase
      @countries.select do |country|
        country['continents'].any? { |cont| cont.downcase == continent_lower }
      end
    end

    def get_by_borders(country_code)
      code_upper = country_code.upcase
      @countries.select { |country| country['borders'].include?(code_upper) }
    end

    def get_landlocked
      @countries.select { |country| country['landlocked'] == true }
    end

    def get_independent
      @countries.select { |country| country['independent'] == true }
    end

    def get_un_members
      @countries.select { |country| country['unMember'] == true }
    end

    def search(query)
      search_term = query.downcase
      @countries.select do |country|
        country['name']['common'].downcase.include?(search_term) ||
        country['name']['official'].downcase.include?(search_term) ||
        country['cca2'].downcase.include?(search_term) ||
        country['cca3'].downcase.include?(search_term) ||
        country['capital'].any? { |cap| cap.downcase.include?(search_term) } ||
        country['altSpellings'].any? { |alt| alt.downcase.include?(search_term) }
      end
    end

    def get_by_timezone(timezone)
      @countries.select { |country| country['timezones'].include?(timezone) }
    end

    def get_by_calling_code(code)
      @countries.select do |country|
        full_code = country['idd']['root'] + country['idd']['suffixes'].join
        full_code.include?(code.to_s)
      end
    end

    def all_currencies
      currencies = []
      @countries.each do |country|
        currencies.concat(country['currencies'].keys)
      end
      currencies.uniq.sort
    end

    def all_languages
      languages = []
      @countries.each do |country|
        languages.concat(country['languages'].keys)
      end
      languages.uniq.sort
    end

    def all_capitals
      capitals = []
      @countries.each do |country|
        capitals.concat(country['capital'])
      end
      capitals.uniq.sort
    end

    def all_regions
      @countries.map { |country| country['region'] }.uniq.sort
    end

    def all_subregions
      @countries.map { |country| country['subregion'] }.uniq.sort
    end

    def all_continents
      continents = []
      @countries.each do |country|
        continents.concat(country['continents'])
      end
      continents.uniq.sort
    end

    def all_timezones
      timezones = []
      @countries.each do |country|
        timezones.concat(country['timezones'])
      end
      timezones.uniq.sort
    end

    def count
      @countries.size
    end

    def get_by_area(min_area: nil, max_area: nil)
      @countries.select do |country|
        next false if min_area && country['area'] < min_area
        next false if max_area && country['area'] > max_area
        true
      end
    end

    def get_by_population(min_pop: nil, max_pop: nil)
      @countries.select do |country|
        next false if min_pop && country['population'] < min_pop
        next false if max_pop && country['population'] > max_pop
        true
      end
    end

    def sort_by_name(order: 'asc')
      sorted = @countries.sort_by { |country| country['name']['common'] }
      order == 'desc' ? sorted.reverse : sorted
    end

    def sort_by_population(order: 'desc')
      sorted = @countries.sort_by { |country| country['population'] }
      order == 'desc' ? sorted.reverse : sorted
    end

    def sort_by_area(order: 'desc')
      sorted = @countries.sort_by { |country| country['area'] }
      order == 'desc' ? sorted.reverse : sorted
    end
  end
end