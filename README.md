# Generating Vanda MAGs with Snakemake Workflow

Log onto farm. Then start screen.

```
screen -S vanda_snakemake
```

Run snakemake workflow with

```
snakemake --cluster "sbatch -t {cluster.time} -p {cluster.partition} -N {cluster.nodes}" --cluster-config cluster_config.yml --jobs 28 --latency-wait=15 --use-conda
```
