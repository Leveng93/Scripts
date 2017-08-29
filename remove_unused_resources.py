""" This module can be used for remove unused resources from project """
import os
import sys
import argparse

parser = argparse.ArgumentParser(description="Manage file prefixes.")
parser.add_argument("directory", type=str, nargs=1, help="Directory with renaming files")

def check_entry(res_name, folder):
    """ Check file entries to pointed directory """
    def contains(res_name, filename):
        """ Try to find string in file """
        name_in_single_quotes = '"{}"'.format(res_name)
        name_in_double_quotes = "'{}'".format(res_name)
        with open(filename) as scanned_file:
            for line in scanned_file:
                if name_in_double_quotes in line or name_in_single_quotes in line:
                    return True
            return False

    for root, _, filenames in os.walk(folder):
        for filename in filenames:
            if contains(res_name, os.path.join(root, filename)):
                return filename

game = parser.parse_args().directory[0]
rc = os.path.join(game, "rc")
src = os.path.join(game, "src")

if not os.path.isdir(game):
    print r'Directory "{}" does not exists'.format(game)
    sys.exit()

print "Remove unused files from {}".format(game)
for res_filename in os.listdir(rc):
    containing_file = check_entry(res_filename, src)
    if not containing_file:
        os.remove(os.path.join(rc, res_filename))
        print "Removed \"{}\"".format(res_filename)
