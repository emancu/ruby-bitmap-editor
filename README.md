# Bitmap editor

Simulates a basic interactive bitmap editor.
Bitmaps are represented as an M x N matrix of pixels with each element representing a colour.


## Program input
The input consists of a file containing a sequence of commands, where a command
is represented by a single capital letter at the beginning of the line.
Parameters of the command are separated by white spaces and they follow the command character.
Pixel co-ordinates are a pair of integers: a column number between 1 and 250,
and a row number between 1 and 250. Bitmaps starts at coordinates 1,1.
Colours are specified by capital letters.


## Commands
There are 7 supported commands:
1. I M N - Create a new M x N image with all pixels coloured white (O).
2. C - Clears the table, setting all pixels to white (O).
3. L X Y C - Colours the pixel (X,Y) with colour C.
4. V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
5. H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
6. S - Show the contents of the current image
7. F X Y C - Fill an area adjacent to the pixel (X,Y) with colour C.


## Example
To run the application you must supply a command file like so `bin/bitmap_editor examples/show.txt`

### Input File

    I 5 6
    L 1 3 A
    V 2 3 6 W
    H 3 5 2 Z
    S


### Expected Output:

    OOOOO
    OOZZZ
    AWOOO
    OWOOO
    OWOOO
    OWOOO
