interface(prettyprint=0): #disable special output formating

read "Modules/Matrix.mpl";
read "Modules/MyTime.mpl";
read "Tests/MatrixTests.mpl";
read "Tests/MyTimeTests.mpl";

#------MyTime smol demo----------

# constructors demo
t := MyTime(120):
k := MyTime(15,59,1):

# print demo
t;
k;

# some funcs demo
t:-WhatLesson();
k:-TimeSinceMidnight();

a := t - k:
a;
a := t + k:
a;



#------MyMatrix smol demo--------

# constructors demo
f := MyMatrix("1 2 3\n4 5 6"):
b := MyMatrix(Matrix([[1,2],[2,3]])):
g := MyMatrix([[1,2],[2,3],[5,7],[7,0]]):

# print demo
f;
b;
g;

# transpose demo
f:-TransposeMe();
f;

# indexer demo
for i from 1 to f:-GetHeight() do
    for j from 1 to f:-GetWidth() do
        f[i,j] := f[i,j]+1;
    end;
end;

#------Tests-------------------

# Matrix Auto Tests
t1 := Threads:-Create(AutoTestMatrixMultiply([-100, 100], [1, 30], 5, true)):
t2 := Threads:-Create(AutoTestMatrixAdd([-100, 100], [1, 60], 5, true)):
t3 := Threads:-Create(AutoTestDeterminant([-100, 100], [1, 6], 3, true)):
t4 := Threads:-Create(AutoTestTranspose([-100, 100], [1, 10], 3, true)):

# MyTime Auto Tests
t5 := Threads:-Create(AutoTestCopy(10, true)):
t6 := Threads:-Create(AutoTestTimeAdd(50, true)):
t7 := Threads:-Create(AutoTestTimeMinus(50, true)):

Threads:-Wait(t1, t2, t3, t4, t5, t6, t7);
