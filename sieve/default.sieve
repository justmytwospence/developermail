# http://sieve.info/

require ["fileinto", "mailbox", "regex", "variables"];

##########
## Spam ##
##########

if allof (header     :regex "X-DSPAM-Result" "^(Spam|Virus|Bl[ao]cklisted)$",
          not header :contains "X-DSPAM-Reclassified" "Innocent") {
  fileinto :create "Spam";
  stop;
}

###################
## Mailing lists ##
###################

if allof (header     :contains "Precedence" "list",
          header     :matches  "List-Id"    "*<*.*",
          not header :contains "From" ["<notifications@github.com>"],
          not header :contains "From" ["alumni@"]) {
  set :lower "listname" "${2}";
  fileinto :create "Lists.${listname}";
}

###########################
## Oddball mailing lists ##
###########################

if header :contains "From" "[via Apache Spark User List]" {
  fileinto :create "Lists.apache-spark-user";
}
