# http://sieve.info/

require ["fileinto", "mailbox", "regex", "variables"];

# Mailing lists
if header :contains "Precedence" "list" {
  if header :regex "List-Id" "<(.*)@" {
    fileinto :create "${1}";
  } else {
    fileinto :create "Lists";
  }
}

# Spam
if allof (header :regex "X-DSPAM-Result" "^(Spam|Virus|Bl[ao]cklisted)$",
          not header :contains "X-DSPAM-Reclassified" "Innocent") {
  fileinto :create "Spam";
}
