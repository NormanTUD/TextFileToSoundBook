use strict;
use warnings;
use Data::Dumper;
use Digest::MD5 qw/md5_hex/;

my $path = shift @ARGV;;
die "$path not found" unless -e $path;

my $filename_md5 = md5_hex($path);

my $full = qx(cat $path);

mkdir $filename_md5 unless -d $filename_md5;

my @sentences = map { s#\s+# #g; $_ } split(/[!\.,?]/, $full);

my $i = 0;
for (@sentences) {
	my $filename = sprintf("%08d", $i);
	next if -e "$filename_md5/$filename.wav";
	s#"##g;
	my $command = qq(pico2wave --lang de-DE --wave $filename_md5/$filename.wav "$_")."\n";
	print $command;
	qx($command);
	$i++;
}

qx(sox $filename_md5/* output.wav);
