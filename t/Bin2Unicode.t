#!/usr/bin/env perl

use Test::More;
use DDG::Test::Goodie;

use utf8;
use strict;
use warnings;

zci answer_type => 'bin2unicode';
zci is_cached   => 1;

sub gen_struc_ans {
    my ($in, $bin, $str, $asc) = @_;

    return "Binary '$bin' converted to " . $asc ? 'ascii' : 'unicode' . " is '$str'",,
        structured_answer => {
            data => {
              title => $str,
              subtitle => "Input: $in",
            },

            templates => {
                group => 'text',
                moreAt => 0
            }
        };
}

my %ctrl_tests;
for (1..32, 127..159){
    my $b = sprintf '%08b', $_;
	$ctrl_tests{join ' ', $b, $b} = undef;
}

ddg_goodie_test(
    [qw( DDG::Goodie::Bin2Unicode )],
    '0110100001100101011011000110110001101111 to text' => test_zci(gen_struc_ans(
        '0110100001100101011011000110110001101111 to text',
        '0110100001100101011011000110110001101111',
        'hello',
        1)),
    '0000000111110111 to unicode' => test_zci(gen_struc_ans(
        '0000000111110111 to unicode',
        '0000000111110111',
        'Ƿ',
        0)),
    '1111010000001010 to text' => test_zci(gen_struc_ans(
        '1111010000001010 to text',
        '1111010000001010',
        '',
        0)),
    '01001101 01110101 01100011 01101000 01100001 01110011 00100000 01000111 01110010 01100001 01100011 01101001 01100001 01110011 00100000 01000011 01101111 01101101 01110000 01100001 01110011 0100110111110000'
        => test_zci(gen_struc_ans(
        '01001101 01110101 01100011 01101000 01100001 01110011 00100000 01000111 01110010 01100001 01100011 01101001 01100001 01110011 00100000 01000011 01101111 01101101 01110000 01100001 01110011 0100110111110000',
        '01001101 01110101 01100011 01101000 01100001 01110011 00100000 01000111 01110010 01100001 01100011 01101001 01100001 01110011 00100000 01000011 01101111 01101101 01110000 01100001 01110011 0100110111110000',
        'M u c h a s   G r a c i a s   C o m p a s ䷰',
        0)),
    '0100110101110101011000110110100001100001011100110010000001000111011100100110000101100011011010010110000101110011001000000100001101101111011011010111000001100001011100110100110111110000'
        => test_zci(gen_struc_ans(
        '0100110101110101011000110110100001100001011100110010000001000111011100100110000101100011011010010110000101110011001000000100001101101111011011010111000001100001011100110100110111110000',
        '0100110101110101011000110110100001100001011100110010000001000111011100100110000101100011011010010110000101110011001000000100001101101111011011010111000001100001011100110100110111110000',
        'Muchas Gracias CompasMð',
        1)),
    '00000000' => test_zci(gen_struc_ans(
        '00000000',
        '00000000',
        'Control character: Null character (NUL)',
        0)),
    '000000000000000000100000' => test_zci(gen_struc_ans(
        '000000000000000000100000',
        '000000000000000000100000',
        'Space (SP)',
        0)),
    '010101' => undef,
    '201 to text' => undef,
    %ctrl_tests
);

done_testing;
