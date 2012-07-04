# rpmbuild -ba bigcouch.spec --define "_revision 0.3a" --define "_release 1"

Name: bigcouch
Version: %{_revision}
Release: %{_release}%{?dist}
License: Apache
Group: Applications/Databases
URL: http://cloudant.com
Vendor: Cloudant
Packager: Joe Williams <joe@cloudant.com>
Summary: BigCouch is a dynamo-style distributed database based on Apache CouchDB.

Source: %{name}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}

%description
BigCouch is a dynamo-style distributed database based on Apache CouchDB.

BuildRequires: erlang
BuildRequires: gcc
BuildRequires: js-devel >= 1.7
BuildRequires: libicu-devel >= 3.0
BuildRequires: libicu
BuildRequires: openssl
BuildRequires: openssl-devel
BuildRequires: python
BuildRequires: python-devel
BuildRequires: erlang

%prep
%setup -n %{name}

%build
./configure -p /opt/%{name}
make dist

%install
mkdir -p %{buildroot}/opt
cp -r $RPM_BUILD_DIR/%{name}/rel/%{name} %{buildroot}/opt/
mkdir -p %{buildroot}/etc/init.d
cat <<'EOF' > %{buildroot}/etc/init.d/%{name}
#!/bin/bash
#
# BigCouch
#
# chkconfig: 345 13 87
# description: BigCouch is a dynamo-style distributed database based on Apache CouchDB.
# processname: bigcouch
# pidfile: /var/run/bigcouch.pid
#

# Source function library.
. /etc/init.d/functions

if [ -f /etc/sysconfig/bigcouch ]; then
    . /etc/sysconfig/bigcouch
fi

prog="bigcouch"
lockfile=${LOCKFILE-/var/lock/subsys/bigcouch}
user=${USER-bigcouch}
RETVAL=0
STOP_TIMEOUT=${STOP_TIMEOUT-10}

# Check that networking is up.
if [ "$NETWORKING" = "no" ]; then
    exit 0
fi

[ -f /opt/bigcouch/bin/bigcouch ] || exit 0

# Detect core count
CORES=`grep -E "^processor" /proc/cpuinfo |wc -l`
if [ "$CORES" = "1" ]; then
    BEAM=beam
else
    BEAM=beam.smp
fi

start() {
    echo -n $"Starting $prog: "

    export HOME=/home/${prog}
    mkdir -p /tmp/${prog}
    chown ${prog}:${prog} /tmp/${prog}

    daemon --user=${user} "/opt/${prog}/bin/${prog} >/dev/null &"
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch ${lockfile}
    return $RETVAL
}

stop() {
    echo -n $"Stopping $prog: "
    killproc $BEAM
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && rm -f ${lockfile} ${pidfile}
    return $RETVAL
}

restart() {
    stop
    start
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status -l ${lockfile} $BEAM
        RETVAL=$?
        ;;
    restart|reload)
        restart
        ;;
    *)
        echo $"Usage: $0 (start|stop|restart|status)"
        exit 1
esac

exit $?
EOF
chmod +x %{buildroot}/etc/init.d/%{name}

%files
%defattr(-, %{name}, %{name})
%doc README.md LICENSE
/opt/%{name}
/etc/init.d/%{name}

%pre
# create group only if it doesn't already exist
if ! getent group %{name} >/dev/null 2>&1; then
        groupadd -r %{name}
fi

# create user only if it doesn't already exist
if ! getent passwd %{name} >/dev/null 2>&1; then
        useradd -r \
        -g %{name} \
        -m -d /home/%{name} \
        --shell /bin/bash \
        %{name}
fi

%post
/sbin/chkconfig --add %{name}
service %{name} start

%preun
if [ $1 = 0 ]; then // package is being erased, not upgraded
    /sbin/service %{name} stop > /dev/null 2>&1
    /sbin/chkconfig --del %{name}
fi

%postun
if [ $1 = 0 ]; then // package is being erased
    # uninstall steps?
else
    /sbin/service %{name} condrestart > /dev/null 2>&1
fi

%clean
rm -rf %{buildroot}

%changelog
* Tue Dec 7 2010 Joe Williams <joe@cloudant.com> 0.3a-1
- First 0.3a build