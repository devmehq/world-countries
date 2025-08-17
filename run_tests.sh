#!/bin/bash

echo "========================================="
echo "Running World Countries Library Tests"
echo "========================================="
echo ""

# TypeScript Tests
echo "1. Running TypeScript Tests..."
echo "-----------------------------------------"
if command -v npm &> /dev/null; then
    npm test 2>&1 | grep -E "(PASS|FAIL|Test Suites:|Tests:)" | head -10
    echo ""
else
    echo "npm not found. Skipping TypeScript tests."
fi

# Python Tests
echo "2. Running Python Tests..."
echo "-----------------------------------------"
cd tests/python
python3 test_world_countries.py 2>&1 | head -20 || echo "Python tests require pytest. Running basic import test..."
python3 -c "
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../../src/python'))
from world_countries import WorldCountries
countries = WorldCountries()
print(f'✓ Python import successful')
print(f'✓ Loaded {countries.count()} countries')
usa = countries.get_by_alpha2_code('US')
print(f'✓ USA lookup: {usa['name']['common'] if usa else 'Failed'}')
"
cd ../..
echo ""

# PHP Tests  
echo "3. Running PHP Tests..."
echo "-----------------------------------------"
if command -v php &> /dev/null; then
    php -r "
    require_once 'src/php/WorldCountries.php';
    use DevMe\WorldCountries\WorldCountries;
    \$countries = new WorldCountries();
    echo '✓ PHP import successful' . PHP_EOL;
    echo '✓ Loaded ' . \$countries->count() . ' countries' . PHP_EOL;
    \$usa = \$countries->getByAlpha2Code('US');
    echo '✓ USA lookup: ' . (\$usa ? \$usa['name']['common'] : 'Failed') . PHP_EOL;
    "
else
    echo "PHP not found. Skipping PHP tests."
fi
echo ""

# Ruby Tests
echo "4. Running Ruby Tests..."  
echo "-----------------------------------------"
if command -v ruby &> /dev/null; then
    ruby -e "
    require_relative 'src/ruby/world_countries'
    countries = WorldCountries::Countries.new
    puts '✓ Ruby import successful'
    puts \"✓ Loaded #{countries.count} countries\"
    usa = countries.get_by_alpha2_code('US')
    puts \"✓ USA lookup: #{usa ? usa['name']['common'] : 'Failed'}\"
    "
else
    echo "Ruby not found. Skipping Ruby tests."
fi
echo ""

echo "========================================="
echo "Test Summary"
echo "========================================="
echo "All basic import and functionality tests completed!"
echo "For full test suites, install test dependencies:"
echo "  - TypeScript: npm install && npm test"
echo "  - Python: pip install pytest pytest-cov && pytest"
echo "  - PHP: composer install && vendor/bin/phpunit"
echo "  - Ruby: bundle install && rspec"