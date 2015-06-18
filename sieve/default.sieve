# http://sieve.info/

require ["fileinto", "regex"];

# Mailing lists
if header :contains "Precedence" "list" {
  fileinto "Lists";
  stop;
}

if header :contains "subject" "test" {
  fileinto "Tests";
  stop;
}

# Spam
if allof (header :regex "X-DSPAM-Result" "^(Spam|Virus|Bl[ao]cklisted)$",
          not header :contains "X-DSPAM-Reclassified" "Innocent") {
  fileinto "Spam";
  stop;
}
