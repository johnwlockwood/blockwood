deploy:
	hugo
	scp -r public/* lockwood@web83.webfaction.com:/home/lockwood/webapps/blockwood/

