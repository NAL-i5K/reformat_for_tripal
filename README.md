# reformat_for_tripal

Some scripts used to format GFF3 adn Fasta files for loading into our Chado schema. 

The main functions involve:
 - using the CDS span to calculate the coordinate ranges for a polypeptide feature
 - adding a polypeptide line to eht gff3
 - adjusting the peptide Fasta file so IDs are consistent for loading.


Some examples:
# add polypeptide lines and CDS IDs to the GFF3
perl generate_polypeptide_lines_CDS_ids_from_gff3.pl -g original_files_plus_peptide/ofas_v1_1_original.gff3 -o NAL_MOD_files/ofas_v1_1_original_with_peptide_cds_ids.gff3 
#update the deflines in the CDS fasta
perl update_CDS_fasta_ids.pl -i original_files_plus_peptide/ofas_v1_1_original.cds.fasta -o NAL_MOD_files/ofas_v1_1_original.cds_NAL_IDs.fasta|wc -l
# update the deflines in the peptide fasta
perl update_peptide_fasta_ids.pl -i original_files_plus_peptide/ofas_v1_1_original.cds.fasta -o NAL_MOD_files/ofas_v1_1_original.cds_NAL_IDs.fasta|wc -l

##Clec
# update the gff
perl generate_polypeptide_lines_CDS_ids_from_gff3.pl -g clec_OGS_v1_2.gff3 -o clec_OGS_v1_2_with_pep_CDS.gff3
#update the CDSdeflines
perl update_CDS_fasta_ids.pl -i clec_OGS_v1_2_CDS.fa -o  clec_OGS_v1_2_CDS_NAL_IDs.fa
# update the peptide deflines (will only update to -PA style if it is -RA style)
perl update_peptide_fasta_ids.pl -i clec_OGS_v1_2_peptide.fa -o clec_OGS_v1_2_peptide_NAL_IDs.fa