.PHONY: static


# Develop content 
dev: 
	(  hugo server -D  --port $(PORT)  --bind="0.0.0.0" --baseURL=$(SERVER_NAME) ) 

# Generate static content 
static: 
	(  hugo  ) 


PORT=8080
SRV_ROOT=$(PWD)/docs
SRV_ROOT=/home/hans/cybercampus/cybercampus.se
SRV_ROOT=/home/hans/cybercampus/cybernode.se
SERVER_NAME="http://localhost:$(PORT)/lammda"

hugo:
	hugo server  -verbose --config config.toml  --port $(PORT)  --bind="0.0.0.0" --baseURL=$(SERVER_NAME)  public 

light: static
	export SERVER_ROOT=$(SRV_ROOT)  && export PORT=$(PORT) && export SERVER_NAME=$(SERVER_NAME) && export MAX_FDS=16384 && /usr/sbin/lighttpd  -D -f  lighttpd.conf



ff: 
	firefox $(SERVER_NAME) 


