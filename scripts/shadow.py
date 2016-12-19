#!/usr/bin/env python
import os
import sys
import string
import json

def shadow_file(src_fn, dst_fn, force, env):
  print src_fn, dst_fn
  if os.path.isfile(dst_fn):
    if not force and os.path.getmtime(dst_fn) > os.path.getmtime(src_fn):
      print "Source file is older"
      return
  
  with open(src_fn) as f, open(dst_fn, 'w') as out:
    t = string.Template(f.read())
    out.write(t.safe_substitute(env))

def main():
  args = sys.argv[1:]
  force = False
  if args[0] == '-f':
    force = True
    args = args[1:]
    
  env = os.environ
  if args[0] == '-e':
    with open(args[1]) as f:
      env = json.load(f)
    args = args[2:]
    
  src_dir, dst_dir = args
  lsrc = len(src_dir)
  
  if os.path.isfile(src_dir):
    shadow_file(src_dir, dst_dir, force, env)
    sys.exit(0)
  
  for root, dirs, files in os.walk(src_dir):
    rel_root = root[lsrc+1:]
    dest_dir = os.path.join(dst_dir, rel_root)
    if not os.path.isdir(dest_dir):
      os.makedirs(dest_dir)
    
    for name in files:
      src_fn = os.path.join(root, name)
      dst_fn = os.path.join(dest_dir, name)
          
      shadow_file(src_fn, dest_fn, force, env)
        
if __name__ == '__main__':
  main()