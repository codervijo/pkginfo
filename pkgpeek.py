#!/usr/bin/python

# Given a directory with package (any language),
# print some info about the package.
# Useful bits would be :
#                      1, language C/perl/python/rails/go/java/IOS
#                      2, Any GIT/repo info                 DONE
#                      3, Linux formated files?
#                      4, Makefile/Cmake,                   DONE
#                      5, configure/autotools detect        DONE
#                      6, No of total files                 DONE
#                      7, Test directory                    DONE
#                      8, Examples directory                DONE
#                      9, Is it kernel source? Which ver?
#           V1        10, No of lines of C code in files
#           V1        11, Dependency libraries
#           V1        12, build instructions
#           V1        13, install instructions            
#           V1        14, instructions to run this package
#           V2        15, config files to run this package
#           V2        16, env variables to run this package
#           V2        17, support for sub-modules/directory trees etc
#           V3        18, option to build the package automatically
#           V4        19, dependecy tree for all software on the system
#           V5        20, What kind of kernel? (linux,*BSD)
#           V5        21, What patches are applied to the kernel?

# Another utility
#           V0        1, Given name of package, get a git clone
#           V0        2, Set up a VM/Microservice for this new package
#           V0        3,

# Another utility
#           Improve upon unifdef
#           Take linux kernel and unifdef all it's source files
#           Do the same for freebsd kernel
#           And busybox
#           This should create simplest all C code that gets run for a given
#           configuration - May be create a resulting output directory
#           (just for reading)


# Another kernel source related utility
#           Much config options better
#           Given OPTION, what are the dependencies?
#           Given OPTION, what is sequence of finding it in menuconfig

# Dependencies
#    1, sys
#    2, os

import sys
import os

if len(sys.argv) != 2:
	print 'Accepting 1 argument : path to package to peek into'
        sys.exit(1)

topdir = sys.argv[1]
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
rorpkg    = False
gnupkg   = False
giturl   = ""
testdir  = ""
exdir    = ""
for dirname, subdirList, fileList in os.walk(topdir):
        # ignore hidden directories (.blah)
        if os.path.basename(dirname).startswith('.'):
		next
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
if os.path.exists(topdir + '/setup.py'):
	if pyfiles > 0 and cfiles == 0:
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
	print 'Makfile based pakage'
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
	print 'Python package'
if mkpkg is True:
	print 'Makefile based C/C++ package'

print '\n\n'
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
