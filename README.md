<h1>Building BigCouch Packages</h1>

Pull down the contents of the 'packages' repo. You can use the vm_bootstrap.rb script to prepare the Ubuntu VMs for building, you may need to adjust the Erlang version. Currently we use R14B01 for the binary packages. Assuming you have VMs ready to go you would run something like the following commands.

<h2>Centos</h2>

The bigcouch source needs to exist in rpmbuild/SOURCES/bigcouch.tar.gz before running the following.

$ rpmbuild -ba bigcouch.spec --define "_revision 0.3" --define "_release 1"

<h2>Ubuntu</h2>
$ ./configure
$ make
$ make install
$ cd ../bigcouch_debian/
$ cp -R /opt/bigcouch opt/
$ /opt/bigcouch/bin/bigcouch # to verify it runs
$ cd ..
$ dpkg --build bigcouch_debian
$ mv bigcouch_debian.deb bigcouch_0.3-1_amd64.deb

Then upload these files to github.

The ubuntu build is likely suboptimal, long term it should probably be built using a chroot, LVM and sbuilder/pbuilder. All of these packages can likely be built via Hudson/Jenkins. One thing to note it is generally considered a bad practice to build these as root, don't do that.

More resources:

http://wiki.centos.org/HowTos/SetupRpmBuildEnvironment
