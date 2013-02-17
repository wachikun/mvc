# -*- Makefile -*-

.PHONY			: all clean package

all			:
	emacs -batch -f batch-byte-compile mvc.el

MKDIR			= mkdir
RM			= rm
PROJECT_VERSION		= 0.1-test8

package			:
	$(MKDIR) -p var/package &&\
	$(RM) -rf var/package/mvc-$(PROJECT_VERSION) &&\
	hg archive var/package/mvc-$(PROJECT_VERSION) &&\
	cd var/package &&\
	$(RM) -f mvc-$(PROJECT_VERSION)/.hg_archival.txt &&\
	$(RM) -f mvc-$(PROJECT_VERSION)/.hgignore &&\
	$(RM) -f mvc-$(PROJECT_VERSION)/.hgtags &&\
	tar cJf mvc-$(PROJECT_VERSION).tar.xz mvc-$(PROJECT_VERSION) &&\
	sha1sum mvc-$(PROJECT_VERSION).tar.xz
