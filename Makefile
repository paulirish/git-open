
install:
	@cp -r ./git-open /usr/local/bin
	@chmod +x /usr/local/bin/git-open

clean:
	@rm /usr/local/bin/git-open

