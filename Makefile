.PHONY: *

help: ## Shows this help prompt
	@echo "Usage: make target1 [target2] ..."
	@echo ""
	@echo "Target                          Description"
	@echo "================================================================================"
	@awk -F ':|##' '/^[^\t].+?:.*?##/ {printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF }' $(MAKEFILE_LIST)

run: ## Runs the application
	DJANGO_SETTINGS_MODULE=timetables.config.local ./manage.py runserver 0.0.0.0:8080

gunicorn: ## Runs the application under gunicorn
	gunicorn gubbins.wsgi

clean: ## Remove generated files
	rm -rf */migrations
	rm -f test.sqlite

build: format lint test ## Lint & Test

format: ## Reformats the codebase
	black .

ci-format:
	python3 -m black --check .

ci-standards:
	python3 -m pylint --ignore-patterns ^test.* ./timetables

lint: ci-format ci-standards ## Checks coding standards

test: ## Tests the application
	cp test_fixture.sqlite test.sqlite
	python3 -m pytest

startup: install clean database migrate superuser ## Preconfigure the application in a clean environment

staticfiles: ## Collect static files
	./manage.py collectstatic --noinput

superuser: ## Sets up the development superuser (admin/admin)
	DJANGO_SUPERUSER_EMAIL=admin@example.com DJANGO_SUPERUSER_USERNAME=admin DJANGO_SUPERUSER_PASSWORD=admin python manage.py createsuperuser --noinput	

install: ## Install dependencies
	touch timetables/config/secrets.py
	python3 -m pip install --user -r requirements.txt

database: ## Rebuilds the database, creating migrations
	./manage.py makemigrations timetables

migrate: ## Update the database
	./manage.py migrate

freeze: ## Freeze the current dependencies into requirements.txt
	python3 -m pip freeze > requirements.txt
