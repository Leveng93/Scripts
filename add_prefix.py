""" This module can be used for renaming files and adding prefixes """
import os
import sys
import argparse

parser = argparse.ArgumentParser(description="Manage file prefixes.")
parser.add_argument("directory", type=str, nargs=1, help="Directory with renaming files")
parser.add_argument("-o", "--old_prefix", type=str,\
    help="the old prefix in file name to be replaced")
parser.add_argument("-n", "--new_prefix", type=str,\
    help="the new prefix to be added to the file name")
args = parser.parse_args()

folder = parser.parse_args().directory[0]
new_prefix = args.new_prefix
old_prefix = args.old_prefix

if not (new_prefix or old_prefix):
    print "At least one prefix must be specified"
    sys.exit()
if not os.path.isdir(folder):
    print r'Directory "{}" does not exists'.format(folder)
    sys.exit()

for filename in os.listdir(folder):
    new_filename = new_prefix or ""
    if old_prefix and filename.startswith(old_prefix):
        new_filename += filename[len(old_prefix):]
    elif new_prefix:
        new_filename += filename
    if not new_filename:
        continue
    os.rename(os.path.join(folder, filename), os.path.join(folder, new_filename))
    print r"{} -> {}".format(filename, new_filename)
