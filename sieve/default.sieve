# http://sieve.info/

require ["envelope", "fileinto", "regex", "variables"];

# Mailing lists
if header :contains "Precedence" ["bulk", "list"] {
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

# Spam
if allof (header :regex "X-DSPAM-Result" "^(Spam|Virus|Bl[ao]cklisted)$",
          not header :contains "X-DSPAM-Reclassified" "Innocent") {
  fileinto "Spam";
  stop;
}
