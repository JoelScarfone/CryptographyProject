# Cryptography Project 

### Install & Run
Prerequsit - A revalvant version of ruby installed. For windows users, see https://rubyinstaller.org/downloads/. 

##### MacOS/Linux

Install required libraries and run rake.
```sh
$ bundle install
$ rake
```

##### Windows
Install the elgamal ruby gem (the only external library used). Either from the command line, or from source.

Command Line:
```sh
$ gem install elgamal
```

From Source (download files here: https://github.com/JoelScarfone/ElGamal): Navigate to the directory with the files, then run:
```sh
$ gem build elgamal.gemspec
$ gem install elgamal-x.x.x
```

With the prerequsites installed, just run 'rake' in the directory of the source code for the crypro project. 
```sh
$ rake
```
