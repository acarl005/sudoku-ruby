# Sudoku 2 Guessing

##Learning Competencies

* Model a simple real-world procedure in Ruby.
* Use Psuedocode to model

##Summary

Starting with your attempt from the [previous iteration of the Sudoku solver](https://socrates.devbootcamp.com//challenges/75), we now want to add the ability to make guessing.

What happens if a square can contain multiple possible numbers and you don't have enough information to conclude right then and there which number it is?

Most people who play Sudoku "guess," usually by writing possibilities in the corners of the square.

##Releases

###Release 0 : Implement a guessing-friendly version of Sudoku

Once we've filled in all cells which have only one possible value, we have to guess.  Write out pseudocode for how that might work before you dive in!

This solver should now be able to solve any Sudoku puzzle, although some will take a long time.  Try it with the `sample.unsolved.txt` file in the source folder.

### Release 1: Try your luck

The `source` folder of this repo includes 4 puzzle sets:

- set-01_sample.unsolved
- set-02_project_euler_50-easy-puzzles
- set-02_project_euler_50-easy-puzzles
- set-04_peter-norvig_11-hardest-puzzles

If you haven't yet tried your hand at the harder puzzles, run your solver against them to see what happens.

Can your solver solve the hardest puzzles?

How long does it take to solve one puzzle?

How long does it take to solve all the puzzles in a set?

### Release 2: Compete to win

Here are the [results of a solver](http://norvig.com/sudoku.html) created by [Peter Norvig](http://en.wikipedia.org/wiki/Peter_Norvig)

```text
Solved 50 of 50 easy puzzles (avg 0.01 secs (86 Hz), max 0.03 secs).
Solved 95 of 95 hard puzzles (avg 0.04 secs (24 Hz), max 0.18 secs).
Solved 11 of 11 hardest puzzles (avg 0.01 secs (71 Hz), max 0.02 secs).
```

Can your solver beat his?

You should [check out his solution](http://norvig.com/sudopy.shtml) and see what you might learn from it.  Get ready to read some Python!

