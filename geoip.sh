#!/bin/bash
# Jack Dwyer 2015

BASE_URL="https://www.maxmind.com/geoip/v2.1/city/%s?use-downloadable-db=1&demo=1"

check_deps() {
  if [[ $(command -v jq > /dev/null; echo $?) -ne 0 ]]; then
    echo "ERROR: missing jq dep"
  fi
}

show_help () {
  echo "Usage: $(basename $0) <ip>"
}

parse_loc_data () {
  local data="$1"
  local ip="$2"
  local city=$(cat ${data} | jq '.city.names.en' | sed 's/"//g;')
  local country=$(cat ${data} | jq '.country.names.en' | sed 's/"//g;')
  local isp=$(cat ${data} | jq '.traits.isp' | sed 's/"//g;')
  printf "%s | %s\n" "$city" "$country"
  printf "%s | %s\n" "$isp" "$ip"
}

get_location_data () {
  local tmp_data=$(mktemp)
  local ip="$1"
  curl -s $(printf "$BASE_URL" "$ip") > $(echo ${tmp_data})
  parse_loc_data ${tmp_data} "$ip"
}

if [[ -z $1 ]]; then
  echo "Error: no IP provided"
  show_help
  exit 1
fi

get_location_data $1
