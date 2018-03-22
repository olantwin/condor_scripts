#!/bin/bash
source /afs/cern.ch/user/o/olantwin/SHiP_Software/setup.sh
set -ux
echo "Starting script."
DIR=$1
ProcId=$2
LSB_JOBINDEX=$((ProcId+1))
MUONS=/eos/experiment/ship/data/Mbias/pythia8_Geant4-withCharm_onlyMuons_4magTarget.root
# export EOSSHIP=root://eospublic.cern.ch/
# export EOS_MGM_URL=root://eospublic.cern.ch
NTOTAL=17786274
NJOBS=$3
TANK=6
ISHIP=3
MUSHIELD=9
N=$(( NTOTAL/NJOBS + ( LSB_JOBINDEX == NJOBS ? NTOTAL % NJOBS : 0 ) ))
FIRST=$(((NTOTAL/NJOBS)*(LSB_JOBINDEX-1)))
if eos stat /eos/experiment/ship/user/olantwin/"$DIR"/"$LSB_JOBINDEX"/ship.conical.MuonBack-TGeant4.root; then
	echo "Target exists, nothing to do."
	exit 0
# elif [[ "$(lsb_release -r -s)" != 6.9 ]]
# then
# 	exit 1
else
	python2 "$FAIRSHIPRUN"/macro/run_simScript.py --tankDesign $TANK --muShieldDesign $MUSHIELD --MuonBack --nEvents $N --firstEvent $FIRST --sameSeed 1 --seed 1 -f $MUONS --nuTauTargetDesign $ISHIP
	xrdcp ship.conical.MuonBack-TGeant4.root root://eospublic.cern.ch//eos/experiment/ship/user/olantwin/"$DIR"/"$LSB_JOBINDEX"/
	if [ "$LSB_JOBINDEX" -eq 1 ]; then
		xrdcp geofile_full.conical.MuonBack-TGeant4.root root://eospublic.cern.ch//eos/experiment/ship/user/olantwin/"$DIR"/
	fi
fi
