with(StringTools):

TestCopy := proc(silent::boolean, $)
    local t1, t2, ok1, ok2;
    t1 := MyTime(500);
    t2 := MyTime(1, 2, 3);

    ok1 := evalb(t1:-TimeSinceMidnight() = 500);
    ok2 := evalb(t2:-TimeSinceMidnight() = 1*3600 + 2*60 + 3);

    if not silent then
        print(t1);
        print(t2);
    end;

    if ok1 and ok2 then
        if not silent then print("Test passed"); end;
        return true;
    else
        print("!!!!!TEST FAILED!!!!!");
        return false;
    end;
end:

AutoTestCopy := proc(times::posint, silent::boolean, $)
    local i, passed;
    passed := 0;
    for i from 1 to times do
        if TestCopy(silent) then passed := passed+1; end;
    end;
    printf("%d/%d tests are passed\n", passed, times);
end:

TestTimeAdd := proc(s::integer, delta::integer, expect::integer, silent::boolean, $)
    local t;
    t := MyTime(s);
    t:-AddSeconds(delta);

    if not silent then
        print(cat("Result: ", t:-TimeSinceMidnight()));
        print(cat("Expected: ", expect));
    end;

    if t:-TimeSinceMidnight() = expect then
        if not silent then print("Test passed"); end;
        return true;
    else
        print("!!!!!TEST FAILED!!!!!");
        return false;
    end;
end:

AutoTestTimeAdd := proc(times::posint, silent::boolean, $)
    local i, s, d, passed, expect;
    passed := 0;
    for i from 1 to times do
        s := rand(0..86399)();
        d := rand(-20000..20000)();
        expect := (s + d) mod (24*60*60);
        if expect < 0 then expect := expect + 24*60*60; end;
        if TestTimeAdd(s, d, expect, silent) then passed := passed+1; end;
    end;
    printf("%d/%d tests are passed\n", passed, times);
end:

TestTimeMinus := proc(s1::integer, s2::integer, expect::integer, silent::boolean, $)
    local t1, t2, result;
    t1 := MyTime(s1);
    t2 := MyTime(s2);
    result := t1 minus t2;

    if not silent then
        print(cat("Result: ", result));
        print(cat("Expected: ", expect));
    end;

    if result = expect then
        if not silent then print("Test passed"); end;
        return true;
    else
        print("!!!!!TEST FAILED!!!!!");
        return false;
    end;
end:

AutoTestTimeMinus := proc(times::posint, silent::boolean, $)
    local i, a, b, passed;
    passed := 0;
    for i from 1 to times do
        a := rand(0..86399)();
        b := rand(0..86399)();
        if TestTimeMinus(a, b, a-b, silent) then passed := passed+1; end;
    end;
    printf("%d/%d tests are passed\n", passed, times);
end:
