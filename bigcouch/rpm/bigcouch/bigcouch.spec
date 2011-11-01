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

%files
%defattr(-, %{name}, %{name})
%doc README.md LICENSE
/opt/%{name}

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

%clean
rm -rf %{buildroot}

%changelog
* Tue Dec 7 2010 Joe Williams <joe@cloudant.com> 0.3a-1
- First 0.3a build