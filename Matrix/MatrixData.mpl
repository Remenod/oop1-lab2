with(ArrayTools):

module MyMatrix()
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
                if new:-Width != Size(v[i]) then
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
        sprintf("%s", s);
        #TODO fix no return bug
    end;

end module: