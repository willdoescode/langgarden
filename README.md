# LangGarden

## The esolang you probably don't need

## Current moves
* { Add one to stack
* } Remove one from stack
* | Print the character value of current stack
* \> Print new line
* @ Start of loop (Note: loop will end when loop stack value is zero)
* \# End of loop
* [ Increase loop stack See [examples](https://github.com/willdoescode/langgarden/blob/main/examples/loop_example.garden) for loop example
* ] Decrease loop stack

## Small example
Getting to "a"
```
[[[[[[[[[[ @ {{{{{{{{{{ ] # }}} |
```
A is the 104th ascii character so using the loop stack and general stack you can quickly get there

## Things to note.
* Anything other than the correct characters will be skipped over as a comment
* There are two stacks, the loop stack, and the general stack
* Once a loop stack hits zero the loop will stop
* The value in the stack corresponds to the ascii character value

The loop stack is separate from the general stack