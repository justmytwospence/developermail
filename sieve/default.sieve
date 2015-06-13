# http://sieve.info/

require ["envelope", "fileinto", "regex", "variables"];

# Spam
if allof (header :regex "X-DSPAM-Result" "^(Spam|Virus|Bl[ao]cklisted)$",
          not header :contains "X-DSPAM-Reclassified" "Innocent") {
  fileinto "Spam";
  stop;
}

# Mailing lists
# https://github.com/Exim/exim/wiki/MailFilteringTips
# Mailman & other lists using list-id
if exists "list-id" {
  if header :regex "list-id" "<([a-z0-9-]+)[.@]" {
    set :lower "listname" "${1}";
    fileinto "list.${listname}";
  } else {
    if header :regex "list-id" "^\\s*<?([a-z0-9-]+)[.@]" {
      set :lower "listname" "${1}";
      fileinto "list.${listname}";
    } else {
      fileinto "list.unknown";
    }
  } stop;
}
# Listar and mailman like
elsif exists "x-list-id" {
  if header :regex "x-list-id" "<([a-z0-9-]+)\\\\." {
    set :lower "listname" "${1}";
    fileinto "list.${listname}";
  } else {
    fileinto "list.unknown";
  } stop;
}
# Ezmlm
elsif exists "mailing-list" {
  if header :regex "mailing-list" "([a-z0-9-]+)@" {
    set :lower "listname" "${1}";
    fileinto "list.${listname}";
  } else {
    fileinto "list.unknown";
  } stop;
}
# York lists service
elsif exists "x-mailing-list" {
  if header :regex "x-mailing-list" "^\\s*([a-z0-9-]+)@?" {
    set :lower "listname" "${1}";
    fileinto "list.${listname}";
  } else {
    fileinto "list.unknown";
  } stop;
}
# Smartlist
elsif exists "x-loop" {
  fileinto "list.unknown";
  stop;
}
# Poorly identified
elsif envelope :contains "from" "owner-" {
  if envelope :regex "from" "owner-([a-z0-9-]+)-outgoing@" {
    set :lower "listname" "${1}";
    fileinto "list.${listname}";
  } elsif envelope :regex "from" "owner-([a-z0-9-]+)@" {
    set :lower "listname" "${1}";
    fileinto "list.${listname}";
  } elsif header :regex "Sender" "owner-([a-z0-9-]+)@" {
    set :lower "listname" "${1}";
    fileinto "list.${listname}";
  } else {
    fileinto "list.unknown";
  } stop;
}
# Other poorly identified
elsif  envelope :contains "from" "-request" {
  if envelope :regex "from" "([a-z0-9-]+)-request@" {
    set :lower "listname" "${1}";
    fileinto "list.${listname}";
  } else {
    fileinto "list.unknown";
  } stop;
}
