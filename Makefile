MAKEFLAGS += -j3

all: linkclump gooreplacer cdn4cn \
	 vimium-c darkreader violentmokey uBlock

linkclump:
	./linkclump.sh

gooreplacer:
	./gooreplacer.sh

cdn4cn:
	./cdn4cn.sh

vimium-c:
	./vimium-c.sh

darkreader:
	./darkreader.sh

violentmokey:
	./violentmonkey.sh

uBlock:
	./uBlock.sh

rmi:
	docker rmi $(docker images -f reference=crxbuilder -q)
