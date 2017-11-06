#!/bin/bash
source /afs/cern.ch/user/o/olantwin/SHiP_Software/SHiP_setup.sh
set -ux
echo "Starting script."
DIR=$1
ProcId=$2
LSB_JOBINDEX=$((ProcId+1))
MUONS=/eos/ship/data/Mbias/pythia8_Geant4-withCharm_onlyMuons_4magTarget.root
NTOTAL=17786274
NJOBS=100
TANK=5
MUSHIELD=7
N=$(( NTOTAL/NJOBS + ( LSB_JOBINDEX == NJOBS ? NTOTAL % NJOBS : 0 ) ))
FIRST=$(((NTOTAL/NJOBS)*(LSB_JOBINDEX-1)))
if eos stat /eos/ship/user/olantwin/"$DIR"/"$LSB_JOBINDEX"/ship.conical.MuonBack-TGeant4.root; then
	echo "Target exists, nothing to do."
	exit 0
elif [[ "$(lsb_release -r -s)" != 6.9 ]]
then
	exit 1
else
	python2 "$FAIRSHIPRUN"/macro/run_simScript.py --tankDesign $TANK --muShieldDesign $MUSHIELD --MuonBack --nEvents $N --firstEvent $FIRST --sameSeed 1 --seed 1 -f $MUONS
	xrdcp ship.conical.MuonBack-TGeant4.root root://eoslhcb.cern.ch//eos/ship/user/olantwin/"$DIR"/"$LSB_JOBINDEX"/
	if [ "$LSB_JOBINDEX" -eq 1 ]; then
		xrdcp geofile_full.conical.MuonBack-TGeant4.root root://eoslhcb.cern.ch//eos/ship/user/olantwin/"$DIR"/
	fi
fi
