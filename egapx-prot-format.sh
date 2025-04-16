#!/bin/bash

#seqtk strips the comment in the header | extract the header names to produce a modified filename without the extra unwanted "gnl|WGS:ZZZZ"
#format of the NCBI protein file: >NP_001009425.1 CD1 precursor [Species name]

inFile=$1
speciesTag="${2:-Species name}"	#quote the input
speciesTag="[${speciesTag}]"

#local control variables [switch off by setting to 0, otherwise set to 1]
getUnique=1	#group the isoform IDs into single records
cleanup=0	#clean the intermediate files
finalize=0	#replace the header with the new modified header

#create a short header for the input fasta file
#seqtk is required, so check for it
seqtk=$(which seqtk 2>/dev/null)
if [ "no$seqtk" == "no" ]; then
	echo "seqtk was not found on this machine. Please install seqtk and ensure it is in your PATH."
	exit -1
else
	tag=$(basename $inFile .faa)
	seqtk seq -C $inFile > ${tag}_short.faa
fi

grep ">" $inFile | sed 's/>//g' | awk 'OFS="\t"{print $0,$0}' > tmp_key_val.txt

cut -f 1 tmp_key_val.txt | sed 's#gnl|WGS:ZZZZ|##g' > tmp_key_val_1_col.txt
awk -v species="$speciesTag" '{ split($1, a, "-"); id = a[1] "." substr(a[2], 2); description = substr($0, index($0, $2)); {print id, description, species }}' tmp_key_val_1_col.txt > tmp_NCBI_format.txt
awk 'OFS="\t"{split($1,vals,"|"); {print $1,vals[3]}}' tmp_key_val.txt > key_val.txt
cut -f 1 key_val.txt > key_original.txt
awk -F ' ' '{print $1}' tmp_NCBI_format.txt > IDs.txt
paste -d "\t" key_original.txt tmp_NCBI_format.txt > key_original_val_NCBI.txt

if [[ $getUnique -eq 1 ]];then
	awk -F'.' '{
    		id = $1
    		copies[id] = copies[id] ? copies[id] ";" $0 : $0
	}
	END {
    		for (id in copies) {
        		print copies[id]
    		}
	}' IDs.txt > uniqueIDs.txt
fi

if [[ $finalize -eq 1 ]];then
	while read k v; do sed -e "s#$k#$v#g" -i ${tag}_short.faa; done < key_original_val_NCBI.txt
fi

if [[ $cleanup -eq 1 ]];then
	rm key_original_val_NCBI.txt key_original.txt IDs.txt key_val.txt tmp_key_val_1_col.txt tmp_key_val.txt tmp_NCBI_format.txt
fi
