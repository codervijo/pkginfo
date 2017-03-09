#!/usr/bin/env bats

# Run it as : WGETDIR=. bats ~/scripts/pkginfo/wget-cli.bats 
#
# load bats/test/test_helper
# fixtures bats

# CLI tests
LOG="/tmp/wgetbats.log"
DEVICE=""

setup() {
    echo "$BATS_TEST_NAME" >> "$LOG"
    if [ x"$WGETDIR" = x ];
    then
        echo "Please set env variable WGETDIR to point to wget source directory" >> "$LOG"
        exit 1
    fi
    if [ ! -d "$WGETDIR" ];
    then
        echo "Please specify wget source directory in WGETDIR env variable" >> "$LOG"
     fi
}

@test "Check if wget binary is correct" {
    result="$(which wget)"
    [ "$result" == "$WGETDIR/src/wget" ]
}

# no args
@test "no arguments prints nothing" {
    run $WGETDIR/src/wget
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "wget: missing URL" ]
}

# help (2 different options)
# usage info
@test "-h prints usage info" {
    run $WGETDIR/src/wget -h
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" =~ "GNU Wget " ]]
}

@test "--help prints usage info" {
    run $WGETDIR/src/wget --help
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" =~ "GNU Wget " ]]
}

# go through every option and test it out

@test "simple wget (bug 44156)" {
    rm -f index.html
    run $WGETDIR/src/wget http://www.example.com
    [ "$status" -eq 0 ]
    [ -f index.html ]
    rm -f index.html
}

@test "wget -O (bug 44156)" {
    rm -f index.html
    run $WGETDIR/src/wget -O- http://www.example.com 2>/tmp/stde5 1>/tmp/stdo5
    [ "$status" -eq 0 ]
    [ ! -f index.html ]
}

# Check various ways of wgetrc
@test "readable \$HOME/.wgetrc" {
    if [ -f $HOME/.wgetrc ];
    then
        cp -f $HOME/.wgetrc $HOME/wgetrc-GOOD
    fi
    [ -d "$WGETDIR" ]
    [ -f "$WGETDIR/doc/sample.wgetrc" ]
    cp -f $WGETDIR/doc/sample.wgetrc $HOME/.wgetrc
    run $WGETDIR/src/wget http://gnu.org -O /dev/null 1>/dev/null 2>&1
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
    [ -d "$WGETDIR" ]
    [ -f "$WGETDIR/doc/sample.wgetrc" ]
    cp -f $WGETDIR/doc/sample.wgetrc $HOME/.wgetrc
    chmod ugo-r $HOME/.wgetrc
    run $WGETDIR/src/wget http://gnu.org -O /dev/null 1>/dev/null 2>&1
    [ "$status" -eq 0 ]
    if [ -f $HOME/wgetrc-GOOD ];
    then
        cp -f $HOME/wgetrc-GOOD $HOME/.wgetrc
    fi
    rm -f $HOME/.wgetrc
}

@test "env var for user wgetrc location(readable, good)" {
    [ -d "$WGETDIR" ]
    [ -f "$WGETDIR/doc/sample.wgetrc" ]
    WGETRC=$WGETDIR/doc/sample.wgetrc run $WGETDIR/src/wget http://gnu.org -O /dev/null 1>/dev/null 2>&1
    [ "$status" -eq 0 ]
}

@test "env var for user wgetrc location(unreadable, not good)" {
    [ -d "$WGETDIR" ]
    [ -f "$WGETDIR/doc/sample.wgetrc" ]
    cp $WGETDIR/doc/sample.wgetrc /tmp/samplewgetrc
    chmod ugo-r /tmp/samplewgetrc
    WGETRC=/tmp/samplewgetrc run $WGETDIR/src/wget http://gnu.org -O /dev/null 1>/dev/null 2>&1
    [ "$status" -eq 0 ]
}

@test "env var for user wgetrc location(no file, not good" {
    WGETRC=/tmp/nosuch run $WGETDIR/src/wget http://gnu.org -O /dev/null 1>/dev/null 2>&1
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "wget: WGETRC points to /tmp/nosuch, which doesn't exist." ]
}

@test "env var for user wgetrc (in unreadable directory, not good)" {
    [ -d "$WGETDIR" ]
    [ -f "$WGETDIR/doc/sample.wgetrc" ]
    mkdir -p /tmp/noentry
    cp $WGETDIR/doc/sample.wgetrc /tmp/noentry/wgetrc
    chmod ugo-rwx /tmp/noentry
    WGETRC=/tmp/noentry/wgetrc run $WGETDIR/src/wget http://gnu.org -O /dev/null 1>/dev/null 2>&1
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "wget:" ]
    chmod u+rwx /tmp/noentry
    rm -rf /tmp/entry
}

@test "env var for system wgetrc location(readable, good)" {
    [ -d "$WGETDIR" ]
    [ -f "$WGETDIR/doc/sample.wgetrc" ]
    SYSTEM_WGETRC=$WGETDIR/doc/sample.wgetrc run $WGETDIR/src/wget http://gnu.org -O /dev/null 1>/dev/null 2>&1
    [ "$status" -eq 0 ]
}

@test "env var for system wgetrc location(unreadable, not good)" {
    [ -d "$WGETDIR" ]
    [ -f "$WGETDIR/doc/sample.wgetrc" ]
    cp $WGETDIR/doc/sample.wgetrc /tmp/samplewgetrc
    chmod ugo-r /tmp/samplewgetrc
    SYSTEM_WGETRC=/tmp/samplewgetrc run $WGETDIR/src/wget http://gnu.org -O /dev/null 1>/dev/null 2>&1
    [ "$status" -eq 0 ]
}

@test "env var for system wgetrc location(no file, not good" {
    SYSTEM_WGETRC=/tmp/nosuch run $WGETDIR/src/wget http://gnu.org -O /dev/null 1>/dev/null 2>&1
    [ "$status" -eq 0 ]
}

@test "env var for system wgetrc (in unreadable directory, not good)" {
    [ -d "$WGETDIR" ]
    [ -f "$WGETDIR/doc/sample.wgetrc" ]
    mkdir -p /tmp/noentry
    cp $WGETDIR/doc/sample.wgetrc /tmp/noentry/wgetrc
    chmod ugo-rwx /tmp/noentry
    SYSTEM_WGETRC=/tmp/noentry/wgetrc run $WGETDIR/src/wget http://gnu.org -O /dev/null 1>/dev/null 2>&1
    [ "$status" -eq 0 ]
    chmod u+rwx /tmp/noentry
    rm -rf /tmp/entry
}

@test "--spider" {
    [ -d "$WGETDIR" ]
    run $WGETDIR/src/wget --spider http://www.example.com
    [ "$status" -eq 0 ]
    [ "${lines[7]}" = "but recursion is disabled -- not retrieving." ]
}

@test "--spider --recursive" {
    [ -d "$WGETDIR" ]
    run $WGETDIR/src/wget --spider --recursive http://www.example.com
    [ "$status" -eq 0 ]
}

@test "-Pprefix" {
    [ -d "$WGETDIR" ]
    rm -rf /tmp/ee1
    rm -f index.html
    run $WGETDIR/src/wget -P/tmp/ee1 http://www.example.com
    [ "$status" -eq 0 ]
    [ ! -f index.html ]
    [ -d /tmp/ee1 ]
    [ -f /tmp/ee1/index.html ]
}

# Output to stdout, and logs in stderr
@test "-O/tmp/stdo6" {
    [ -d "$WGETDIR" ]
    rm -f /tmp/stdo6 /tmp/stdo61
    rm -f /tmp/stde6
    rm -f index.html
    $WGETDIR/src/wget -O/tmp/stdo6 http://www.example.com 1>/tmp/stdo61 2>/tmp/stde6
    [ "$?" -eq 0 ]
    [ ! -f index.html ]
    [ ! -f "-" ]
    [ -f /tmp/stdo6 ]
    [ -f /tmp/stde6 ]
    stdsize=$(wc -l /tmp/stdo6  | cut -f1 -d' ')
    outsize=$(wc -l /tmp/stdo61 | cut -f1 -d' ')
    errsize=$(wc -l /tmp/stde6  | cut -f1 -d' ')
    [ $stdsize -eq 50 ]
    [ $outsize -eq  0 ]
    [ $errsize -eq 11 ]
}
@test "-O-" {
    [ -d "$WGETDIR" ]
    rm -f /tmp/stdo1
    rm -f /tmp/stde1
    rm -f index.html
    $WGETDIR/src/wget -O- http://www.example.com 1>/tmp/stdo1 2>/tmp/stde1
    [ "$?" -eq 0 ]
    [ ! -f index.html ]
    [ ! -f "-" ]
    [ -f /tmp/stdo1 ]
    [ -f /tmp/stde1 ]
    outsize=$(wc -l /tmp/stdo1 | cut -f1 -d' ')
    errsize=$(wc -l /tmp/stde1 | cut -f1 -d' ')
    [ $outsize -eq 50 ]
    [ $errsize -eq 11 ]
}

# Logs to stdout, but output to index.html
@test "-o/tmp/stdo7" {
    [ -d "$WGETDIR" ]
    rm -f /tmp/stdo7 /tmp/stdo71
    rm -f /tmp/stde7
    rm -f index.html
    $WGETDIR/src/wget -o/tmp/stdo7 http://www.example.com 1>/tmp/stdo71 2>/tmp/stde7
    [ "$?" -eq 0 ]
    [ -f index.html ]
    [ ! -f "-" ]
    [ -f /tmp/stdo7 ]
    [ -f /tmp/stde7 ]
    stdsize=$(wc -l /tmp/stdo71 | cut -f1 -d' ')
    outsize=$(wc -l /tmp/stdo7  | cut -f1 -d' ')
    errsize=$(wc -l /tmp/stde7  | cut -f1 -d' ')
    [ $stdsize -eq  0 ]
    [ $outsize -eq 12 ]
    [ $errsize -eq  0 ]
}
@test "-o-" {
    [ -d "$WGETDIR" ]
    rm -f /tmp/stdo2
    rm -f /tmp/stde2
    rm -f index.html
    $WGETDIR/src/wget -o- http://www.example.com 1>/tmp/stdo2 2>/tmp/stde2
    [ "$?" -eq 0 ]
    [ -f index.html ]
    [ ! -f "-" ]
    [ -f /tmp/stdo2 ]
    [ -f /tmp/stde2 ]
    outsize=$(wc -l /tmp/stdo2 | cut -f1 -d' ')
    errsize=$(wc -l /tmp/stde2 | cut -f1 -d' ')
    [ $outsize -eq 12 ]
    [ $errsize -eq 0 ]
}

# Combination test cases

@test "--badargs" {
    run wget --badargs
    [ "$status" -ne 0 ]
    [ "${lines[0]}" = "wget: unrecognized option '--badargs'" ]
}

#teardown() {
#    echo "$BATS_TEST_NAME complete">> "$LOG"
#}