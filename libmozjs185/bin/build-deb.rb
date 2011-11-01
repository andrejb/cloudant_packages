#!/usr/bin/ruby

src_name = "libmozjs185-1.0.0"
tgz_name = "libmozjs185_1.0.0"

build = <<-EOH
rm -rf build/
mkdir -p build/
cp tarballs/#{src_name}.tar.gz build/#{tgz_name}.orig.tar.gz
tar -C build/ -xzf build/#{tgz_name}.orig.tar.gz
cp -r debian build/#{src_name}/debian
cd build/#{src_name}
debuild -us -uc
EOH

puts "building libmozjs185 packages"
system(build)
