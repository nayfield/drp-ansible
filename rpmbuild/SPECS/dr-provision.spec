Name:           dr-provision
Version:        3.12.0
Release:        4%{?dist}
Summary:        Digital Rebar Provision
License:        Apache
URL:            https://github.com/digitalrebar/provision

Source0:	https://github.com/digitalrebar/provision/releases/download/v%{version}/%{name}.zip 
Patch0: 	drp-change-path.patch


# This is where we install to.
# NOTE this doesn't change our patch.
# maybe-TODO: make patch a token and sed in prep
%global ourspot /app/PXE

# TODO:
#  1. run as DRP user not root
#   requires setcap, change in unit, and perms on drp-data dir

#needed?   BuildRequires:  unzip
Requires:       p7zip
Requires:	bsdtar

%description
Digital Rebar provision

%prep
%setup -c
%patch0 -p1

#  # %build 
#  #  This should apply patches to initscript
#  #  For our locations and UID

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/%{ourspot}/drp-bin
install -d $RPM_BUILD_ROOT/%{ourspot}/drp-data 
install -d $RPM_BUILD_ROOT/%{ourspot}/drp-data/tftpboot
install -d $RPM_BUILD_ROOT/etc/systemd/system
install bin/linux/amd64/* $RPM_BUILD_ROOT/%{ourspot}/drp-bin
install assets/startup/dr-provision.service $RPM_BUILD_ROOT/etc/systemd/system/dr-provision.service

%files
%defattr(-,root,root,-)
%{ourspot}
/etc/systemd/system/dr-provision.service
%doc



%changelog
* Tue Mar 19 2019 PHB - 3.12.0-4
- global location var

* Tue Mar 19 2019 PHB - 3.12.0-3
- location patches

* Tue Mar 19 2019 PHB - 3.12.0-2
- First pkg

