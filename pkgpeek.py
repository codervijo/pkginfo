#!/usr/bin/python

# Dependencies
#    1, sys
#    2, os

import sys
import os

if len(sys.argv) != 2:
	print 'Accepting 1 argument : path to package to peek into'
        sys.exit(1)

# Configuration
debug    = False

# Init variables
topdir   = sys.argv[1]
subdirs  = 0
cfiles   = 0
cppfiles = 0
pyfiles  = 0
plfiles  = 0
rbfiles  = 0
shfiles  = 0
unfiles  = 0
totfiles = 0
m4files  = 0
javafiles= 0
txtfiles = 0
unixfl   = 0
winfl    = 0
lnxkrnl  = False
pypkg    = False
mkpkg    = False
rorpkg   = False
gnupkg   = False
giturl   = ""
testdir  = ""
exdir    = ""
for dirname, subdirList, fileList in os.walk(topdir):
        # ignore hidden directories (.blah)
        if os.path.basename(dirname).startswith('.'):
		next
	if debug is True:
		print 'Found directory: %s subdirList %s' % (dirname, subdirList)
	if dirname.lower().endswith('/.git'):
		next
        if dirname.lower().endswith('/test') or dirname.lower().endswith('/tests') or dirname.lower().endswith('/testenv'):
		testdir += dirname + " "
	if dirname.lower().endswith('/example') or dirname.lower().endswith("/examples"):
		exdir  = dirname
 
	for fname in fileList:
		if os.path.basename(fname).startswith('.'):
			next
		#print dirname, "/",fname
		if os.path.isdir(fname):
			#count total no of dirs
			#print fname, "is a directory"
			subdirs += 1
		else:
			#is it unix formatted
			#does it have c, pl/pm or py or sh
			if fname.lower().endswith('.c') or fname.lower().endswith('.h'):
				cfiles    += 1	
			elif fname.lower().endswith('.cpp'):
				cppfiles  += 1	
			elif fname.lower().endswith('.pl') or fname.lower().endswith('.pm') or fname.lower().endswith('.px'):
				plfiles   += 1
			elif fname.lower().endswith('.py'):
				pyfiles   += 1
			elif fname.lower().endswith('.rb'):
				rbfiles   += 1
			elif fname.lower().endswith('.sh'):
				shfiles   += 1
			elif fname.lower().endswith('.m4'):
				m4files   += 1
			elif fname.lower().endswith('.java'):
				javafiles += 1
                        elif fname.lower().endswith('.txt'):
				txtfiles  += 1
			else:
				# print "Unknown file", fname
				unfiles   += 1
			# If there is a setup.py, its likely a python package
			if fname.lower() == 'setup.py':
				pypkg = True
			# If it is named Makefile
			if fname.lower() == 'Makefile':
				mkpkg = True
			# is it named configure or autotools
			if fname.lower() == "configure":
				gnupkg = True
			# count total no of files
			totfiles += 1	


# Get GIT/repo info
gitdir=topdir + "/.git"
if os.path.isdir(gitdir):
	print 'Found Git directory'
        conffile = gitdir + "/config"
	giturl   = ''
	if os.path.exists(conffile): 
		print "good .git dir"
		conff = open(conffile, 'r')
		for line in conff:
			if '[remote' in line:
				print line.strip()
			if 'url' in line:
				print line.strip()
				giturl = line.strip().split('=')[1]
	print "GIT repo : ", giturl
else:
	print gitdir, 'is not a directory'

# Analyse - what kind of package is it?
# If it has just python files and 0 c/java/perl files, python package
if pypkg is True:
	pypkg = False
	if os.path.exists(topdir + '/setup.py'):
		print 'Found setup.py in ', topdir
		if pyfiles > 0 and cfiles == 0:
			print 'pypkg is going true'
			pypkg = True
# If it is mostly C (likely in src/), and Makefiles/configure  C package
# TODO needs to be improved, this is stopgap
if cfiles > pyfiles:
	mkpkg = True
if os.path.exists(topdir + '/Rakefile'):
	rorpkg = True
if os.path.exists(topdir + '/Readme'):
	rf = open(topdir + '/Readme')
	for line in rf:
		if line == 'Linux Kernel\n':
			lnxkrnl = True
		else:
			lnxknrl = False
		break
# Version of kernel is output of 'make kernelversion'
# Print Report
if giturl is not "":
	print 'Package GIT repo : ', giturl
if mkpkg is True:
	print 'Makefile based pakage'
if gnupkg is True:
	print 'GNU (autotools) based package'
if rorpkg is True:
	print 'Ruby on Rails package'
elif mkpkg is False and gnupkg is False:
	print 'Unknwon build type'

if testdir:
	print 'Test(s) are in ', testdir
if exdir:
	print 'Example(s) are in', exdir

if pypkg is True:
	print 'Python package', pypkg
if mkpkg is True:
	print 'Makefile based C/C++ package' # FIXME

print '\n'
print '%5d C files'       % cfiles
print '%5d C++ files'     % cppfiles
print '%5d Python files'  % pyfiles
print '%5d Perl files'    % plfiles
print '%5d Ruby files'    % rbfiles
print '%5d Shell files'   % shfiles
print '%5d Java files'    % javafiles
print '%5d GNU m4 files'  % m4files
print '%5d Text files'    % txtfiles
print '%5d Unknown files' % unfiles
print '--------------'
print '%5d Total files'   %totfiles
