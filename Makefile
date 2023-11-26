.PHONY:  build

build:
	rm -rf build
	mkdir build
	cd link/link/authorize && zip ../../../build/authorize.zip lambda_handler.py
	cd link/link/login && zip ../../../build/login.zip lambda_handler.py
	cd link/link/token && zip ../../../build/token.zip lambda_handler.py