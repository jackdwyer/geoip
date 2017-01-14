#geoip
Bash & jq wrapper for MaxMinds GeoIP Demo

## Example Usage
```bash
$ ./geoip.sh -h
Usage: geoip.sh [OPTION] <ip>

  -h      help
  -g      lat,lng only

Output Format
  <state> | <country> | <latitude> | <longitude> | <isp> | <ip>

$ ./geoip.sh $(dig +short jackdwyer.org)
San Francisco | United States | 37.7697 | -122.3933 | CloudFlare | 104.28.0.37

$ ./geoip.sh -g $(dig +short jackdwyer.org)
37.7697,-122.3933
```

## Dependencies
[jq](https://stedolan.github.io/jq/)

## Install
```bash
$ curl -s -o ${HOME}/bin/geoip https://raw.githubusercontent.com/jackdwyer/geoip/master/geoip.sh
$ chmod +x ${HOME}/bin/geoip
```

## TODOs
[0] More DRY, curl & parsing repeated

## Thanks
[MaxMind Geo IP Demo](https://www.maxmind.com/en/geoip-demo)
