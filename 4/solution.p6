#!/usr/bin/perl
use v6;
use strict;
my $file = open "input.txt", :r;
# year-month-day hour:minute
# first, just put all of the input as data into an array of
class GuardEvent {
    has DateTime $.date;
    has str $.year;
    has str $.month;
    has str $.day;
    has str $.hour;
    has str $.minute;
    has str $.description;
}

# Array of guard events
my @guardEvents;
my %guardMinutesSleeping = Hash.new();
for $file.lines -> $line {
    next unless $line;
    # [1518-10-31 00:58] wakes up
    if $line ~~ /
    . # [
      $<year>=[\d+] '-'
      $<month>=[\d+] '-'
      $<day>=[\d+] ' '
      $<hour>=[\d+] ':'
      $<minute>=[\d+]
    . #]
    $<description>=[.*]
    / {
        @guardEvents.push: GuardEvent.new(
            date => DateTime.new((~$<year>,~$<month>, ~$<day>).join('-') ~ 'T' ~ (~$<hour>, ~$<minute>, '00Z').join(':')),
            year => ~$<year>,
            month => ~$<month>,
            day => ~$<day>,
            hour => ~$<hour>,
            minute => ~$<minute>,
            description => ~$<description>
        );

        # Initialize guard hashmap as we get them
        if ~$<description> ~~ /$<id>=['#'\d+]/ {
          my $guardId = ~$<id>;
          if ! %guardMinutesSleeping{$guardId} {
            my %minutesHistogram;
            for 0..59 -> $minute { %minutesHistogram{$minute} = 0}
            %guardMinutesSleeping{$guardId} = %minutesHistogram;
          }
        }
    }
}
@guardEvents = @guardEvents.sort: { $^a.date.Instant <=> $^b.date.Instant};
# Hash of guard id -> minutes sleeping
my $fellAsleepAt = 0;
my $guardId = '';
for @guardEvents -> $event {
  if $event.description ~~ /$<id>=['#'\d+]/ {
    $guardId = ~$<id>;
  } elsif $event.description ~~ /'falls asleep'/ {
    $fellAsleepAt = $event.minute.Int;
  } elsif $event.description ~~ /'wakes up'/ {
    for $fellAsleepAt..^$event.minute.Int -> $minute {
      %guardMinutesSleeping{$guardId}{$minute}++;
    }
  }
}

my $sleepiestGuard = '';
my $sleepiestGlobalMinute = 0;
my $mostMinutesSleptByGuard = 0;
# for each guard
for %guardMinutesSleeping<>:k -> $id {
  # start with a zero zum & sleepiest minute has no minutes
  my $totalGuardMinutesSleeping = 0;
  my $mostMinutesSoFar = 0;
  my $sleepiestMinute = 0;
  my %minutesHistogram = %guardMinutesSleeping{$id};
  # for each minute, 0..59
  for %minutesHistogram<>:k -> $minute {
    my $totalMinutesAtThisTime = %minutesHistogram{$minute};
    $totalGuardMinutesSleeping += $totalMinutesAtThisTime;
    if $totalMinutesAtThisTime > $mostMinutesSoFar {
      $mostMinutesSoFar = $totalMinutesAtThisTime;
      $sleepiestMinute  = $minute;
    }
  }
  if $totalGuardMinutesSleeping > $mostMinutesSleptByGuard {
    $mostMinutesSleptByGuard = $totalGuardMinutesSleeping;
    $sleepiestGuard = $id;
    $sleepiestGlobalMinute = $sleepiestMinute;
  }
}

say 'The sleepiest guard is ' ~ $sleepiestGuard;
say 'He has slept a total of ' ~ $mostMinutesSleptByGuard;
say 'His sleepiest minute was ' ~ $sleepiestGlobalMinute;

my $highestConsistentMinuteAmt = 0;
my $partbid = '';
my $partbminute = 0;
for %guardMinutesSleeping<>:k -> $id {
  # start with a zero zum & sleepiest minute has no minutes
  my $sleepiestMinute = 0;
  my $highestFrequency = 0;
  my %minutesHistogram = %guardMinutesSleeping{$id};
  # for each minute, 0..59
  for %minutesHistogram<>:k -> $minute {
    my $totalMinutesAtThisTime = %minutesHistogram{$minute};
    if $totalMinutesAtThisTime > $highestFrequency {
      $highestFrequency = $totalMinutesAtThisTime;
      $sleepiestMinute  = $minute;
    }
  }
  if $highestFrequency > $highestConsistentMinuteAmt {
    $highestConsistentMinuteAmt = $highestFrequency;
    $partbid = $id;
    $partbminute = $sleepiestMinute;
  }
}
say $partbid ~ '*' ~ $partbminute;

$file.close;
