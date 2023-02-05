Rebuilding Abulafia / random-generator.com

1. download and install docker desktop. start it up -- https://www.docker.com/products/docker-desktop/
1. grab the random generators archive from archive.org.-- https://archive.org/details/wiki-random_generatorcom
1. decompress this zip file, and there are multiple wikidumps inside. pick one and decompress. i used the most recent one:
   `random_generatorcom-20200225-wikidump.7z`. it should have a folder called `images` and a file called `random_generatorcom-20200225-history.xml`. Rename the XML file to `history.xml`
1. create a working directory on your computer where you want this to live. copy the images directory and the history.xml file to this directory
1. visit the mediawiki docker image on docker hub -- https://hub.docker.com/_/mediawiki
1. scroll down to the section on Volumes which contains an example `stack.yml`
   - you can find this by ctrl+F for "example stack.yml for mediawiki"
1. Copy the contents of that `stack.yml` file into a `stack.yml` file into your working directory
1. Deploy the stack with `docker stack deploy -c stack.yml mediawiki`
1. visit localhost:8080 and go through the steps to install and configure mediawiki. go through these steps. to configure the database, use the following variables
   - host/url: change from `localhost` to `database`
   - database name: `my_wiki`
   - user: `wikiuser`
   - password: `example`
1. you should eventually reach a screen that automatically downloads LocalSettings.php with your configuration settings. copy LocalSettings.php into your working directory.
1. open stack.yml file, you should see a comment saying "After inital setup...". Uncomment the line starting with `./LocalSettings.php:...` to bind the LocalSettings.php on your machine to the appropriate location inside the container
1. add an additional line to bind the history.xml file to a location inside the container. It should look like this when you're done:
   ```
   # After initial setup, download LocalSettings.php to the same directory as
   # this yaml and uncomment the following line and use compose to restart
   # the mediawiki service
   - ./LocalSettings.php:/var/www/html/LocalSettings.php
   - ./history.xml:/var/www/html/history.xml
   ```
1. Deploy the stack again with `docker stack deploy -c stack.yml mediawiki`
1. visit http://localhost:8080/ . Your wiki should be reading the LocalSettings.php file that has now been mounted inside its directory and you should be redirected to "Main Page".
1. From docker desktop interface, click on the containers tab. find the runnning container with a name like `mediawiki_mediawiki` and click the CLI icon, which looks like this: `>_`. It should open up a terminal inside the container.
1. Run `pwd` to ensure that you're in the `/var/www/html` directory. Run `ls` and ensure that both LocalSettings.php and history.xml are here
1. run the following to import your xml file: `php maintenance/importDump.php < history.xml`. this will take a while but eventually end with
   ```
   3100 (22.72 pages/sec 291.89 revs/sec)
   Done!
   ```
1. go ahead and run the suggested commands to rebuild recent changes and initialize site stats
   ```
   php maintenance/rebuildrecentchanges.php
   php maintenance/initSiteStats.php
   ```
1. visit http://localhost:8080/index.php/Special:AllPages and you should see all the generators! Now we will install all custom extension to make the generators actually work.
1. I found the

https://github.com/daveyounce/AbulafiaParser

http://localhost:8080/index.php/Special:Version
