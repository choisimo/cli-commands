## example : 50x error pages 
    error_page 500 502 503 504 /50x/$status.html;
    location /50x/ {
      alias /var/www/html/error_html/50x/;
    }
