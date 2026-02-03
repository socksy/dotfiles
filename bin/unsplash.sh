#!/usr/bin/env bash
pushd "$(dirname $0)" > /dev/null
ACCESS_KEY="$(cat _secret_unsplash_api_access_key | tr -d '\n ' )"
SECRET_KEY="$(cat _secret_unsplash_api_secret_key | tr -d '\n ' )"
popd > /dev/null

if [ -z "$@" ]; then
  QUERY_STRING=""
else
  QUERY_STRING="&query=$@"
fi

photo_json="$(curl -s -XGET -H "Authorization: Client-ID $ACCESS_KEY" "https://api.unsplash.com/photos/random?orientation=landscape&client_id=$ACCESS_KEY$QUERY_STRING")"
echo $photo_json
url="$(echo $photo_json | jq -r '.urls.raw')"
slug="$(echo $photo_json | jq -r '.slug')"

curl -s $url > $slug.jpg && echo $PWD/$slug.jpg
