with(LinearAlgebra):

RandMatrix := proc(n::posint, valRange::list, $)
    local i, j, randInt;
    randInt := rand(valRange[1]..valRange[2]);
    return Matrix(n, n, (i,j) -> randInt());
end:

MatricesEqual := proc(A::Matrix, B::Matrix, $)
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


TestDeterminant := proc(mat::Matrix, silent::boolean, $)
    local myDet, libDet, myMat;
    myMat := MyMatrix(mat);
    if not silent then
        printf("\n");
        print(myMat);
    end;
    myDet := myMat:-CalcDeterminant();
    libDet := Determinant(mat);
    if not silent then
        print(cat("MyMatrix: ", myDet));
        print(cat("Maple Lib: ", libDet));
    end;
    
    if evalb(myDet = libDet) then
        if not silent then
            print("Test passed");
        end;
        return true;
    else
        print("!!!!!TEST FAILED!!!!!");
        return false;
    end;
end:

AutoTestDeterminant := proc(valRange::list, matricesSize::list, eachSizeTest::numeric, silent::boolean, $)
    local i, j, passedTestsests;
    passedTests := 0;
    for i from matricesSize[1] to matricesSize[2] do
        if not silent then
            printf("\nN: %d", i);
        end;
        for j from 1 to eachSizeTest do
            if TestDeterminant(RandMatrix(i, valRange), silent) then 
                passedTests := passedTests + 1;  
            end;
        end;
    end;
    printf("%d/%d tests are passed\n", passedTests, (matricesSize[2]-matricesSize[1]+1)*eachSizeTest);
end:

TestTranspose := proc(mat::Matrix, silent::boolean, $)
    local myTrs, libTrs, myMat;
    myMat := MyMatrix(mat);
    if not silent then
        printf("\n");
        print(myMat);
    end;
    myTrs := myMat:-GetTransposedCopy():-GetData();
    libTrs := Transpose(mat);
    if not silent then
        print(cat("MyMatrix: ", myTrs));
        print(cat("Maple Lib: ", libTrs));
    end;
    
    if MatricesEqual(myTrs, libTrs) then
        if not silent then
            print("Test passed");
        end;
        return true;
    else
        print("!!!!!TEST FAILED!!!!!");
        return false;
    end;
end:

AutoTestTranspose := proc(valRange::list, matricesSize::list, eachSizeTest::numeric, silent::boolean, $)
    local i, j, passedTestsests;
    passedTests := 0;
    for i from matricesSize[1] to matricesSize[2] do
        if not silent then
            printf("\nN: %d", i);
        end;
        for j from 1 to eachSizeTest do
            if TestTranspose(RandMatrix(i, valRange), silent) then
                passedTests := passedTests + 1;  
            end;
        end;
    end;
    printf("%d/%d tests are passed\n", passedTests, (matricesSize[2]-matricesSize[1]+1)*eachSizeTest);
end: