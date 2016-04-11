#!/usr/bin/env python
import os
import sys
import string

def main():
  args = sys.argv[1:]
  force = False
  if args[0] == '-f':
    force = True
    args = args[1:]
    
  src_dir, dst_dir = args
  lsrc = len(src_dir)

  for root, dirs, files in os.walk(src_dir):
    rel_root = root[lsrc+1:]
    dest_dir = os.path.join(dst_dir, rel_root)
    if not os.path.isdir(dest_dir):
      os.makedirs(dest_dir)
    
    for name in files:
      src_fn = os.path.join(root, name)
      dst_fn = os.path.join(dest_dir, name)
      
      print src_fn, dst_fn
      if os.path.isfile(dst_fn):
        if not force and os.path.getmtime(dst_fn) > os.path.getmtime(src_fn):
          print "Older"
          continue
      
      with open(src_fn) as f, open(dst_fn, 'w') as out:
        for line in f:
          t = string.Template(line)
          out.write(t.safe_substitute(os.environ))
        
if __name__ == '__main__':
  main()