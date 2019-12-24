SWIPL = swipl -q -s
TEST_FILES = $(wildcard test*.pl)
LONG_TEST_FILES = $(wildcard longtest*.pl)

.PHONY: test longtest

test:
	for test_file in $(TEST_FILES) ; do \
		$(SWIPL) $$test_file ; \
	done

longtest:
	for test_file in $(LONG_TEST_FILES) ; do \
		$(SWIPL) $$test_file ; \
	done
