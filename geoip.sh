#!/bin/bash
# Jack Dwyer 2015

BASE_URL="https://www.maxmind.com/geoip/v2.1/city/%s?use-downloadable-db=1&demo=1"

check_deps () {
  if [[ $(command -v jq > /dev/null; echo $?) -ne 0 ]]; then
    echo "ERROR: missing jq dependency"
    exit 1
  fi
}

show_help () {
  echo "Usage: $(basename "$0") <ip>"
}

parse_loc_data () {
  local data="$1"
  local ip="$2"
  local city=$(jq '.city.names.en' < "${data}" | sed 's/"//g;')
  local country=$(jq '.country.names.en' < "${data}" | sed 's/"//g;')
  local isp=$(jq '.traits.isp' < "${data}" | sed 's/"//g;')
  printf "%s | %s | %s | %s\n" "$city" "$country" "$isp" "$ip"
}

get_location_data () {
  local tmp_data=$(mktemp)
  local ip="$1"
  curl -s "$(printf "$BASE_URL" "$ip")" > "${tmp_data}"
  parse_loc_data "${tmp_data}" "$ip"
}

check_deps

if [[ -z $1 ]]; then
  echo "Error: no IP provided"
  show_help
  exit 1
fi

get_location_data "$1"
