SAMPLES, = glob_wildcards('DATA/{sample}.fastq.gz')
print(SAMPLES)

rule all:
    input:
        "cmp.mat.matrix.png",
        expand("OUTPUT/MEGAHIT/{samples}", samples=SAMPLES)

rule compare:
    input:
        expand("DATA/{samples}.fastq.gz.sig", samples=SAMPLES)
    output:
        "cmp.mat.matrix.png"
    conda:
        "env-sourmash.yml"
    shell:
        """sourmash compare {input} -o cmp.mat &&\
           sourmash plot cmp.mat"""

rule compute_sig:
    input:
        "{filename}"
    output:
        "{filename}.sig"
    conda:
        "env-sourmash.yml"
    shell:
        "sourmash compute -k 31 --scaled 1000 {input} -o {output} --name-from-first"

rule assemble:
    input:
        "DATA/{samples}.fastq.gz"
    output:
        "OUTPUT/MEGAHIT/{samples}/final.contigs.fa"
    conda:
        "env-megahit.yml"
    shell:
        "megahit --12 {input} --min-contig-len 1500 -o {output}"
