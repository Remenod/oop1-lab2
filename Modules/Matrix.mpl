with(ArrayTools):

module MyMatrix()
    #-----------------MATRIX DATA---------------------
    option object; #define module as a class

    local Data::Matrix;

    local Height::numeric;
    local Width::numeric;

    export ModuleApply::static := proc() #some constructor call syntax magic
       Object(MyMatrix, _passed);
    end;

    export ModuleCopy::static := proc(new::MyMatrix, proto::MyMatrix, v, $) #actual constructor
        if v :: Matrix then #coolass overloading
            new:-Height, new:-Width := Size(v);
            new:-Data := v;
        elif v :: Array and v[1] :: Array and v[1][1] :: numeric then
            new:-Height := Size(v);
            new:-Width := Size(v[1]);
            new:-Data := Matrix(new:-Height, new:-Width);

            local i, j;
            for i from 1 to new:-Height do
                if new:-Width <> Size(v[i]) then
                    error "Ur jagged array kinda too jagged";
                end;

                for j from 1 to new:-Width do
                    new:-Data[i,j] := v[i][j];
                end;
            end;
        elif v :: MyMatrix then
            new:-Height := v:-Height;
            new:-Width := v:-Width;
            new:-Data := Matrix(v:-Data);
        elif v :: string then
            ;#TODO
        else
            error "Unsuported argument type %1", v;
        end;
    end;

    export GetHeight := proc(_self ::MyMatrix, $)
        return _self :-Height;
    end;

    export GetWidth := proc(_self ::MyMatrix, $)
        return _self :-Width;
    end;

    export GetElement := proc(_self ::MyMatrix, i::posint, j::posint, $)
        return _self [i,j];
    end;

    export SetElement := proc(_self ::MyMatrix, i::posint, j::posint, value, $)
        _self [i,j] := value;
    end;

    export ModuleSelect := proc(_self ::MyMatrix, i::posint, j::posint, $) #indexer get
        return _self :-Data[i,j];
    end;

    export ModuleAssign := proc(_self ::MyMatrix, i::posint, j::posint, value, $) #indexer set
        _self :-Data[i,j] := value;
    end;

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

    export `+`::static := proc( m1::MyMatrix, m2::MyMatrix )
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

    export `*`::static := proc( m1::MyMatrix, m2::MyMatrix )
        local i, j, k, res;
        if m1:-Width <> m2:-Height then
            error "Number of columns of first matrix must equal number of rows of second matrix";
        end if;

        res := Matrix(m1:-Height, m2:-Width, 0);
        for i from 1 to m1:-Height do
            for j from 1 to m2:-Width do
                for k from 1 to m1:-Width do
                    res[i,j] := res[i,j] + m1[i,k] * m2[k,j];
                end do;
            end do;
        end do;

        MyMatrix(res);
    end;

end module:
    