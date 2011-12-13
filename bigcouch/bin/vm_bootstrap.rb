#!/usr/bin/ruby

arch = `uname -m`
js_version = "1.0.0"

if arch == "x86_64"
  erlang_build = "--enable-m64-build"
  icu_build = "amd64"
elsif arch = "i686" || arch == "i386"
  erlang_build = ""
  icu_build = "i386"
end

deps = <<-EOH
apt-get update \
apt-get --force-yes -y upgrade
apt-get --force-yes -y dist-upgrade
apt-get --force-yes -y install \
    autoconf \
    build-essential \
    debhelper \
    devscripts \
    git-core \
    libcurl4-openssl-dev \
    libncurses5-dev \
    libssl0.9.8 \
    libssl-dev \
    libtool \
    m4 \
    openjdk-6-jdk \
    quilt \
    ruby \
    ruby-dev \
    ssh \
    vim
EOH

libmozjs = <<-EOH
wget -c http://packages.cloudant.com/libmozjs185/#{js_version}/#{arch}/libmozjs185_#{js_version}-1_#{arch}.deb
wget -c http://packages.cloudant.com/libmozjs185/#{js_version}/#{arch}/libmozjs185-dev_#{js_version}-1_#{arch}.deb
dpkg -i libmozjs185_#{js_version}-1_#{arch}.deb
dpkg -i libmozjs185-dev_#{js_version}-1_#{arch}.deb
EOH

icu = <<-EOH
apt-get -y install libicu-dev
EOH

erlang_version = "otp_src_R14B01"
erlang_options = "--enable-kernel-poll --enable-hipe --enable-threads --enable-smp-support #{erlang_build}"

erlang = <<-EOH
echo -n "Fetching erlang tarball: "
wget --quiet -c http://erlang.org/download/#{erlang_version}.tar.gz
echo "done"
tar zxf #{erlang_version}.tar.gz
cd #{erlang_version}
./configure #{erlang_options}
make install
cd ~/
EOH

puts "installing deps"
system(deps)

puts "installing icu"
system(icu)

puts "installing libmozjs"
system(libmozjs)

puts "installing erlang"
system(erlang)

system ("apt-get clean")
