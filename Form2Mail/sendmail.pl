#!/usr/bin/perl

# --> SMTP-Program to send mails:
$Sendmail_Prog = "/usr/sbin/sendmail -t -i";
# --> E-Mail address to send to
$mailto = 'yourmail@domain.com';

# -------> Embed Modul for CGI-Scripts:
use CGI;

# -------> Construt CGI-Modulto read form-data:
$query = new CGI;
@names = $query->param;

# -------> read values from hidden and other fields:
$delimiter = $query->param('delimiter');  # ---> Delimeter for mail
$returnhtml = $query->param('return');    # ---> URL for forwarding
$mailfrom = $query->param('email');      # ---> E-Mail-From
$sendername = $query->param('name');      # ---> Sender name
$subject = $query->param('subject');      # ---> E-Mail-Subject

# -------> all Whitespace-Character (space, tab, Newline) in emtpy char transformation
#             AVOID Fraud
$subject =~ s/\s/ /g;

# -------> Create message from all forms:
$mailtext = "";
foreach(@names) {
  $name = $_;
  @values = "";
  @values = $query->param($name);
  if($name ne "return" && $name ne "subject" && $name ne "delimiter") {
    foreach $value (@values) {
      $mailtext = $mailtext.$name;
      $mailtext = $mailtext.$delimiter;
      $mailtext = $mailtext.$value."\n";
    }
  }
}

# -------> Send e-mail:
open(MAIL,"|$Sendmail_Prog -t") || print STDERR "Mailprogramm konnte nicht gestartet werden\n";
print MAIL "To: $mailto\n";
print MAIL "From: $mailfrom($sendername)\n";
print MAIL "Reply-to: $mailfrom\n";
print MAIL "Subject: $subject\n\n";
print MAIL "$mailtext\n";
close(MAIL);

# -------> Forward page:
print "Location: $returnhtml\n\n";
