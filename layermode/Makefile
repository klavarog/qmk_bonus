QARA = ~/bin/qara2c
INDENT = indent

build: tangle
	@echo "Finished building"

clean:
	@rm layermode.h

layermode.h:
	@$(QARA) < litsrc/layermode.h.md | $(INDENT) > layermode.h
	@echo "Tangled litsrc/layermode.h.md to layermode.h"

tangle: layermode.h
	@echo "Finished tangling"

