# http://sieve.info/

require "fileinto";
require "imap4flags";
require "regex";

if allof (header :regex "X-DSPAM-Result" "^(Spam|Virus|Bl[ao]cklisted)$",
  not header :contains "X-DSPAM-Reclassified" "Innocent") {
  fileinto "spam";
  stop;
}
