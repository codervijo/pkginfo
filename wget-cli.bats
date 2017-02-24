#!/usr/bin/env bats

# Run it as : WGETDIR=. bats ~/scripts/pkginfo/wget-cli.bats 
#
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
    [[ "${lines[0]}" =~ "GNU Wget " ]]
}

@test "--help prints usage info" {
    run wget --help
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" =~ "GNU Wget " ]]
}

# go through every option and test it out

# Check various ways of wgetrc
@test "readable \$HOME/.wgetrc" {
    if [ -f $HOME/.wgetrc ];
    then
        cp -f $HOME/.wgetrc $HOME/wgetrc-GOOD
    fi
    cp -f $WGETDIR/doc/sample.wgetrc $HOME/.wgetrc
    run wget http://gnu.org 1>/dev/null
    [ "$status" -eq 0 ]
    if [ -f $HOME/wgetrc-GOOD ];
    then
       cp -f $HOME/wgetrc-GOOD $HOME/.wgetrc
    fi
}

@test "unreadable \$HOME/.wgetrc" {
    if [ -f $HOME/.wgetrc ];
    then
        cp -f $HOME/.wgetrc $HOME/wgetrc-GOOD
    fi
    cp -f $WGETDIR/doc/sample.wgetrc $HOME/.wgetrc
    chmod ugo-r $HOME/.wgetrc
    run wget http://gnu.org -O /dev/null 1>/dev/null
    [ "$status" -eq 0 ];
    if [ -f $HOME/wgetrc-GOOD ];
    then
        cp -f $HOME/wgetrc-GOOD $HOME/.wgetrc
    fi
    rm -f $HOME/.wgetrc
}

@test "env var for wgetrc location(readable, good)" {
    WGETRC=$WGETDIR/doc/sample.wgetrc run wget http://gnu.org -O /dev/null 1>/dev/null
    [ "$status" -eq 0 ];
}

@test "env var for wgetrc location(unreadable, not good)" {
    cp $WGETDIR/doc/sample.wgetrc /tmp/samplewgetrc
    chmod ugo-r /tmp/samplewgetrc
    WGETRC=/tmp/samplewgetrc run wget http://gnu.org -O /dev/null 1>/dev/null
    [ "$status" -eq 0 ];
}

@test "env var for wgetrc location(no file, not good" {
    WGETRC=/tmp/nosuch run wget http://gnu.org -O /dev/null 1>/dev/null
    [ "$status" -eq 0 ];
}
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