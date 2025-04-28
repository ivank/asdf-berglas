#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/GoogleCloudPlatform/berglas"
TOOL_NAME="berglas"
TOOL_TEST="berglas --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url os uname_kernel_name uname_machine release_file
	version="$1"
	filename="$2"

	uname_kernel_name="$(uname --kernel-name)"
	uname_machine="$(uname --machine)"

	case "$uname_kernel_name" in
	Linux)
		uname_s="Linux"

		case "$uname_machine" in
		x86_64)
			release_file="linux_amd64"
			;;
		aarch64)
			release_file="linux_arm64"
			;;
		*)
			fail "Machine not supported: $uname_machine"
			;;
		esac
		;;
	Darwin)
		case "$uname_machine" in
		x86_64)
			release_file="darwin_amd64"
			;;
		arm)
			release_file="darwin_arm64"
			;;
		*)
			fail "Machine not supported: $uname_machine"
			;;
		esac
		;;
	*)
		fail "Kernel not supported: $uname_kernel_name"
		;;
	esac

	url="$GH_REPO/releases/download/${version}/${TOOL_NAME}_${version}_${release_file}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
