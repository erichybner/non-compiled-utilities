###################################################
#This script navigates through a bunch of files and
#recursively searches and replaces a string
###################################################
 
#!/usr/bin/python
 
import os, sys, getopt, re
 
#default options
TMPEND = "asdfjlkjiii_+1233"
TOPDIR = "."
REPLACE = False
QUIETOUTPUT = False
REGEXENABLE = False
TESTING = False
SRCERROR = True #check usage
ASK = False
 
def usage():
  print """
  USAGE:
    traversal.py -h
    traversal.py [-e fileend] [-d topdir] -s search [-r replace]
    -h --help help
    -e --end file ending for temp files
    -d --dir top directory (default .)
    -s --search phrase to search for
    -r --replace phrase to replace with (default do nothing)
    -t --test test mode (don't actually replace, just print what would be replaced)
       this is equivelant to leaving -r out or writing -r 'sameas -s'
    -q --quiet quiet mode, supress output
    -a --ask ask before replacing stuff
    -x --regex use regular expressions instead of a straight search and replace"""
 
def replace(filename, searchstring, replacestring):
  regex = ""
  if REGEXENABLE:
    regex = re.compile(searchstring)
  try:
    file = open(filename, 'r')
    tmpfile = open(filename + TMPEND, 'w')
    for i in file.readlines():
      #change the file
      if not REGEXENABLE:
        newstr = i.replace(searchstring, replacestring)
      else:
        newstr = regex.sub(replacestring, i)
      #print the changes
      if not QUIETOUTPUT:
        if newstr != i:
          if ASK:
            print "in file", filename
            print "Replace", i, "with", newstr,
            replacebool = raw_input('y/n: ')
            if replacebool[0] not in ('y', 'Y'):
              newstr = i
          else:
            print "in file", filename
            print "Replacing", i, "with", newstr
      #only write the new string to the file if not testing
      if not TESTING:
        tmpfile.write(newstr)
      else:
        tmpfile.write(i)
    file.close()
    tmpfile.close()
    os.renames(filename + TMPEND, filename)
  except IOError, (errno, strerror):
    if errno == 21:
      pass
    else:
      print "unexpected error:",sys.exc_info()[0]
      raise
 
def search(arg, dirname, fnames):
  for file in fnames:
    replace(os.path.join(dirname,file), arg[0], arg[1])
 
if __name__ == '__main__':
  try:
    opts, args = getopt.getopt(sys.argv[1:], 'he:d:s:r:txa',["help", "end", "dir", "search", "replace", "test", "regex", "ask"])
  except getopt.GetoptError:
    print "Error"
    usage()
    sys.exit(2)
 
  phrase = ""
  replacestring = ""
 
  #process the options
  for o, a in opts:
    if o in ("-h", "--help"):
      usage()
      sys.exit(0)
    if o in ('-e', '--end'):
      TMPEND = a
    if o in ('-d', '--dir'):
      TOPDIR = a
    if o in ('-s', '--search'):
      phrase = a
      SRCERROR = False
    if o in ('-r', '--replace'):
      REPLACE = True
      replacestring = a
    if o in ('-t', '--test'):
      print "Running in Testing mode"
      print "No changes should take place to your files\n"
      TESTING = True
    if o in ('-q', '--quiet'):
      QUIETOUTPUT = True
    if o in ('-x', '--regex'):
      REGEXENABLE = True
    if o in ('-a', '--ask'):
      ASK = True
 
  #the phrase to search for is necessary
  if SRCERROR:
    print "Error, need the phrase to search for (-s)"
    usage()
    sys.exit(2)
 
  #The phrase to replace with by default is itself
  if not REPLACE:
    replacestring = phrase
 
  os.path.walk(TOPDIR, search, [phrase, replacestring])
