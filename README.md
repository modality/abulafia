# Rebooting Abulafia

Time was, the [Abulafia](http://random-generator.com) wiki had ton of tables filled with useful content for TTRPGs. Its killer feature was a plugin which performed text substitution: you could write a random table as a wiki page and the plugin would generate results on the fly. But the magic came from the fact you could include results from _other tables_ on the wiki in your tables. And because it was a wiki, anyone could add random tables. This wiki had a gigantic corpus of data... with a few steps you could pull together the color table, the animal table, the objects table, and you'd have some really intricate descriptions

> From [Dragon description](http://localhost:8080/index.php/Dragon_description): "Keneflakthralialia the old dragon has khaki scales; a unicorn’s horn; two long, strong legs; bat-like wings, and a long, sinuous tail. It has reptilian eyes. It can exhale a cone of ice. All who behold it shall rightly adore it as a god."

> From [Chimera](http://localhost:8080/index.php/Chimera): "This chimera has a cactus's head, the body of a sparrow and a giraffe's tongue. Though it might behave like a fly around soldiers, it usually has a hippopotamus's disposition. It enjoys wearing a uniform, and a collar can be seen on its eye. It carries a ruler at all times. It has a fondness for dirt, but is weakened by exposure to rain."

> From [Bows](http://localhost:8080/index.php/Bows): "A longbow made of hickory wood. The grip is wrapped in beige wool. The bowstring is actually a single wire made of finely-crafted Living Metal. Accompanying the bow is a quiver of oiled red-violet calfskin with rabbit fur trim. It contains blunt arrows with shafts of ironwood wood in its natural color and fletching of salmon feathers."

Unfortunately, it was a victim of its own success. It became very slow to use, either due to traffic or database load. There were few safeguards prevent errors, infinite loops, and misuse. I don't remember when it stopped working. But it's alive again, now.

With a lot of luck, I have puzzled out how to stand up a Mediawiki instance, import a data dump I found on Archive.org, and even hack [the Abulafia Parser plugin](https://github.com/daveyounce/AbulafiaParser) to get random generation working again. I have never understood PHP and don't intend to, so "working on my machine" is as far as I intend to take this project. If you want to host this thing publically, go with my blessing!

Here are steps to get it running locally, which assumes a little familiarity with Github and Docker.

### Usage pt. 1 - mise en place

1. Clone this repo.
   - `git clone git@github.com:modality/abulafia.git`
2. Download and install Docker Desktop and start it up.
   - https://www.docker.com/products/docker-desktop/
3. Download the Abulafia archive from archive.org.
   - https://archive.org/details/wiki-random_generatorcom
4. Decompress the Abulafia archive. Inside, there are multiple wikidumps. Pick one and decompress.
   - I used the most recent one: `random_generatorcom-20200225-wikidump.7z`.
5. Inside the decompressed dump, there should be a folder called `images` and a file called `random_generatorcom-20200225-history.xml`. Rename the XML file to `history.xml`. Copy the `images` folder and the `history.xml` file into your cloned repo.
6. On the command line, in the repo directory, deploy the stack file. This will take a couple minutes to download and build the containers. Eventually, in Docker desktop you should see two running containers: one for MediaWikia and one for its MariaDB database.
   - `docker stack deploy -c stack.yml mediawiki`

### Usage pt. 2 - wiki configuration

7. Visit http://localhost:8080 and go through the steps to install and configure Mediawiki. To configure the database, use the following variables (these are also found in `stack.yml`).
   - host or URL: change from `localhost` to `database`
   * database name: `my_wiki`
   * user: `wikiuser`
   * password: `example`
8. You will eventually reach a screen that automatically downloads a file called `LocalSettings.php` with your configuration settings. Copy `LocalSettings.php` into your repo directory.
9. Open the `stack.yml` file. In it, you should see a comment saying "After inital setup...". Uncomment the line starting with `./LocalSettings.php:...` to bind the `LocalSettings.php` in your repo directory to the appropriate location inside the MediaWiki container. It should look like this when you're done:
   ```
   # After initial setup, download LocalSettings.php to the same directory as
   # this yaml and uncomment the following line and use compose to restart
   # the mediawiki service
   - ./LocalSettings.php:/var/www/html/LocalSettings.php
   ```
10. Deploy the stack again with `docker stack deploy -c stack.yml mediawiki`
11. Visit http://localhost:8080/ . Your wiki should be reading the `LocalSettings.php` file that has now been mounted inside its directory and you should be redirected to "Main Page".

### Usage pt. 3 - data import

12. From docker desktop interface, click on the containers tab. Find the runnning container with a name like `mediawiki_mediawiki` and click the CLI icon, which looks like this: `>_`. It should open up a terminal inside the container.
13. Run `pwd` to ensure that you're in the `/var/www/html` directory. Run `ls` and ensure that both `LocalSettings.php` and `history.xml` are here.
14. Run the following to import your xml file: `php maintenance/importDump.php < history.xml`. this will take a while but eventually end with
    ```
    3100 (22.72 pages/sec 291.89 revs/sec)
    Done!
    ```
15. Go ahead and run the suggested commands to rebuild recent changes and initialize site stats
    ```
    php maintenance/rebuildrecentchanges.php
    php maintenance/initSiteStats.php
    ```
16. Visit http://localhost:8080/index.php/Special:AllPages and you should see all pages for all the generators!

### Usage pt. 4 - wiki plugin installation

17. This next part fairly easy. Paste the following lines of code at the bottom of your `LocalSettings.php` file.
    ```php
    wfLoadExtension ( 'CiteThisPage' );
    wfLoadExtension ( 'ReplaceText' );
    wfLoadExtension ( 'ParserFunctions' );
    $wgPFEnableStringFunctions = true;
    wfLoadExtension ( 'AbulafiaParser' );
    ```
18. Visit the Version page and scroll down to the "Installed extensions" section. You should see the four extension above installed. Scroll all the way to the bottom of this page to look at the "Parser extension tags" section. If the Abulafia plugin is loaded correctly, the two generation tags should be here: `<sgdisplay>` and `<sgtable>`.
    - http://localhost:8080/index.php/Special:Version

### Usage pt. 5 - actual random generation

19. You are now ready to roll (on random tables)! Visit any generator and refresh the page to get results.
    - [All Pages](http://localhost:8080/index.php/Special:AllPages)
    - [Category: Generator](http://localhost:8080/index.php/Category:Generator)
20. Generators can include results from other pages. One quirk of this system is that you have to visit the other page first to generate initial data before it can be included. This is borne out of the (correct) assumption that when you're creating a table, you would edit and save the page, and generate the initial data, all before someone referenced your table. Obviously this didn't happen if we've imported all these tables from XML. Here's an example of how to go about generating this info:
    - [Dragon Triumvirate](http://localhost:8080/index.php/Dragon_Triumvirate) requires information from other pages and will produce incomplete data until those tables are loaded.
    - In order to figure out which tables are required, click the "Edit" button. Looking in the source, we can see when tables are required because they are enclosed in brackets with the format `[PAGE NAME.TABLE NAME]`.
    - On the Dragon Triumvirate page source, we can see `[Blackstaff.Organizations]` and `[Forgotten Realms Icons.MacGuffin]` (among others). So in this case I would visit the [Blackstaff](http://localhost:8080/index.php/Blackstaff) and [Forgotten Realms Icons](http://localhost:8080/index.php/Forgotten_Realms_Icons) pages to generate their data. Then I can go back to Dragon Triumvirate and results from those tables will be included.
