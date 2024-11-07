.PHONY: all clean

all:
	bash subst.sh
	bash deploy.sh

clean:
	rm -rf out
