FROM mdillon/postgis:9.6

VOLUME ["/geonames"]
VOLUME ["/var/lib/postgresql/data"]

# WIP: make it do this:

apt-get update -y
apt-get install -y gem git  ruby  ruby-dev build-essential  zlib1g-dev libpq-dev curl

mkdir work
cd work
git clone https://github.com/JulesAU/gazetteer
cd gazetteer
gem install bundler
bundle install
mkdir data
make data

echo '
default:
    host: postgres
    password: password
    user: geonames
    port: 5432
' > /root/.postgres


export LANG=C.UTF-8
./gazetteer.rb setup -d geonames -c default
./gazetteer.rb metadata -d geonames -c default

./gazetteer.rb import  -d geonames -f data/allCountries.txt -c default

# Optionally
./gazetteer.rb altnames  -d geonames -c default

./gazetteer.rb postprocess -d geonames -c default
