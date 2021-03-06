SRCS:=attribution setup.py

venv:
	python -m venv .venv
	source .venv/bin/activate && make setup dev
	echo 'run `source .venv/bin/activate` to use virtualenv'

build:
	python setup.py build

dev:
	python setup.py develop

setup:
	python -m pip install -Ur requirements-dev.txt
	python -m pip install -Ur requirements.txt

release: lint test clean
	python setup.py sdist bdist_wheel
	python -m twine upload dist/*

format:
	python -m usort format $(SRCS)
	python -m black attribution setup.py

lint:
	python -m pylint --rcfile .pylint $(SRCS)
	python -m usort check $(SRCS)
	python -m black --check $(SRCS)

test:
	python -m coverage run -m attribution.tests
	python -m coverage report
	python -m mypy attribution

.PHONY: html
html:
	sphinx-build -b html docs html

clean:
	rm -rf build dist html README MANIFEST *.egg-info

distclean: clean
	rm -rf .venv