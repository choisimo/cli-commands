## install chrome
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    
    sudo apt install ./google-chrome-stable_current_amd64.deb
    
    wget https://chromedriver.storage.googleapis.com/109.0.5414.74/chromedriver_linux64.zip
    
    unzip chromedriver_linux64.zip

## install python3
    sudo apt-get install python3

## crontab
    #include <stdio.h>
    #include <stdlib.h>
    
    int main(int argc, char* argv){
    
            printf("argc %d", argc);
    
            system("crontab -l > temp.txt");
    
            // 1분. 2시.  3일.  4월.   5요일
            
            system("echo '2 8 * * * /usr/bin/python3 /home/usr/documents/hello.py");
    
            system("crontab temp.txt");
    
            system("rm temp.txt");
    
            printf("new crontab setted");
    
            return 0;
    }
#### crontab command
    crontab -l //search exist crontabs
    crontab -r //remove all exist crontabs
    