check: lint test

PY_SOURCE_FILES=mosec setup.py
RUST_SOURCE_FILES=src/*

install:
	pip install -e .[dev]

test:
	pytest tests -vv

doc:
	cd docs && make html

clean:
	rm -rf build/ dist/ *.egg-info .pytest_cache
	find . -name '*.pyc' -type f -exec rm -rf {} +
	find . -name '__pycache__' -exec rm -rf {} +

package: clean
	python setup.py sdist bdist_wheel

publish: package
	twine upload dist/*

format:
	autoflake --in-place --recursive ${PY_SOURCE_FILES}
	isort --project=spectree ${PY_SOURCE_FILES}
	black ${PY_SOURCE_FILES}
	rustfmt ${RUST_SOURCE_FILES}

lint:
	isort --check --diff --project=spectree ${PY_SOURCE_FILES}
	black --check --diff ${PY_SOURCE_FILES}
	flake8 ${PY_SOURCE_FILES} --count --show-source --statistics
	rustfmt --check ${RUST_SOURCE_FILES}

.PHONY: test doc