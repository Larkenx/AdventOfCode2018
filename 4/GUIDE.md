# Perl 6 Crash Course
I struggled immensely with trying to understand the Perl 6 documentation. I feel that it's almost impossible for folks who aren't familiar with Perl to learn, and it fails to properly communicate some of the basic features of the language in a pleasant & easy to understand way. I did a crash course through the docs to finish a programming challenge for [Day 4 in Advent of Code 2018](https://adventofcode.com/2018/day/4). Here's my tips and tricks after staying up til 3AM to finish the advent challenge.

# Perl 6 Setup
You can find some good instructions on [setting up perl here](https://perl6intro.com/#_installing_perl_6).
> Be sure to add `#!/usr/bin/perl` and  `use v6;` to the top of your `.p6` or `.pl` file.

## Text Editor Recommendations
I don't recommend to go without some sort of syntax checker, or else you'll waste a lot of time. Perl 6's error messages are pretty poor and not descriptive. Check out the Atom text editor, and more specifically [Atom perl 6editor tools](https://atom.io/packages/atom-perl6-editor-tools) and [Script](https://atom.io/packages/script) for running the scripts.



## Semicolons are a thing
All statements need to need with a semi-colon like Java. This is difficult sometimes since Perl 6 has the expressiveness of languages that don't require semicolons,
so sometimes it's difficult to remember to place them. The error messages involving that will look like this below; however, the error message is inconsistent if you miss one before say a control/loop statement like a `for` or `if`. That's where the text editor syntax checker is really handy.
```
Two terms in a row across lines (missing semicolon or comma?)
```
```
Unexpected block in infix position (missing statement control word before the expression?)
```

## Printing stuff
You can print with the `say` keyword. Here's Hello World:
```perl6
say 'Hello world';
```

## Symbols or Sigils (and Twigils?) in Perl 6
I didn't have enough to read too much about sigils, but whenever you are defining
new variables, there are some built-in symbols / sigils into the language that
define special variables or perform operations.

From the [Perl 6 docs](https://docs.perl6.org/language/glossary#Sigil):

> In Perl, the sigil is the first character of a variable name. It must be either $, @, %, or & respectively for a scalar, array, hash, or code variable. See also Twigil and role. Also sigiled variables allow short conventions for variable interpolation in a double quoted string, or even postcircumfix expressions starting with such a variable.

## Defining variables
You can define new variables that are dynamically typed by using the [`my`](https://docs.perl6.org/syntax/my) declarator and the `$` symbol before the variable name.
```perl6
my $string = 'Hello world';
my $number = 123;
```
You can then reference that variable by `$yourVariableName`. You can re-assign the variable by doing `$yourVariableName = 'anything else'`;

## Calling methods of primitive types, classes or objects
If you need to call a function on a base primitive type like an `int` or `str`, there are a surprising number of ways you can do this in Perl 6 syntax. You can use whichever one you prefer or mix and match to your pleasure. You can call methods with a more traditional, C-like syntax using the `.` method call operator, `foo.myfunction(arg1, arg2)`.  
```perl6
my $abcs = 'abcdefghikjklmonpqrstuvxy';
say $abcs.contains('z'); # False
say $abcs.contains('a'); # True
```
Alternatively, you can use the [`:` operator](https://docs.perl6.org/routine/:), which allows you to do some kind of magic where you transform a function call into a method call. So you can start off with the function name you want to call, say `contains`, but specify what actual string or object you want contains to be called on (carried out as a method call). The docs have a good example:
> Used as an argument separator just like infix , and marks the argument to its left as the invocant. That turns what would otherwise be a function call into a method call.
```perl6
substr('abc': 1);       # same as 'abc'.substr(1)
```

Lastly, you can use the `:` operator in a different context; to "stream" arguments into a method. It does not use the `:` in the *routine* context that is seen above (*The `..` operator is used to create a range or sequence of numbers from a to b.*).
```perl6
'abc'.contains: 'a'; # True
'abcdef'.substr: 1..3; # Gets the characters from index 1 to 3 -> 'bcd'
```

For fun, here's a code block where we use all 3 of kinds of method calls at the same time. We take the string `abcdef`, grab the characters from index 1 to 3, reverse it, then check to see if the result contains the string 'dcb'.
```perl6
my $abcs = 'abcdef';
contains(($abcs.substr: 1..3).flip(): 'dcb') # True
```
## If statements
If statements are quite similar to what you'd see in most languages. Use the `if` keyword with an expression following it, and curly braces wrapping around the code you want to execute.
```perl6
if 'abc'.contains('a') {
  say 'I know my abcs';
}
```
In Perl 6, there are number of operators defined for equality checking. `==` is used for numeric value comparison, and `eq` for string and other value comparison. See [all of the operators here](https://docs.perl6.org/language/operators#TOC_Title).

You can also define `elsif` statements as well.
```perl6
my $love = 'everlasting';
if $love ne 'everlasting' {
  say ':('
} elsif $love eq 'everlasting' {
  say ':)'
}
```

## Defining arrays and working with them
You can define a new [array](https://docs.perl6.org/type/Array) in the same way as defining a variable, but with the `@` sigil instead of the `$`. To assign some initial values, you create a comma separated list of values surrounded by parens, e.g `(1, 2, 3,4)` or `('a', 'b', 'c', 'd')`.
```perl6
my @a;
my @b = (1, 2, 3, 4);
```
You can add new elements with `push`.
```perl6
my @arr = (1, 2, 3, 4);
@arr.push(5);
say @arr;
# [1,2,3,4 5]
```
You can remove elements with [`splice`](https://docs.perl6.org/type/Array#routine_splice), which seems to behave a lot like a JavaScript splice.
```perl6
my @foo = (a b c d e f g);
say @foo.splice(0, 1);        # Returns removed elements -> [a]
say @foo;                     # -> [b, c, d, e, f, g]
```

## Looping over arrays
Probably one of my (few) favorite things about the language is how we can iterate over stuff. I did not get the opportunity to use a whole lot of built-in operators like `map` or `reduce` (*I was too frustrated to attempt to use them.*).

You can iterate over an `iterable` object like a `list` or `array` with the `for` keyword (acts as a `foreach`). You can then add a `->` operator followed by a variable name, which will define the element you're looping over.
```perl6
my @numbers = (1, 2, 3, 4);
for @numbers -> $number {
  say $number;
}
```
For iterating over the array more traditionally, you can use a range

## Hashmaps
Like with arrays, you can define a new hashmap with the `%` operator. You can then set and retrieve values in your hashmap by accessing it with curly braces. You can initialize a hashmap by setting it equal to a list of `key => value` pairs.
```perl6
my %days = (Monday => 1, Tuesday => 2, Wednesday => 3, Thursday => 4, Friday => "I'm in love");
%days{'Monday'} = 2;
%days{'Monday'}++;
say %days{'Friday'}; # I'm in love
```
You can get iterate over hashmaps in a few ways.You can get all of the keys of a hashmap with `%myHashMap<>:k`, or values with `%myHashMap<>:k`, and finally key-value pairs with `%myHashMap<>:kv`. Here's an example of iterating over the entire hashmap's keys and updating value.
```perl6
my %days = (Monday => 1, Tuesday => 2, Wednesday => 3, Thursday => 4, Friday => "I'm in love");
for %days<>:k -> $day {
  if $day eq 'Friday' { # Take the key and see if it's equal to Friday
    say %days{$day}
  }
}
# I'm in love
```

## Regular Expressions - The best thing about Perl 6
Perl 6's regular expression support is its major feature, as it supports a basic feature set of regular expressions in other languages like named capture groups. The regular expression documentation is decent with a lot of examples, [see here](https://docs.perl6.org/language/regexes#index-entry-Regular_Expressions).

### Condensed Regexp Guide
Regular expressions are created much like in other languages by placing regexp literals, wildcards, and character classes between two slashes, `/ regular expression goes here /`. Given any `str` in perl, you can *apply* a regular expression by using the [`~~`](https://docs.perl6.org/routine/~~) operator.
> The `~` operator is string concatenation, and often used to convert other variables to strings, (e.g `~1 eq '1'`);

Here's an example of checking to see if a string matches a regular expression:
```perl6
my $favoriteFood = 'cheese';
if $favoriteFood ~~ /(cheese|chocolate|hotdogs)/ { say 'me too'!; }
```

We can also create capture groups with names which is very useful for parsing complex data and assigning names to the elements in the input. In this example, we're going to also take advantage of Perl6's feature that whitespace isn't accounted for in regexps, so we can break the regexp over multiple lines.
```perl6
my $time = '[2018-12-21 23:59:59]';
if $time ~~
  /
    . # Left bracket [
    $<years>=[\d+] '-' # yyyy
    $<months>=[\d+] '-' # mm
    $<days>=[\d+] ' ' # dd
    $<hours>=[\d+] ':' # hh
    $<minute>=[\d+] ':' #mm
    $<seconds>=[\d+]  #ss
    .* # Right Bracket ]
  / {
    my $today = ~$<days>; # Get the string value of the named days captured group
    my $suffix = 'th';
    if $today ~~ /1|\d1/ {
      $suffix = 'st';
    } elsif $today ~~ /2|\d2/ {
      $suffix = 'nd';
    } elsif $today ~~ /3|\d3/ {
      $suffix = 'rd';
    }
    say 'Today is the ' ~ ~($today.Int) ~ $suffix ~ '.';
}
```
