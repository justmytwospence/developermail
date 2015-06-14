# http://sieve.info/

require ["envelope", "fileinto", "regex", "variables"];

# Spam
if allof (header :regex "X-DSPAM-Result" "^(Spam|Virus|Bl[ao]cklisted)$",
          not header :contains "X-DSPAM-Reclassified" "Innocent") {
  fileinto "Spam";
  stop;
}

# Mailing lists
if header "Precedence" "list" {
  if exists "list-id" {
    if header :regex "list-id" ".*<([a-zA-Z0-9-]+)[.@].*" {
      set :lower "listname" "${1}";
      fileinto "${listname}";
    } else {
      fileinto "Lists";
    }
  } stop;
} else {
  fileinto "Lists";
  stop;
}
