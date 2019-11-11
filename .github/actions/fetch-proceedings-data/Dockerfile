FROM julia:1
RUN apt-get update && apt-get install -y git 

COPY entrypoint.sh /entrypoint.sh
COPY Project.toml /Project.toml
COPY Manifest.toml /Manifest.toml
COPY run.jl /run.jl

RUN julia --project=. -e 'using Pkg; pkg"instantiate"; pkg"precompile"'


ENTRYPOINT ["/entrypoint.sh"]