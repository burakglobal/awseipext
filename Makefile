test: lint
	@echo "--> Running Python tests"
	/srv/lambda/venv/bin/py.test tests || exit 1
	@echo ""

develop:
	@echo "--> Installing dependencies"
	pip install -r requirements.txt
	pip install "file://`pwd`#egg=awseipext[tests]"
	@echo ""

dev-docs:
	# todo the docs, so typical, right?

clean:
	@echo "--> Cleaning pyc files"
	find . -name "*.pyc" -delete
	rm -rf ./publish ./htmlcov ./awseipext.egg-info
	@echo ""

lint:
	@echo "--> Linting Python files"
	PYFLAKES_NODOCTEST=1 /srv/lambda/venv/bin/flake8 awseipext
	@echo ""

coverage:
	coverage run --branch --source=awseipext -m py.test tests
	coverage html

publish: clean
	# Ensure directory exists
	mkdir -p ./publish/awseipext_lambda
	# Copy in libs
	cp -r /srv/lambda/venv/lib/python2.7/site-packages/. ./publish/awseipext_lambda/
	# Copy in module code
	cp -r ./awseipext ./publish/awseipext_lambda/
	mv ./publish/awseipext_lambda/awseipext/aws_lambda/* ./publish/awseipext_lambda/
	# Copy in config
	cp -r ./lambda_configs/. ./publish/awseipext_lambda/
	# Zip it
	cd ./publish/awseipext_lambda && zip -q -r ../awseipext_lambda.zip .

.PHONY: develop dev-docs clean test lint coverage publsh
