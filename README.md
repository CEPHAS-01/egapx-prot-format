# egapx-prot-format
This is a script to help to reformat the protein output file of the NCBI EGAPx (https://github.com/ncbi/egapx) annotation pipeline to be amenable to downstream analyses.

The current header has the format ">gnl|WGS:ZZZZ|UserSuppliedName_v1_000001-P1 ubiquitin carboxyl-terminal hydrolase 17-like protein 6" where "UserSuppliedName" is the locus_tag_prefix specified in the yml file prior to running the EGAPx pipeline.

The NCBI header for protein sequence is in the format ">UserSuppliedName_v1_000001.1 ubiquitin carboxyl-terminal hydrolase 17-like protein 6 [Species name]".

This script takes the output of the protein annotation from the NCBI EGAPx pipeline and replaces the sequence headers with the proper NCBI format, and also produces a sequence ID file ("uniqueIDs.txt") of the protein sequence of the transcript isoforms, one isoform per line e.g. 

UserSuppliedName_v1_001270.1
UserSuppliedName_v1_028290.1;UserSuppliedName_v1_028290.2;UserSuppliedName_v1_028290.3
UserSuppliedName_v1_015676.1;UserSuppliedName_v1_015676.2

Tools like Omark (https://github.com/DessimozLab/OMArk) which assesses the quality of a proteome requires the NCBI format. 

# Dependencies

This script requires that you have seqtk (https://github.com/lh3/seqtk) installed and in your PATH.


# Download a copy

Obtain a copy by downloading and saving it to a location on your machine. You may need to make it executable:

chmod +x /path/to/egapx-prot-format.sh

# How to run

bash /path/to/egapx-prot-format.sh inputProteinSequence.faa "Species name"

NB: If your species name is more than a word, it is important that you put the words in a quote.

This could also be run on a cluster by submitting it with sbatch

sbatch --mem=XG -c Y /path/to/egapx-prot-format.sh inputProteinSequence.faa "Species name"


# Feedback

Please open an issue (https://github.com/CEPHAS-01/egapx-prot-format/issues) if you run into any problem or have questions regarding this script.

