#!/usr/bin/python
import sys
import urllib
import os
import shutil
import datetime
import re

project      = None
date         = ""
download_dir = None
suffix       = None
keepVersion  = False

# ----------------------------------------------------------------------------------------
# customSuffix[siteName][buildName] = SuffixToUse
# ----------------------------------------------------------------------------------------
# This global variable is used to provide a custom suffix mapping based on
# site and build name.
# ----------------------------------------------------------------------------------------
customSuffix = {
   'altair.kitware': {
      'MountainLion-nightlymaster-superbuild'        : '10.8',
      'MountainLion-nightlymaster-superbuild-nompi'  : '10.8-NoMPI' },
   'debian-x64.kitware': {'nightlymaster-superbuild' : 'glibc-2.3.6' },
   'debian-x32.kitware': {'nightlymaster-superbuild' : 'glibc-2.3.6' },
   'Blight.kitware' : {'ubuntu-x64-nightlymaster-superbuild' : 'glibc-2.15' },
   'kamino.kitware' : {
     'Lion-nightlymaster-superbuild'                 : 'Python-26',
     'Lion-python27-nightlymaster-superbuild'        : 'Python-27'
   }
}

# ----------------------------------------------------------------------------------------

def printUsage():
  print "Usage: script.py --project=ParaView"
  print
  print "List of options:"
  print " --help         : Print this script usage."
  print " --project      : Mandatory argument that select in which project"
  print "                  we should look at for the uploaded files. (MANDATORY)"
  print " --download-dir : This option will trigger the download of the files and"
  print "                  will store then to the provided directory. If not provided,"
  print "                  we will only list the files URLs to the standard output."
  print "                 (OPTIONAL)"
  print " --date         : Specify for which date we should try to downlaod/list"
  print "                  the given file URLs. (OPTIONAL)"
  print " --suffix       : Append suffix to the download name so ParaView-v3.98.tgz"
  print "                  will be named ParaView-v3.98-${SUFFIX}.tgz (OPTIONAL)"
  print " --yesterday    : Set the date to be yesterday date"
  print " --version      : Allow to keep the initial file version, otherwise any"
  print "                  version number will be removed from the file name."
  print
  print "Command line examples:"
  print "  $ ./script.py --project=ParaView"
  print "  $ ./script.py --project=ParaView --date=2012-09-11"
  print "  $ ./script.py --help"
  print "  $ ./script.py --project=ParaView --download-dir=/tmp/pv-nightly --suffix=NIGHTLY --yesterday"
  print

# ----------------------------------------------------------------------------------------

def processArgs():
  global project, date, suffix, download_dir
  global keepVersion
  for arg in sys.argv:
    if arg.startswith("--help"):
      printUsage()
      return False
    if arg.startswith("--project="):
      project = arg.split("=")[1]
    if arg.startswith("--date="):
      date = arg.split("=")[1]
    if arg.startswith("--download-dir="):
      download_dir = arg.split("=")[1]
    if arg.startswith("--suffix="):
      suffix = arg.split("=")[1]
    if arg.startswith("--yesterday"):
      now = datetime.datetime.now() - datetime.timedelta(days=1)
      date = "%d-%02d-%d" % (now.year, now.month, now.day)
    if arg.startswith("--version"):
      keepVersion = True

  if not project:
     printUsage()
     return False

  return True

# ----------------------------------------------------------------------------------------

def extractBuildIds():
    buildIds = []
    url = ( "http://open.cdash.org/index.php?project=%s&date=%s" ) % (project, date)
    page = urllib.urlopen(url)
    for line in page:
        index = line.find("viewFiles")
        while index != -1:
            # Extract build id
            start = line.find('=', index)
            end = line.find('"', index)
            buildIds.append(line[start+1:end])
            index = line.find("viewFiles", index + 1)
    return buildIds

# ----------------------------------------------------------------------------------------

def getBuildInfo(buildId):
    buildName = ""
    siteName  = ""
    fileURLs  = []
    url = ("http://open.cdash.org/viewFiles.php?buildid=%s") % (buildId)
    page = urllib.urlopen(url)
    for line in page:
        # Search for build name
        summaryIndex = line.find("buildSummary.php?buildid=")
        if summaryIndex != -1:
            start = line.find(">", summaryIndex+1) + 1
            end   = line.find("<", summaryIndex+1)
            buildName = line[start:end]

        # Search for site name
        siteIndex = line.find("<b>Site: </b>")
        if siteIndex != -1:
            start = line.find("</b>", siteIndex+1) + 4
            end   = line.find("<br", siteIndex+1)
            siteName = line[start:end]

        # Search for files
        index = line.find("upload/")
        while index != -1:
            end = line.find('"', index)
            fileURLs.append("http://open.cdash.org/" + line[index:end])
            index = line.find("upload/", index + 1)
    return { 'site': siteName, 'name': buildName, 'urls': fileURLs }

# ----------------------------------------------------------------------------------------

def getSuffix(buildInfo, default_suffix):
  if customSuffix.has_key(info['site']) and customSuffix[info['site']].has_key(info['name']):
    custom_suffix = customSuffix[info['site']][info['name']]
    if default_suffix:
      return "%s-%s" % (custom_suffix, default_suffix)
    else:
      return custom_suffix
  return default_suffix

# ----------------------------------------------------------------------------------------

def printBuildInfo(info):
    print " Site: %s" % info['site']
    print " Name: %s" % info['name']
    print " URLs:"
    for url in info['urls']:
        print "  - %s" % url

# ----------------------------------------------------------------------------------------

def filterDestinationFileName(fileName):
  global keepVersion
  if not keepVersion:
    fileName = re.sub( r'-[0-9]+.[0-9]+.[0-9]+.RC[0-9]', '', fileName)
    return re.sub( r'-[0-9]+.[0-9]+.[0-9]+', '', fileName)
  return fileName

# ----------------------------------------------------------------------------------------

def downloadFiles(buildInfo, destination, default_suffix):
    if not os.path.exists(destination):
        os.makedirs(destination)

    for url in info['urls']:
        dstFileName = filterDestinationFileName(url.split('/')[-1])
        suffix = getSuffix(buildInfo, default_suffix)
        if suffix:
            if dstFileName.endswith(".tar.gz"):
              dstFileName = dstFileName[0:-7] + '-' + suffix + '.tar.gz'
            else:
              extensionIndex = dstFileName.rfind(".")
              dstFileName = dstFileName[0:extensionIndex] + '-' + suffix + dstFileName[extensionIndex:]
        fulldestinationPath = destination + "/" + dstFileName
        print "Downloading %s" % fulldestinationPath
        urllib.urlretrieve (url, fulldestinationPath)

# ----------------------------------------------------------------------------------------

if __name__ == "__main__":
  if processArgs():
    buildIds = extractBuildIds()
    if len(buildIds) > 0:
      print
      fileInfos = []
      for id in buildIds:
        fileInfos.append( getBuildInfo(id) )
      if download_dir:
        if os.path.exists(download_dir):
          shutil.rmtree(download_dir)
        print ("Download to %s" % download_dir)
        for info in fileInfos:
          downloadFiles(info, download_dir, suffix)
      else:
        if not date:
          now = datetime.datetime.now()
          date = "%d-%d-%d" % (now.year, now.month, now.day)
        print "--------------------------------------------"
        print " Available files for project %s - Date: %s" % (project,date)
        print "--------------------------------------------"
        for info in fileInfos:
          printBuildInfo(info)
          print "--------------------------------------------"
        print
    else:
      print "No build founds with generated files."

# ----------------------------------------------------------------------------------------
