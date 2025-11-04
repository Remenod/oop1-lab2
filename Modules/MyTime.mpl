module MyTime()
    option object;

    local seconds::integer;

    local ValidateData := proc(_self::MyTime)
        if _self:-seconds < 0 then
            _self:-seconds := 0;
        elif _self:-seconds > 24*60*60 then
            _self:-seconds := _self:-seconds mod 24*60*60;
        end;
    end;

    export ModuleApply::static := proc()
       Object(MyTime, _passed);
    end;

    export ModuleCopy::static := proc(new::MyTime, proto::MyTime, h::integer, m::integer, s::integer, $)
            new:-seconds := h*60*60 + m*60 + s;
            new:-ValidateData();
    end;

    export ModulePrint := proc(_self::MyTime, $)
        local secs, h, m, s;
        _self:-ValidateData();
        secs := _self:-seconds mod 24*60*60;
        h := floor(secs / 3600);
        secs := secs - h*3600;
        m := floor(secs / 60);
        s := secs - m*60;
        return sprintf("%d:%02d:%02d", h, m, s);
    end;

    export TimeSinceMidnight := proc(_self::MyTime, $)
        _self:-ValidateData();
        return seconds;
    end;

    export AddOneSecond := proc(_self::MyTime, $)
        _self:-seconds += 1;
        _self:-ValidateData();
    end;

    export AddOneMinute := proc(_self::MyTime, $)
        _self:-seconds += 60;
        _self:-ValidateData();
    end;

    export AddOneHour := proc(_self::MyTime, $)
        _self:-seconds += 60*60;
        _self:-ValidateData();
    end;

    export AddSeconds := proc(_self::MyTime, s::integer, $)
        _self:-seconds += s;
        _self:-ValidateData();
    end;

    export `-`::static := proc(t1::MyTime, t2::MyTime, $)
        return MyTime(t1:-seconds - t2:-seconds);
    end;

    export WhatLesson := proc(_self::MyTime)
        if   _self:-seconds < 60*480  then return "пари ще не почалися";
        elif _self:-seconds < 60*560  then return "1-а пара";
        elif _self:-seconds < 60*580  then return "перерва між 1-ю та 2-ю парами";
        elif _self:-seconds < 60*660  then return "2-а пара";
        elif _self:-seconds < 60*680  then return "перерва між 2-ю та 3-ю парами";
        elif _self:-seconds < 60*760  then return "3-я пара";
        elif _self:-seconds < 60*780  then return "перерва між 3-ю та 4-ю парами";
        elif _self:-seconds < 60*860  then return "4-а пара";
        elif _self:-seconds < 60*880  then return "перерва між 4-ю та 5-ю парами";
        elif _self:-seconds < 60*960  then return "5-а пара";
        elif _self:-seconds < 60*970  then return "перерва між 5-ю та 6-ю парами";
        elif _self:-seconds < 60*1050 then return "6-а пара";
        end;
        return "пари вже скінчилися";
    end;


end:
