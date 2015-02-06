GETPATH = $(firstword $(subst :, ,$1))
BINPATH = $(call GETPATH, ${PATH}) 
GOPATH = $(join ${BINPATH}, /git-open)

install:
	@cp -r ./git-open ${GOPATH}
	@chmod +x ${GOPATH}

clean:
	@rm ${GOPATH}


