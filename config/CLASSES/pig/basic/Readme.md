# Pig
sudo apt-get install pig

# remove Hieve catalog usage
sed -i -e 's#exec /usr/lib/pig/bin/pig -useHCatalog "$@"#exec /usr/lib/pig/bin/pig "$@"#' /usr/bin/pig
