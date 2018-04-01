#!/usr/bin/env bash
pkg_name="PAKAGE_NAME"
bin_file="BIN_FILE"
src_path="${bin_file}-linux-x64";
read Version < $src_path/version
Version=$(expr "$Version" : '.\(.*\)')
pkg_name_deb="$pkg_name/DEBIAN"
pkg_place="${pkg_name}/usr/local/bin/app-${pkg_name}"

mkdir "$pkg_name" "$pkg_name_deb"
mkdir -p "$pkg_place"

cp -R "$src_path" "$pkg_place"

echo "Source: $pkg_name
Section: unknown
Maintainer: \"Igor Stcherbina\"
Standards-Version: $Version
Package: $pkg_name
Architecture: all
Version: $Version
Description: auto-generated package by Igor Stcherbina." > "$pkg_name_deb/control"

echo "#!/bin/sh
	echo \"	[Desktop Entry]
	Name=$pkg_name
	Comment=
	GenericName=
	Keywords=
	Exec=/usr/local/bin/app-${pkg_name}/${src_path}/${bin_file}
	Terminal=false
	Type=Application
	Icon=/usr/local/bin/app-${pkg_name}/${src_path}/fav.png
	Path=
	Categories=app
	NoDisplay=false
	\" > \"\$(xdg-user-dir DESKTOP)/$pkg_name.desktop\"
" > "$pkg_name_deb/postinst"

chmod 0755 "$pkg_name_deb/postinst"

echo "#!/bin/sh \n ./app_${pkg_name}/${src_path}/${bin_file}" > "${pkg_name}/usr/local/bin/${pkg_name}"

dpkg-deb --build $pkg_name

rm -rf $pkg_name

echo "Finish"
