#!/usr/bin/env bats

#load bats/test/test_helper
# fixtures bats

# CLI tests
LOG="$TMP/setup.log"
DEVICE=""

#setup() {
#  echo "$BATS_TEST_NAME" >> "$LOG"
#  local numdevs
#  numdevs=$(gpio --list-devices|wc -l)
#  DEVICE=`gpio --list-devices`
#  if [ "$numdevs" -le 1 ];
#  then
#      echo "Not enough devices, test will fail"
#  elif [ "$numdevs" -gt 1 ];
#  then
#      echo "More than 1 device is not currently supported"
#  else
#      echo "Using device ${DEVICE} for testing"
#  fi
#
#}

@test "Check if wget binary is correct" {
   result="$(which wget)"
   #[ "$result" == "/home/product/code/firmware/current/bin/gpio" ]
}

# no args
@test "no arguments prints nothing" {
    run wget
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "wget: missing URL" ]
}

# help (2 different options)
# usage info
@test "-h prints usage info" {
    run wget -h
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "GNU Wget 1.17.1, a non-interactive network retriever." ]
}

@test "--help prints usage info" {
    run wget --help
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "GNU Wget 1.17.1, a non-interactive network retriever." ]
}
# go through every option and test it out


# Combination test cases
# set heartbeatdon and get heartbeatstatus
# set heartbeatdon and get status
# set various options and get status

@test "--badargs" {
    run wget --badargs
    [ "$status" -ne 0 ]
    [ "${lines[0]}" = "wget: unrecognized option '--badargs'" ]
}

#teardown() {
#    echo "$BATS_TEST_NAME complete">> "$LOG"
#}