# http://sieve.info/

require ["fileinto", "regex", "variables"];

# Mailing lists
if header :contains "Precedence" "list" {
  fileinto "Lists";
}

# Spam
if allof (header :regex "X-DSPAM-Result" "^(Spam|Virus|Bl[ao]cklisted)$",
          not header :contains "X-DSPAM-Reclassified" "Innocent") {
  fileinto :create "Spam";
}
