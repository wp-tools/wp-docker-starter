# wp-docker-starter

This project is a simple starter to get you going with local WordPress development using Docker. It even has subdomain multi-site support out of the box, just flip the switch. Huzzah!
 

**Requirements:**

- Docker (e.g. DockerCE for Mac)
- Docker Compose CLI (usually installed with Docker)
- GNU `make` (usually already on *nix based system. For Windows see: http://gnuwin32.sourceforge.net/packages/make.htm)


Please **DO NOT** use this for production sites. 

### TL;DR;

```
git clone https://github.com/rheinardkorf/wp-docker-starter.git my-project
cd my-project
make env
make setup
make up
# Happy developing!
```

Or you can download the repo as a zip, extract it and run the three make commands. ¯\\_(ツ)_/¯ 

---

### Why another WordPress Docker project?

This project is primarily for me to document my own processes. This is a starter project with the intent of ending up with
a project that probably won't look anything like this.  In fact, I recommend running `rm -rf .git` straight away to detach
from this repo. 

I do feel that the official WordPress Docker Hub image is lacking in tools that I use on a daily basis and therefore I
forever find myself scrambling to come up with a solution. Spending more time on Docker instead of development (thats bad!).
This repo is my own answer to that. Feel free to use it, contribute to it, or simply using it as a starting point for your
own development workflows.

#### All the bits

**Alpine Linux**:  
This project is setup with mostly Alpine Linux images to keep images small on my local machine. Having experienced other
larger images running in clusters, I am not convinced that Alpine is always the answer, but its nice here.

**PHP-FPM**:  
Because WordPress is PHP. The `wordpress-php` service is a `php-fpm` service that executes all the WordPress code. (shhh,
dont tell people this actually does all the work).

**Nginx**:  
Nginx is a great web server. Its lean and simple to setup. But in this case its used as a proxy server to the `php-fpm` service.
You could do this with Traefik as well, but Nginx is a bit more documented in the WordPress space.

**MariaDB**:  
All our MySQL goodness. This service contains all the data for our site. In this project I am mapping it to a local folder in
this repo. Have a poke around and you will see a `data` folder in this folder after you've run `make setup`.

**Other Tools**:  
- xDebug: One reason for not using the _/wordpress Docker Hub image is because there is no remote debugger available. This solves that.
- wp-cli: Doing WordPress things from the command line. In our case, via docker-compose and on the running image.
- php-unit: Because we all love to test our code.
- GNU make: Makefiles are old technology, but they are a super convenient alternative to bash scripts if you don't need them. Because we are executing code on containers, this is tool is invaluable.
- Composer: Composer is a great tool. Its a beast if you don't have it locally, but we're running it all in a container here. Please also applaud all the work from the <https://wpackagist.org/> project.    

There are some tools that have not made it to the list yet, but I will add them as the need arises. Or you are free to add them via
pull requests to this repo. For example, I have not yet added a `redis` support, I may not at all. Its not on my scope at the moment.

---

### make

GNU make is used as a convenience tool to wrap up the Docker commands required. Each "rule" in the `Makefile` is 
called a target and is executed by `make`ing the target.  E.g. `make env` actually execures `cp .env.dist .env`.

Here is a list of the commands:
  
| Command | Description |
| :--- | :--- |
| `env` | Copies .env.dist to .env |
| `setup` | Prepares WordPress folders and installs WordPress. |
| `build` | Rebuilds the WordPress Docker image. |
| `up` | Run WordPress services with 'docker-compose up'. |
| `down` | Stops WordPress services with 'docker-compose down'. |

There are a few others there too, feel free to poke around, but use those with caution.

---

### .env

When you clone this repository you will have to make sure that you copy the `.env.dist` file to `.env`. This file
contains all the environment variables to configure your project. For convenience you can run:

```
make env
```

The file exposes the following variables specifically related to your WordPress setup:

| Variable | Description |
| :--- | :--- |
| `WP_DOMAIN` | The local domain to use for your site. This needs to be added to your hosts file. Default: `wordpress.local` |
| `WP_SITE_TITLE` | Your WordPress site title. Default: `WordPress Local Development` |
| `WP_USER` | Your WordPress user. Default: `admin` (clearly a bad idea) |
| `WP_PASS` | Your WordPress user password. Default: `password` (another stellar idea) |
| `WP_EMAIL` | Your WordPress user email. Default: `admin@wordpress.local` |
| `WP_MULTISITE` | Leave this as `false` for a single site install. Change to `true` for multi-site. Default: `false` |
| `WP_MYSQL_DATABASE` | WordPress database. Leave it as `wordpress` for an easier `make setup` experience. Default: `wordpress` |
| `WP_MYSQL_PASSWORD` | MySQL password. Default: `wordpress` |
| `WP_MYSQL_ROOT_PASSWORD` | MySQL root password. Default: `wordpress` |
| `WP_MYSQL_USER` | MySQL user. Default: `wordpress` |
| `WP_AUTH_KEY` | WordPress salt. Default value provided, but change it to your own hash if you need to. |
| `WP_SECURE_AUTH_KEY` | WordPress salt. Default value provided, but change it to your own hash if you need to. |
| `WP_LOGGED_IN_KEY` | WordPress salt. Default value provided, but change it to your own hash if you need to. |
| `WP_NONCE_KEY` | WordPress salt. Default value provided, but change it to your own hash if you need to. |
| `WP_AUTH_SALT` | WordPress salt. Default value provided, but change it to your own hash if you need to. |
| `WP_SECURE_AUTH_SALT` | WordPress salt. Default value provided, but change it to your own hash if you need to. |
| `WP_LOGGED_IN_SALT` | WordPress salt. Default value provided, but change it to your own hash if you need to. |
| `WP_NONCE_SALT` | WordPress salt. Default value provided, but change it to your own hash if you need to. |

For xDebug development you can also change the default xDebug settings using the following variables. Please note that in doing
so you will need to rebuild your WordPress PHP image. You can do this with `make build` before your next `make up`.

| Variable | Description |
| :--- | :--- |
| `PHP_XDEBUG_DEFAULT_ENABLE` | Default: `1` |
| `PHP_XDEBUG_REMOTE_ENABLE` | Default: `1` |
| `PHP_XDEBUG_REMOTE_HOST` | Default: `127.0.0.1` |
| `PHP_XDEBUG_REMOTE_PORT` | Default: `9000` |
| `PHP_XDEBUG_REMOTE_AUTO_START` | Default: `1` |
| `PHP_XDEBUG_REMOTE_CONNECT_BACK` | Default: `1` |
| `PHP_XDEBUG_IDEKEY` | Default: `docker` |
| `PHP_XDEBUG_PROFILER_ENABLE` | Default: `0` |
| `PHP_XDEBUG_PROFILER_OUTPUT_DIR` | Default: `/tmp` |

---

### MIT Licence

This repo is licensed using the more permissive MIT licence. Please note that includes only the files here. It does **NOT** extend
to WordPress which is licensed using the copyleft GPL license. When working in the `wordpress/core` or `wordpress/wp-content` folders you are in GPL land.