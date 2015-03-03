# http://sieve.info/

require "fileinto";
require "imap4flags";
require "regex";

# Place all spam mails in "Spam" folder
if allof (header :regex "X-DSPAM-Result" "^(Spam|Virus|Bl[ao]cklisted)$",
  not header :contains "X-DSPAM-Reclassified" "Innocent") {

  # Uncomment this if you want your spam mails to be automatically marked as read
  # setflag "\\Seen";

  fileinto "Spam";
  stop;
}
