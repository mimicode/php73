# php7.3.16 

## USEAGE: 
- #docker rm -f  php73a php73b nginx
- docker run --name php73a -d -v /Users/zhang/PhpstormProjects:/var/www:rw leitaozhang/php73:latest
- docker run --name php73b -d -v /Users/zhang/PhpstormProjects:/var/www:rw leitaozhang/php73:latest
- docker run  --name nginx  -v /Users/zhang/PhpstormProjects:/var/www:ro -v /Users/zhang/docker/nginx/config:/etc/nginx/conf.d --link php73a --link php73b  -p 80:80 -p 443:443 nginx:latest    

## NGINX
### /Users/zhang/docker/nginx/config/localhost.conf
    server {
	    listen       80;
	    server_name   localhost 127.0.0.1;
	    access_log   /var/log/nginx/localhost.access.log  main;
	    root /var/www/localhost;
	    index  index.php index.html index.htm; 
	    location ~ \.php$ {
            fastcgi_pass   php73a:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }
    }
    
## vvv
    tar zcvf  ../php73.tar.gz -C /Users/zhang/Documents/phpserver/php73/file_tar --exclude=.DS_Store  ./