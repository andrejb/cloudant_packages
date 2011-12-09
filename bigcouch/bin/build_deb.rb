#!/usr/bin/ruby

if ARGV.length != 2
    puts "usage: #{$0} tag version"
    exit 1
end

tag = ARGV[0]
vsn = ARGV[1]

url = "https://github.com/cloudant/bigcouch/tarball/#{tag}"
appfile = "apps/couch/src/couch.app.src"

build = <<-EOH
rm -rf build/
mkdir -p build/
wget -cq #{url} -O build/bigcouch_#{vsn}.orig.tar.gz
tar -C build -zxf build/bigcouch_#{vsn}.orig.tar.gz
mv build/cloudant-bigcouch-* build/bigcouch-#{vsn}
cp -r debian build/bigcouch-#{vsn}/debian
cd build/bigcouch-#{vsn}
cat #{appfile} | sed s/%VSN%/#{vsn}/ > #{appfile}.tmp
mv #{appfile}.tmp #{appfile}
debuild -us -uc
EOH

puts "building bigcouch packages"
system(build)
