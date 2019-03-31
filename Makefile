all:
	collector evaluator tidyrisk noLD

collector: .PHONY
	make -C collector/ latest

evaluator: .PHONY
	make -C evaluator/ latest

tidyrisk: .PHONY
	make -C tidyrisk/ latest

noLD: .PHONY
	make -C noLD/ latest

.PHONY:
	@echo "Building tidyrisk images locally...\n"

clean::
	make -C collector/ clean
	make -C evaluator/ clean
	make -C tidyrisk/ clean
	make -C noLD/ clean
