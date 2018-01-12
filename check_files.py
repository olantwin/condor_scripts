#!/bin/env python2
import click
import ROOT


@click.command()
@click.argument('jobname')
@click.argument('n_jobs', default=100)
def check_files(jobname, n_jobs):
    chain = ROOT.TChain('cbmsim')

    for i in [
            '''root://eospublic.cern.ch//eos/experiment/ship/user/olantwin/'''
            '''{0}/{1}/ship.conical.MuonBack-TGeant4.root'''.format(
                jobname,
                n
            )
            for n in range(1, n_jobs + 1)
    ]:
        chain.Add(i)

    print chain.GetEntries()


if __name__ == '__main__':
    check_files()
