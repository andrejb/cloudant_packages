Building BigCouch Packages
==========================

Pull down the contents of the 'packages' repo. You can use the vm_bootstrap.rb script to prepare the Ubuntu VMs for building, you may need to adjust the Erlang version. Currently we use R14B01 for the binary packages. Assuming you have VMs ready to go you would run something like the following commands.

Centos
------

The bigcouch source needs to exist in rpmbuild/SOURCES/bigcouch.tar.gz before running the following.

$ rpmbuild -ba bigcouch.spec --define "_revision 0.3" --define "_release 1"

Ubuntu
------

1. git clone git://github.com/cloudant/bigcouch.git
2. git archive --format=tar bigcouch-$VERSION | gzip > bigcouch_$VERSION.orig.tar.gz
3. move that file to this directory.
4. untar that file into the deb/ subdirectory.
5. debuild -us -uc

More resources
--------------

http://wiki.centos.org/HowTos/SetupRpmBuildEnvironment
