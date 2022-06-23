SAMPLES, = glob_wildcards('DATA/{sample}.fastq.gz')
print(SAMPLES)

rule all:
    input:
        "cmp.mat.matrix.png",
        expand("OUTPUT/MEGAHIT/{samples}/final.contigs.fa", samples=SAMPLES)

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
        expand("DATA/{samples}.fastq.gz", samples=SAMPLES)
    output:
        expand("OUTPUT/MEGAHIT/{samples}/final.contigs.fa", samples=SAMPLES)
    conda:
        "env-megahit.yml"
    params:
        input_list=lambda w, input: ".".join(input)
    shell:
        "megahit --12 {params.input_list} --min-contig-len 1500 -o {output}"
