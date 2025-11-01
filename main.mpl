interface(prettyprint=0): #disable maple output formating

read "Modules/Matrix.mpl";

f := MyMatrix(Matrix([[1,2],[3,4],[5,6]])):
f;

f:-TransposeMe();
f;