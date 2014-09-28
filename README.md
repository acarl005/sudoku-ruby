# Sudoku 2 Guessing

##Learning Competencies

* Model a simple real-world system in Ruby code
* Use Pseudocode effectively to model problem-solving
* Practice single responsibility of methods
* Practice effective naming of variables and methods

##Summary

More advanced Sudoku games can't be solved with the simple logic we used in Sudoku 1.  It's time to upgrade your solver and tackle more complex boards.

Most people who attempt Sudoku games of intermediate or expert difficulty usually write potential possibilities in the corners of the current cell and investigate how a plugging in a value would play out in the game.  Other Sudoku players use additional techniques to employ more than just the row, column, and box to narrow possibilities.

In this challenge, the goal is to strengthen your algorithm to include guessing or more elaborate techniques.


##Releases

### Release 0 :  More Advanced Logic

**Improve your Sudoku solver to solve the next five puzzles.**

Puzzles 6 - 10 from `set-01_sudoku_puzzles.txt` can be solved using logic alone but require more than just identifying when a square has only one possible value.  

The `Sudoku#solve` method should still give up if it gets stuck.


### Release 1:  Eduated Guessing

**Improve your Sudoku solver to solve all of the puzzles.**

Sooner or later, some Sudoku games require a form of guessing to solve the board successfully.  Write out pseudocode for how that might work before you dive in!

Use the Puzzles 11 - 15 from `set-01_sudoku_puzzles.txt` to test your algorithm. 

#### Choose your path: 

1) Use your existing algorithm to solve as many cells of your board using logic, and then let your new guessing alorithm take over.  This may make your algorithm faster for boards containing cells with one possible value.

2) Start from scratch and code a new solution that applies guessing from the beginning. If your Sudoku 1 code was written with single responsibility and great naming, you'll be able to leverage many of your existing methods. 


### Release 2: Benchmarking and competing to win 

The `source` folder of this repo includes 3 more puzzle sets:

- set-02_project_euler_50-easy-puzzles
- set-03_peter-norvig_95-hard-puzzles
- set-04_peter-norvig_11-hardest-puzzles

Run your solver against them to see what happens.

Here are the [results of a solver](http://norvig.com/sudoku.html) created by [Peter Norvig](http://en.wikipedia.org/wiki/Peter_Norvig)

```text
Solved 50 of 50 easy puzzles (avg 0.01 secs (86 Hz), max 0.03 secs).
Solved 95 of 95 hard puzzles (avg 0.04 secs (24 Hz), max 0.18 secs).
Solved 11 of 11 hardest puzzles (avg 0.01 secs (71 Hz), max 0.02 secs).
```

Can your solver beat his?

You should [check out his solution](http://norvig.com/sudopy.shtml) and see what you might learn from it.  Get ready to read some Python!


#### Profiling your code

If you're curious, you might want to see how long it takes for each line of code in your solver to run.

One tool you might use to do this is [rblineprof](https://github.com/tmm1/rblineprof).  There are lots of ways to profile your code.

After profiling, did you learn anything about how your solver works to improve its overall performance?
