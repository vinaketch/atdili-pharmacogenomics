#!/usr/bin/env python3

import os
import sys

hap_db = sys.argv[1]
hap_db1 = open(hap_db, "r")

var_file = sys.argv[2]
var_file1 = open(var_file, "r")

keys = []
values = []

for line in hap_db1:
    line = line.strip().split()
    keys.append(line[-1])
    values.append(line[0])

dict1 = dict(zip(keys, values))

list1 = []

for line in var_file1:
    if '>' in line:
        line = line.strip()
        list1.append(line)

if len(list1) == 0:
    hap1 = 'ref_diplo'
    hap2 = 'ref_diplo'

elif len(list1) == 1:
    hap1 = 'ref_diplo'
    hap2 = list1[0]

else:
    hap1 = list1[0]
    hap2 = list1[-1]

alleles  = []

if hap1 not in keys:
    alleles.append(hap1)
else:
    alleles.append(dict1[hap1])

if hap2 not in keys:
    alleles.append(hap2)
else:
    alleles.append(dict1[hap2])

alleles = sorted(alleles)

print("/".join(alleles))

