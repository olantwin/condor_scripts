#!/bin/sh
source /afs/cern.ch/user/o/olantwin/SHiP_Software/setup.sh
set -ux
echo "Starting script."
DIR=$1
ProcId=$2
LSB_JOBINDEX=$((ProcId+1))
NJOBS=$3
if eos stat /eos/experiment/ship/user/olantwin/"$DIR"/"$LSB_JOBINDEX"/ship.conical.MuonBack-TGeant4_rec.root; then
	echo "Target exists, nothing to do."
	exit 0
# elif [[ "$(lsb_release -r -s)" != 6.9 ]]
# then
# 	exit 1
else
	python2 "$FAIRSHIPRUN"/macro/ShipReco.py  -f root://eospublic.cern.ch//eos/experiment/ship/user/olantwin/"$DIR"/"$LSB_JOBINDEX"/ship.conical.MuonBack-TGeant4.root -g root://eospublic.cern.ch//eos/experiment/ship/user/olantwin/"$DIR"/geofile_full.conical.MuonBack-TGeant4.root
	xrdcp ship.conical.MuonBack-TGeant4_rec.root root://eospublic.cern.ch//eos/experiment/ship/user/olantwin/"$DIR"/"$LSB_JOBINDEX"/
fi
