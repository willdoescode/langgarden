# LangGarden

## The esolang you probably don't need

## Current moves
* { Increment general stack by one
* } Decrement general stack by one
* | Output ascii value of current general stack
* \> Output newline character
* @ Start of loop (Note: loop will end when loop stack value is zero)
* \# End of loop
* [ Increment loop stack by one. See [examples](https://github.com/willdoescode/langgarden/blob/main/examples/loop_example.garden) for loop example
* ] Decrement loop stack by one

## Small example
Getting to "a"
```
[[[[[[[[[[ @ {{{{{{{{{{ ] # }}} |
```
A is the 104th ascii character so using the loop stack and general stack you can quickly get there

### [Hello world example](https://github.com/willdoescode/langgarden/blob/main/examples/hello_world.garden)

## Things to note.
* Anything other than the correct characters will be skipped over as a comment
* There are two stacks, the loop stack, and the general stack
* Once the loop stack hits zero any currently running loop will stop
* The value in the stack corresponds to the ascii character value