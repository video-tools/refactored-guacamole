#!/bin/bash

set -eu -o pipefail

project="ffmpeg-dev"

scratch_variant="alpine"

cwd="$(dirname "$0")"
template_dir="$cwd/templates"
dockerfile_dir="$cwd/docker-images"

#If there is no ruby available install it
if ! which ruby 2>&1 > /dev/null; then
  alias ruby="docker run --rm -u $(id -u) -v "${PWD}":/usr/src/myapp -w /usr/src/myapp ruby:2.5-alpine ruby"
fi

semver_re='[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)\([0-9A-Za-z-]*\)'
iwantplate="ruby $template_dir/iwantplate.rb"
travis_matrix=""
variant=alpine
version=testing
release=testing

mkdir -p ./${dockerfile_dir}/${release}/$variant
sh ${iwantplate} -V ${variant} -v ${version} > ${dockerfile_dir}/${release}/${variant}/Dockerfile &
sh ${iwantplate} -s -V ${variant} -v ${version} > ${dockerfile_dir}/${release}/${variant}/Manifest &
wait

#sed -e "s/%%VERSIONS%%/${travis_matrix}/" ${template_dir}/travis.template > .travis.yml

