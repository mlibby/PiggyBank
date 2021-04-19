test:
	py.test.exe

coverage:
	py.test.exe --cov=app --cov-report html:covhtml 
