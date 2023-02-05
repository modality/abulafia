# Rebooting Abulafia

The [Abulafia](http://random-generator.com) wiki used to have a ton of tables filled with useful content for TTRPGs. It had a custom wiki plugin which did some text substitution: you could write a random table and the plugin would generate results in the page automatically. But the magic came from the fact you could include results from other tables on the wiki in your tables. And because it was a wiki, anyone could add random tables. Unfortunately, it was a victim of its own success. It became very slow, and there were few safeguards prevent errors and infinite recursion. But I managed to piece it together, and it runs pretty snappily on a local machine.

1. Clone this repo -- `git clone xxx`
2. Download and install Docker Desktop and start it up.
   - https://www.docker.com/products/docker-desktop/
3. Grab the Abulafia archive from archive.org.
   - https://archive.org/details/wiki-random_generatorcom
4. Decompress this archive. Inside, there are multiple wikidumps. Pick one and decompress. I used the most recent one: `random_generatorcom-20200225-wikidump.7z`.
5. Inside the decompressed dump, there should be a folder called `images` and a file called `random_generatorcom-20200225-history.xml`. Rename the XML file to `history.xml`
6. Copy the `images` directory and the `history.xml` file into your repo.
7. Deploy the stack file with `docker stack deploy -c stack.yml mediawiki`
8. Visit http://localhost:8080 and go through the steps to install and configure Mediawiki. go through these steps. to configure the database, use the following variables (these are also found in `stack.yml`.
   - host/url: change from `localhost` to `database`
   * database name: `my_wiki`
   * user: `wikiuser`
   * password: `example`
9. you should eventually reach a screen that automatically downloads LocalSettings.php with your configuration settings. copy LocalSettings.php into your working directory.
10. open stack.yml file, you should see a comment saying "After inital setup...". Uncomment the line starting with `./LocalSettings.php:...` to bind the LocalSettings.php on your machine to the appropriate location inside the container. It should look like this when you're done:
    ```
    # After initial setup, download LocalSettings.php to the same directory as
    # this yaml and uncomment the following line and use compose to restart
    # the mediawiki service
    - ./LocalSettings.php:/var/www/html/LocalSettings.php
    ```
11. Deploy the stack again with `docker stack deploy -c stack.yml mediawiki`
12. Visit http://localhost:8080/ . Your wiki should be reading the LocalSettings.php file that has now been mounted inside its directory and you should be redirected to "Main Page".
13. From docker desktop interface, click on the containers tab. Find the runnning container with a name like `mediawiki_mediawiki` and click the CLI icon, which looks like this: `>_`. It should open up a terminal inside the container.
14. Run `pwd` to ensure that you're in the `/var/www/html` directory. Run `ls` and ensure that both `LocalSettings.php` and `history.xml` are here.
15. Run the following to import your xml file: `php maintenance/importDump.php < history.xml`. this will take a while but eventually end with
    ```
    3100 (22.72 pages/sec 291.89 revs/sec)
    Done!
    ```
16. go ahead and run the suggested commands to rebuild recent changes and initialize site stats

```

php maintenance/rebuildrecentchanges.php

php maintenance/initSiteStats.php

```

1. visit http://localhost:8080/index.php/Special:AllPages and you should see all the generators! Now we will install all custom extension to make the generators actually work.

1. I found the

https://github.com/daveyounce/AbulafiaParser

http://localhost:8080/index.php/Special:Version

generating information based on other tables will be incomplete until you generate those tables manually.

this is borne out of the correct assumption that someone would edit and save the page, and then the website would insert the initial rows into the database

but people are not edting the page if we've imported them from XML!
so there is some manual hunting involved

you will have to click through all the w
http://localhost:8080/index.php/Dragon_Triumvirate

[Blackstaff.Organizations]
[Forgotten Realms Icons.MacGuffin]
