package Audio::Gramofile;

use 5.005;
use strict;

use Carp;

require Exporter;
require DynaLoader;
use vars qw($VERSION @ISA);
@ISA = qw(Exporter
	DynaLoader);

$VERSION = '0.02';

bootstrap Audio::Gramofile $VERSION;

=pod

=head1 NAME

Audio::Gramofile - Perl interface to libgramofile, a library derived from Gramofile

=head1 SYNOPSIS

use Audio::Gramofile;

my $gramofile = Audio::Gramofile->new;

$gramofile->set_input_file($wav_file);

$gramofile->set_output_file($out_file);

# track splitting methods

$gramofile->init_tracksplit("make_use_rms" => 1);

$gramofile->split_to_tracks;

# signal processing methods

$gramofile->init_filter_tracks(@filter_list);

$gramofile->init_simple_median_filter("num_samples" => 7);

$gramofile->init_double_median_filter("first_num_samples" => 5);

$gramofile->init_simple_mean_filter("num_samples" => 9);

$gramofile->init_rms_filter("num_samples" => 3);

$gramofile->init_cmf_filter("rms_length" => 9);

$gramofile->init_cmf2_filter("rec_med_len" => 11);

$gramofile->init_cmf3_filter("fft_length" => 8);

$gramofile->init_simple_normalize_filter("normalize_factor" => 25);

$gramofile->filter_tracks;

=head1 ABSTRACT

This module provides a Perl interface to Gramofile, a program for recording
gramophone records. It is able to record hours of CD quality music,
split long sound files in separate tracks, and remove ticks and pops from
recordings.

Gramofile was written by Anne Bezemer and Ton Le.

Gramofile is available from http://panic.et.tudelft.nl/~costar/gramofile/

libgramofile - a library derived from Gramofile is
available from http://sourceforge.net/projects/libgramofile

=head1 DESCRIPTION

=head2 new

returns an object initialised with the parameters specified in the original C code.

e.g. my $gramofile = Audio::Gramofile->new;

=head2 set_input_file

sets the input .wav file for track splitting and signal processing methods.

e.g. $gramofile->set_input_file($wav_file);

=head2 track splitting methods

=head2 init_tracksplit

The following elements may be initialised by this method. All are used to
modify the track splitting algorithm.

=over 4

=item *

  make_use_rms # Save/load signal power (RMS) data to/from .rms file

=item *

  make_graphs # Generate graph files

=item *

  blocklen # Length of blocks of signal power data (samples)

=item *

  global_silence_factor # Global silence factor (0.1 %)

=item *

  local_silence_threshold # Local silence factor (%)

=item *

  min_silence_blocks # Minimal length of inter-track silence (blocks)

=item *

  min_track_blocks # Minimal length of tracks (blocks)

=item *

  extra_blocks_start # Number of extra blocks at track start

=item *

  extra_blocks_end # Number of extra blocks at track end

=back

e.g. $gramofile->init_tracksplit("make_use_rms" => 1, "min_silence_blocks" => 10);

=head2 split_to_tracks

The input file is split into a number of tracks. A file with name new.wav
will be split into tracks called new01.wav, new02.wav etc.

e.g. $gramofile->split_to_tracks;

=head2 signal processing methods

=head2 init_filter_tracks

Any, or all, of the following filters may be specified:

=over 4

=item *

simple_median_filter

=item *

simple_mean_filter

=item *

cond_median_filter

=item *

double_median_filter

=item *

cond_median2_filter

=item *

rms_filter

=item *

copyonly_filter

=item *

monoize_filter

=item *

cond_median3_filter

=item *

simple_normalize_filter

=item *

experiment_filter

=back

The filters are applied in the order given in the list.

e.g. $gramofile->init_filter_tracks("rms_filter", "simple_mean_filter");

by default the cond_median2_filter is used.

=head2 set_output_file

sets the output .wav file name for the signal processing method, filter_tracks.

e.g. $gramofile->set_output_file($out_file);

=head2 init_simple_median_filter

This method allows the parameters to be set for the simple median filter.

The following elements may be set for this filter:

=over 4

=item *

num_samples # the number of samples of which to take the median.

=back

e.g. $gramofile->init_simple_median_filter("num_samples" => 7);

=head2 init_double_median_filter

This method allows the parameters to be set for the simple median filter.

The following elements may be set for this filter:

=over 4

=item *

first_num_samples # the number of samples of which to take the median

=item *

second_num_samples # the number of samples of the second (correction) median.

=back

e.g. $gramofile->init_double_median_filter("first_num_samples" => 5);

=head2 init_simple_mean_filter

This method allows the parameters to be set for the simple mean filter.

The following elements may be set for this filter:

=over 4

=item *

num_samples # the number of samples of which to take the mean.

=back

e.g. $gramofile->init_simple_mean_filter("num_samples" => 9);

=head2 rms_filter

This method allows the parameters to be set for the rms filter.

The following elements may be set for this filter:

=over 4

=item *

num_samples # the number of samples of which to take the rms.

=back

e.g. $gramofile->init_rms_filter("num_samples" => 3);

=head2 init_cmf_filter

This method allows the parameters to be set for the conditional mean filter.

The following elements may be set for this filter:

=over 4

=item *

num_samples # the number of samples of the median which will be used to interpolate ticks.

=item *

rms_length # the number of samples of which to take the rms.

=item *

rms_med_len # the length of the recursive median operation.

=item *

rms_med_dec # the decimation factor of the recursive median operation.

=item *

tick_threshold # the threshold for tick detection.

=back

e.g. $gramofile->init_cmf_filter("rms_length" => 9, "tick_threshold" => 3000);

=head2 init_cmf2_filter

This method allows the parameters to be set for the second conditional mean filter.

The following elements may be set for this filter:

=over 4

=item *

rms_length # the number of samples of which to take the rms.

=item *

rms_med_len # the length of the recursive median operation.

=item *

rms_med_dec # the decimation factor of the recursive median operation.

=item *

fine_threshold # the fine threshold for tick start/end.

=item *

tick_threshold # the threshold for detection of tick presence.

=back

e.g. $gramofile->init_cmf2_filter("rec_med_len" => 11, "fine_threshold" => 2500);

=head2 init_cmf3_filter

This method allows the parameters to be set for the second conditional mean (frequency domain using fft) filter.

The following elements may be set for this filter:

=over 4

=item *

rms_length # the number of samples of which to take the rms.

=item *

rms_med_len # the length of the recursive median operation.

=item *

rms_med_dec # the decimation factor of the recursive median operation.

=item *

fine_threshold # the fine threshold for tick start/end.

=item *

tick_threshold # the threshold for detection of tick presence.

=item *

fft_length # Length for fft to interpolate (2^n).

=back

e.g. $gramofile->init_cmf3_filter("fft_length" => 8, "fine_threshold" => 2500);

=head2 init_simple_normalize_filter

This method allows the parameters to be set for the simple normalize filter.

The following elements may be set for this filter:

=over 4

=item *

normalize_factor # the normalization factor.

=back

e.g. $gramofile->init_simple_normalize_filter("normalize_factor" => 50);

=head2 filter_tracks

This method filters the tracks with the previously specified (or default) parameters.

e.g. $gramofile->filter_tracks;

=head2 NOTE

All methods whose names start with "init_" can be called with a hash (as documented) or by a list
of integers, given in the order of the documented hash keys. Any unused values must be assigned to undef.

e.g. $gramofile->init_cmf2_filter("rec_med_len" => 11, "fine_threshold" => 2500);

could be invoked via

$gramofile->init_cmf2_filter(undef, 11, undef, 2500, undef);

(However, this shortcut isn't documented..., and may be removed)

=head1 EXPORT

None by default.

=head1 SEE ALSO

Gramofile : available from http://panic.et.tudelft.nl/~costar/gramofile/

libgramofile : A dynamically linked library derived from Gramofile, which this
module needs, available from http://sourceforge.net/projects/libgramofile

fftw - the fastest Fourier Transform in the west : available from http://www.fftw.org

Signproc.txt, Tracksplit.txt, Tracksplit2.txt supplied with the Gramofile source code.

=head1 AUTHOR

Bob Wilkinson, E<lt>bob@fourtheye.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Bob Wilkinson

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = {};
  bless $self, $class;

  $self->_init;
  $self;
}

sub set_input_file {
  my $self = shift;
  my $file = shift;

  croak "Need an input file, $!" unless (defined $file);
  $self->{input_file} = $file;
}

sub set_output_file {
  my $self = shift;
  my $file = shift;

  croak "Need an output file, $!" unless (defined $file);
  $self->{output_file} = $file;
}

sub _init {
  my $self = shift;

  $self->init_tracksplit(1, 0, 4410, 150, 5, 20, 50, 3, 6);
  $self->init_filter_tracks([ 5 ]);
  $self->init_simple_median_filter(num_samples => 3);
  $self->init_double_median_filter(5, 5);
  $self->init_simple_mean_filter(3);
  $self->init_rms_filter(3);
  $self->init_cmf_filter(21, 9, 11, 5, 2500);
  $self->init_cmf2_filter(9, 11, 12, 2000, 8500);
  $self->init_cmf3_filter(9, 11, 12, 2000, 8500, 9);
  $self->init_simple_normalize_filter(0);
}

sub init_tracksplit {
  my $self = shift;

  my $make_use_rms;
  my $make_graphs;
  my $blocklen;
  my $global_silence_factor;
  my $local_silence_threshold;
  my $min_silence_blocks;
  my $min_track_blocks;
  my $extra_blocks_start;
  my $extra_blocks_end;

  if (_first_numeric($_[0])) {
    $make_use_rms = @_ ? shift : undef;
    $make_graphs = @_ ? shift : undef;
    $blocklen = @_ ? shift : undef;
    $global_silence_factor = @_ ? shift : undef;
    $local_silence_threshold = @_ ? shift : undef;
    $min_silence_blocks = @_ ? shift : undef;
    $min_track_blocks = @_ ? shift : undef;
    $extra_blocks_start = @_ ? shift : undef;
    $extra_blocks_end = @_ ? shift : undef;
  } else {
    my %hash = (@_);
    $make_use_rms = delete $hash{make_use_rms};
    $make_graphs = delete $hash{make_graphs};
    $blocklen = delete $hash{blocklen};
    $global_silence_factor = delete $hash{global_silence_factor};
    $local_silence_threshold = delete $hash{local_silence_factor};
    $min_silence_blocks = delete $hash{min_silence_factor};
    $min_track_blocks = delete $hash{min_track_blocks};
    $extra_blocks_start = delete $hash{extra_blocks_start};
    $extra_blocks_end = delete $hash{extra_blocks_end};
    croak "BAD ELEMENT in HASH" if %hash;
  }

  $self->{tracksplit}->{make_use_rms} = $make_use_rms if (defined $make_use_rms);
  $self->{tracksplit}->{make_graphs} = $make_graphs if (defined $make_graphs);
  $self->{tracksplit}->{blocklen} = $blocklen if (defined $blocklen);
  $self->{tracksplit}->{global_silence_factor} = $global_silence_factor if (defined $global_silence_factor);
  $self->{tracksplit}->{local_silence_threshold} = $local_silence_threshold if (defined $local_silence_threshold);
  $self->{tracksplit}->{min_silence_blocks} = $min_silence_blocks if (defined $min_silence_blocks);
  $self->{tracksplit}->{min_track_blocks} = $min_track_blocks if (defined $min_track_blocks);
  $self->{tracksplit}->{extra_blocks_start} = $extra_blocks_start if (defined $extra_blocks_start);
  $self->{tracksplit}->{extra_blocks_end} = $extra_blocks_end if (defined $extra_blocks_end);
  1;
}

sub init_filter_tracks {
  my $self = shift;

  my $filter_ptr = @_ ? shift : undef;
  return unless (defined $filter_ptr);

  unless (ref $filter_ptr) {
    my %filters_id = (
      simple_median_filter    => 1,
      simple_mean_filter      => 2,
      cond_median_filter      => 3,
      double_median_filter    => 4,
      cond_median2_filter     => 5,
      rms_filter              => 6,
      copyonly_filter         => 7,
      monoize_filter          => 8,
      cond_median3_filter     => 9,
      simple_normalize_filter => 10,
      experiment_filter       => 11,
    );
    my @name_list = ($filter_ptr, @_);
    my @num_list;
    foreach my $filter (@name_list) {
      croak "Invalid filter name, $filter, $!" unless (defined $filters_id{$filter});
      push @num_list, $filters_id{$filter};
    }
    $filter_ptr = \@num_list;
  }

  $self->{filter_num} = @$filter_ptr;
  $self->{filter_ptr} = $filter_ptr;
  1;
}

sub init_simple_median_filter {
  my $self = shift;

  my $num_samples;
  if (_first_numeric($_[0])) {
    $num_samples = @_ ? shift : undef;
  } else {
    my %hash = (@_);
    $num_samples = delete $hash{num_samples};
    croak "BAD ELEMENT in HASH" if %hash;
  }

  _odd_error_check("simple_median_num_samples", $num_samples);
  $self->{simple_median}->{num_samples} = $num_samples if (defined $num_samples);
  1;
}

sub init_double_median_filter {
  my $self = shift;

  my $first_num_samples;
  my $second_num_samples;
  if (_first_numeric($_[0])) {
    $first_num_samples = @_ ? shift : undef;
    $second_num_samples = @_ ? shift : undef;
  } else {
    my %hash = (@_);
    $first_num_samples = delete $hash{first_num_samples};
    $second_num_samples = delete $hash{second_num_samples};
    croak "BAD ELEMENT in HASH" if %hash;
  }

  _odd_error_check("double_median_first_num_samples", $first_num_samples);
  _odd_error_check("double_median_second_num_samples", $second_num_samples);

  $self->{double_median}->{first_num_samples} = $first_num_samples if (defined $first_num_samples);
  $self->{double_median}->{second_num_samples} = $second_num_samples if (defined $second_num_samples);
  1;
}

sub init_simple_mean_filter {
  my $self = shift;

  my $num_samples;
  if (_first_numeric($_[0])) {
    $num_samples = @_ ? shift : undef;
  } else {
    my %hash = (@_);
    $num_samples = delete $hash{num_samples};
    croak "BAD ELEMENT in HASH" if %hash;
  }

  _odd_error_check("simple_mean_num_samples", $num_samples);

  $self->{simple_mean}->{num_samples} = $num_samples if (defined $num_samples);
  1;
}

sub init_rms_filter {
  my $self = shift;

  my $num_samples;
  if (_first_numeric($_[0])) {
    $num_samples = @_ ? shift : undef;
  } else {
    my %hash = (@_);
    $num_samples = delete $hash{num_samples};
    croak "BAD ELEMENT in HASH" if %hash;
  }

  _odd_error_check("rms_filter_num_samples", $num_samples);

  $self->{rms}->{num_samples} = $num_samples if (defined $num_samples);
  1;
}

sub init_cmf_filter {
  my $self = shift;

  my $num_samples;
  my $rms_length;
  my $rec_med_len;
  my $rec_med_dec;
  my $tick_threshold;
  if (_first_numeric($_[0])) {
    $num_samples = @_ ? shift : undef;
    $rms_length = @_ ? shift : undef;
    $rec_med_len = @_ ? shift : undef;
    $rec_med_dec = @_ ? shift : undef;
    $tick_threshold = @_ ? shift : undef;
  } else {
    my %hash = (@_);
    $num_samples = delete $hash{num_samples};
    $rms_length = delete $hash{rms_length};
    $rec_med_len = delete $hash{rec_med_len};
    $rec_med_dec = delete $hash{rec_med_dec};
    $tick_threshold = delete $hash{tick_threshold};
    croak "BAD ELEMENT in HASH" if %hash;
  }

  _odd_error_check("cmf_median_tick_num_samples", $num_samples);
  _odd_error_check("cmf_rms_length", $rms_length);
  _odd_error_check("cmf_recursive_median_length", $rec_med_len);
  _error_check("cmf_decimation_factor", $rec_med_dec, 0);
  _error_check("cmf_tick_detection_threshold", $tick_threshold, 999);

  $self->{cmf}->{num_samples} = $num_samples if (defined $num_samples);
  $self->{cmf}->{rms_length} = $rms_length if (defined $rms_length);
  $self->{cmf}->{rec_med_len} = $rec_med_len if (defined $rec_med_len);
  $self->{cmf}->{rec_med_dec} = $rec_med_dec if (defined $rec_med_dec);
  $self->{cmf}->{tick_threshold} = $tick_threshold if (defined $tick_threshold);
  1;
}

sub init_cmf2_filter {
  my $self = shift;
  my $rms_length;
  my $rec_med_len;
  my $rec_med_dec;
  my $fine_threshold;
  my $tick_threshold;
  if (_first_numeric($_[0])) {
    $rms_length = @_ ? shift : undef;
    $rec_med_len = @_ ? shift : undef;
    $rec_med_dec = @_ ? shift : undef;
    $fine_threshold = @_ ? shift : undef;
    $tick_threshold = @_ ? shift : undef;
  } else {
    my %hash = (@_);
    $rms_length = delete $hash{rms_length};
    $rec_med_len = delete $hash{rec_med_len};
    $rec_med_dec = delete $hash{rec_med_dec};
    $fine_threshold = delete $hash{fine_threshold};
    $tick_threshold = delete $hash{tick_threshold};
    croak "BAD ELEMENT in HASH" if %hash;
  }

  _odd_error_check("cmf2_rms_length", $rms_length);
  _odd_error_check("cmf2_recursive_median_length", $rec_med_len);
  _error_check("cmf2_decimation_factor", $rec_med_dec, 0);
  _error_check("cmf2_tick_fine_threshold", $fine_threshold, 0);
  _error_check("cmf2_tick_detection_threshold", $tick_threshold, 999);

  $self->{cmf2}->{rms_length} = $rms_length if (defined $rms_length);
  $self->{cmf2}->{rec_med_len} = $rec_med_len if (defined $rec_med_len);
  $self->{cmf2}->{rec_med_dec} = $rec_med_dec if (defined $rec_med_dec);
  $self->{cmf2}->{fine_threshold} = $fine_threshold if (defined $fine_threshold);
  $self->{cmf2}->{tick_threshold} = $tick_threshold if (defined $tick_threshold);
  1;
}

sub init_cmf3_filter {
  my $self = shift;
  my $rms_length;
  my $rec_med_len;
  my $rec_med_dec;
  my $fine_threshold;
  my $tick_threshold;
  my $fft_length;
  if (_first_numeric($_[0])) {
    $rms_length = @_ ? shift : undef;
    $rec_med_len = @_ ? shift : undef;
    $rec_med_dec = @_ ? shift : undef;
    $fine_threshold = @_ ? shift : undef;
    $tick_threshold = @_ ? shift : undef;
    $fft_length = @_ ? shift : undef;
  } else {
    my %hash = (@_);
    $rms_length = delete $hash{rms_length};
    $rec_med_len = delete $hash{rec_med_len};
    $rec_med_dec = delete $hash{rec_med_dec};
    $fine_threshold = delete $hash{fine_threshold};
    $tick_threshold = delete $hash{tick_threshold};
    $fft_length = delete $hash{fft_length};
    croak "BAD ELEMENT in HASH" if %hash;
  }

  _odd_error_check("cmf3_rms_length", $rms_length);
  _odd_error_check("cmf3_recursive_median_length", $rec_med_len);
  _error_check("cmf3_decimation_factor", $rec_med_dec, 0);
  _error_check("cmf3_tick_fine_threshold", $fine_threshold, 0);
  _error_check("cmf3_tick_detection_threshold", $tick_threshold, 999);
  _error_check("cmf3_fft_length", $fft_length, 5, 13);

  $self->{cmf3}->{rms_length} = $rms_length if (defined $rms_length);
  $self->{cmf3}->{rec_med_len} = $rec_med_len if (defined $rec_med_len);
  $self->{cmf3}->{rec_med_dec} = $rec_med_dec if (defined $rec_med_dec);
  $self->{cmf3}->{fine_threshold} = $fine_threshold if (defined $fine_threshold);
  $self->{cmf3}->{tick_threshold} = $tick_threshold if (defined $tick_threshold);
  $self->{cmf3}->{fft_length} = $fft_length if (defined $fft_length);
  1;
}

sub init_simple_normalize_filter {
  my $self = shift;

  my $normalize_factor;
  if (_first_numeric($_[0])) {
    $normalize_factor = @_ ? shift : undef;
  } else {
    my %hash = (@_);
    $normalize_factor = delete $hash{normalize_factor};
    croak "BAD ELEMENT in HASH" if %hash;
  }

  _error_check("simple_normalize_factor", $normalize_factor, -1, 101);
  $self->{simple_normalize}->{normalize_factor} = $normalize_factor if (defined $normalize_factor);
  1;
}

sub split_to_tracks {
  my $self = shift;

  croak "Input .wav file needs to be set, $!" unless (defined $self->{input_file});

  Audio::Gramofile::tracksplit_main($self->{input_file},
                                    $self->{tracksplit}->{make_use_rms},
                                    $self->{tracksplit}->{make_graphs},
                                    $self->{tracksplit}->{blocklen},
                                    $self->{tracksplit}->{global_silence_factor},
                                    $self->{tracksplit}->{local_silence_threshold},
                                    $self->{tracksplit}->{min_silence_blocks},
                                    $self->{tracksplit}->{min_track_blocks},
                                    $self->{tracksplit}->{extra_blocks_start},
                                    $self->{tracksplit}->{extra_blocks_end})
}

sub filter_tracks {
  my $self = shift;

  croak "Input .wav file needs to be set, $!" unless (defined $self->{input_file});
  croak "Output .wav file needs to be set, $!" unless (defined $self->{output_file});
  croak "List of filters needs to be set, $!" unless (defined $self->{filter_ptr});

  my $simple_median_num_samples = $self->{simple_median}->{num_samples};
  my $double_median_init_params_ptr = [ $self->{double_median}->{first_num_samples},
                                        $self->{double_median}->{second_num_samples} ];
  my $simple_mean_num_samples = $self->{simple_mean}->{num_samples};
  my $rms_filter_num_samples = $self->{rms}->{num_samples};
  my $cmf_init_params_ptr = [ $self->{cmf}->{first_num_samples},
                              $self->{cmf}->{rms_length},
                              $self->{cmf}->{rec_med_len},
                              $self->{cmf}->{rec_med_dec},
                              $self->{cmf}->{tick_threshold} ];
  my $cmf2_init_params_ptr = [ $self->{cmf2}->{rms_length},
                               $self->{cmf2}->{rec_med_len},
                               $self->{cmf2}->{rec_med_dec},
                               $self->{cmf2}->{fine_threshold},
                               $self->{cmf2}->{tick_threshold} ];
  my $cmf3_init_params_ptr = [ $self->{cmf3}->{rms_length},
                               $self->{cmf3}->{rec_med_len},
                               $self->{cmf3}->{rec_med_dec},
                               $self->{cmf3}->{fine_threshold},
                               $self->{cmf3}->{tick_threshold},
			       $self->{cmf3}->{fft_length} ];
  my $simple_normalize_factor = $self->{simple_normalize}->{normalize_factor};

  Audio::Gramofile::signproc_main($self->{input_file},
                                  $self->{output_file},
                                  $self->{filter_num},
                                  $self->{filter_ptr},
                                  $simple_median_num_samples,
                                  $double_median_init_params_ptr,
                                  $simple_mean_num_samples,
                                  $rms_filter_num_samples,
                                  $cmf_init_params_ptr,
                                  $cmf2_init_params_ptr,
                                  $cmf3_init_params_ptr,
                                  $simple_normalize_factor);
}

sub _first_numeric {
  my $param = shift;
  return 1 unless (defined $param); # permits lists to have undef first element
  return $param =~ /^\d+$/;
}

sub _odd_error_check {
  my $name = shift;
  my $value = shift;

  return unless (defined $value);
  croak "Param $name (value is $value) needs to be odd and greater than 0"
    unless (($value > 0) and ($value % 2));
}

sub _error_check {
  my $name = shift;
  my $value = shift;
  my $min = shift;
  my $max = @_ ? shift : undef;

  return unless (defined $value);
  croak "Param $name (value is $value) needs to be greater than $min" unless ($value > $min);
  if (defined $max) {
    croak "Param $name (value is $value) needs to be less than $max" unless ($value < $max);
  }
}

1;
