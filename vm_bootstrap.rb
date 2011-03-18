#!/usr/bin/ruby

arch = `uname -m`

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
ssh \
vim \
git-core \
ruby ruby-dev rubygems \
libcurl4-openssl-dev \
libssl-dev libssl0.9.8 \
build-essential libtool autoconf \
libncurses5-dev m4 \
openjdk-6-jdk
EOH

libmozjs = <<-EOH
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 74EE6429
echo "deb http://ppa.launchpad.net/commonjs/ppa/ubuntu karmic main" >> /etc/apt/sources.list
apt-get update
apt-get --force-yes -y install libmozjs-1.9.2 libmozjs-1.9.2-dev
ln -svf /usr/lib/libmozjs-1.9.2.so /usr/lib/libmozjs.so
EOH

icu = <<-EOH
apt-get install libicu42 libicu-dev
EOH

erlang_version = "otp_src_R13B04"
erlang_options = "--enable-kernel-poll --enable-hipe --enable-threads --enable-smp-support #{erlang_build}"

erlang = <<-EOH
wget http://erlang.org/download/#{erlang_version}.tar.gz
tar zxvf #{erlang_version}.tar.gz
cd #{erlang_version}
./configure #{erlang_options}
make
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
