import countriesData from '../../data/world-countries.json';

export interface NativeName {
  official: string;
  common: string;
}

export interface Currency {
  name: string;
  symbol: string;
}

export interface Idd {
  root: string;
  suffixes: string[];
}

export interface Translation {
  official: string;
  common: string;
}

export interface Demonym {
  f: string;
  m: string;
}

export interface Maps {
  googleMaps: string;
  openStreetMaps: string;
}

export interface Car {
  signs: string[];
  side: string;
}

export interface Images {
  png: string;
  svg: string;
  alt?: string;
}

export interface CapitalInfo {
  latlng: number[];
}

export interface PostalCode {
  format: string;
  regex: string;
}

export interface Gini {
  [year: string]: number;
}

export interface Country {
  name: {
    common: string;
    official: string;
    nativeName?: Record<string, NativeName>;
  };
  tld: string[];
  cca2: string;
  ccn3: string;
  cca3: string;
  cioc: string;
  independent: boolean;
  status: string;
  unMember: boolean;
  currencies: Record<string, Currency>;
  idd: Idd;
  capital: string[];
  altSpellings: string[];
  region: string;
  subregion: string;
  languages: Record<string, string>;
  translations: Record<string, Translation>;
  latlng: number[];
  landlocked: boolean;
  borders: string[];
  area: number;
  demonyms: {
    eng: Demonym;
    fra: Demonym;
  };
  flag: string;
  maps: Maps;
  population: number;
  gini?: Gini;
  fifa: string;
  car: Car;
  timezones: string[];
  continents: string[];
  flags: Images;
  coatOfArms: Images;
  startOfWeek: string;
  capitalInfo: CapitalInfo;
  postalCode: PostalCode;
}

export class WorldCountries {
  private countries: Country[];

  constructor() {
    this.countries = countriesData as any as Country[];
  }

  getAll(): Country[] {
    return this.countries;
  }

  getByAlpha2Code(code: string): Country | undefined {
    return this.countries.find(c => c.cca2 === code.toUpperCase());
  }

  getByAlpha3Code(code: string): Country | undefined {
    return this.countries.find(c => c.cca3 === code.toUpperCase());
  }

  getByNumericCode(code: string): Country | undefined {
    return this.countries.find(c => c.ccn3 === code);
  }

  getByCommonName(name: string): Country | undefined {
    const nameLower = name.toLowerCase();
    return this.countries.find(c => c.name.common.toLowerCase() === nameLower);
  }

  getByOfficialName(name: string): Country | undefined {
    const nameLower = name.toLowerCase();
    return this.countries.find(c => c.name.official.toLowerCase() === nameLower);
  }

  getByRegion(region: string): Country[] {
    return this.countries.filter(c => c.region.toLowerCase() === region.toLowerCase());
  }

  getBySubregion(subregion: string): Country[] {
    return this.countries.filter(c => c.subregion.toLowerCase() === subregion.toLowerCase());
  }

  getByCurrency(currencyCode: string): Country[] {
    const code = currencyCode.toUpperCase();
    return this.countries.filter(c => code in c.currencies);
  }

  getByLanguage(languageCode: string): Country[] {
    const code = languageCode.toLowerCase();
    return this.countries.filter(c => code in c.languages);
  }

  getByCapital(capital: string): Country[] {
    const capitalLower = capital.toLowerCase();
    return this.countries.filter(c => 
      c.capital.some(cap => cap.toLowerCase() === capitalLower)
    );
  }

  getByContinent(continent: string): Country[] {
    return this.countries.filter(c => 
      c.continents.some(cont => cont.toLowerCase() === continent.toLowerCase())
    );
  }

  getByBorders(countryCode: string): Country[] {
    const code = countryCode.toUpperCase();
    return this.countries.filter(c => c.borders.includes(code));
  }

  getLandlocked(): Country[] {
    return this.countries.filter(c => c.landlocked);
  }

  getIndependent(): Country[] {
    return this.countries.filter(c => c.independent);
  }

  getUNMembers(): Country[] {
    return this.countries.filter(c => c.unMember);
  }

  search(query: string): Country[] {
    const searchTerm = query.toLowerCase();
    return this.countries.filter(c => 
      c.name.common.toLowerCase().includes(searchTerm) ||
      c.name.official.toLowerCase().includes(searchTerm) ||
      c.capital.some(cap => cap.toLowerCase().includes(searchTerm)) ||
      c.altSpellings.some(alt => alt.toLowerCase().includes(searchTerm)) ||
      c.cca2.toLowerCase().includes(searchTerm) ||
      c.cca3.toLowerCase().includes(searchTerm)
    );
  }

  getByTimezone(timezone: string): Country[] {
    return this.countries.filter(c => c.timezones.includes(timezone));
  }

  getByCallingCode(code: string): Country[] {
    return this.countries.filter(c => {
      const fullCode = c.idd.root + c.idd.suffixes.join('');
      return fullCode.includes(code);
    });
  }

  getAllCurrencies(): string[] {
    const currencies = new Set<string>();
    this.countries.forEach(c => {
      Object.keys(c.currencies).forEach(curr => currencies.add(curr));
    });
    return Array.from(currencies).sort();
  }

  getAllLanguages(): string[] {
    const languages = new Set<string>();
    this.countries.forEach(c => {
      Object.keys(c.languages).forEach(lang => languages.add(lang));
    });
    return Array.from(languages).sort();
  }

  getAllCapitals(): string[] {
    const capitals = new Set<string>();
    this.countries.forEach(c => {
      c.capital.forEach(cap => capitals.add(cap));
    });
    return Array.from(capitals).sort();
  }

  getAllRegions(): string[] {
    const regions = new Set<string>();
    this.countries.forEach(c => regions.add(c.region));
    return Array.from(regions).sort();
  }

  getAllSubregions(): string[] {
    const subregions = new Set<string>();
    this.countries.forEach(c => subregions.add(c.subregion));
    return Array.from(subregions).sort();
  }

  getAllContinents(): string[] {
    const continents = new Set<string>();
    this.countries.forEach(c => {
      c.continents.forEach(cont => continents.add(cont));
    });
    return Array.from(continents).sort();
  }

  getAllTimezones(): string[] {
    const timezones = new Set<string>();
    this.countries.forEach(c => {
      c.timezones.forEach(tz => timezones.add(tz));
    });
    return Array.from(timezones).sort();
  }

  count(): number {
    return this.countries.length;
  }

  getByArea(minArea?: number, maxArea?: number): Country[] {
    return this.countries.filter(c => {
      if (minArea !== undefined && c.area < minArea) return false;
      if (maxArea !== undefined && c.area > maxArea) return false;
      return true;
    });
  }

  getByPopulation(minPop?: number, maxPop?: number): Country[] {
    return this.countries.filter(c => {
      if (minPop !== undefined && c.population < minPop) return false;
      if (maxPop !== undefined && c.population > maxPop) return false;
      return true;
    });
  }

  sortByName(order: 'asc' | 'desc' = 'asc'): Country[] {
    const sorted = [...this.countries].sort((a, b) => 
      a.name.common.localeCompare(b.name.common)
    );
    return order === 'desc' ? sorted.reverse() : sorted;
  }

  sortByPopulation(order: 'asc' | 'desc' = 'desc'): Country[] {
    const sorted = [...this.countries].sort((a, b) => a.population - b.population);
    return order === 'desc' ? sorted.reverse() : sorted;
  }

  sortByArea(order: 'asc' | 'desc' = 'desc'): Country[] {
    const sorted = [...this.countries].sort((a, b) => a.area - b.area);
    return order === 'desc' ? sorted.reverse() : sorted;
  }
}

export const countries = new WorldCountries();
export default countries;