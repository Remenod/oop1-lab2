interface(prettyprint=0): #disable maple output formating

read "Modules/Matrix.mpl";

f := MyMatrix(Matrix([[1,2],[3,4],[5,6]])):
f;

f:-TransposeMe();
f;

for i from 1 to f:-GetHeight() do
    for j from 1 to f:-GetWidth() do
        f[i,j] := f[i,j]+1;
    end;
end;

read "Tests/MatrixTests.mpl";
AutoTestDeterminant([-100, 100], [1, 6], 3);
AutoTestTranspose([-100, 100], [1, 10], 3);