# http://sieve.info/

require ["fileinto", "mailbox", "regex", "variables"];

# Spam
if allof (header :regex "X-DSPAM-Result" "^(Spam|Virus|Bl[ao]cklisted)$",
          not header :contains "X-DSPAM-Reclassified" "Innocent") {
  fileinto :create "Spam";
  stop;
}

# Mailing lists
if allof (header :contains "Precedence" "list",
          not header :contains "From" ["<notifications@github.com>"],
          header :regex "List-Id" "<(.+)>") {
  set :lower "listname" "${1}";
  fileinto :create "${listname}";
}
