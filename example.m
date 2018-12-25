res = cell(1,300);
k = 0;
for i = 1:250
    pos = randi([1,2]);
    if pos == 1
         c = FAST.ActiveSession('GPU');
     else
       c = FAST.ActiveSession();
     end

        b = FAST.ActiveSession();
        clear b;
        c = FAST.ActiveSession('GPU');
        clear a;
end