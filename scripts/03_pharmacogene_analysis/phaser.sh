#!/bin/bash


for i in $(cat samples.txt); do
bcftools view -s ${i} test/0002.vcf.gz | bcftools query -e 'GT="0|1" || GT="0|0"' -f'[%POS~%REF>%ALT;]' | tr -d '\n' | sed 's/;$/\n/' > haps/${i}_haps.txt

bcftools view -s ${i} test/0002.vcf.gz | bcftools query -e 'GT="1|0" || GT="0|0"' -f'[%POS~%REF>%ALT;]' | tr -d '\n' | sed 's/;$/\n/' >> haps/${i}_haps.txt

done


# for i in $(cat snames.txt); do
#     wc -l ${i}_haps.txt >> hap_counts.txt
# done

# rm *haps.txt
