#!/bin/env python2
import ROOT

jobname = "short_1.9"
chain = ROOT.TChain("cbmsim")

for i in ["root://eoslhcb.cern.ch//eos/ship/user/olantwin/{}/{}/ship.conical.MuonBack-TGeant4.root".format(jobname, n) for n in range(1,101)]:
	chain.Add(i)
	
print chain.GetEntries()

