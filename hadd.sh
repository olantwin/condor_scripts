#!/bin/bash
source /afs/cern.ch/user/o/olantwin/SHiP_Software/setup.sh
set -ux
hadd "$1" $(eval echo "$2") && xrdcp "$1" $(dirname $(dirname "$2"))/"$1"
