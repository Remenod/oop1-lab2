with(ArrayTools):

module MyMatrix()
    #-----------------MATRIX DATA---------------------
    option object; #define module as a class

    local Data::Matrix;

    local Height::numeric;
    local Width::numeric;

    local Determinant::numeric = NULL;

    export ModuleApply::static := proc() #some constructor call syntax magic
       Object(MyMatrix, _passed);
    end;

    #actual constructor
    export ModuleCopy::static := overload(
        [
            proc(new::MyMatrix, proto::MyMatrix, v::Matrix, $)
            option overload;
                new:-Height, new:-Width := Size(v);
                new:-Data := v;
            end,

            proc(new::MyMatrix, proto::MyMatrix, v::list, $)
            option overload;
                local i, j;
                if v :: list and v[1] :: list and v[1][1] :: numeric then
                    new:-Height := nops(v);
                    new:-Width := nops(v[1]);
                    new:-Data := Matrix(new:-Height, new:-Width);

                    for i from 1 to new:-Height do
                        if new:-Width <> nops(v[i]) then
                            error "Ur jagged array kinda too jagged";
                        end;

                        for j from 1 to new:-Width do
                            new:-Data[i,j] := v[i][j];
                        end;
                    end;
                else
                    error "Unsuported argument type %1(%2)", whattype(v), v;
                end;
            end,

            proc(new::MyMatrix, proto::MyMatrix, v::MyMatrix, $)
            option overload;
                new:-Height := v:-Height;
                new:-Width := v:-Width;
                new:-Data := Matrix(v:-Data);
            end,

            proc(new::MyMatrix, proto::MyMatrix, v::string, $)
                local lines, i, j, rowValues, nRows, nCols;
                lines := StringTools:-Split(v, "\n");

                nRows := nops(lines);
                nCols := 0;

                rowValues := StringTools:-Split(lines[1], " \t");
                nCols := nops(rowValues);

                new:-Height := nRows;
                new:-Width := nCols;
                new:-Data := Matrix(nRows, nCols);

                for i from 1 to nRows do
                    rowValues := StringTools:-Split(lines[i], " \t");
                    if nops(rowValues) <> nCols then
                        error "Jagged row detected in string input";
                    end if;
                    for j from 1 to nCols do
                        new:-Data[i,j] := parse(rowValues[j]);
                    end do;
                end do;
            end
        ]
    ):

    export GetHeight := proc(_self ::MyMatrix, $)
        return _self :-Height;
    end;

    export GetWidth := proc(_self ::MyMatrix, $)
        return _self :-Width;
    end;

    export GetElement := proc(_self ::MyMatrix, i::posint, j::posint, $)
        return _self[i,j];
    end;

    export SetElement := proc(_self ::MyMatrix, i::posint, j::posint, value, $)
        _self[i,j] := value;
        NULL;
    end;

    export GetData := proc(_self::MyMatrix, $)
        return Matrix(_self:-Height, _self:-Width, (i,j) -> _self[i,j]);
    end;

    export `?[]` := proc(_self::MyMatrix, idx::list, value::list, $)
        if nargs = 2 then
            return _self:-Data[op(idx)];
        elif nargs = 3 then
            if value[1]::numeric then
                _self:-Data[op(idx)] := value[1];
                _self:-Determinant := NULL;
            else
                error "Value must be numeric";
            end;
        else
            error "Arguments count mismatch";
        end;
        NULL;
    end proc;

    export ModulePrint := proc(_self ::MyMatrix, $)
        local s, i, j;
        s := "";

        for i from 1 to _self :-Height do
            for j from 1 to _self :-Width do
                s := cat(s, sprintf("%g", _self :-Data[i,j]));

                if j < _self :-Width then
                    s := cat(s, "\t");
                end if;
            end do;

            if i < _self :-Height then
                s := cat(s, "\n");
            end if;
        end do;
        s := cat(s, "\n");
        printf("%s", s);
        NULL; #its impossible to not print return value. Lets hate this together
    end;

    #-----------------MATRIX OPERATIONS---------------

    export `+`::static := proc( m1::MyMatrix, m2::MyMatrix, $ )
        local i, j, res;
        if m1:-Height <> m1:-Height or m1:-Width <> m2:-Width then
            error "Matrix dimensions must match for addition";
        end if;

        res := Matrix(m1:-Height, m1:-Width);
        for i from 1 to m1:-Height do
            for j from 1 to m1:-Width do
                res[i,j] := m1[i,j] + m2[i,j];
            end do;
        end do;

        MyMatrix(res);
    end;

    export `*`::static := proc( m1::MyMatrix, m2::MyMatrix, $ )
        local i, j, k, res;
        if m1:-Width <> m2:-Height then
            error "Number of columns of first matrix must equal number of rows of second matrix";
        end if;

        res := Matrix(m1:-Height, m2:-Width, 0);
        for i from 1 to m1:-Height do
            for j from 1 to m2:-Width do
                for k from 1 to m1:-Width do
                    res[i,j] += m1[i,k] * m2[k,j];
                end do;
            end do;
        end do;

        MyMatrix(res);
    end;

    local GetTransposedArray := proc(_self::MyMatrix, $ )
        local res, i, j;
        res := Matrix(_self:-Width, _self:-Height);

        for i from 1 to _self:-Height do
            for j from 1 to _self:-Width do
            res[j, i] := _self:-Data[i, j];
            end;
        end;
         return res;
    end;

    export GetTransposedCopy := proc(_self::MyMatrix, $ )
        return MyMatrix(_self:-GetTransposedArray());
    end;

    export TransposeMe := proc(_self::MyMatrix, $ )
        local tmp := _self:-GetTransposedCopy();
        _self:-Data := tmp:-Data;
        _self:-Height:= tmp:-Height;
        _self:-Width := tmp:-Width;
        _self:-Determinant := NULL;
        NULL;
    end;

    export CalcDeterminant := proc(_self::MyMatrix, $)
        if _self:-Width <> _self:-Height then
            error "Matrix rows and columns count are not equal";
        end if;

        if assigned(_self:-Determinant) and _self:-Determinant <> NULL then
            return _self:-Determinant;
        end if;

        local n := _self:-Height;
        local sum := 0;
        local j, i, minorMatrix;

        if n = 1 then
            return _self[1,1];
        end if;

        for j from 1 to n do
            minorMatrix := Matrix(n-1, n-1);
            for i from 2 to n do
                local col := 1;
                for local k from 1 to n do
                    if k <> j then
                        minorMatrix[i-1, col] := _self[i,k];
                        col += 1;
                    end;
                end;
            end;

            sum += (-1)^(1+j) * _self[1,j] * MyMatrix(minorMatrix):-CalcDeterminant();
        end;

        _self:-Determinant := sum;
        return sum;
    end;


end module:
    