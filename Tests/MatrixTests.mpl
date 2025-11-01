with(LinearAlgebra):

RandMatrix := proc(n::posint, valRange::list, $)
    local i, j, randInt;
    randInt := rand(valRange[1]..valRange[2]);
    return Matrix(n, n, (i,j) -> randInt());
end;

MatricesEqual := proc(A::Matrix, B::Matrix)
    local i,j;
    if RowDimension(A) <> RowDimension(B) or ColumnDimension(A) <> ColumnDimension(B) then
        return false;
    end;
    for i from 1 to RowDimension(A) do
        for j from 1 to ColumnDimension(A) do
            if A[i,j] <> B[i,j] then
                return false;
            end;
        end;
    end;
    return true;
end:


TestDeterminant := proc(mat::Matrix)
    local myDet, libDet, myMat;
    myMat := MyMatrix(mat);
    printf("\n");
    print(myMat);
    myDet := myMat:-CalcDeterminant();
    libDet := Determinant(mat);
    
    print(cat("MyMatrix: ", myDet));
    print(cat("Maple Lib: ", libDet));
    
    if evalb(myDet = libDet) then
        print("Test passed");
        return true;
    else
        print("!!!!!TEST FAILED!!!!!");
        return false;
    end;
end;

AutoTestDeterminant := proc(valRange::list, matricesSize::list, eachSizeTest::numeric, $)
    local i, j, passedTestsests;
    passedTests := 0;
    for i from matricesSize[1] to matricesSize[2] do
        printf("\nN: %d", i);
        for j from 1 to eachSizeTest do
            if TestDeterminant(RandMatrix(i, valRange)) then 
                passedTests := passedTests + 1;  
            end;
        end;
    end;
    printf("%d/%d tests are passed\n", passedTests, (matricesSize[2]-matricesSize[1]+1)*eachSizeTest);
end;

TestTranspose := proc(mat::Matrix)
    local myTrs, libTrs, myMat;
    myMat := MyMatrix(mat);
    printf("\n");
    print(myMat);
    myTrs := myMat:-GetTransposedCopy():-GetData();
    libTrs := Transpose(mat);
    
    print(cat("MyMatrix: ", myTrs));
    print(cat("Maple Lib: ", libTrs));
    
    if MatricesEqual(myTrs, libTrs) then
        print("Test passed");
        return true;
    else
        print("!!!!!TEST FAILED!!!!!");
        return false;
    end;
end;

AutoTestTranspose := proc(valRange::list, matricesSize::list, eachSizeTest::numeric, $)
    local i, j, passedTestsests;
    passedTests := 0;
    for i from matricesSize[1] to matricesSize[2] do
        printf("\nN: %d", i);
        for j from 1 to eachSizeTest do
            if TestTranspose(RandMatrix(i, valRange)) then
                passedTests := passedTests + 1;  
            end;
        end;
    end;
    printf("%d/%d tests are passed\n", passedTests, (matricesSize[2]-matricesSize[1]+1)*eachSizeTest);
end;