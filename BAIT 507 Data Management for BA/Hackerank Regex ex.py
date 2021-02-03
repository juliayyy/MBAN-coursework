# Regex Homework
import re
## Q1. Matching Specific String
## https://www.hackerrank.com/challenges/matching-specific-string/problem
Regex_Pattern = r'hackerrank'

## Q2. Matching Digits & Non-Digit Characters
https://www.hackerrank.com/challenges/matching-digits-non-digit-character/problem
\d
Regex_Pattern = r"\d\d\D\d\d\D\d\d\d\d"
import re

## Q3. Matching Whitespace & Non-Whitespace Character
## https://www.hackerrank.com/challenges/matching-whitespace-non-whitespace-character/problem
\s
Regex_Pattern = r"\S\S\s\S\S\s\S\S"
import re

## Q4. Matching Word & Non-Word Character
## https://www.hackerrank.com/challenges/matching-word-non-word/problem
\w
Regex_Pattern = r"\w\w\w\W\w\w\w\w\w\w\w\w\w\w\W\w\w\w"	# Do not delete 'r'.
Regex_Pattern = \w{3}\W\w{10}\W\w{3}
import re

## Q5. Matching Start & End
## https://www.hackerrank.com/challenges/matching-start-end/problem
^, $, .
Regex_Pattern = r"^\d\w\w\w\w\.$"	# Do not delete 'r'.
Regex_Pattern = ^\d\w{4}\.$

## Q6. Matching Specific Characters
## https://www.hackerrank.com/challenges/matching-specific-characters/problem
[]
Regex_Pattern = r'^[123][120][xs0][30Aa][xsu][.,]$'

## Q7. Excluding Specific Characters
## https://www.hackerrank.com/challenges/excluding-specific-characters/problem
[^]
Regex_Pattern = r'^\D[^aeiou][^bcDF]\S[^AEIOU][^,.]$'	# Do not delete 'r'.

## Q8. Matching Character Ranges
## https://www.hackerrank.com/challenges/matching-range-of-characters/problem
[a-z]
Regex_Pattern = r'^[a-z][1-9][^a-z][^A-Z][A-Z]'	# Do not delete 'r'.

## Q9. Matching {x} Repetitions
## https://www.hackerrank.com/challenges/matching-x-repetitions/problem
{x}
Regex_Pattern = r'^[a-zA-Z02468]{40}[13579\s]{5}$'

## Q10. Matching {x, y} Repetitions
## https://www.hackerrank.com/challenges/matching-x-y-repetitions/problem
{x,y}
Regex_Pattern = r'^\d{1,2}[A-Za-z]{3,}[.]{0,3}$'

## Q11. Matching Zero Or More Repetitions
## https://www.hackerrank.com/challenges/matching-zero-or-more-repetitions/problem
## *: The * tool will match zero or more repetitions of character/character class/group.
Regex_Pattern = r'^\d{2,}[a-z]*[A-Z]*$'


## Q12. Matching One Or More Repetitions
## https://www.hackerrank.com/challenges/matching-one-or-more-repititions/problem
## +: The + tool will match one or more repetitions of character/character class/group.
Regex_Pattern = r'^\d+[A-Z]+[a-z]+$'

## Q13. Matching Ending Items
## https://www.hackerrank.com/challenges/matching-ending-items/problem
## $: The $ boundary matcher matches an occurrence of a character/character class/group at the end of a line.
Regex_Pattern = r'^[a-zA-Z]*s$'


## Q14. Capturing & Non-Capturing Groups
## https://www.hackerrank.com/challenges/capturing-non-capturing-groups/problem
* We did not cover non-capturing group in class. But this problem can be solved with capturing group that we did cover in class.
* Essentially, non-capturing groups are like capturing groups, except that you cannot back-reference them using "\1" etc.
## () Parenthesis ( ) around a regular expression can group that part of regex together. This allows us to apply different quantifiers to that group.
## (?: ) can be used to create a non-capturing group. It is useful if we do not need the group to capture its match.
Regex_Pattern = r'(ok){3,}'


## Q15. Alternative Matching
## https://www.hackerrank.com/challenges/alternative-matching/problem
## (|):Alternations, denoted by the | character, match a single item out of several possible items separated by
# the vertical bar. When used inside a character class, it will match characters; when used inside a group,
# it will match entire expressions (i.e., everything to the left or everything to the right of the vertical bar).
# We must use parentheses to limit the use of alternations.
Regex_Pattern = r'^(Mrs?|Ms|Dr|Er)\.[a-zA-Z]+$'


## Q16. Matching Same Text Again & Again
## https://www.hackerrank.com/challenges/matching-same-text-again-again/problem
## \group_number This tool (\1 references the first capturing group) matches the same text as previously matched by the capturing group.
Regex_Pattern = r'^([a-z]\w\s\W\d\D[A-Z][a-zA-Z][aeiouAEIOU]\S)\1$'
