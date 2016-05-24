# Hangman

The Odin Project : Ruby Programming : Intermediate Ruby

This is an implementation of the hangman game.  It does not draw a hangman, ASCII art gets too messy.  It does tell the player how many moves are left, and shows them any correct letters in their positions.

Number of guesses is the length of the secret plus a constant.  This stops the game getting too easy for short secrets, and gives margin for long secrets.

Game saving uses YAML.