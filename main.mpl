interface(prettyprint=0): #disable special output formating

read "Modules/Matrix.mpl";
read "Modules/MyTime.mpl";

t := MyTime(12,59,1):
t;
t:-WhatLesson();
t:-TimeSinceMidnight();

# f := MyMatrix("1 2 3\n4 5 6"):
# b := MyMatrix(Matrix([[1,2],[2,3]])):
# g := MyMatrix([[1,2],[2,3],[5,7],[7,0]]):
# f;
# b;
# g;

# f:-TransposeMe();
# f;

# for i from 1 to f:-GetHeight() do
#     for j from 1 to f:-GetWidth() do
#         f[i,j] := f[i,j]+1;
#     end;
# end;

# read "Tests/MatrixTests.mpl";
# AutoTestDeterminant([-100, 100], [1, 6], 3);
# AutoTestTranspose([-100, 100], [1, 10], 3);