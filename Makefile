LIBS := $(wildcard lib/*.nut)
HTML := $(wildcard html/*.html)
JS := $(wildcard js/*.js)

all: build run

build: agent.nut_ device.nut_

agent.nut_: agent.nut $(LIBS) $(JS) $(HTML)
device.nut_: device.nut $(LIBS)

# We use 'Builder' to preprocess the nut files.
# See https://github.com/electricimp/Builder
# You need to "npm install -g Builder"
PLEASEBUILD_OPTS := -l
PLEASEBUILD := pleasebuild $(PLEASEBUILD_OPTS)

# .nut -> .nut_
%.nut_: %.nut
	$(PLEASEBUILD) $< >$@

# We use 'impt' to push the code.
# See https://github.com/electricimp/imp-central-impt
# You need to "npm install -g imp-central-impt"
IMPT := impt
IMPT_PROJECT := .impt.project

run: $(IMPT_PROJECT)
	$(IMPT) build run

run-log:
	$(IMPT) build run --log

clean:
	rm -f device.nut_ agent.nut_
