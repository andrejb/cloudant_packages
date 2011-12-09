#!/usr/bin/ruby

mozilla_ftp = "http://ftp.mozilla.org/pub/mozilla.org/js"
src_name = "js185-1.0.0"
dst_name = "libmozjs185-1.0.0"

repackage = <<-EOH
rm -rf js-1.8.5/ #{src_name}* #{dst_name}*
rm -rf deb/#{dst_name}*
mkdir -p tarballs

cd tarballs/
wget -qcN #{mozilla_ftp}/#{src_name}.tar.gz
cd ../

tar -xzf tarballs/#{src_name}.tar.gz
mkdir #{dst_name}
cp -r js-1.8.5/js/src/* #{dst_name}/

# Fix include path
sed 's/^MODULE[[:space:]]*=[[:space:]]*js/MODULE = mozjs/g' \
    < js-1.8.5/js/src/Makefile.in \
    > #{dst_name}/Makefile.in

rm #{dst_name}/jit-test/tests/sunspider/check-date-format-tofte.js

tar -czf tarballs/#{dst_name}.tar.gz #{dst_name}

rm -rf js-1.8.5/ #{src_name}* #{dst_name}/
EOH

puts "repackaging libmozjs tarball"
system(repackage)
