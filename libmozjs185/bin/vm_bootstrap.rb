#!/usr/bin/ruby


deps = <<-EOH
apt-get update
apt-get --force-yes -y upgrade
apt-get --force-yes -y dist-upgrade
apt-get --force-yes -y install \
    ssh \
    vim \
    git-core \
    build-essential \
    dh-make \
    devscripts \
    autotools-dev \
    zip \
    libnspr4-dev
EOH

puts "installing deps"
system(deps)

system ("apt-get clean")
