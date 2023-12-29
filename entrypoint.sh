#!/bin/bash -l

branch="${2:-master}"
echo "Cloning Wesnoth $branch."
git clone \
    --depth 1 \
    --filter=blob:none \
    --sparse \
    --single-branch --branch $branch \
    -c advice.detachedHead=false \
    https://github.com/wesnoth/wesnoth \
    /wesnoth
(cd /wesnoth && git sparse-checkout --no-cone set data/tools/ data/core/**/*.cfg)

echo "Creating dummy files for Wesnoth resources..."
for file in $(cd /wesnoth && git ls-tree $branch --name-only -r | grep "^data/.*$")
do
    mkdir -p "/wesnoth/$(dirname "$file")"
    touch "/wesnoth/$file"
done
echo "Wesnoth repository is ready."

# Capturing Python script stdout.
exec 5>&1

echo
echo "Running wmlscope..."
output=$(
    python /wesnoth/data/tools/wmlscope $3 /wesnoth/data/core/ $1 2>&1 | \
    grep --line-buffered -P '^("[^/].*", line.*$)|(^[^/].* is not a valid.*$)|(^[^/].* image is \d+ x \d+, expected.*$)|(^Resource [^/].* is unused.*$)' | \
    tee >(cat - >&5)
)

if [[ -z $output ]]; then
    echo
    echo "No issues found by wmlscope within the project."
    exit 0
else
    echo
    echo "Found issues with the project resources."
    echo "See the logs from the wmlscope tool."
    exit 1
fi
