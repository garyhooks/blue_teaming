

## Subfinder

## theHarvester

Update the api-keys.yaml file located in ./data/ directory. This should be moved to /home/ubuntu/.theHarvester/.

Run the following to search for emails across all sources
> /home/ubuntu/.local/bin/uv run theHarvester -d targetdomain.com -l 20000 -b all -q

