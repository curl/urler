##########################################################################
#                                  _   _ ____  _
#  Project                     ___| | | |  _ \| |
#                             / __| | | | |_) | |
#                            | (__| |_| |  _ <| |___
#                             \___|\___/|_| \_\_____|
#
# Copyright (C) Daniel Stenberg, <daniel@haxx.se>, et al.
#
# This software is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at https://curl.se/docs/copyright.html.
#
# You may opt to use, copy, modify, merge, publish, distribute and/or sell
# copies of the Software, and permit persons to whom the Software is
# furnished to do so, under the terms of the COPYING file.
#
# This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
# KIND, either express or implied.
#
# SPDX-License-Identifier: curl
#
##########################################################################

TARGET = trurl
OBJS = trurl.o
ifndef TRURL_IGNORE_CURL_CONFIG
LDLIBS += $$(curl-config --libs)
CFLAGS += $$(curl-config --cflags)
endif
CFLAGS += -W -Wall -Wshadow -pedantic
CFLAGS += -Wconversion -Wmissing-prototypes -Wwrite-strings -Wsign-compare -Wno-sign-conversion
ifndef NDEBUG
CFLAGS += -Werror -g
endif
MANUAL = trurl.1

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man/man1
ZSH_COMPLETIONSDIR ?= $(PREFIX)/share/zsh/site-functions
COMPLETION_FILES=completions/_trurl.zsh

INSTALL ?= install
PYTHON3 ?= python3

all: $(TARGET) $(MANUAL)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $(TARGET) $(LDLIBS)

trurl.o: trurl.c version.h

$(MANUAL): trurl.md
	./scripts/cd2nroff trurl.md > $(MANUAL)

.PHONY: install
install:
	$(INSTALL) -d $(DESTDIR)$(BINDIR)
	$(INSTALL) -m 0755 $(TARGET) $(DESTDIR)$(BINDIR)
	(if test -f $(MANUAL); then \
	$(INSTALL) -d $(DESTDIR)$(MANDIR); \
	$(INSTALL) -m 0644 $(MANUAL) $(DESTDIR)$(MANDIR); \
	fi)
	(if test -f $(COMPLETION_FILES); then \
	$(INSTALL) -d $(DESTDIR)$(ZSH_COMPLETIONSDIR); \
	$(INSTALL) -m 0755 $(COMPLETION_FILES) $(ZSH_COMPLETIONSDIR)/_trurl; \
	fi)

.PHONY: clean
clean:
	rm -f $(OBJS) $(TARGET) $(COMPLETION_FILES) $(MANUAL)

.PHONY: test
test: $(TARGET)
	@$(PYTHON3) test.py

.PHONY: test-memory
test-memory: $(TARGET)
	@$(PYTHON3) test.py --with-valgrind

.PHONY: checksrc
checksrc:
	./scripts/checksrc.pl trurl.c version.h

.PHONY: completions
completions: trurl.md
	./completions/generate_completions.sh $^
