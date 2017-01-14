#!/bin/bash
# Jack Dwyer 2015

BASE_URL="https://www.maxmind.com/geoip/v2.1/city/%s?use-downloadable-db=1&demo=1"

check_deps () {
  if [[ $(command -v curl > /dev/null; echo $?) -ne 0 ]]; then
    echo "ERROR: missing curl dependency"
    exit 1
  fi
  if [[ $(command -v jq > /dev/null; echo $?) -ne 0 ]]; then
    echo "ERROR: missing jq dependency"
    exit 1
  fi
}

show_help () {
  SCRIPT_NAME=$(basename "${0}")
  echo "Usage: ${SCRIPT_NAME} [OPTION] <ip>"
  echo ""
  echo "  -h      help"
  echo "  -g      lat,lng only"
  echo ""
  echo "Output Format"
  echo "<state> | <country> | <latitude> | <longitude> | <isp> | <ip>"
}

parse_lat_lng() {
  # TODO do this only once
  local data="$1"
  local ip="$2"
  local lat
  local lng
  lat=$(jq '.location.latitude' < "${data}" | sed 's/"//g;')
  lng=$(jq '.location.longitude' < "${data}" | sed 's/"//g;')
  printf "%s,%s\n" "${lat}" "${lng}"
}

parse_loc_data () {
  local data="$1"
  local ip="$2"
  local city=$(jq '.city.names.en' < "${data}" | sed 's/"//g;')
  local country=$(jq '.country.names.en' < "${data}" | sed 's/"//g;')
  local isp=$(jq '.traits.isp' < "${data}" | sed 's/"//g;')
  local lat=$(jq '.location.latitude' < "${data}" | sed 's/"//g;')
  local lng=$(jq '.location.longitude' < "${data}" | sed 's/"//g;')
  printf "%s | %s | %s | %s | %s | %s\n" "$city" "$country" \
                                         "$lat" "$lng" \
                                         "$isp" "$ip"
}

do_curl() {
  local tmp_data;
  tmp_data=$(mktemp)
  local ip="$1"
  curl -s "$(printf "${BASE_URL}" "$ip")" > "${tmp_data}"
  echo "${tmp_data}"
}

get_location_data () {
  tmp_data=$(do_curl "${1}")
  parse_loc_data "${tmp_data}" "${1}"
}

get_geo_data() {
  tmp_data=$(do_curl "${1}")
  parse_lat_lng "${tmp_data}" "${1}"
}

check_deps

if [[ "${1}" = "-h" ]]; then
  show_help
  exit 0
fi

if [[ "${1}" = "-g" ]]; then
  if [[ -z ${2} ]]; then
    echo "Error: no IP provided"
    show_help
    exit 1
  fi
  get_geo_data "${2}"
else
  if [[ -z ${1} ]]; then
    echo "Error: no IP provided"
    show_help
    exit 1
  fi
  get_location_data "$1"
fi

