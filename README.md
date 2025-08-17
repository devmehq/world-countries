# World Countries

Comprehensive world countries data including names, codes, capitals, currencies, languages, and more. Available for TypeScript, PHP, Ruby, and Python.

## Features

- 🌍 **Complete Coverage**: Data for all world countries
- 🏛️ **Rich Information**: Country names, native names, capitals, currencies, languages, phone codes, continents, and emoji flags
- 🔍 **Smart Search**: Search by name, code, continent, currency, language, or phone code
- 📦 **Multi-Language Support**: Available for TypeScript/JavaScript, PHP, Ruby, and Python
- 🎯 **Type-Safe**: Full TypeScript support with type definitions
- ⚡ **Lightweight**: Zero dependencies, pure JSON data
- 🔄 **ISO Standards**: Follows ISO 3166-1 alpha-2 country codes

## Installation

### TypeScript/JavaScript (npm)

```bash
npm install @devmehq/world-countries
```

### PHP (Composer)

```bash
composer require devmehq/world-countries
```

### Ruby (Gem)

```bash
gem install world_countries
```

### Python (pip)

```bash
pip install world-countries
```

## Usage

### TypeScript/JavaScript

```typescript
import { WorldCountries } from '@devmehq/world-countries';

const countries = new WorldCountries();

// Get all countries
const allCountries = countries.getAll();

// Get country by code
const usa = countries.getByCode('US');
console.log(usa);
// { name: 'United States', native: 'United States', phone: [1], ... }

// Search countries
const results = countries.search('united');

// Get countries by continent
const europeanCountries = countries.getByContinent('EU');

// Get countries by currency
const euroCountries = countries.getByCurrency('EUR');

// Get countries by language
const spanishCountries = countries.getByLanguage('es');

// Get countries by phone code
const countriesWithCode1 = countries.getByPhoneCode(1);
```

### PHP

```php
<?php
use DevMe\WorldCountries\WorldCountries;

$countries = new WorldCountries();

// Get all countries
$allCountries = $countries->getAll();

// Get country by code
$usa = $countries->getByCode('US');

// Search countries
$results = $countries->search('united');

// Get countries by continent
$europeanCountries = $countries->getByContinent('EU');

// Get countries by currency
$euroCountries = $countries->getByCurrency('EUR');
```

### Ruby

```ruby
require 'world_countries'

countries = WorldCountries::Countries.new

# Get all countries
all_countries = countries.all

# Get country by code
usa = countries.get_by_code('US')

# Search countries
results = countries.search('united')

# Get countries by continent
european_countries = countries.get_by_continent('EU')

# Get countries by currency
euro_countries = countries.get_by_currency('EUR')
```

### Python

```python
from world_countries import WorldCountries

countries = WorldCountries()

# Get all countries
all_countries = countries.get_all()

# Get country by code
usa = countries.get_by_code('US')

# Search countries
results = countries.search('united')

# Get countries by continent
european_countries = countries.get_by_continent('EU')

# Get countries by currency
euro_countries = countries.get_by_currency('EUR')
```

## Data Structure

Each country contains the following information:

```json
{
  "US": {
    "name": "United States",
    "native": "United States",
    "phone": [1],
    "continent": "NA",
    "capital": "Washington D.C.",
    "currency": ["USD", "USN", "USS"],
    "languages": ["en"],
    "emoji": "🇺🇸",
    "emojiU": "U+1F1FA U+1F1F8"
  }
}
```

### Fields

- **name**: Country name in English
- **native**: Country name in its native language
- **phone**: Array of international calling codes
- **continent**: Continent code (AF, AN, AS, EU, NA, OC, SA)
- **capital**: Capital city name
- **currency**: Array of currency codes (ISO 4217)
- **languages**: Array of language codes (ISO 639-1)
- **emoji**: Country flag emoji
- **emojiU**: Unicode representation of the flag emoji

## API Methods

All implementations provide these core methods:

| Method | Description | Returns |
|--------|-------------|---------|
| `getAll()` / `get_all()` | Get all countries | Object/Dict with all countries |
| `getByCode(code)` / `get_by_code(code)` | Get country by ISO code | Country object or null |
| `getByName(name)` / `get_by_name(name)` | Get country by name | Country object with code or null |
| `getByContinent(continent)` / `get_by_continent(continent)` | Get countries by continent | Object/Dict of matching countries |
| `getByCurrency(currency)` / `get_by_currency(currency)` | Get countries by currency | Object/Dict of matching countries |
| `getByLanguage(language)` / `get_by_language(language)` | Get countries by language | Object/Dict of matching countries |
| `getByPhoneCode(code)` / `get_by_phone_code(code)` | Get countries by phone code | Object/Dict of matching countries |
| `search(query)` | Search countries by name/code/capital | Object/Dict of matching countries |
| `getAllCodes()` / `get_all_codes()` | Get all country codes | Array/List of codes |
| `getAllNames()` / `get_all_names()` | Get all country names | Array/List of names |
| `getAllCapitals()` / `get_all_capitals()` | Get all unique capitals | Array/List of capitals |
| `getAllContinents()` / `get_all_continents()` | Get all unique continents | Array/List of continents |
| `getAllCurrencies()` / `get_all_currencies()` | Get all unique currencies | Array/List of currencies |
| `getAllLanguages()` / `get_all_languages()` | Get all unique languages | Array/List of languages |
| `count()` | Get total number of countries | Number |

## Continent Codes

- **AF**: Africa
- **AN**: Antarctica
- **AS**: Asia
- **EU**: Europe
- **NA**: North America
- **OC**: Oceania
- **SA**: South America

## Examples

### Find Countries in Multiple Ways

```javascript
const countries = new WorldCountries();

// Get all English-speaking countries
const englishSpeaking = countries.getByLanguage('en');

// Get all countries using US Dollar
const usdCountries = countries.getByCurrency('USD');

// Get all Asian countries
const asianCountries = countries.getByContinent('AS');

// Search for countries with "island" in the name
const islandNations = countries.search('island');

// Get country by multiple criteria
const spain = countries.getByCode('ES');
const spainByName = countries.getByName('Spain');

// Get statistics
console.log(`Total countries: ${countries.count()}`);
console.log(`Total currencies: ${countries.getAllCurrencies().length}`);
console.log(`Total languages: ${countries.getAllLanguages().length}`);
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details

## Credits

Created and maintained by [DevMe](https://github.com/devmehq)

## Related Projects

- [World Currencies](https://github.com/devmehq/world-currencies) - Comprehensive world currencies data

## Support

For issues and feature requests, please use the [GitHub issues page](https://github.com/devmehq/world-countries/issues).