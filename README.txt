AndroVariant
=========================================

This tool is designed to be used to aid discussion and research of known
android malware.  It is not meant to detect malware but simply to determine
relationships using different methods and techniques.

Usage
=====
./androv -p <plugin> <file.apk>
Example:
./androv -p SpellCheckerPlugin.rb com.Beautry.Girl.apk

You can specify as many plugins as you want.  Use -v to be verbose and print
timings for each plugin.

Plugins
=======
SpellCheckPlugin - String matching similar to many common spell checkers
  Requires rubygems and Text to be installed (gem install Text)

Writing your own plugin
=======================
To write your own plugin to test matching characterstics of malware simply
extend your class from AndroVPlugin.  The following methods will be called
by the main application:
  load_config - Load any config files and signature files you may need
  analyze - The routine that actually does all the work
  report - A basic report to screen method

config files are kept in config/

LICENSE
=======
This code relies on METASM which is included (metasm.cr0.org)

This software is licensed under the Creative Commons Attributes-ShareAlike 3.0 License
