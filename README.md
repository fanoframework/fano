# Fano Framework

Web application framework for modern Pascal programming language.
[Learn more](https://fanoframework.github.io).

## Requirement

- Linux or FreeBSD
- [Free Pascal](https://www.freepascal.org/) >= 3.0
- Web Server (Apache, nginx)
- [libcurl development](https://curl.haxx.se/libcurl/) (optional)
- [libmicrohttpd development](https://www.gnu.org/software/libmicrohttpd/) (optional)

## Installation

### Install from Fano Command Line tool

[Fano CLI](https://github.com/fanoframework/fano-cli) is command line tool intended to simplify
[scaffolding web application](https://fanoframework.github.io/scaffolding-with-fano-cli/), creating controllers, views, models, etc. It is recommended way to setup web application skeleton with Fano Framework.

    $ fanocli --project-cgi=my-cool-app
    $ cd my-cool-app
    $ fanocli --mvc=Hello
    $ ./build.sh

### Install from sample application

You can clone sample application repositories that is available in
[Fano Framework documentation](https://fanoframework.github.io/examples) as base application skeleton.

### Install from scratch with Git submodule

If you decide to start from scratch,

    $ mkdir my-cool-app
    $ cd my-cool-app
    $ git init
    $ git submodule add https://github.com/fanoframework/fano.git

This command will pull Fano Web Framework repository into `fano` directory inside your `my-cool-app` directory.

### Install from scratch without Git submodule

Using `git submodule` requires you to have copy of Fano respository locked to specific commit in your application project directory structure. If you have multiple applications that uses Fano, each of them will have their own copy of Fano respository that may be locked to different commit version. Updating Fano repository in one application does not affect other applications. It is roughly similar to how Composer (PHP) or NPM (Node.js) works.

If you do not want this code duplication, you may clone Fano repository as usual
in a directory, then, in your each application project configuration, you tell
Free Pascal, directory where to search Fano units.

This approach, however, has disadvantage. When you update your Fano repository,
all your applications that depends on Fano will be affected. If newer version of Fano repository introduces breaking changes, application that requires older version of Fano repository may fail.

## Versioning Number

Fano Framework follows [Semantic Versioning 2.0.0](https://semver.org/#semantic-versioning-200).

## Windows User

Fano Framework is not yet supported on Windows.

## Roadmap

See [Projects](https://github.com/orgs/fanoframework/projects) for more information about what is currently being developed or planed.

## Copyright Notice

[See NOTICE.txt](NOTICE.txt)
